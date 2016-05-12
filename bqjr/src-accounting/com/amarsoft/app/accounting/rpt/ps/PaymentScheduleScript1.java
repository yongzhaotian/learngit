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
import com.amarsoft.are.util.Arith;

/**
 * "等额本息期初还"还款方式的还款计划产生引擎。"等额本息期初还"与常规"等额本息"还款方式的区别在于前者是在每期期初进行还款，
 * 但期供和利息计算依然是根据期末的日期进行。相当于在常规"等额本息"的基础上将还款日期由期末改为了期初，是一种提前还的方式。
 * 
 * @author xyqu 2014年7月29日
 * 
 */
public final class PaymentScheduleScript1 implements IPaymentScheduleScript {

	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan_T, String toDate,
			AbstractBusinessObjectManager bom) throws Exception {
		BusinessObject loan = loan_T.cloneObject();
		String businessDate = loan.getString("BusinessDate");
		// 删除未来还款计划
		PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, "", null);

		// 获取贷款更新当日的还款计划，用以更新当前贷款余额
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
						- currentPrincipal, AccountingHelper.getMoneyPrecision(loan));
		// 重新赋值本金余额
		AccountCodeConfig.setBusinessObjectBalance(loan, "AccountCodeNo",
				ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, loanBalance);

		// 防止死循环
		int x = 0;
		List<BusinessObject> result = new ArrayList<BusinessObject>();// 新还款计划
		while (x < 1000 && loanBalance > 0d) {
			x++;
			// 计算期供本金
			double instalmentPrincipalAmt = 0d;
			String nextDueDateTmp = LoanFunctions.getNextDueDate(loan);
			loanBalance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
					ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
			if (loanBalance <= 0d) {
				break;
			}
			String nextDueDate = "";

			if (nextDueDate.equals("")) {
				nextDueDate = nextDueDateTmp;
			}
			loan.setAttributeValue("BusinessDate", nextDueDate);

			// 获取上次结息日，作为贷款的还款日
			String lastDueDate = LoanFunctions.getLastDueDate(loan);

			// 计算期供利息
			double instalmentInterest = 0d;
			List<BusinessObject> interestLogList = InterestSettleFunctions.getSettleInterestScript(
					ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest).settleInterest(loan, loan, nextDueDate,
					ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest, bom);
			for (BusinessObject interestLog : interestLogList) {
				instalmentInterest += interestLog.getDouble("InterestBase") + interestLog.getDouble("InterestAmt")
						- Arith.round(interestLog.getDouble("InterestBase"), AccountingHelper.getMoneyPrecision(loan));
			}
			boolean flag = RPTFunctions.getPayInterestFlag(loan, nextDueDate);
			if (!flag) {
				instalmentInterest = 0.0d;
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
				instalmentPrincipalAmt += instalmentPrincipalAmtTemp;
				RPTFunctions.getPMTScript(loan, rptSegment).nextInstalment(loan, rptSegment);// 进入下一个还款期次，并更新下次还款日及其他属性
			}

			instalmentPrincipalAmt = Arith.round(instalmentPrincipalAmt, AccountingHelper.getMoneyPrecision(loan));
			// 针对末期还本金存在的尾数问题，最后一期的还款本金至为贷款余额
			if (loanBalance - instalmentPrincipalAmt <= result.size() * 0.01) {
				instalmentPrincipalAmt = loanBalance;
			}

			if (Arith.round(instalmentPrincipalAmt + instalmentInterest, AccountingHelper.getMoneyPrecision(loan)) <= 0) {
				continue;
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
			paymentSchedule.setAttributeValue("ObjectNo", loan.getObjectNo());
			paymentSchedule.setAttributeValue("RelativeObjectType", loan.getObjectType());
			paymentSchedule.setAttributeValue("RelativeObjectNo", loan.getObjectNo());
			paymentSchedule.setAttributeValue("SeqID", currentPeriod);
			paymentSchedule.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
			paymentSchedule.setAttributeValue("PayDate", lastDueDate);
			paymentSchedule.setAttributeValue("PayPrincipalAmt",
					Arith.round(instalmentPrincipalAmt, AccountingHelper.getMoneyPrecision(loan)));
			paymentSchedule.setAttributeValue("PayInteAmt",
					Arith.round(instalmentInterest, AccountingHelper.getMoneyPrecision(loan)));
			paymentSchedule.setAttributeValue("PrincipalBalance", loanBalance);
			paymentSchedule.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
			result.add(paymentSchedule);
		}
		loan.setRelativeObjects(result);

		return result;
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
		ArrayList<BusinessObject> validRPTSegmentList = new ArrayList<BusinessObject>();
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
