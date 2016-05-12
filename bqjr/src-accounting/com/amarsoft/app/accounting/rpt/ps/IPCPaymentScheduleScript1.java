package com.amarsoft.app.accounting.rpt.ps;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.rpt.due.CommonDueDateScript;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.app.accounting.util.RateFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;

public class IPCPaymentScheduleScript1 implements IPaymentScheduleScript{

	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan,String toDate,AbstractBusinessObjectManager bom) throws Exception {
		BusinessObject loanTemp =loan.cloneObject();
		String businessDate = loanTemp.getString("BusinessDate");
		List<BusinessObject> a1=PaymentScheduleFunctions.getPaymentScheduleList(loanTemp, "1", businessDate, businessDate, "Unfinished");
		double currentPrincipal=0d;
		for(BusinessObject a:a1){
			currentPrincipal+=a.getDouble("PayPrincipalAmt")-a.getDouble("ActualPayPrincipalAmt");
		}

		AccountCodeConfig.setBusinessObjectBalance(loanTemp, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, 
				Arith.round(AccountCodeConfig.getBusinessObjectBalance(loanTemp, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal
						,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)-currentPrincipal,2));
		
		String updateInstalAmtFlag=loanTemp.getString("UpdateInstalAmtFlag");
		if(updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){//��Ҫ���㻹��ƻ�ʱ����ɾ������ԭ���Ļ���ƻ�
			//PaymentScheduleFunctions.removeFuturePaymentScheduleList(loanTemp, null, bom);
		}
		List<BusinessObject> paymentScheduleList = PaymentScheduleFunctions.getFuturePaymentScheduleList(loanTemp, "1");
		if(paymentScheduleList==null||paymentScheduleList.isEmpty()){
			//���δ������ƻ�Ϊ�գ�������δ������ƻ���ֻ��ȷ��PayDate��ObjectNo��PayType���ɣ�������㱾����Ϣ
			CommonDueDateScript dueDateScript = new CommonDueDateScript();
			List<String> payDateList = dueDateScript.getPayDateList(loan, this.getActiveRPTSegment(loan).get(0));
			int seq=1;
			for(String payDate:payDateList){
				BusinessObject ps = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,bom);
				
				ps.setAttributeValue("ObjectType", loanTemp.getObjectType());
				ps.setAttributeValue("ObjectNo", loanTemp.getObjectNo());
				ps.setAttributeValue("PayDate", payDate);
				ps.setAttributeValue("PayType", "1");
				ps.setAttributeValue("SeqID", seq);
				loanTemp.setRelativeObject(ps);
				seq++;
			}
		}
		
		paymentScheduleList = PaymentScheduleFunctions.getFuturePaymentScheduleList(loanTemp, "1");
		double principalBalance = AccountCodeConfig.getBusinessObjectBalance(loanTemp, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal
				,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		String lastDueDate = LoanFunctions.getLastDueDate(loanTemp);
		
		double installmentAmt = this.getInstallmentAmt(loanTemp,lastDueDate,principalBalance, paymentScheduleList);
		
		int i=0;
		for(BusinessObject ps:paymentScheduleList){//���㻹��ƻ��������Ϣ
			i++;
			String payDate = ps.getString("PayDate");
			//�����ڹ���Ϣ
    		double psInterestRate=RateFunctions.getInterestRate(loanTemp, lastDueDate, lastDueDate, payDate,ACCOUNT_CONSTANTS.RateType_Normal);
    		double interestAmount = Arith.round(principalBalance*psInterestRate,2);
			ps.setAttributeValue("PayInteAmt", interestAmount);
			//�����ڹ�����
			double principalAmount = 0d;
			double fixInstallmentAmt = ps.getMoney("FixInstallmentAmt");
			double fixPrincipalAmt = ps.getMoney("FixPrincipalAmt");
			
			if(fixInstallmentAmt==0d){
				fixInstallmentAmt=installmentAmt;
			}
			if(fixPrincipalAmt>0d){
				principalAmount=fixPrincipalAmt;//���ָ���������ʹ�ñ�����
			}
			else{
				principalAmount= Arith.round(fixInstallmentAmt-interestAmount,2);
			}
			
			if(principalAmount>principalBalance||i==paymentScheduleList.size()){
				principalAmount=principalBalance;
			}
			if(principalAmount<0d) principalAmount=0;
	    	ps.setAttributeValue("PayPrincipalAmt", principalAmount);
	    	//����ʣ�౾��
			principalBalance = Arith.round(principalBalance-principalAmount,2);
			ps.setAttributeValue("PrincipalBalance", principalBalance);
			loan.setAttributeValue("NormalBalance", principalBalance);
			ps.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
			lastDueDate=payDate;
			ARE.getLog().debug("SeqID="+ps.getInt("SeqID")+";PayDate="+ps.getString("PayDate")+";InstallmentAmt="+Arith.round(principalAmount+interestAmount,2)
					+";principalAmount="+principalAmount+";interestAmount="+interestAmount
					+";PrincipalBalance="+principalBalance);
			loanTemp.setAttributeValue("BusinessDate", payDate);
			if(ps.getMoney("FixInstallmentAmt")>0||ps.getMoney("FixPrincipalAmt")>0){
				installmentAmt = this.getInstallmentAmt(loanTemp,lastDueDate,principalBalance, PaymentScheduleFunctions.getFuturePaymentScheduleList(loanTemp, "1"));
			}
		}
		return paymentScheduleList;
	}
	
	private double getInstallmentAmt(BusinessObject loan,String lastDueDate,double principalBalance,List<BusinessObject> paymentScheduleList)  throws Exception{
		double installmentAmt=0d;
		
		if(principalBalance<=0d) return 0d;
		
		double base1 = 1;//�������ӣ���ʼΪ1
    	double baseSum = 0;//������������֮��
    	double alterSum = 0;// ���ڵ�������뵱���������ӻ� ���ۼ�
    	double alterbase = 0;// ���ڵ���������������֮��
    	
    	for(BusinessObject ps:paymentScheduleList){
    		String payDate = ps.getString("PayDate");
    		double installmentInterestRate=RateFunctions.getInterestRate(loan, lastDueDate, lastDueDate, payDate,ACCOUNT_CONSTANTS.RateType_Normal);
			base1 = base1/(1+installmentInterestRate);
			baseSum += base1;
			/*
			//�жϸ����Ƿ��н�����������У��򲻲����������Ӽ���;�����ʶΪָ�����ڻ��������ֹ��޸ĵļ�¼���ٲ��������������
			double fixInstallmentAmt=ps.getMoney("FixInstallmentAmt");
			if(fixInstallmentAmt>0d){
				alterSum += fixInstallmentAmt*base1;
				alterbase += base1;
			}
			*/
			lastDueDate = payDate;
    	}
    	installmentAmt =  Arith.round((principalBalance-alterSum)/(baseSum-alterbase),2);
		return installmentAmt;
	}
		
	/**
	 * ��õ�ǰ��Ч�Ļ���������Ϣ
	 * @param loan
	 * @return
	 * @throws Exception
	 */
	public ArrayList<BusinessObject> getActiveRPTSegment(BusinessObject loan) throws Exception {	
		ArrayList<BusinessObject> rptSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		ArrayList<BusinessObject> validRPTSegmentList= new ArrayList<BusinessObject>();
		if(rptSegmentList==null) return validRPTSegmentList;
		
		String businessDate=loan.getString("BusinessDate");
		for(BusinessObject a:rptSegmentList){
			String status = a.getString("Status");
			if(!status.equals("1")) continue;
			String SegFromDate = a.getString("SegFromDate");
			String SegToDate = a.getString("SegToDate");
			if(SegFromDate!=null&&SegFromDate.length()>0&&SegFromDate.compareTo(businessDate)>0)
				continue;
			if(SegToDate!=null&&SegToDate.length()>0&&SegToDate.compareTo(businessDate)<=0)
				continue;
			
			validRPTSegmentList.add(a);
		}
		return validRPTSegmentList;
	}
}
