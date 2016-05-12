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
 * @date 2011-4-19 ����04:14:55
 *
 * logs: 1. 
 */
public interface Operator {
	
	/** used as operator */
	public static final String ���� = "eq";

	/** used as operator */
	public static final String С�� = "lt";

	/** used as operator */
	public static final String С�ڵ��� = "lteq";

	/** used as operator */
	public static final String ���� = "gt";

	/** used as operator */
	public static final String ���ڵ��� = "gteq";
	
	/** used as operator */
	public static final String ������ = "noteq";

	/** used as operator */
	public static final String ������ = "in";

	/** used as operator */
	public static final String �������� = "notin";

	/** used as operator */
	public static final String ��������һ = "notcontains";
	
	/** used as operator */
	public static final String ���������� = "notcontainsAny";

	/** used as operator */
	public static final String �������� = "containsall";
	
	/** used as operator */
	public static final String ��������֮һ = "containsone";

	/** used as operator */
	public static final String ���� = "ignore";
	
	/** used as operator */
	public static final String ������ = "likes";
	
	/** used as operator */
	public static final String �������� = "notlikes";
	
	/** used as operator */
	public static final String ������ = "limits";
	
	/** used as operator */
	public static final String �������� = "unlimits";
	
	/**
	 * ����ַ������бȽ���֤
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean validateString(String source,String target) throws OperationNotSupportedException;
	/**
	 * ��Ծ��������бȽ���֤
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean validateNumber(double source,double target) throws OperationNotSupportedException;
	/**
	 * ����������бȽ���֤
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean validateInteger(int source,int target) throws OperationNotSupportedException;
	/**
	 * ��Բ���ֵ���бȽ���֤
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean validateBoolean(boolean source,boolean target) throws OperationNotSupportedException;
}
