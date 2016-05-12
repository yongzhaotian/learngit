package com.amarsoft.app.accounting.rpt.ps;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.interest.settle.InterestSettleFunctions;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;

public class CommonPaymentScheduleScript implements IPaymentScheduleScript{

	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan_T,String toDate,AbstractBusinessObjectManager bom) throws Exception {

		BusinessObject loan = loan_T.cloneObject();//首先克隆
		
		String businessDate = loan.getString("BusinessDate");
		PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan,"", null);//删除未来还款计划
		List<BusinessObject> a1=PaymentScheduleFunctions.getPaymentScheduleList(loan, "1", businessDate, businessDate, "Unfinished");
		double currentPrincipal=0d;
		for(BusinessObject a:a1){
			currentPrincipal+=a.getDouble("PayPrincipalAmt")-a.getDouble("ActualPayPrincipalAmt");
		}
		
		//取贷款余额信息
		double loanBalance = Arith.round(
						AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo"
								,ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal
								,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)-currentPrincipal,2);//获取贷款正常本金余额
		//重新赋值本金余额
		AccountCodeConfig.setBusinessObjectBalance(loan, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, loanBalance);
		
		//防止死循环
		int x =0;
		ArrayList<BusinessObject> paymentScheduleList=new ArrayList<BusinessObject>();//新还款计划
		while(x<1000&&loanBalance>0d){
			x++;
			//计算期供本金
			double instalmentPrincipalAmt=0d;
			String nextDueDateTmp=LoanFunctions.getNextDueDate(loan);
			loanBalance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal
					,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
			if(loanBalance<=0d) break;
			String nextDueDate = "";

			if(nextDueDate.equals("")) nextDueDate = nextDueDateTmp;
			loan.setAttributeValue("BusinessDate", nextDueDate);
			//计算期供利息
			double instalmentInterest=0d;
			List<BusinessObject> interestLogList = InterestSettleFunctions.getSettleInterestScript(ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest)
						.settleInterest(loan, loan, nextDueDate,ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest, bom);
			for(BusinessObject interestLog:interestLogList){
				instalmentInterest+=interestLog.getDouble("InterestAmt");
			}
			
			ArrayList<BusinessObject> rptList = this.getActiveRPTSegment(loan);
			for (BusinessObject rptSegment:rptList){
				if(!nextDueDate.equals(rptSegment.getString("NextDueDate"))) continue;//不处理
				
				String SegToDate=rptSegment.getString("SegToDate");
				if(SegToDate==null||SegToDate.length()==0)
					SegToDate= loan.getString("MaturityDate");
				
				double instalmentPrincipalAmtTemp = Arith.round(RPTFunctions.getPMTScript(loan, rptSegment).getPrincipalAmount(loan, rptSegment),2);//贷款本金
				instalmentPrincipalAmt+=instalmentPrincipalAmtTemp;
				RPTFunctions.getPMTScript(loan, rptSegment).nextInstalment(loan, rptSegment);//进入下一个还款期次，并更新下次还款日及其他属性
			}
			
			instalmentPrincipalAmt=Arith.round(instalmentPrincipalAmt,2);
			if(loanBalance-instalmentPrincipalAmt<=paymentScheduleList.size()*0.01) {//解决四舍五入的尾数问题
				instalmentPrincipalAmt=loanBalance;
			}
			
			if(Arith.round(instalmentPrincipalAmt+instalmentInterest,2)<=0) continue;
			
			//计算贷款期次
			int currentPeriod =loan.getInt("CurrentPeriod")+1;
			loan.setAttributeValue("CurrentPeriod",currentPeriod);
			loanBalance=Arith.round(loanBalance-instalmentPrincipalAmt,2);
			//更新贷款余额
			loan.setAttributeValue("NormalBalance", loanBalance);
			AccountCodeConfig.setBusinessObjectBalance(loan, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, loanBalance);
			
			//新建还款计划
			BusinessObject paymentSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,bom);
			
			paymentSchedule.setAttributeValue("ObjectType", loan.getObjectType());
			paymentSchedule.setAttributeValue("ObjectNo", loan.getString("SerialNo"));
			paymentSchedule.setAttributeValue("SeqID", currentPeriod);
			paymentSchedule.setAttributeValue("PayType", "1");
			paymentSchedule.setAttributeValue("PayDate", nextDueDate);
			paymentSchedule.setAttributeValue("PayPrincipalAmt", Arith.round(instalmentPrincipalAmt,2));
			paymentSchedule.setAttributeValue("PayInteAmt", Arith.round(instalmentInterest,2));
			paymentSchedule.setAttributeValue("PrincipalBalance", loanBalance);
			paymentSchedule.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
			paymentScheduleList.add(paymentSchedule);
			ARE.getLog().debug("SeqID="+paymentSchedule.getInt("SeqID")+";PayDate="+paymentSchedule.getString("PayDate")+";InstallmentAmt="+Arith.round(instalmentPrincipalAmt+instalmentInterest,2)
					+";principalAmount="+instalmentPrincipalAmt+";interestAmount="+instalmentInterest
					+";PrincipalBalance="+loanBalance);
			

		}
		loan.setRelativeObjects(paymentScheduleList);
		//生成贴息计划
		//paymentScheduleList.addAll(PaymentScheduleFunctions.splitPaymentSchedule(loan,bom));
		
		return paymentScheduleList;
	}
	
	/**
	 * 获得当前有效的还款区段信息
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
			if(SegToDate!=null&&SegToDate.length()>0&&SegToDate.compareTo(businessDate)<0)
				continue;
			
			validRPTSegmentList.add(a);
		}
		return validRPTSegmentList;
	}
}
