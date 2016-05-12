package com.amarsoft.app.accounting.rpt.ps;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.rpt.due.IDueDateScript;
import com.amarsoft.app.accounting.rpt.pmt.IPMTScript;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.AccountingHelper;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctionsForHead;
import com.amarsoft.app.accounting.util.RateFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;

public class IPCPaymentScheduleScript5 implements IPaymentScheduleScript {

	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan, String toDate,
			AbstractBusinessObjectManager bom) throws Exception {
		BusinessObject loanTemp = loan.cloneObject();
		String businessDate = loanTemp.getString("BusinessDate");
		List<BusinessObject> a1 = PaymentScheduleFunctions.getPaymentScheduleList(loanTemp,
				ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal, businessDate, businessDate);
		double currentPrincipal = 0d;
		for (BusinessObject a : a1) {
			currentPrincipal += a.getDouble("PayPrincipalAmt") - a.getDouble("ActualPayPrincipalAmt");
		}

		AccountCodeConfig.setBusinessObjectBalance(loanTemp, "AccountCodeNo",
				ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, Arith.round(
						AccountCodeConfig.getBusinessObjectBalance(loanTemp, "AccountCodeNo",
								ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
								ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)
								- currentPrincipal, AccountingHelper.getMoneyPrecision(loan)));

		String updatePMTSchdFlag = loanTemp.getString("UpdatePMTSchdFlag");
		if (updatePMTSchdFlag != null && updatePMTSchdFlag.equals(ACCOUNT_CONSTANTS.FLAG_YES)) {// 需要重算还款计划时，则删除所有原来的还款计划
			PaymentScheduleFunctions.removeFuturePaymentScheduleList(loanTemp, null, bom);
		}
		BusinessObject rptSegment = this.getActiveRPTSegment(loanTemp).get(0);
		IDueDateScript dueDateScript = RPTFunctions.getDueDateScript(loanTemp, rptSegment);
		IPMTScript pmtScript = RPTFunctions.getPMTScript(loanTemp, rptSegment);

		List<BusinessObject> paymentScheduleList = PaymentScheduleFunctionsForHead.getFuturePaymentScheduleList(
				loanTemp, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
		if (paymentScheduleList == null || paymentScheduleList.isEmpty()) {
			// 如果未来还款计划为空，则生成未来还款计划，只需确定PayDate、ObjectNo、PayType即可，无需计算本金利息
			List<String> payDateList = dueDateScript.getPayDateList(loanTemp, rptSegment);
			int seq = loan.getInt("CurrentPeriod") + 1;
			for (String payDate : payDateList) {
				BusinessObject ps = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule, bom);

				ps.setAttributeValue("ObjectType", loanTemp.getObjectType());
				ps.setAttributeValue("ObjectNo", loanTemp.getObjectNo());
				//ps.setAttributeValue("RelativeObjectType", loanTemp.getObjectType());
				//ps.setAttributeValue("RelativeObjectNo", loanTemp.getString("SerialNo"));
				ps.setAttributeValue("PayDate", payDate);
				ps.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
				ps.setAttributeValue("SeqID", seq);
				loanTemp.setRelativeObject(ps);
				seq++;
			}
		}

		paymentScheduleList = PaymentScheduleFunctionsForHead.getFuturePaymentScheduleList(loanTemp,
				ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);

		String lastDueDate = LoanFunctions.getLastDueDate(loanTemp);
		double principalBalance = AccountCodeConfig.getBusinessObjectBalance(loanTemp, "AccountCodeNo",
				ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
				ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		// 初始化指定金额
		List<BusinessObject> fixpsList = loan.getRelativeObjects("FixPaymentSchedule");
		if (fixpsList != null && fixpsList.size() > 0) {
			for (BusinessObject fixps : fixpsList) {
				double fixInstallmentAmt = fixps.getMoney("FixInstallmentAmt");
				double fixPrincipalAmt = fixps.getMoney("FixPrincipalAmt");
				String payDate = fixps.getString("PayDate");
				int seqID = fixps.getInt("SeqID");
				for (BusinessObject ps : paymentScheduleList) {
					if (seqID == ps.getInt("SeqID")) {
						if (fixInstallmentAmt != 0d || fixPrincipalAmt != 0d) {
							ps.setAttributeValue("FixInstallmentAmt", fixInstallmentAmt);
							ps.setAttributeValue("FixPrincipalAmt", fixPrincipalAmt);
							ps.setAttributeValue("PayDate", payDate);
						} else if (!payDate.equals(ps.getString("PayDate"))) {
							ps.setAttributeValue("PayDate", payDate);
						}
						break;
					}
				}
			}
		}

		double installmentAmt = pmtScript.getInstalmentAmount(loanTemp, rptSegment);
		rptSegment.setAttributeValue("SegInstalmentAmt", installmentAmt);
		int i = 0;
		for (BusinessObject ps : paymentScheduleList) {// 计算还款计划本金和利息
			i++;
			String payDate = ps.getString("PayDate");
			double principalAmount = 0d;
			double fixInstallmentAmt = ps.getMoney("FixInstallmentAmt");
			double fixPrincipalAmt = ps.getMoney("FixPrincipalAmt");

			if (fixInstallmentAmt == 0d) {
				fixInstallmentAmt = installmentAmt;
			} else if (fixInstallmentAmt < 0d) {
				ps.setAttributeValue("PrincipalBalance", principalBalance);
				ps.setAttributeValue("PayPrincipalAmt", 0d);
				ps.setAttributeValue("PayInteAmt", 0d);
				continue;
			}

			// 计算期供利息
			double psInterestRate = RateFunctions.getInterestRate(loanTemp, lastDueDate, lastDueDate, payDate,
					ACCOUNT_CONSTANTS.RateType_Normal);
			//double interestAmount = Arith.round(principalBalance * psInterestRate,AccountingHelper.getMoneyPrecision(loan));
			//hhcf利息修正
			double fineAmount = rptSegment.getDouble("SegRPTAmount");//尾款金额
			double fineRate = rptSegment.getDouble("Remark");//尾款利率
			double fineInterestAmount = Arith.round(fineAmount * fineRate * 0.01/12,AccountingHelper.getMoneyPrecision(loan));
			double interestAmount = Arith.round(((principalBalance-fineAmount) * psInterestRate) + fineInterestAmount,
					AccountingHelper.getMoneyPrecision(loan));
			
			ps.setAttributeValue("PayInteAmt", interestAmount);
			// 计算期供本金
			if (fixPrincipalAmt > 0d) {
				principalAmount = fixPrincipalAmt;// 如果指定本金金额，则使用本金金额
			} else if (fixPrincipalAmt < 0d) {
				principalAmount = 0;// 如果指定本金金额，则使用本金金额
			} else {
				principalAmount = Arith.round(fixInstallmentAmt - interestAmount,
						AccountingHelper.getMoneyPrecision(loan));
			}
			// 最后一期如果存在尾差，则合并
			if (principalAmount > principalBalance || i == paymentScheduleList.size()
					|| principalBalance - principalAmount < paymentScheduleList.size() * 0.01) {
				principalAmount = principalBalance;
			}
			if (principalAmount < 0d)
				principalAmount = 0;
			ps.setAttributeValue("PayPrincipalAmt",
					Arith.round(principalAmount, AccountingHelper.getMoneyPrecision(loan)));
			// 计算剩余本金
			principalBalance = Arith
					.round(principalBalance - principalAmount, AccountingHelper.getMoneyPrecision(loan));
			ps.setAttributeValue("PrincipalBalance", principalBalance);

			AccountCodeConfig.setBusinessObjectBalance(loanTemp, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, principalBalance);

			lastDueDate = payDate;
			ps.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
			ARE.getLog().debug(
					"SeqID=" + ps.getInt("SeqID") + ";PayDate=" + ps.getString("PayDate") + ";InstallmentAmt="
							+ Arith.round(principalAmount + interestAmount, AccountingHelper.getMoneyPrecision(loan))
							+ ";principalAmount=" + ps.getDouble("PayPrincipalAmt") + ";interestAmount="
							+ interestAmount + ";PrincipalBalance=" + principalBalance);
		}
		return paymentScheduleList;
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
			if (SegToDate != null && SegToDate.length() > 0 && SegToDate.compareTo(businessDate) <= 0)
				continue;

			validRPTSegmentList.add(a);
		}
		return validRPTSegmentList;
	}
}
