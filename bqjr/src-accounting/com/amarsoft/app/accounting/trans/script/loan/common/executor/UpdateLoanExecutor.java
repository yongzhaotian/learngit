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
 * �����
 */
public class UpdateLoanExecutor implements ITransactionExecutor{
	
	
	/**
	 * �������ݴ���
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
			//���û��ʽ��Ϣ�Ƿ�����¹�
			ArrayList<BusinessObject> rptList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
			for(BusinessObject rpt:rptList)
			{
				if("1".equals(updateInstalAmtFlag))
				{
					rpt.setAttributeValue("UpdateInstalAmtFlag", "1");
				}
			}
			
			// �����µĻ���ƻ�
			List<BusinessObject> paymentScheduleListNew = PaymentScheduleFunctions.createLoanPaymentScheduleList(loan,null,new DefaultBusinessObjectManager(bomanager.getSqlca()));
			PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, null, bomanager);//ɾ��ԭ�л���ƻ�
			
			//��hhcf����ǰ����ɾ�����ڻ���ƻ������üƻ�
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
			
			loan.setRelativeObjects(paymentScheduleListNew);//��ֵ�µĻ���ƻ�
			bomanager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, paymentScheduleListNew);
			/*****����RPT���ڹ�*****/
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
			//�ڹ���ʶ�޸�Ϊ�������¼��㣬����ÿ�������ڹ�
			loan.setAttributeValue("UpdateInstalAmtFlag","0");
			loan.setAttributeValue("UpdatePMTSchdFlag", "2");
		}
		
		double normalBalance =0d,overdueBalance=0d,odInterest=0d,fineInterest=0d,compInterest=0d,pmtAmount=0d;
		
		int lcaTimes = 0;//����Ƿ�����
		
		String nextDueDate="";//�´λ�����
		int currentPeriod = loan.getInt("CurrentPeriod");
		//HHCF���·��û���ƻ�������
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
						if(payType!=null&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)&&payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay)&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All)) continue;//ֻ������������ǰ�����¼
						double feeAmount = Arith.round(feePSschedule.getDouble("PayPrincipalAmt") - feePSschedule.getDouble("ActualPayPrincipalAmt"), 2);
						//����ȫ���������ڣ�������Ϣ
						if( feeAmount  <=0 && paydate.compareTo(businessDate) <= 0){
							if("".equals(feePSschedule.getString("FinishDate"))||feePSschedule.getString("FinishDate")==null) {
								feePSschedule.setAttributeValue("FinishDate", businessDate);
								//ARE.getLog().info("����ƻ���ˮ�š�"+feePSschedule.getObjectNo()+"���������ڣ�"+businessDate);
							}
						}
						else{
							if((feeAmount <=0 && paydate.compareTo(businessDate) >= 0)&&transaction.getString("TransCode").equals("0055")){
								//��ǰ�������Ͻ������� hhcf����
								feePSschedule.setAttributeValue("FinishDate", businessDate);
								//ARE.getLog().info("����ƻ���ˮ�š�"+feePSschedule.getObjectNo()+"���������ڣ�"+businessDate);
								continue;
							}
							feePSschedule.setAttributeValue("FinishDate", "");
						}
						
						//�����ڹ��������ڣ���������Ϣ
						if( feeAmount <=0 ){
							if(feePSschedule.getString("SettleDate")==null||feePSschedule.getString("SettleDate").equals("")) {
								feePSschedule.setAttributeValue("SettleDate", businessDate);
								//ARE.getLog().info("����ƻ���ˮ�š�"+feePSschedule.getObjectNo()+"���ڹ��������ڣ�"+businessDate);
							}
						}
						else{
							if((feeAmount <=0 && paydate.compareTo(businessDate) >= 0)&&transaction.getString("TransCode").equals("0055")){
								//��ǰ�������Ͻ������� hhcf����
								feePSschedule.setAttributeValue("SettleDate", businessDate);
								//ARE.getLog().info("����ƻ���ˮ�š�"+feePSschedule.getObjectNo()+"���ڹ��������ڣ�"+businessDate);
								continue;
							}
							feePSschedule.setAttributeValue("SettleDate", "");
						}
						
						
						String finishdate = feePSschedule.getString("FinishDate");//�ѽ���Ļ���ƻ�������
						if(!"".equals(finishdate)&&finishdate!=null) continue;
					}
				}
			}
		}
		
		//���ݻ���ƻ��������
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
				if(payType!=null&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)&&payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay)&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All)) continue;//ֻ������������ǰ�����¼
				if(paydate.compareTo(businessDate)>0&&finishDate.length()==0){//δ������ƻ�����δ����
					if(nextDueDate.length()==0||nextDueDate.compareTo(paydate)>0){
						nextDueDate=paydate;
						pmtAmount=paymentschedule.getDouble("PayPrincipalAmt")+paymentschedule.getDouble("PayInteAmt");//�´λ����
						currentPeriod=paymentschedule.getInt("SeqID")-1;
					}
				}
				//���»���ƻ�״̬
				double prinacipal = Arith.round(paymentschedule.getDouble("PayPrincipalAmt") - paymentschedule.getDouble("ActualPayPrincipalAmt"), 2);
				double inte = Arith.round(paymentschedule.getDouble("PayInteAmt") - paymentschedule.getDouble("ActualPayInteAmt"), 2);
				double fine = Arith.round(paymentschedule.getDouble("PayFineAmt") - paymentschedule.getDouble("ActualPayFineAmt"), 2);
				double comp = Arith.round(paymentschedule.getDouble("PayCompdInteAmt") - paymentschedule.getDouble("ActualPayCompdInteAmt"), 2);
				
				//����ȫ���������ڣ�������Ϣ
				if( prinacipal + inte+ fine + comp <=0 && paydate.compareTo(businessDate) <= 0){
					if("".equals(paymentschedule.getString("FinishDate"))||paymentschedule.getString("FinishDate")==null) {
						paymentschedule.setAttributeValue("FinishDate", businessDate);
						//ARE.getLog().info("����ƻ���ˮ�š�"+paymentschedule.getObjectNo()+"���������ڣ�"+businessDate);
					}
				}
				else{
					if((prinacipal + inte+ fine + comp <=0 && paydate.compareTo(businessDate) >= 0)&&transaction.getString("TransCode").equals("0055")){
						//��ǰ�������Ͻ������� hhcf����
						paymentschedule.setAttributeValue("FinishDate", businessDate);
						//ARE.getLog().info("����ƻ���ˮ�š�"+paymentschedule.getObjectNo()+"���������ڣ�"+businessDate);
						continue;
					}
					paymentschedule.setAttributeValue("FinishDate", "");
				}
				
				//�����ڹ��������ڣ���������Ϣ
				if( prinacipal + inte <=0 ){
					if(paymentschedule.getString("SettleDate")==null||paymentschedule.getString("SettleDate").equals("")) {
						paymentschedule.setAttributeValue("SettleDate", businessDate);
						//ARE.getLog().info("����ƻ���ˮ�š�"+paymentschedule.getObjectNo()+"���ڹ��������ڣ�"+businessDate);
					}
				}
				else{
					if((prinacipal + inte+ fine + comp <=0 && paydate.compareTo(businessDate) >= 0)&&transaction.getString("TransCode").equals("0055")){
						//��ǰ�������Ͻ������� hhcf����
						paymentschedule.setAttributeValue("SettleDate", businessDate);
						//ARE.getLog().info("����ƻ���ˮ�š�"+paymentschedule.getObjectNo()+"���ڹ��������ڣ�"+businessDate);
						continue;
					}
					paymentschedule.setAttributeValue("SettleDate", "");
				}
				
					
				String finishdate = paymentschedule.getString("FinishDate");//�ѽ���Ļ���ƻ�������
				if(!"".equals(finishdate)&&finishdate!=null) continue;
				
				fineInterest += fine;//�ۼƷ�Ϣ���
				compInterest += comp;//�ۼƸ������
				
				if(paydate.compareTo(businessDate) >= 0){
					normalBalance+= prinacipal;//���������������
				}
				else{
					if(paymentschedule.getString("SettleDate").equals("")){
						lcaTimes++;
					}
					overdueBalance += prinacipal;//�ۼ��ѵ��ڱ�����
					odInterest += inte;//�ۼ�ǷϢ���
				}
			}
		}
		loan.setAttributeValue("NextDueDate", nextDueDate);//�´λ�����
		loan.setAttributeValue("OverdueBalance", Arith.round(overdueBalance,2));//�������
		loan.setAttributeValue("NormalBalance", Arith.round(normalBalance,2));//�������
		loan.setAttributeValue("ODInteBalance", Arith.round(odInterest,2));//�ڹ�ǷϢ
		loan.setAttributeValue("FineInteBalance", Arith.round(fineInterest,2));//��Ϣ
		loan.setAttributeValue("CompdInteBalance", Arith.round(compInterest,2));//����
		loan.setAttributeValue("LcaTimes", lcaTimes);//�������ڴ���
		loan.setAttributeValue("NextInstalmentAmt", pmtAmount);//�´λ����
		loan.setAttributeValue("CurrentPeriod", currentPeriod);//��ǰ�ڴ�
		if("0055".equals(transaction.getString("TransCode"))){
			loan.setAttributeValue("AccrueInteBalance", "0.00");//������Ϣ
		}
			
		int overdueDays=LoanFunctions.getOverDays(loan);
		loan.setAttributeValue("OverdueDays", overdueDays);
		
		LoanFunctions.updateLoanStatus(loan, bomanager);
		LoanFunctions.updateLoanRptSegment(loan, bomanager);
		TriggerTools.deal(bomanager,loan);//�������¹�������
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		
		return 1;
	}

}
