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
 * @author zllin@amarsoft.com 2008 下午12:43:33
 * 
 */
public class Calculate {
	// 判断是否为操作符号
	public static boolean isOperator(String operator) {
		if (operator.equals("+") || operator.equals("-")
				|| operator.equals("*") || operator.equals("/")
				|| operator.equals("(") || operator.equals(")"))
			return true;
		else
			return false;
	}

	// 设置操作符号的优先级别
	public static int priority(String operator) {
		if (operator.equals("+") || operator.equals("-")
				|| operator.equals("("))
			return 1;
		else if (operator.equals("*") || operator.equals("/"))
			return 2;
		else
			return 0;
	}

	// 做2值之间的计算
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
