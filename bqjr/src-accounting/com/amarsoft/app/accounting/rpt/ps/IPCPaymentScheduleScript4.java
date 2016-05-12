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
import com.amarsoft.app.accounting.util.AccountingHelper;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

public class IPCPaymentScheduleScript4 implements IPaymentScheduleScript {

	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan_T, String toDate,
			AbstractBusinessObjectManager bom) throws Exception {

		BusinessObject loan = loan_T.cloneObject();// 首先克隆

		String businessDate = loan.getString("BusinessDate");
		PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, "", null);// 删除未来还款计划
		List<BusinessObject> a1 = PaymentScheduleFunctions.getPaymentScheduleList(loan,
				ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal, businessDate, businessDate);
		double currentPrincipal = 0d;
		for (BusinessObject a : a1) {
			currentPrincipal += a.getDouble("PayPrincipalAmt") - a.getDouble("ActualPayPrincipalAmt");
		}

		// 取贷款余额信息
		double loanBalance = Arith.round(
				AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
						ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
						ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)
						- currentPrincipal, AccountingHelper.getMoneyPrecision(loan));// 获取贷款正常本金余额
		// 重新赋值本金余额
		AccountCodeConfig.setBusinessObjectBalance(loan, "AccountCodeNo",
				ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, loanBalance);

		// 防止死循环
		int x = 0;
		ArrayList<BusinessObject> paymentScheduleList = new ArrayList<BusinessObject>();// 新还款计划
		while (x < 1000 && loanBalance > 0d) {
			x++;
			// 计算期供本金
			double instalmentPrincipalAmt = 0d;
			String nextDueDateTmp = LoanFunctions.getNextDueDate(loan);
			loanBalance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
					ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
			if (loanBalance <= 0d)
				break;
			String nextDueDate = "";

			if (nextDueDate.equals(""))
				nextDueDate = nextDueDateTmp;
			loan.setAttributeValue("BusinessDate", nextDueDate);
			// 计算期供利息
			double instalmentInterest = 0d;
			List<BusinessObject> interestLogList = InterestSettleFunctions.getSettleInterestScript(
					ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest).settleInterest(loan, loan, nextDueDate,
					ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest, bom);
			for (BusinessObject interestLog : interestLogList) {
				instalmentInterest += interestLog.getDouble("InterestBase") + interestLog.getDouble("InterestAmt")
						- Arith.round(interestLog.getDouble("InterestBase"), AccountingHelper.getMoneyPrecision(loan));
			}

			List<BusinessObject> rptList = this.getActiveRPTSegment(loan);
			for (BusinessObject rptSegment : rptList) {
				if (!nextDueDate.equals(rptSegment.getString("NextDueDate")))
					continue;// 不处理

				String SegToDate = rptSegment.getString("SegToDate");
				if (SegToDate == null || SegToDate.length() == 0)
					SegToDate = loan.getString("MaturityDate");

				double instalmentPrincipalAmtTemp = Arith.round(RPTFunctions.getPMTScript(loan, rptSegment)
						.getPrincipalAmount(loan, rptSegment), AccountingHelper.getMoneyPrecision(loan));// 贷款本金
				/*
				 * 尾款不合并还时，倒数第二期次的还款额校正。 贷款余额-区段余额（尾款）-期供本金<=系统精度时，
				 * 当期期供本金=贷款余额-区段金额（尾款）
				 */
				double segamount = rptSegment.getDouble("SEGRPTAmount");
				if (loanBalance - instalmentPrincipalAmtTemp - segamount <= paymentScheduleList.size() * 0.01) {// 解决四舍五入的尾数问题
					instalmentPrincipalAmtTemp = loanBalance - segamount;
				}
				/* 结束 */
				instalmentPrincipalAmt += instalmentPrincipalAmtTemp;

				RPTFunctions.getPMTScript(loan, rptSegment).nextInstalment(loan, rptSegment);// 进入下一个还款期次，并更新下次还款日及其他属性
			}

			instalmentPrincipalAmt = Arith.round(instalmentPrincipalAmt, AccountingHelper.getMoneyPrecision(loan));
			if (loanBalance - instalmentPrincipalAmt <= paymentScheduleList.size() * 0.01) {// 解决四舍五入的尾数问题
				instalmentPrincipalAmt = loanBalance;
			}
			
			double segAmount = 0.0;
			double tailInteAmt = 0.0;
			double instalmentInterest_temp = 0.0;
			
			//利息修正
			instalmentInterest_temp = this.getSegAmountInterrest(instalmentInterest,loan,bom);
			instalmentInterest = instalmentInterest_temp;
			
			//if(Arith.round(instalmentPrincipalAmt+instalmentInterest,2)<=0) {
			if(Arith.round(instalmentPrincipalAmt+instalmentInterest,2)<=instalmentInterest_temp) {
				loanBalance=0.0;
				BusinessObject rptSegment = this.getActiveRPTSegment(loan).get(0);
				if(rptSegment == null) throw new Exception("未取到还款区段信息！");
				segAmount = rptSegment.getDouble("SEGRPTAmount");
				tailInteAmt = segAmount * Double.valueOf(rptSegment.getString("Remark"))/100.0/12;
			}
			
			//末期还款本金金额限定为贷款余额
			if(nextDueDate.equals(loan.getString("MaturityDate"))){
				instalmentPrincipalAmt=loanBalance;
			}
			// 计算贷款期次
			int currentPeriod = loan.getInt("CurrentPeriod") + 1;
			loan.setAttributeValue("CurrentPeriod", currentPeriod);
			loanBalance = Arith.round(loanBalance - instalmentPrincipalAmt, AccountingHelper.getMoneyPrecision(loan));
			// 更新贷款余额
			loan.setAttributeValue("NormalBalance", loanBalance);
			AccountCodeConfig.setBusinessObjectBalance(loan, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, loanBalance);

			// 新建还款计划
			BusinessObject paymentSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule, bom);

			paymentSchedule.setAttributeValue("ObjectType", loan.getObjectType());
			paymentSchedule.setAttributeValue("ObjectNo", loan.getString("SerialNo"));
			//paymentSchedule.setAttributeValue("RelativeObjectType", loan.getObjectType());
			//paymentSchedule.setAttributeValue("RelativeObjectNo", loan.getString("SerialNo"));
			paymentSchedule.setAttributeValue("SeqID", currentPeriod);
			paymentSchedule.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
			paymentSchedule.setAttributeValue("PayDate", nextDueDate);
			if(loanBalance <= 0.0) {
				paymentSchedule.setAttributeValue("PayPrincipalAmt", Arith.round(segAmount,2));
				paymentSchedule.setAttributeValue("PayInteAmt", Arith.round(tailInteAmt,2));
			}
			else {
				paymentSchedule.setAttributeValue("PayPrincipalAmt", Arith.round(instalmentPrincipalAmt,2));
				paymentSchedule.setAttributeValue("PayInteAmt", Arith.round(instalmentInterest,2));
			}
			paymentSchedule.setAttributeValue("PrincipalBalance", loanBalance);
			paymentSchedule.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
			paymentScheduleList.add(paymentSchedule);
			ARE.getLog().debug(
					"SeqID="
							+ paymentSchedule.getInt("SeqID")
							+ ";PayDate="
							+ paymentSchedule.getString("PayDate")
							+ ";InstallmentAmt="
							+ Arith.round(instalmentPrincipalAmt + instalmentInterest,
									AccountingHelper.getMoneyPrecision(loan)) + ";principalAmount="
							+ instalmentPrincipalAmt + ";interestAmount=" + instalmentInterest + ";PrincipalBalance="
							+ loanBalance);

		}
		loan.setRelativeObjects(paymentScheduleList);
		// 生成贴息计划
		// paymentScheduleList.addAll(PaymentScheduleFunctions.splitPaymentSchedule(loan,bom));

		return paymentScheduleList;
	}

	private double getSegAmountInterrest(double instalmentInterest,BusinessObject loan,AbstractBusinessObjectManager bom) throws Exception {

		BusinessObject rptSegment_Temp = this.getActiveRPTSegment(loan).get(0);
		if(rptSegment_Temp == null) throw new Exception("未取到还款区段信息！");
		double segAmount_Temp = rptSegment_Temp.getDouble("SEGRPTAmount");
		double tailInteAmt_Temp = segAmount_Temp * Double.valueOf(rptSegment_Temp.getString("Remark"))/100.0/12;
		
		List<BusinessObject> rateSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		double temp_rate = 0.0;
		double temp_InteAmt = 0.0;
		
		if(rateSegmentList!=null){
			for(BusinessObject rateSegment:rateSegmentList){
				if(rateSegment.getString("RateType").equals("01")){
					temp_rate = rateSegment.getDouble("BusinessRate");
					temp_InteAmt = segAmount_Temp * temp_rate/100.0/12;
				}
				
			}
		}
		return Arith.round(instalmentInterest-temp_InteAmt+tailInteAmt_Temp,2);
	}

	/**
	 * 获得当前有效的还款区段信息
	 * 
	 * @param loan
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getActiveRPTSegment(BusinessObject loan) throws Exception {
		List<BusinessObject> rptSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		List<BusinessObject> validRPTSegmentList = new ArrayList<BusinessObject>();
		if (rptSegmentList == null)
			return validRPTSegmentList;

		String businessDate = loan.getString("BusinessDate");
		for (BusinessObject a : rptSegmentList) {
			String status = a.getString("Status");
			if (!status.equals(ACCOUNT_CONSTANTS.STATUS_EFFECTIVE))
				continue;
			String SegFromDate = a.getString("SegFromDate");
			String SegToDate = a.getString("SegToDate");
			if (SegFromDate != null && SegFromDate.length() > 0 && SegFromDate.compareTo(businessDate) > 0)
				continue;
			if (SegToDate != null && SegToDate.length() > 0 && SegToDate.compareTo(businessDate) < 0)
				continue;

			validRPTSegmentList.add(a);
		}
		return validRPTSegmentList;
	}
}