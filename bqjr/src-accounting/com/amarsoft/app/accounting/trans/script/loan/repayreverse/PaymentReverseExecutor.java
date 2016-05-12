package com.amarsoft.app.accounting.trans.script.loan.repayreverse;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

public class PaymentReverseExecutor implements ITransactionExecutor {
	//是否需要删除结息的log
	public boolean dealLog = false;
	
	private ITransactionScript transactionScript;


	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript =transactionScript;
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		//取Loan对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject oldTransaction = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		BusinessObject oldPaymentBill = oldTransaction.getRelativeObject(oldTransaction.getString("DocumentType"), oldTransaction.getString("DocumentSerialNo"));
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		setOldBill();
		
		//将冲账金额拆入 还款计划
		updatePaymentSch();

		//将本金内转
		double ps_OverduePrincipalBalance = 0d;//getPaymentSchdAmt(loan,loan.getString("BusinessDate"), ACCOUNT_CONSTANTS.PS_AMOUNT_TYPE_Principal);
		transaction.setAttributeValue("PSOverduePrincipal", ps_OverduePrincipalBalance);
		
		//如果冲的是部分提前还款-期供不变的提前还款，那么必须把贷款的带起日更新回原来的值。因为部分提前还款-期供不变会改变贷款的到期日，反冲的时候应该恢复。
		if(ACCOUNT_CONSTANTS.PrepaymentType_Part_FixInstalment.equals(oldPaymentBill.getString("PrepayType")))
		{
			String oldBillRemark = oldPaymentBill.getString("Remark");
			if(oldBillRemark.indexOf("LoanMaturityDate")>=0)
			{
				String s[] = oldBillRemark.split(",");
				for(int i=0;i<s.length;i++){
					if(s[i].contains("LoanMaturityDate")){
						String ss[] = s[i].split("@");
						loan.setAttributeValue("MaturityDate", ss[1]);
						break;
					}
				}
			}
		}
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,paymentBill);	
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,oldPaymentBill);	
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);		
		
		//如果结清的贷款再冲销，需要将贷款处理日期更新到当天,dxu1 20121205
		String businessDate = SystemConfig.getBusinessDate();
		if(loan.getString("BusinessDate").compareTo(businessDate)<0){
			loan.setAttributeValue("BusinessDate", businessDate);
		}
		return 1;
	}
	
	private void setOldBill() throws Exception{
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		//取Loan对象
		BusinessObject oldTransaction = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		BusinessObject oldPaymentBill = oldTransaction.getRelativeObject(oldTransaction.getString("DocumentType"), oldTransaction.getString("DocumentSerialNo"));
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		
		oldTransaction.setAttributeValue("TransStatus", "2");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,oldTransaction);	
		
		oldPaymentBill.setAttributeValue("Status", "2");//原交易更新为已冲账
		String cashOnLineFlag = paymentBill.getString("CashOnLineFlag");
		paymentBill.setValue(oldPaymentBill);
		paymentBill.setAttributeValue("Status", "1");
		paymentBill.setAttributeValue("ActualPayDate", SystemConfig.getBusinessDate());
		paymentBill.setAttributeValue("ActualPayAmt",-oldPaymentBill.getDouble("ActualPayamt"));
		paymentBill.setAttributeValue("ActualPayPrincipalAMT",-oldPaymentBill.getDouble("ActualPayPrincipalAMT"));
		paymentBill.setAttributeValue("ActualPayODPrincipalAMT",-oldPaymentBill.getDouble("ActualPayODPrincipalAMT"));
		paymentBill.setAttributeValue("ActualPayInteAmt",-oldPaymentBill.getDouble("ActualPayInteAmt"));
		paymentBill.setAttributeValue("ActualPayODInteAmt",-oldPaymentBill.getDouble("ActualPayODInteAmt"));
		paymentBill.setAttributeValue("ActualPayFineAmt",-oldPaymentBill.getDouble("ActualPayFineAmt"));
		paymentBill.setAttributeValue("ActualPayCompdInteAmt",-oldPaymentBill.getDouble("ActualPayCompdInteAmt"));
		paymentBill.setAttributeValue("PrePayPrincipalAmt",-oldPaymentBill.getDouble("PrePayPrincipalAmt"));
		paymentBill.setAttributeValue("PrePayInteAmt",-oldPaymentBill.getDouble("PrePayInteAmt"));
		paymentBill.setAttributeValue("CashOnLineFlag", cashOnLineFlag);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,paymentBill);	
	}


	//循环更新还款计划表
	private void updatePaymentSch() throws Exception{
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject oldTransaction = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		BusinessObject oldPaymentBill = oldTransaction.getRelativeObject(oldTransaction.getString("DocumentType"), oldTransaction.getString("DocumentSerialNo"));
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		
		List<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		String businessDate = loan.getString("BusinessDate");
		
		//List<BusinessObject> paymentLogList=oldPaymentBill.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.PaymentLog);
		List<BusinessObject> paymentLogList=oldTransaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.PaymentLog);
		for(BusinessObject bo : paymentLogList){
			
			BusinessObject paymentSchedule = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,bo.getString("PSSerialNo"));
			if(paymentSchedule==null){
				List<BusinessObject> feeList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
				if(feeList!=null){
					for(BusinessObject fee:feeList){
						paymentSchedule = fee.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,bo.getString("PSSerialNo"));
						if(paymentSchedule!=null){
							paymentSchedule.setRelativeObject(bo);
							if(!paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)){
								//【一般还款部分的处理,将paymentLog的记录循环更新到paymentschdue中】
								//本金
								paymentSchedule.setAttributeValue("ActualPayPrincipalAmt",Arith.round(paymentSchedule.getDouble("ActualPayPrincipalAmt") - bo.getDouble("ActualPayPrincipalAmt"),2));
								
								//利息
								paymentSchedule.setAttributeValue("ActualPayInteAmt",Arith.round(paymentSchedule.getDouble("ActualPayInteAmt") - bo.getDouble("ActualPayInteAmt"),2));
								
								if((bo.getDouble("ActualPayPrincipalAmt") + bo.getDouble("ActualPayInteAmt") )>0 ){
									paymentSchedule.setAttributeValue("SettleDate", "");
								}
								//罚息
								paymentSchedule.setAttributeValue("ActualPayFineAmt",Arith.round(paymentSchedule.getDouble("ActualPayFineAmt") - bo.getDouble("ActualPayFineAmt"),2));

								//复利
								paymentSchedule.setAttributeValue("ActualPayCompdinteAmt",Arith.round(paymentSchedule.getDouble("ActualPayCompdinteAmt") - bo.getDouble("ActualPayCompdinteAmt"),2));

								paymentSchedule.setAttributeValue("FinishDate", "");
								
								//客户服务费A2,印花税A11,滞纳金A10,财务管理费A7,保险费A12
								if(paymentSchedule.getString("PayType").equals("A2")) paymentBill.setAttributeValue("ACTUALCUSTOMERSERVEFEE", -bo.getDouble("ActualPayPrincipalAmt"));
								if(paymentSchedule.getString("PayType").equals("A11")) paymentBill.setAttributeValue("ACTUALSTAMPTAX", -bo.getDouble("ActualPayPrincipalAmt"));
								if(paymentSchedule.getString("PayType").equals("A10")) paymentBill.setAttributeValue("ACTUALPAYFINEAMT", -bo.getDouble("ActualPayPrincipalAmt"));
								if(paymentSchedule.getString("PayType").equals("A7")) paymentBill.setAttributeValue("ACTUALACCOUNTMANAGEFEE", -bo.getDouble("ActualPayPrincipalAmt"));
								if(paymentSchedule.getString("PayType").equals("A12")) paymentBill.setAttributeValue("ACTUALPAYINSURANCEFEE", -bo.getDouble("ActualPayPrincipalAmt"));

								
								boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,paymentSchedule);	
								boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete, bo);
								
							}
						}
					}
				}
				continue;
			}
			
			if(paymentSchedule!=null){
				paymentSchedule.setRelativeObject(bo);
				if(paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)){
					//【一般还款部分的处理,将paymentLog的记录循环更新到paymentschdue中】
					//本金
					paymentSchedule.setAttributeValue("ActualPayPrincipalAmt",Arith.round(paymentSchedule.getDouble("ActualPayPrincipalAmt") - bo.getDouble("ActualPayPrincipalAmt"),2));
					
					//利息
					paymentSchedule.setAttributeValue("ActualPayInteAmt",Arith.round(paymentSchedule.getDouble("ActualPayInteAmt") - bo.getDouble("ActualPayInteAmt"),2));
					
					if((bo.getDouble("ActualPayPrincipalAmt") + bo.getDouble("ActualPayInteAmt") )>0 ){
						paymentSchedule.setAttributeValue("SettleDate", "");
					}
					//罚息
					paymentSchedule.setAttributeValue("ActualPayFineAmt",Arith.round(paymentSchedule.getDouble("ActualPayFineAmt") - bo.getDouble("ActualPayFineAmt"),2));

					//复利
					paymentSchedule.setAttributeValue("ActualPayCompdinteAmt",Arith.round(paymentSchedule.getDouble("ActualPayCompdinteAmt") - bo.getDouble("ActualPayCompdinteAmt"),2));

					paymentSchedule.setAttributeValue("FinishDate", "");
					
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,paymentSchedule);	
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete, bo);
					
				}else if(paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay)||paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All)){
					//【提前还款部分的处理,删除掉还款的哪一期，注意结息日的处理,】
					
					//目前控制住超过结息日不能冲账
					String lastDueDate = LoanFunctions.getLastDueDate(loan);
					if(lastDueDate.compareTo(paymentSchedule.getString("PayDate"))>0) throw new Exception("提前还款已经过了一次结息周期,不允许冲销！");
						
					//如果正交易是按贷款余额计息，则需要更新结息日回以前的结息日
					String sPrepayInterestBaseFlag =  oldPaymentBill.getString("PrepayInterestBaseFlag");
					if(sPrepayInterestBaseFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestBaseFlag_NormalBalance)){
						String sRemak =  oldPaymentBill.getString("ReMark");
						String oldLastDueDay = "";
						String oldNextDueDay = "";
						if(!"".equals(sRemak)){
							if(sRemak.indexOf("LastDueDate")>=0){
								String s[] = sRemak.split(",");
								for(int i=0;i<s.length;i++){
									if(s[i].contains("LastDueDate")){
										String ss[] = s[i].split("@");
										oldLastDueDay = ss[1];
									}
								}	
							}
							
							if(sRemak.indexOf("NextDuedate")>=0){
								String s[] = sRemak.split(",");
								for(int i=0;i<s.length;i++){
									if(s[i].contains("NextDuedate")){
										String ss[] = s[i].split("@");
										oldNextDueDay = ss[1];
									}
								}	
							}
						}
						if(!oldLastDueDay.equals("") || !oldNextDueDay.equals("")){
							ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
							if(rptList==null||rptList.isEmpty())  throw new Exception("未找到贷款{"+loan.getObjectNo()+"}有效的还款定义!");
							for (BusinessObject rptSegment:rptList){
								dealLog = true;
								String status = rptSegment.getString("Status");
								if(!status.equals("1")) continue; 
								if(!rptSegment.getString("SegFromDate").equals("") && rptSegment.getString("SegFromDate").compareTo(businessDate)>0)
									continue;
								if(rptSegment.getString("SegToDate")!=null && !rptSegment.getString("SegToDate").equals("") && rptSegment.getString("SegToDate").compareTo(businessDate)<0)
									continue;
								//记录下上次还款日，如果冲账需要更新回去
								
								rptSegment.setAttributeValue("LastDueDate", oldLastDueDay);
								boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, rptSegment);
								
								//处理结息记录
								List<BusinessObject> tempInterestList = new ArrayList<BusinessObject>();
								List<BusinessObject> interestList=  loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.interest_log);
								if(interestList != null){
									
									for(BusinessObject inteLog : interestList){
										
										if(loan.getObjectNo().equals(inteLog.getString("ObjectNo"))
												&& loan.getObjectType().equals(inteLog.getString("ObjectType"))
												&& loan.getObjectNo().equals(inteLog.getString("RelativeObjectNo"))
												&& loan.getObjectType().equals(inteLog.getString("RelativeObjectType")))
										{
											
											if(ACCOUNT_CONSTANTS.Prepayment_InterestBaseFlag_NormalBalance.equals(oldPaymentBill.getString("PrepayInterestBaseFlag"))
													&& inteLog.getString("InterestDate").equals(oldLastDueDay) 
													&& (inteLog.getString("SettleDate").equals(oldNextDueDay) || inteLog.getString("SettleDate").equals(oldPaymentBill.getString("ActualPayDate"))))
											{
												tempInterestList.add(inteLog);
												boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete,inteLog);		
											}
											//挂息部分恢复
											if(ACCOUNT_CONSTANTS.PrepaymentType_All.equals(oldPaymentBill.getString("PrepayType"))
												&& inteLog.getString("SettleDate").equals(oldPaymentBill.getString("ActualPayDate")) 
												&& ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_PrePay_Principal.equals(inteLog.getString("BaseAmountFlag")))
											{
												inteLog.setAttributeValue("SettleDate", "");
												boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,inteLog);	
											}
										}
									}
									
								}
								loan.removeRelativeObject(tempInterestList);
							}
							
						}
						
					}
					
					loan.setAttributeValue("UPDATEPMTSCHDFLAG", "1");
					loan.setAttributeValue("UpdateInstalAmtFlag", "1");
					String prepayType = oldPaymentBill.getString("PrepayType");
					if(prepayType.equals(ACCOUNT_CONSTANTS.PrepaymentType_Part_FixInstalment)){
						loan.setAttributeValue("UpdateInstalAmtFlag", "0");
						ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
						if(rptList==null||rptList.isEmpty())  throw new Exception("未找到贷款{"+loan.getObjectNo()+"}有效的还款定义!");
						for (BusinessObject rptSegment:rptList){
							rptSegment.setAttributeValue("UpdateInstalAmtFlag", "0");//不要求重算期供
						}
					}
					
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete, paymentSchedule);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete, bo);
				}else{
					throw new Exception("还款计划类型不正确!" );
				}
				
			}
		}
			
		/*************对interestLog进行处理，冲账后计算金额需要复原********************/
		//当日还当日冲的不做处理,同一期还多次需要控制从后往前冲销
		
		if(!paymentBill.getString("ActualpayDate").equals(oldPaymentBill.getString("ActualpayDate"))){
			List<BusinessObject> rateList =InterestFunctions.getRateSegmentList(loan
					, ACCOUNT_CONSTANTS.RateType_Overdue);
			for(BusinessObject paymentSchedule : paymentScheduleList){
				//只处理一般还款的
				if(!paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)) continue;
				List<BusinessObject> paymentLog = paymentSchedule.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.PaymentLog);
				if(paymentLog == null  || paymentLog.isEmpty()) continue;
								
				for (BusinessObject rateSegment:rateList){
					if(rateSegment.getString("Status").equals("3")) continue;//非停本停息的
					String segmentSerialNo = rateSegment.getString("SerialNo");
					String interestObjectNo = paymentSchedule.getObjectNo();
					String interestObjectType = paymentSchedule.getObjectType();
					
					String interestBaseFlag = rateSegment.getString("InterestBaseFlag");//计息基础
					if(interestBaseFlag==null||interestBaseFlag.length()==0) 
						throw new Exception("利率信息{"+rateSegment.getObjectNo()+"}的计息基础标示为空！");
					
					String interestBaseFlagArray[] = interestBaseFlag.split(",");
					
					for(int i=0;i<interestBaseFlagArray.length;i++){
						String[] baseFlagArray={};//PaymentScheduleFunctions.getPaymentSchdAmtAttributeName(interestBaseFlagArray[i]);
						String payBaseFlag[] = baseFlagArray[0].split(",");
						String actualBaseFlag[] = baseFlagArray[1].split(",");
						double payAmt=0d;
						double actualPayAmt=0d;
						
						if(payBaseFlag.length>1){
							payAmt=paymentSchedule.getDouble(payBaseFlag[0])+paymentSchedule.getDouble(payBaseFlag[1]);
						}else{
							payAmt=paymentSchedule.getDouble(payBaseFlag[0]);
						}
						
						if(actualBaseFlag.length>1){
							actualPayAmt=paymentSchedule.getDouble(actualBaseFlag[0])+paymentSchedule.getDouble(actualBaseFlag[1]);
						}else{
							actualPayAmt=paymentSchedule.getDouble(actualBaseFlag[0]);
						}
									
						double baseAmount = Arith.round(payAmt-actualPayAmt,2);
						if(baseAmount<=0) {
							continue;
						}
											
						BusinessObject interestLog = null;//取settledate为空的记录
						BusinessObject lastInterestLog = null;//取上一条记录
						List<BusinessObject> interestLogList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.interest_log);
						if(interestLogList!=null){
							for(BusinessObject interestLogTemp:interestLogList){
								if(!segmentSerialNo.equals(interestLogTemp.getString("RateSegmentNo"))) continue;//不是当前利率的，跳过
								if(!interestBaseFlagArray[i].equals(interestLogTemp.getString("BaseAmountFlag"))) continue;//不是当前计息对象的，跳过
								if(!interestObjectType.equals(interestLogTemp.getString("ObjectType"))) continue;//不是当前计息对象的，跳过
								if(!interestObjectNo.equals(interestLogTemp.getString("ObjectNo"))) continue;//不是当前计息对象的，跳过
								
								String lastLogSerialNo = interestLogTemp.getString("LastSerialNo");
								String sInterestDate = interestLogTemp.getString("InterestDate");
								//不为空则证明有上一条log
								if(sInterestDate.equals(oldPaymentBill.getString("ActualpayDate")) && !lastLogSerialNo.equals("")){								
									for(int j=0;j<interestLogList.size();j++){
										BusinessObject last = interestLogList.get(j);
										if(last.getString("SerialNo").equals(lastLogSerialNo)){
											lastInterestLog=last;
										}
									}
								}
								String settleDate = interestLogTemp.getString("SettleDate");
								if(null==settleDate||"".equals(settleDate)){
									interestLog=interestLogTemp;
								}								
							}
						}
						
						if((interestLog!=null&&oldPaymentBill.getString("ActualpayDate").compareTo(interestLog.getString("LastInteDate"))>=0)||
								lastInterestLog!=null){
							//设置settleDate
							for(BusinessObject interestLogTemp:interestLogList){
								if(!segmentSerialNo.equals(interestLogTemp.getString("RateSegmentNo"))) continue;//不是当前利率的，跳过
								if(!interestBaseFlagArray[i].equals(interestLogTemp.getString("BaseAmountFlag"))) continue;//不是当前计息对象的，跳过
								String settleDate = interestLogTemp.getString("SettleDate");
								if(null==settleDate||"".equals(settleDate)){
									interestLogTemp.setAttributeValue("SettleDate", paymentBill.getString("ActualpayDate"));
									boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, interestLogTemp);
								}								
							}
							
						}
					}					
				}
			}
		}
	}
}
