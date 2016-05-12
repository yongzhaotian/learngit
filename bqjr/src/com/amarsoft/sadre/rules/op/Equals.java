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

import com.amarsoft.app.als.sadre.util.DecimalUtil;

 /**
 * <p>Title: Equals.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-19 ÏÂÎç04:31:09
 *
 * logs: 1. 
 */
public class Equals implements Operator {

	
	public boolean validateString(String source, String target) throws OperationNotSupportedException {
		return source.equals(target);
	}

	
	public boolean validateNumber(double source, double target) throws OperationNotSupportedException {
//		String srcValue = DecimalUtil.formatNumber(source,"#0.00000");
//		String destValue = DecimalUtil.formatNumber(target,"#0.00000");
//		return validateString(srcValue,destValue);
		return DecimalUtil.subtract(source, target)==0;
	}

	
	public boolean validateInteger(int source, int target) throws OperationNotSupportedException {
		return (source==target);
	}

	
	public boolean validateBoolean(boolean source, boolean target) throws OperationNotSupportedException {
		return (source==target);
	}



}
