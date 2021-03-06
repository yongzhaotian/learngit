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
 * <p>Title: ContainsOne.java </p>
 * <p>Description:  至少包含其中之一</p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-22 下午12:51:42
 *
 * logs: 1. 
 */
public class ContainsOne implements Operator {

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateString(java.lang.String, java.lang.String)
	 */
	
	public boolean validateString(String source, String target)
			throws OperationNotSupportedException {
		//null in null?
		if(source==null || target==null) return false;
		
		boolean valIn = false;
		boolean exists = false;
		String[] arraySource = source.split("\\,");
		String[] arrayTarget = target.split("\\,");
		
		for(int dest=0; dest<arrayTarget.length; dest++){	//desc中的所有元素都在src中,为in操作的相反
			
			exists = false;		//reset exists-flag
			for(int src=0; src<arraySource.length; src++){
				if(arrayTarget[dest].equals(arraySource[src])){		//如果有一个dest存在于src,则结束对该dest的判断
					exists = true;
					break;
				}
			}
			if(exists){		//一旦dest存在于src中,则结束所有判断,满足包含其中之一的条件
				valIn = true;
				break;
			}
		}
		
		return valIn;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateNumber(double, double)
	 */
	
	public boolean validateNumber(double source, double target)
			throws OperationNotSupportedException {
		throw new OperationNotSupportedException("精度数不支持'ContainsAtLeastOne'操作");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateInteger(int, int)
	 */
	
	public boolean validateInteger(int source, int target)
			throws OperationNotSupportedException {
		throw new OperationNotSupportedException("整数不支持'ContainsAtLeastOne'操作");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateBoolean(boolean, boolean)
	 */
	
	public boolean validateBoolean(boolean source, boolean target)
			throws OperationNotSupportedException {
		throw new OperationNotSupportedException("布尔不支持'ContainsAtLeastOne'操作");
	}

}
