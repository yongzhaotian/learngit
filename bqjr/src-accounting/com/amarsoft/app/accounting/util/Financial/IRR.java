package com.amarsoft.app.accounting.util.Financial;
/**
 * 内部收益率 为投资的回收利率，其中包含定期支付（负值）和定期收入（正值）
 * @author jshen
 *
 */
public class IRR {
	static public double evaluate(final double[] cashFlows) {
		return evaluate(cashFlows,Double.NaN);
	}
	static public double evaluate(final double[] cashFlows,final double estimatedResult) {
		double result = Double.NaN;

		if (cashFlows != null && cashFlows.length > 0) {
			if (cashFlows[0] != 0d) {
				final double noOfCashFlows = cashFlows.length;

				double sumCashFlows = 0d;
				int noOfNegativeCashFlows = 0;
				int noOfPositiveCashFlows = 0;
				for (int i = 0; i < noOfCashFlows; i++) {
					sumCashFlows += cashFlows[i];
					if (cashFlows[i] > 0) {
						noOfPositiveCashFlows++;
					} else if (cashFlows[i] < 0) {
						noOfNegativeCashFlows++;
					}
				}

				if (noOfNegativeCashFlows > 0 && noOfPositiveCashFlows > 0) {

					double irrGuess = 0.1; 
					if (!Double.isNaN(estimatedResult)) {
						irrGuess = estimatedResult;
						if (irrGuess <= 0d)
							irrGuess = 0.5;
					}

					double irr = 0d;
					if (sumCashFlows < 0) { 
						irr = -irrGuess;
					} else { 
						irr = irrGuess;
					}
					final double minDistance = 1E-15;

					final double cashFlowStart = cashFlows[0];
					final int maxIteration = 100;
					boolean wasHi = false;
					double cashValue = 0d;
					for (int i = 0; i <= maxIteration; i++) {
						cashValue = cashFlowStart;

						for (int j = 1; j < noOfCashFlows; j++) {
							cashValue += cashFlows[j] / Math.pow(1d + irr, j);
						}

						if (Math.abs(cashValue) < 0.01) {
							result = irr;
							break;
						}

						if (cashValue > 0d) {
							if (wasHi) {
								irrGuess /= 2;
							}

							irr += irrGuess;

							if (wasHi) {
								irrGuess -= minDistance;
								wasHi = false;
							}

						} else {
							irrGuess /= 2;
							irr -= irrGuess;
							wasHi = true;
						}

						if (irrGuess <= minDistance) {
							result = irr;
							break;
						}
					}
				}
			}
		}
		return result;
	}
}
