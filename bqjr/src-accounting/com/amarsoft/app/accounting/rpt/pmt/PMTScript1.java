/**
 * 
 */
package com.amarsoft.app.accounting.rpt.pmt;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.AccountingHelper;
import com.amarsoft.app.accounting.util.PRODUCT_CONSTANTS;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;

/**
 * �ȶϢ
 * 
 * @author yegang
 */
public class PMTScript1 extends BasicPMTScript {

	public double getInstalmentAmount(BusinessObject loan, BusinessObject rptSegment) throws LoanException, Exception {
		// �������ʵ���ʱ��Ҫ�ж����ڹ���ȡʲôģʽ
		String newPMTType = loan.getString("NewPMTType");
		if (newPMTType == null || newPMTType.length() == 0) {
			newPMTType = rptSegment.getString("NewPMTType");
		}
		if (newPMTType == null || newPMTType.length() == 0) {
			String rpttermID = loan.getString("RPTTermID");
			newPMTType = ProductConfig.getTermParameterAttribute(rpttermID, "NewPMTType", "DefaultValue");
		}
		if (newPMTType == null || newPMTType.length() == 0) {
			newPMTType = PRODUCT_CONSTANTS.NEWPMTTYPE_NEWINSTALMENTAMT;// Ĭ��ʹ�����ڹ�
		}

		int totalPeriod = rptSegment.getInt("TotalPeriod");
		String updateInstalAmtFlag = rptSegment.getString("UpdateInstalAmtFlag");

		double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
		// �����Ҫ�����ڹ��������¼���
		if (instalmentAmt <= 0d || updateInstalAmtFlag != null
				&& updateInstalAmtFlag.equals(ACCOUNT_CONSTANTS.FLAG_YES)) {
			String lastDueDate = LoanFunctions.getLastDueDate(loan);
			String nextDueDate = LoanFunctions.getNextDueDate(loan);
			String paymentFrequencyType = rptSegment.getString("PaymentFrequencyType");// ��������
			List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan,
					ACCOUNT_CONSTANTS.RateType_Normal, lastDueDate, nextDueDate);
			double installInterestRate = 0.0d;
			if (rateList == null || rateList.isEmpty()) {// ������������Ĭ��Ϊ��
				installInterestRate = 0.0d;
			} else {
				// ʹ�����µ����ʼ���
				BusinessObject rateTerm = rateList.get(rateList.size() - 1);
				if (newPMTType.equals(PRODUCT_CONSTANTS.NEWPMTTYPE_NEWINSTALMENTAMT)) {
					rateTerm = rateList.get(rateList.size() - 1);
				}
				// �������ʱ��ʱ����Ҫ�ж���μ����ڹ�
				installInterestRate = InterestFunctions.getInstalmentRate(1.0d, rateTerm.getInt("YearDays"),
						rateTerm.getString("RateUnit"), rateTerm.getRate("BusinessRate"), paymentFrequencyType);
			}
			// ��������ڴ�
			totalPeriod = RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
			// ���㱾�׶���Ҫ�����ı�����
			double outstandingBalance = RPTFunctions.getOutStandingBalance(loan, rptSegment);
			double balance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
					ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
			double instalmentAmount = 0.0;
			// �����ڴ�Ϊ��ʱ��˵����Ҫһ���Գ���
			if (totalPeriod == 0) {
				instalmentAmount = outstandingBalance + balance * installInterestRate;
			} else {
				// ���ʴ�����ʱ����
				if (installInterestRate > 0d)
					instalmentAmount = outstandingBalance * installInterestRate
							* (1 + 1 / (java.lang.Math.pow(1 + installInterestRate, totalPeriod) - 1));
				else {// ����
					instalmentAmount = outstandingBalance / totalPeriod;
					ARE.getLog().warn("����ִ������С�ڵ����㣬���飡" + loan.getObjectNo());
				}
				instalmentAmount += (balance - outstandingBalance) * installInterestRate;
			}
			return Arith.round(instalmentAmount, AccountingHelper.getMoneyPrecision(loan));
		} else {// ����ֱ�ӷ���ԭ���Ľ��
			return instalmentAmt;
		}
	}

	public double getPrincipalAmount(BusinessObject loan, BusinessObject rptSegment) throws LoanException, Exception {
		double outstandingBalance = RPTFunctions.getOutStandingBalance(loan, rptSegment);
		double balance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
				ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
				ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		String interestType = rptSegment.getString("InterestType");
		String paymentFrequencyType = rptSegment.getString("PaymentFrequencyType");// ��������
		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);// �õ���������

		double installInterestRate = 0.0d;
		String lastDueDate = rptSegment.getString("LASTDUEDATE");
		String nextDueDate = rptSegment.getString("NEXTDUEDATE");
		if (rateList == null || rateList.isEmpty()) {// ������������Ĭ��Ϊ��
			installInterestRate = 0.0d;
		} else if (ACCOUNT_CONSTANTS.InterestType_Daily.equals(interestType)) {// ���ռ�Ϣ
			BusinessObject rateTerm = rateList.get(0);
			int inteDays = DateFunctions.getDays(lastDueDate, nextDueDate);
			installInterestRate = InterestFunctions.getDailyRate(1.0d, inteDays, rateTerm.getInt("YearDays"),
					rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"));// ������
		} else {
			BusinessObject rateTerm = rateList.get(0);
			installInterestRate = InterestFunctions.getInstalmentRate(1.0d, rateTerm.getInt("YearDays"),
					rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), paymentFrequencyType);
		}

		double instalmentAmt = getInstalmentAmount(loan, rptSegment);

		String segToDate = rptSegment.getString("SegToDate");
		String maturityDate = loan.getString("MaturityDate");
		if (AccountingHelper.notEmpty(nextDueDate)
				&& (AccountingHelper.notEmpty(segToDate) && nextDueDate.compareTo(segToDate) >= 0 || nextDueDate
						.compareTo(maturityDate) >= 0))
			return outstandingBalance;
		if (instalmentAmt <= balance * installInterestRate)
			return 0.0d;
		else {
			double principalAmt = Arith.round(
					instalmentAmt
							- Arith.round(balance * installInterestRate, AccountingHelper.getMoneyPrecision(loan)),
					AccountingHelper.getMoneyPrecision(loan));
			if (principalAmt > rptSegment.getDouble("SegRPTBalance")
					&& PRODUCT_CONSTANTS.SEGRPTAMOUNT_SEG_AMT.equals(rptSegment.getString("SegRPTAmountFlag")))
				principalAmt = Arith.round(rptSegment.getDouble("SegRPTBalance"),
						AccountingHelper.getMoneyPrecision(loan));
			return principalAmt;
		}
	}

}
