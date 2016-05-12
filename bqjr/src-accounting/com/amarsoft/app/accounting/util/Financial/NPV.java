package com.amarsoft.app.accounting.util.Financial;

public class NPV {
	/**
	 * ���ھ���ֵ
	 * @author jshen
	 */
	static public double evaluate(final double rate,final double[]cashFlows) {
		double sum = 0d;
		for (int i = 0; i < cashFlows.length; i++) {
			sum += cashFlows[i] / Math.pow(rate + 1d, i);
		}
		return sum;
	}
}
