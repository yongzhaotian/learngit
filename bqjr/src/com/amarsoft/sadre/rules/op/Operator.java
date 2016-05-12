/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.rules.op;

import javax.naming.OperationNotSupportedException;

 /**
 * <p>Title: Operator.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-19 下午04:14:55
 *
 * logs: 1. 
 */
public interface Operator {
	
	/** used as operator */
	public static final String 等于 = "eq";

	/** used as operator */
	public static final String 小于 = "lt";

	/** used as operator */
	public static final String 小于等于 = "lteq";

	/** used as operator */
	public static final String 大于 = "gt";

	/** used as operator */
	public static final String 大于等于 = "gteq";
	
	/** used as operator */
	public static final String 不等于 = "noteq";

	/** used as operator */
	public static final String 在其中 = "in";

	/** used as operator */
	public static final String 不在其中 = "notin";

	/** used as operator */
	public static final String 不包含其一 = "notcontains";
	
	/** used as operator */
	public static final String 不包含所有 = "notcontainsAny";

	/** used as operator */
	public static final String 包含所有 = "containsall";
	
	/** used as operator */
	public static final String 包含其中之一 = "containsone";

	/** used as operator */
	public static final String 忽略 = "ignore";
	
	/** used as operator */
	public static final String 隶属于 = "likes";
	
	/** used as operator */
	public static final String 不隶属于 = "notlikes";
	
	/** used as operator */
	public static final String 局限于 = "limits";
	
	/** used as operator */
	public static final String 不局限于 = "unlimits";
	
	/**
	 * 针对字符串进行比较验证
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean validateString(String source,String target) throws OperationNotSupportedException;
	/**
	 * 针对精度数进行比较验证
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean validateNumber(double source,double target) throws OperationNotSupportedException;
	/**
	 * 针对整数进行比较验证
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean validateInteger(int source,int target) throws OperationNotSupportedException;
	/**
	 * 针对布尔值进行比较验证
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean validateBoolean(boolean source,boolean target) throws OperationNotSupportedException;
}
