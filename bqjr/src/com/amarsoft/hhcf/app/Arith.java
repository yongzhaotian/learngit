package com.amarsoft.hhcf.app;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class Arith {
	/**
	 * �ṩ��ȷ�ӷ������add����
	 * 
	 * @param value1
	 *            ������
	 * @param value2
	 *            ����
	 * @return ���������ĺ�
	 */
	public static double add(double value1, double value2) {
		BigDecimal b1 = new BigDecimal(Double.valueOf(value1));
		BigDecimal b2 = new BigDecimal(Double.valueOf(value2));
		return b1.add(b2).doubleValue();
	}

	/**
	 * �ṩ��ȷ���������sub����
	 * 
	 * @param value1
	 *            ������
	 * @param value2
	 *            ����
	 * @return ���������Ĳ�
	 */
	public static double sub(double value1, double value2) {
		BigDecimal b1 = new BigDecimal(Double.valueOf(value1));
		BigDecimal b2 = new BigDecimal(Double.valueOf(value2));
		return b1.subtract(b2).doubleValue();
	}

	/**
	 * �ṩ��ȷ�˷������mul����
	 * 
	 * @param value1
	 *            ������
	 * @param value2
	 *            ����
	 * @return ���������Ļ�
	 */
	public static double mul(double value1, double value2) {
		BigDecimal b1 = new BigDecimal(Double.valueOf(value1));
		BigDecimal b2 = new BigDecimal(Double.valueOf(value2));
		return b1.multiply(b2).doubleValue();
	}

	/**
	 * �ṩ��ȷ�ĳ������㷽��div
	 * 
	 * @param value1
	 *            ������
	 * @param value2
	 *            ����
	 * @param scale
	 *            ��ȷ��Χ
	 * @return ������������
	 * @throws IllegalAccessException
	 */
	public static double div(double value1, double value2, int scale)
			throws IllegalAccessException {
		// �����ȷ��ΧС��0���׳��쳣��Ϣ
		if (scale < 0) {
			throw new IllegalAccessException("��ȷ�Ȳ���С��0");
		}
		java.text.DecimalFormat df=new java.text.DecimalFormat("0.00000000");
		BigDecimal b1 = new BigDecimal(df.format(value1));
		System.out.println(b1);
		BigDecimal b2 = new BigDecimal(df.format(value2));
		System.out.println(b2);
		return b1.divide(b2, scale).doubleValue();
	}
	public static void main(String args[])
	{
	try {
		System.out.println(20.00/100.00);
		System.out.println(Arith.div(21.5, 100, 3));
	} catch (IllegalAccessException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	}
}
