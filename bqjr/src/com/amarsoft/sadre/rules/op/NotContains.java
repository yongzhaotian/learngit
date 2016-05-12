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
 * <p>Title: NotContains.java </p>
 * <p>Description: NotContains 维度值(多值)不包含目标值中的其一 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-21 下午05:09:58
 *
 * logs: 1. 
 */
public class NotContains implements Operator {

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateString(java.lang.String, java.lang.String)
	 */
	
	public boolean validateString(String source, String target) throws OperationNotSupportedException{
		//null notin null?
		if(source==null || target==null) return true;
		
		boolean valNoContains = false;
		boolean exists = false;
		String[] arraySource = source.split("\\,");
		String[] arrayTarget = target.split("\\,");
//		if(arraySource.length<arrayTarget.length){		//源元素小于目标元素个数，不可能满足要求:不包含所有对象
//			return true;
//		}
		
//		for(int src=0; src<arraySource.length; src++){		//任何一个dest都不存在于src中
//			
//			for(int dest=0; dest<arrayTarget.length; dest++){
//				if(arraySource[src].equals(arrayTarget[dest])){		//如果有一个dest存在于src,则结束对该dest的判断
//					exists = true;
//					break;
//				}
//			}
//			if(exists){			//一旦dest不存在于src中,则结束所有判断
//				valIn = false;
//				break;
//			}
//		}
		
		for(int dest=0; dest<arrayTarget.length; dest++){		//遍历dest检查是否存在于src中
			
			for(int src=0; src<arraySource.length; src++){
				exists = false;			//每次循环都要初始化状态为false
				if(arraySource[src].equals(arrayTarget[dest])){		//如果有一个dest存在于src,则继续对该dest的判断
					exists = true;
					break;
				}
			}
			if(!exists){			//一旦dest不存在于src中,说明存在该dest不包含于src中,则结束所有判断
				valNoContains = true;
				break;
			}
		}
		
		return valNoContains;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateNumber(double, double)
	 */
	
	public boolean validateNumber(double source, double target) throws OperationNotSupportedException{
		throw new OperationNotSupportedException("精度数不支持'NotContains'操作");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateInteger(int, int)
	 */
	
	public boolean validateInteger(int source, int target) throws OperationNotSupportedException{
		throw new OperationNotSupportedException("整数不支持'NotContains'操作");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateBoolean(boolean, boolean)
	 */
	
	public boolean validateBoolean(boolean source, boolean target) throws OperationNotSupportedException{
		throw new OperationNotSupportedException("布尔值不支持'NotContains'操作");
	}

}
