package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.trigger.TriggerTools;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.rpt.due.IPeriodScript;
import com.amarsoft.app.accounting.rpt.pmt.IPMTScript;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

/**
 * 贷款发放
 */
public class UpdateLoanExecutor implements ITransactionExecutor{
	
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager bomanager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String businessDate = loan.getString("BusinessDate");
		
		String updatePSFlag=loan.getString("UpdatePMTSchdFlag");
		String updateInstalAmtFlag = loan.getString("UpdateInstalAmtFlag");
		
		ArrayList<BusinessObject> pslist = new ArrayList<BusinessObject>();
		
		if(updatePSFlag!=null&&updatePSFlag.equals("1")){
			//设置还款方式信息是否更新月供
			ArrayList<BusinessObject> rptList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
			for(BusinessObject rpt:rptList)
			{
				if("1".equals(updateInstalAmtFlag))
				{
					rpt.setAttributeValue("UpdateInstalAmtFlag", "1");
				}
			}
			
			// 生成新的还款计划
			List<BusinessObject> paymentScheduleListNew = PaymentScheduleFunctions.createLoanPaymentScheduleList(loan,null,new DefaultBusinessObjectManager(bomanager.getSqlca()));
			PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, null, bomanager);//删除原有还款计划
			
			//【hhcf】提前还款删除当期还款计划及费用计划
			String transCode = transaction.getString("TransCode");
			if(transCode.equals("0055")){
				List<BusinessObject> feeList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
				if(feeList!=null&&feeList.size()>0){
					for(BusinessObject fee:feeList){
						String feeNo = fee.getObjectNo();
						
						ASValuePool asfee = new ASValuePool();
						asfee.setAttribute("ObjectType", fee.getObjectType());
						asfee.setAttribute("ObjectNo", feeNo);
						asfee.setAttribute("PayDate",transaction.getString("TransDate"));
						String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo" ;
						List<BusinessObject> feepaymentScheduleList = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule,whereClauseSql,asfee);
						if(feepaymentScheduleList !=null && !feepaymentScheduleList.isEmpty()){
							for(BusinessObject feeps:feepaymentScheduleList){
								if(feeps.getString("PayDate").compareTo(transaction.getString("TransDate"))>=0){
									pslist.add(feeps);
								}
							}
						}
					}
				}
				ASValuePool aspayment = new ASValuePool();
				aspayment.setAttribute("PayDate", transaction.getString("TransDate"));
				aspayment.setAttribute("ObjectNo",loan.getObjectNo());
				aspayment.setAttribute("ObjectType",loan.getObjectType());
			
				List<BusinessObject> loanpayment = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, "PayDate=:PayDate and ObjectNo=:ObjectNo and ObjectType=:ObjectType ",aspayment);				
				if(loanpayment !=null && !loanpayment.isEmpty()){
					for(BusinessObject loanps:loanpayment){
						pslist.add(loanps);
					}
				}
				
				if(pslist!=null && !pslist.isEmpty()){
					bomanager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_delete, pslist);
				}
			}
			
			loan.setRelativeObjects(paymentScheduleListNew);//赋值新的还款计划
			bomanager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, paymentScheduleListNew);
			/*****更新RPT的期供*****/
			for(BusinessObject rpt:rptList){
				String status = rpt.getString("Status");
				if("1".equals(status)) {
					IPeriodScript periodScript = RPTFunctions.getPeriodScript(loan, rpt);
					int t=periodScript.getTotalPeriod(loan, rpt);
					rpt.setAttributeValue("TotalPeriod", t);
					IPMTScript pmtScript = RPTFunctions.getPMTScript(loan, rpt);
					if(pmtScript!=null){
						double instalmentAmount=RPTFunctions.getPMTScript(loan, rpt).getInstalmentAmount(loan, rpt);
						rpt.setAttributeValue("SegInstalmentAmt", instalmentAmount);
						bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, rpt);
					}
				}
				rpt.setAttributeValue("UpdateInstalAmtFlag","0");
			}
			//期供标识修改为不再重新计算，避免每次重算期供
			loan.setAttributeValue("UpdateInstalAmtFlag","0");
			loan.setAttributeValue("UpdatePMTSchdFlag", "2");
		}
		
		double normalBalance =0d,overdueBalance=0d,odInterest=0d,fineInterest=0d,compInterest=0d,pmtAmount=0d;
		
		int lcaTimes = 0;//连续欠款次数
		
		String nextDueDate="";//下次还款日
		int currentPeriod = loan.getInt("CurrentPeriod");
		//HHCF更新费用还款计划的日期
		ArrayList<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList!=null){
			for(BusinessObject fee:feeList){
				ArrayList<BusinessObject> b = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
				if(b!=null){
					for(BusinessObject feePSschedule :b){
						String paydate=feePSschedule.getString("PayDate");
						String payType=feePSschedule.getString("PayType");
						String finishDate=feePSschedule.getString("FinishDate");
						if(finishDate==null)finishDate="";
						if(payType!=null&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)&&payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay)&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All)) continue;//只计算正常和提前还款记录
						double feeAmount = Arith.round(feePSschedule.getDouble("PayPrincipalAmt") - feePSschedule.getDouble("ActualPayPrincipalAmt"), 2);
						//更新全部结清日期，含罚复息
						if( feeAmount  <=0 && paydate.compareTo(businessDate) <= 0){
							if("".equals(feePSschedule.getString("FinishDate"))||feePSschedule.getString("FinishDate")==null) {
								feePSschedule.setAttributeValue("FinishDate", businessDate);
								//ARE.getLog().info("还款计划流水号【"+feePSschedule.getObjectNo()+"】结清日期："+businessDate);
							}
						}
						else{
							if((feeAmount <=0 && paydate.compareTo(businessDate) >= 0)&&transaction.getString("TransCode").equals("0055")){
								//提前还款置上结清日期 hhcf需求
								feePSschedule.setAttributeValue("FinishDate", businessDate);
								//ARE.getLog().info("还款计划流水号【"+feePSschedule.getObjectNo()+"】结清日期："+businessDate);
								continue;
							}
							feePSschedule.setAttributeValue("FinishDate", "");
						}
						
						//更新期供结清日期，不含罚复息
						if( feeAmount <=0 ){
							if(feePSschedule.getString("SettleDate")==null||feePSschedule.getString("SettleDate").equals("")) {
								feePSschedule.setAttributeValue("SettleDate", businessDate);
								//ARE.getLog().info("还款计划流水号【"+feePSschedule.getObjectNo()+"】期供结清日期："+businessDate);
							}
						}
						else{
							if((feeAmount <=0 && paydate.compareTo(businessDate) >= 0)&&transaction.getString("TransCode").equals("0055")){
								//提前还款置上结清日期 hhcf需求
								feePSschedule.setAttributeValue("SettleDate", businessDate);
								//ARE.getLog().info("还款计划流水号【"+feePSschedule.getObjectNo()+"】期供结清日期："+businessDate);
								continue;
							}
							feePSschedule.setAttributeValue("SettleDate", "");
						}
						
						
						String finishdate = feePSschedule.getString("FinishDate");//已结清的还款计划不考虑
						if(!"".equals(finishdate)&&finishdate!=null) continue;
					}
				}
			}
		}
		
		//根据还款计划更新余额
		ArrayList<BusinessObject> a = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		//hhcf
		if(transaction.getString("TransCode").equals("4015")){
			for(Iterator<BusinessObject> it=a.iterator();it.hasNext();){
				BusinessObject psa = it.next();
				for(BusinessObject pstemp:pslist){
					if(psa.equals(pstemp)){
						it.remove();
					}
				}
			}
		}
			
		if(a!=null){
			for(BusinessObject paymentschedule:a){
				String paydate=paymentschedule.getString("PayDate");
				String payType=paymentschedule.getString("PayType");
				String finishDate=paymentschedule.getString("FinishDate");
				if(finishDate==null)finishDate="";
				if(payType!=null&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)&&payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay)&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All)) continue;//只计算正常和提前还款记录
				if(paydate.compareTo(businessDate)>0&&finishDate.length()==0){//未来还款计划，且未还清
					if(nextDueDate.length()==0||nextDueDate.compareTo(paydate)>0){
						nextDueDate=paydate;
						pmtAmount=paymentschedule.getDouble("PayPrincipalAmt")+paymentschedule.getDouble("PayInteAmt");//下次还款额
						currentPeriod=paymentschedule.getInt("SeqID")-1;
					}
				}
				//更新还款计划状态
				double prinacipal = Arith.round(paymentschedule.getDouble("PayPrincipalAmt") - paymentschedule.getDouble("ActualPayPrincipalAmt"), 2);
				double inte = Arith.round(paymentschedule.getDouble("PayInteAmt") - paymentschedule.getDouble("ActualPayInteAmt"), 2);
				double fine = Arith.round(paymentschedule.getDouble("PayFineAmt") - paymentschedule.getDouble("ActualPayFineAmt"), 2);
				double comp = Arith.round(paymentschedule.getDouble("PayCompdInteAmt") - paymentschedule.getDouble("ActualPayCompdInteAmt"), 2);
				
				//更新全部结清日期，含罚复息
				if( prinacipal + inte+ fine + comp <=0 && paydate.compareTo(businessDate) <= 0){
					if("".equals(paymentschedule.getString("FinishDate"))||paymentschedule.getString("FinishDate")==null) {
						paymentschedule.setAttributeValue("FinishDate", businessDate);
						//ARE.getLog().info("还款计划流水号【"+paymentschedule.getObjectNo()+"】结清日期："+businessDate);
					}
				}
				else{
					if((prinacipal + inte+ fine + comp <=0 && paydate.compareTo(businessDate) >= 0)&&transaction.getString("TransCode").equals("0055")){
						//提前还款置上结清日期 hhcf需求
						paymentschedule.setAttributeValue("FinishDate", businessDate);
						//ARE.getLog().info("还款计划流水号【"+paymentschedule.getObjectNo()+"】结清日期："+businessDate);
						continue;
					}
					paymentschedule.setAttributeValue("FinishDate", "");
				}
				
				//更新期供结清日期，不含罚复息
				if( prinacipal + inte <=0 ){
					if(paymentschedule.getString("SettleDate")==null||paymentschedule.getString("SettleDate").equals("")) {
						paymentschedule.setAttributeValue("SettleDate", businessDate);
						//ARE.getLog().info("还款计划流水号【"+paymentschedule.getObjectNo()+"】期供结清日期："+businessDate);
					}
				}
				else{
					if((prinacipal + inte+ fine + comp <=0 && paydate.compareTo(businessDate) >= 0)&&transaction.getString("TransCode").equals("0055")){
						//提前还款置上结清日期 hhcf需求
						paymentschedule.setAttributeValue("SettleDate", businessDate);
						//ARE.getLog().info("还款计划流水号【"+paymentschedule.getObjectNo()+"】期供结清日期："+businessDate);
						continue;
					}
					paymentschedule.setAttributeValue("SettleDate", "");
				}
				
					
				String finishdate = paymentschedule.getString("FinishDate");//已结清的还款计划不考虑
				if(!"".equals(finishdate)&&finishdate!=null) continue;
				
				fineInterest += fine;//累计罚息金额
				compInterest += comp;//累计复利金额
				
				if(paydate.compareTo(businessDate) >= 0){
					normalBalance+= prinacipal;//贷款正常本金余额
				}
				else{
					if(paymentschedule.getString("SettleDate").equals("")){
						lcaTimes++;
					}
					overdueBalance += prinacipal;//累计已到期本金金额
					odInterest += inte;//累计欠息金额
				}
			}
		}
		loan.setAttributeValue("NextDueDate", nextDueDate);//下次还款日
		loan.setAttributeValue("OverdueBalance", Arith.round(overdueBalance,2));//逾期余额
		loan.setAttributeValue("NormalBalance", Arith.round(normalBalance,2));//正常余额
		loan.setAttributeValue("ODInteBalance", Arith.round(odInterest,2));//期供欠息
		loan.setAttributeValue("FineInteBalance", Arith.round(fineInterest,2));//罚息
		loan.setAttributeValue("CompdInteBalance", Arith.round(compInterest,2));//复利
		loan.setAttributeValue("LcaTimes", lcaTimes);//连续逾期次数
		loan.setAttributeValue("NextInstalmentAmt", pmtAmount);//下次还款额
		loan.setAttributeValue("CurrentPeriod", currentPeriod);//当前期次
		if("0055".equals(transaction.getString("TransCode"))){
			loan.setAttributeValue("AccrueInteBalance", "0.00");//计提利息
		}
			
		int overdueDays=LoanFunctions.getOverDays(loan);
		loan.setAttributeValue("OverdueDays", overdueDays);
		
		LoanFunctions.updateLoanStatus(loan, bomanager);
		LoanFunctions.updateLoanRptSegment(loan, bomanager);
		TriggerTools.deal(bomanager,loan);//触发更新关联对象
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		
		return 1;
	}

}
