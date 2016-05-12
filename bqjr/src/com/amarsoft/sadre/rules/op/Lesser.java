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
 * <p>Title: Lesser.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-19 下午04:32:17
 *
 * logs: 1. 
 */
public class Lesser implements Operator{

	
	public boolean validateString(String source, String target) throws OperationNotSupportedException {
//		ARE.getLog().warn("Operation Not Supported!");
//		return false;
//		return source.compareTo(target) < 0;
		throw new OperationNotSupportedException("字符不支持'<'操作");
	}

	
	public boolean validateNumber(double source, double target) throws OperationNotSupportedException {
		return DecimalUtil.subtract(source, target)<0;
	}

	
	public boolean validateInteger(int source, int target) throws OperationNotSupportedException {
		return source<target;
	}

	
	public boolean validateBoolean(boolean source, boolean target) throws OperationNotSupportedException {
//		ARE.getLog().warn("Operation Not Supported!");
//		return false;
		throw new OperationNotSupportedException("布尔不支持'<'操作");
	}

}
