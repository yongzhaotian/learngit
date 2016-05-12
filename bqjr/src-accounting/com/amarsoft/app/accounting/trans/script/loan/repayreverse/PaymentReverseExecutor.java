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
	//�Ƿ���Ҫɾ����Ϣ��log
	public boolean dealLog = false;
	
	private ITransactionScript transactionScript;


	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript =transactionScript;
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		//ȡLoan����
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject oldTransaction = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		BusinessObject oldPaymentBill = oldTransaction.getRelativeObject(oldTransaction.getString("DocumentType"), oldTransaction.getString("DocumentSerialNo"));
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		setOldBill();
		
		//�����˽����� ����ƻ�
		updatePaymentSch();

		//��������ת
		double ps_OverduePrincipalBalance = 0d;//getPaymentSchdAmt(loan,loan.getString("BusinessDate"), ACCOUNT_CONSTANTS.PS_AMOUNT_TYPE_Principal);
		transaction.setAttributeValue("PSOverduePrincipal", ps_OverduePrincipalBalance);
		
		//�������ǲ�����ǰ����-�ڹ��������ǰ�����ô����Ѵ���Ĵ����ո��»�ԭ����ֵ����Ϊ������ǰ����-�ڹ������ı����ĵ����գ������ʱ��Ӧ�ûָ���
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
		
		//�������Ĵ����ٳ�������Ҫ����������ڸ��µ�����,dxu1 20121205
		String businessDate = SystemConfig.getBusinessDate();
		if(loan.getString("BusinessDate").compareTo(businessDate)<0){
			loan.setAttributeValue("BusinessDate", businessDate);
		}
		return 1;
	}
	
	private void setOldBill() throws Exception{
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		//ȡLoan����
		BusinessObject oldTransaction = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		BusinessObject oldPaymentBill = oldTransaction.getRelativeObject(oldTransaction.getString("DocumentType"), oldTransaction.getString("DocumentSerialNo"));
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		
		oldTransaction.setAttributeValue("TransStatus", "2");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,oldTransaction);	
		
		oldPaymentBill.setAttributeValue("Status", "2");//ԭ���׸���Ϊ�ѳ���
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


	//ѭ�����»���ƻ���
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
								//��һ�㻹��ֵĴ���,��paymentLog�ļ�¼ѭ�����µ�paymentschdue�С�
								//����
								paymentSchedule.setAttributeValue("ActualPayPrincipalAmt",Arith.round(paymentSchedule.getDouble("ActualPayPrincipalAmt") - bo.getDouble("ActualPayPrincipalAmt"),2));
								
								//��Ϣ
								paymentSchedule.setAttributeValue("ActualPayInteAmt",Arith.round(paymentSchedule.getDouble("ActualPayInteAmt") - bo.getDouble("ActualPayInteAmt"),2));
								
								if((bo.getDouble("ActualPayPrincipalAmt") + bo.getDouble("ActualPayInteAmt") )>0 ){
									paymentSchedule.setAttributeValue("SettleDate", "");
								}
								//��Ϣ
								paymentSchedule.setAttributeValue("ActualPayFineAmt",Arith.round(paymentSchedule.getDouble("ActualPayFineAmt") - bo.getDouble("ActualPayFineAmt"),2));

								//����
								paymentSchedule.setAttributeValue("ActualPayCompdinteAmt",Arith.round(paymentSchedule.getDouble("ActualPayCompdinteAmt") - bo.getDouble("ActualPayCompdinteAmt"),2));

								paymentSchedule.setAttributeValue("FinishDate", "");
								
								//�ͻ������A2,ӡ��˰A11,���ɽ�A10,��������A7,���շ�A12
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
					//��һ�㻹��ֵĴ���,��paymentLog�ļ�¼ѭ�����µ�paymentschdue�С�
					//����
					paymentSchedule.setAttributeValue("ActualPayPrincipalAmt",Arith.round(paymentSchedule.getDouble("ActualPayPrincipalAmt") - bo.getDouble("ActualPayPrincipalAmt"),2));
					
					//��Ϣ
					paymentSchedule.setAttributeValue("ActualPayInteAmt",Arith.round(paymentSchedule.getDouble("ActualPayInteAmt") - bo.getDouble("ActualPayInteAmt"),2));
					
					if((bo.getDouble("ActualPayPrincipalAmt") + bo.getDouble("ActualPayInteAmt") )>0 ){
						paymentSchedule.setAttributeValue("SettleDate", "");
					}
					//��Ϣ
					paymentSchedule.setAttributeValue("ActualPayFineAmt",Arith.round(paymentSchedule.getDouble("ActualPayFineAmt") - bo.getDouble("ActualPayFineAmt"),2));

					//����
					paymentSchedule.setAttributeValue("ActualPayCompdinteAmt",Arith.round(paymentSchedule.getDouble("ActualPayCompdinteAmt") - bo.getDouble("ActualPayCompdinteAmt"),2));

					paymentSchedule.setAttributeValue("FinishDate", "");
					
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,paymentSchedule);	
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete, bo);
					
				}else if(paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay)||paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All)){
					//����ǰ����ֵĴ���,ɾ�����������һ�ڣ�ע���Ϣ�յĴ���,��
					
					//Ŀǰ����ס������Ϣ�ղ��ܳ���
					String lastDueDate = LoanFunctions.getLastDueDate(loan);
					if(lastDueDate.compareTo(paymentSchedule.getString("PayDate"))>0) throw new Exception("��ǰ�����Ѿ�����һ�ν�Ϣ����,�����������");
						
					//����������ǰ���������Ϣ������Ҫ���½�Ϣ�ջ���ǰ�Ľ�Ϣ��
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
							if(rptList==null||rptList.isEmpty())  throw new Exception("δ�ҵ�����{"+loan.getObjectNo()+"}��Ч�Ļ����!");
							for (BusinessObject rptSegment:rptList){
								dealLog = true;
								String status = rptSegment.getString("Status");
								if(!status.equals("1")) continue; 
								if(!rptSegment.getString("SegFromDate").equals("") && rptSegment.getString("SegFromDate").compareTo(businessDate)>0)
									continue;
								if(rptSegment.getString("SegToDate")!=null && !rptSegment.getString("SegToDate").equals("") && rptSegment.getString("SegToDate").compareTo(businessDate)<0)
									continue;
								//��¼���ϴλ����գ����������Ҫ���»�ȥ
								
								rptSegment.setAttributeValue("LastDueDate", oldLastDueDay);
								boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, rptSegment);
								
								//�����Ϣ��¼
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
											//��Ϣ���ָֻ�
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
						if(rptList==null||rptList.isEmpty())  throw new Exception("δ�ҵ�����{"+loan.getObjectNo()+"}��Ч�Ļ����!");
						for (BusinessObject rptSegment:rptList){
							rptSegment.setAttributeValue("UpdateInstalAmtFlag", "0");//��Ҫ�������ڹ�
						}
					}
					
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete, paymentSchedule);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete, bo);
				}else{
					throw new Exception("����ƻ����Ͳ���ȷ!" );
				}
				
			}
		}
			
		/*************��interestLog���д������˺��������Ҫ��ԭ********************/
		//���ջ����ճ�Ĳ�������,ͬһ�ڻ������Ҫ���ƴӺ���ǰ����
		
		if(!paymentBill.getString("ActualpayDate").equals(oldPaymentBill.getString("ActualpayDate"))){
			List<BusinessObject> rateList =InterestFunctions.getRateSegmentList(loan
					, ACCOUNT_CONSTANTS.RateType_Overdue);
			for(BusinessObject paymentSchedule : paymentScheduleList){
				//ֻ����һ�㻹���
				if(!paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)) continue;
				List<BusinessObject> paymentLog = paymentSchedule.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.PaymentLog);
				if(paymentLog == null  || paymentLog.isEmpty()) continue;
								
				for (BusinessObject rateSegment:rateList){
					if(rateSegment.getString("Status").equals("3")) continue;//��ͣ��ͣϢ��
					String segmentSerialNo = rateSegment.getString("SerialNo");
					String interestObjectNo = paymentSchedule.getObjectNo();
					String interestObjectType = paymentSchedule.getObjectType();
					
					String interestBaseFlag = rateSegment.getString("InterestBaseFlag");//��Ϣ����
					if(interestBaseFlag==null||interestBaseFlag.length()==0) 
						throw new Exception("������Ϣ{"+rateSegment.getObjectNo()+"}�ļ�Ϣ������ʾΪ�գ�");
					
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
											
						BusinessObject interestLog = null;//ȡsettledateΪ�յļ�¼
						BusinessObject lastInterestLog = null;//ȡ��һ����¼
						List<BusinessObject> interestLogList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.interest_log);
						if(interestLogList!=null){
							for(BusinessObject interestLogTemp:interestLogList){
								if(!segmentSerialNo.equals(interestLogTemp.getString("RateSegmentNo"))) continue;//���ǵ�ǰ���ʵģ�����
								if(!interestBaseFlagArray[i].equals(interestLogTemp.getString("BaseAmountFlag"))) continue;//���ǵ�ǰ��Ϣ����ģ�����
								if(!interestObjectType.equals(interestLogTemp.getString("ObjectType"))) continue;//���ǵ�ǰ��Ϣ����ģ�����
								if(!interestObjectNo.equals(interestLogTemp.getString("ObjectNo"))) continue;//���ǵ�ǰ��Ϣ����ģ�����
								
								String lastLogSerialNo = interestLogTemp.getString("LastSerialNo");
								String sInterestDate = interestLogTemp.getString("InterestDate");
								//��Ϊ����֤������һ��log
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
							//����settleDate
							for(BusinessObject interestLogTemp:interestLogList){
								if(!segmentSerialNo.equals(interestLogTemp.getString("RateSegmentNo"))) continue;//���ǵ�ǰ���ʵģ�����
								if(!interestBaseFlagArray[i].equals(interestLogTemp.getString("BaseAmountFlag"))) continue;//���ǵ�ǰ��Ϣ����ģ�����
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
