/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.rules.rpn;

import com.amarsoft.app.als.sadre.util.DecimalUtil;

/**
 * Calculate.java desc:
 * 
 * @author zllin@amarsoft.com 2008 ����12:43:33
 * 
 */
public class Calculate {
	// �ж��Ƿ�Ϊ��������
	public static boolean isOperator(String operator) {
		if (operator.equals("+") || operator.equals("-")
				|| operator.equals("*") || operator.equals("/")
				|| operator.equals("(") || operator.equals(")"))
			return true;
		else
			return false;
	}

	// ���ò������ŵ����ȼ���
	public static int priority(String operator) {
		if (operator.equals("+") || operator.equals("-")
				|| operator.equals("("))
			return 1;
		else if (operator.equals("*") || operator.equals("/"))
			return 2;
		else
			return 0;
	}

	// ��2ֵ֮��ļ���
	public static String twoResult(String operator, String a, String b) {
		try {
			String op = operator;
			String rs = new String();
			double x = Double.parseDouble(b);
			double y = Double.parseDouble(a);
			double z = 0;
			if (op.equals("+"))
				z = DecimalUtil.add(x, y);
			else if (op.equals("-"))
//				z = x - y;
				z = DecimalUtil.subtract(x, y);
			else if (op.equals("*"))
//				z = x * y;
				z = DecimalUtil.multiply(x, y);
			else if (op.equals("/"))
//				z = x / y;
				z = DecimalUtil.divide(x, y);
			else
				z = 0;
			return rs + z;
		} catch (NumberFormatException e) {
			System.out.println("input has something wrong!");
			return "Error";
		}
	}
}
