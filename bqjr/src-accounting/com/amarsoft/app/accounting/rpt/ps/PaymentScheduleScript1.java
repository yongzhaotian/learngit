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
 * "�ȶϢ�ڳ���"���ʽ�Ļ���ƻ��������档"�ȶϢ�ڳ���"�볣��"�ȶϢ"���ʽ����������ǰ������ÿ���ڳ����л��
 * ���ڹ�����Ϣ������Ȼ�Ǹ�����ĩ�����ڽ��С��൱���ڳ���"�ȶϢ"�Ļ����Ͻ�������������ĩ��Ϊ���ڳ�����һ����ǰ���ķ�ʽ��
 * 
 * @author xyqu 2014��7��29��
 * 
 */
public final class PaymentScheduleScript1 implements IPaymentScheduleScript {

	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan_T, String toDate,
			AbstractBusinessObjectManager bom) throws Exception {
		BusinessObject loan = loan_T.cloneObject();
		String businessDate = loan.getString("BusinessDate");
		// ɾ��δ������ƻ�
		PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, "", null);

		// ��ȡ������µ��յĻ���ƻ������Ը��µ�ǰ�������
		List<BusinessObject> a1 = PaymentScheduleFunctions.getPaymentScheduleList(loan,
				ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal, businessDate, businessDate);
		double currentPrincipal = 0d;
		for (BusinessObject a : a1) {
			currentPrincipal += a.getDouble("PayPrincipalAmt") - a.getDouble("ActualPayPrincipalAmt");
		}

		// ȡ���������Ϣ
		double loanBalance = Arith.round(
				AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
						ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
						ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)
						- currentPrincipal, AccountingHelper.getMoneyPrecision(loan));
		// ���¸�ֵ�������
		AccountCodeConfig.setBusinessObjectBalance(loan, "AccountCodeNo",
				ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, loanBalance);

		// ��ֹ��ѭ��
		int x = 0;
		List<BusinessObject> result = new ArrayList<BusinessObject>();// �»���ƻ�
		while (x < 1000 && loanBalance > 0d) {
			x++;
			// �����ڹ�����
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

			// ��ȡ�ϴν�Ϣ�գ���Ϊ����Ļ�����
			String lastDueDate = LoanFunctions.getLastDueDate(loan);

			// �����ڹ���Ϣ
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
					continue;// ������

				String SegToDate = rptSegment.getString("SegToDate");
				if (SegToDate == null || SegToDate.length() == 0)
					SegToDate = loan.getString("MaturityDate");

				double instalmentPrincipalAmtTemp = Arith.round(RPTFunctions.getPMTScript(loan, rptSegment)
						.getPrincipalAmount(loan, rptSegment), AccountingHelper.getMoneyPrecision(loan));// �����
				instalmentPrincipalAmt += instalmentPrincipalAmtTemp;
				RPTFunctions.getPMTScript(loan, rptSegment).nextInstalment(loan, rptSegment);// ������һ�������ڴΣ��������´λ����ռ���������
			}

			instalmentPrincipalAmt = Arith.round(instalmentPrincipalAmt, AccountingHelper.getMoneyPrecision(loan));
			// ���ĩ�ڻ�������ڵ�β�����⣬���һ�ڵĻ������Ϊ�������
			if (loanBalance - instalmentPrincipalAmt <= result.size() * 0.01) {
				instalmentPrincipalAmt = loanBalance;
			}

			if (Arith.round(instalmentPrincipalAmt + instalmentInterest, AccountingHelper.getMoneyPrecision(loan)) <= 0) {
				continue;
			}

			// ��������ڴ�
			int currentPeriod = loan.getInt("CurrentPeriod") + 1;
			loan.setAttributeValue("CurrentPeriod", currentPeriod);
			loanBalance = Arith.round(loanBalance - instalmentPrincipalAmt, AccountingHelper.getMoneyPrecision(loan));
			// ���´������
			loan.setAttributeValue("NormalBalance", loanBalance);
			AccountCodeConfig.setBusinessObjectBalance(loan, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal, loanBalance);

			// �½�����ƻ�
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
	 * ��õ�ǰ��Ч�Ļ���������Ϣ
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
