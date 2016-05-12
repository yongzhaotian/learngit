package com.amarsoft.app.accounting.util.Financial;

import com.amarsoft.app.accounting.config.loader.DateFunctions;

/**
 * 不定期净现值
 * @author jshen
 */
public class XNPV {
	static public double evaluate(final double rate,final double[]cashFlows,final String[] dateFlows,int intBasisYDays) {
		double sum = 0d;
		for (int i = 0; i < cashFlows.length; i++) {
			sum += cashFlows[i] / Math.pow(rate + 1d, DateFunctions.getDays(dateFlows[0],dateFlows[i])/(intBasisYDays*1d));
		}
		return sum;
	}
}
