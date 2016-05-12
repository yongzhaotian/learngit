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
 * 等额本息
 * 
 * @author yegang
 */
public class PMTScript1 extends BasicPMTScript {

	public double getInstalmentAmount(BusinessObject loan, BusinessObject rptSegment) throws LoanException, Exception {
		// 存在利率调整时需要判断新期供采取什么模式
		String newPMTType = loan.getString("NewPMTType");
		if (newPMTType == null || newPMTType.length() == 0) {
			newPMTType = rptSegment.getString("NewPMTType");
		}
		if (newPMTType == null || newPMTType.length() == 0) {
			String rpttermID = loan.getString("RPTTermID");
			newPMTType = ProductConfig.getTermParameterAttribute(rpttermID, "NewPMTType", "DefaultValue");
		}
		if (newPMTType == null || newPMTType.length() == 0) {
			newPMTType = PRODUCT_CONSTANTS.NEWPMTTYPE_NEWINSTALMENTAMT;// 默认使用新期供
		}

		int totalPeriod = rptSegment.getInt("TotalPeriod");
		String updateInstalAmtFlag = rptSegment.getString("UpdateInstalAmtFlag");

		double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
		// 如果需要更新期供金额，则重新计算
		if (instalmentAmt <= 0d || updateInstalAmtFlag != null
				&& updateInstalAmtFlag.equals(ACCOUNT_CONSTANTS.FLAG_YES)) {
			String lastDueDate = LoanFunctions.getLastDueDate(loan);
			String nextDueDate = LoanFunctions.getNextDueDate(loan);
			String paymentFrequencyType = rptSegment.getString("PaymentFrequencyType");// 偿还周期
			List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan,
					ACCOUNT_CONSTANTS.RateType_Normal, lastDueDate, nextDueDate);
			double installInterestRate = 0.0d;
			if (rateList == null || rateList.isEmpty()) {// 不存在利率是默认为零
				installInterestRate = 0.0d;
			} else {
				// 使用最新的利率计算
				BusinessObject rateTerm = rateList.get(rateList.size() - 1);
				if (newPMTType.equals(PRODUCT_CONSTANTS.NEWPMTTYPE_NEWINSTALMENTAMT)) {
					rateTerm = rateList.get(rateList.size() - 1);
				}
				// 存在利率变更时，需要判断如何计算期供
				installInterestRate = InterestFunctions.getInstalmentRate(1.0d, rateTerm.getInt("YearDays"),
						rateTerm.getString("RateUnit"), rateTerm.getRate("BusinessRate"), paymentFrequencyType);
			}
			// 计算贷款期次
			totalPeriod = RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
			// 计算本阶段需要偿还的本金金额
			double outstandingBalance = RPTFunctions.getOutStandingBalance(loan, rptSegment);
			double balance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
					ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
			double instalmentAmount = 0.0;
			// 贷款期次为零时，说明需要一次性偿还
			if (totalPeriod == 0) {
				instalmentAmount = outstandingBalance + balance * installInterestRate;
			} else {
				// 利率大于零时计算
				if (installInterestRate > 0d)
					instalmentAmount = outstandingBalance * installInterestRate
							* (1 + 1 / (java.lang.Math.pow(1 + installInterestRate, totalPeriod) - 1));
				else {// 警告
					instalmentAmount = outstandingBalance / totalPeriod;
					ARE.getLog().warn("贷款执行利率小于等于零，请检查！" + loan.getObjectNo());
				}
				instalmentAmount += (balance - outstandingBalance) * installInterestRate;
			}
			return Arith.round(instalmentAmount, AccountingHelper.getMoneyPrecision(loan));
		} else {// 否则直接返回原来的结果
			return instalmentAmt;
		}
	}

	public double getPrincipalAmount(BusinessObject loan, BusinessObject rptSegment) throws LoanException, Exception {
		double outstandingBalance = RPTFunctions.getOutStandingBalance(loan, rptSegment);
		double balance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
				ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
				ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		String interestType = rptSegment.getString("InterestType");
		String paymentFrequencyType = rptSegment.getString("PaymentFrequencyType");// 偿还周期
		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);// 得到正常利率

		double installInterestRate = 0.0d;
		String lastDueDate = rptSegment.getString("LASTDUEDATE");
		String nextDueDate = rptSegment.getString("NEXTDUEDATE");
		if (rateList == null || rateList.isEmpty()) {// 不存在利率是默认为零
			installInterestRate = 0.0d;
		} else if (ACCOUNT_CONSTANTS.InterestType_Daily.equals(interestType)) {// 按日计息
			BusinessObject rateTerm = rateList.get(0);
			int inteDays = DateFunctions.getDays(lastDueDate, nextDueDate);
			installInterestRate = InterestFunctions.getDailyRate(1.0d, inteDays, rateTerm.getInt("YearDays"),
					rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"));// 日利率
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
