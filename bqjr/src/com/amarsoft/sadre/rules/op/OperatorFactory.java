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

import com.amarsoft.are.ARE;

 /**
 * <p>Title: OperatorFactory.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-19 下午04:22:26
 *
 * logs: 1. 
 */
public class OperatorFactory {
	public static Operator getOperator(String operatorType){
		Operator op = null; 
		if(operatorType.equals(Operator.等于)){
			op = new Equals();
		}else if(operatorType.equals(Operator.不等于)){
			op = new NotEquals();
		}else if(operatorType.equals(Operator.大于)){
			op = new Greater();
		}else if(operatorType.equals(Operator.小于)){
			op = new Lesser();
		}else if(operatorType.equals(Operator.大于等于)){
			op = new GreaterEquals();
		}else if(operatorType.equals(Operator.小于等于)){
			op = new LesserEquals();
		}else if(operatorType.equals(Operator.在其中)){
			op = new Within();
		}else if(operatorType.equals(Operator.不在其中)){
			op = new NotWithin();
		}else if(operatorType.equals(Operator.包含所有)){
			op = new ContainsAll();
		}else if(operatorType.equals(Operator.包含其中之一)){
			op = new ContainsOne();
		}else if(operatorType.equals(Operator.不包含其一)){
			op = new NotContains();
		}else if(operatorType.equals(Operator.不包含所有)){
			op = new NotContainsAny();
		}else if(operatorType.equals(Operator.隶属于)){
			op = new Likes();
		}else if(operatorType.equals(Operator.不隶属于)){
			op = new NotLikes();
		}else if(operatorType.equals(Operator.局限于)){
			op = new Limits();
		}else if(operatorType.equals(Operator.不局限于)){
			op = new Unlimits();
		}else{
			ARE.getLog().warn("缺少该操作符!"+operatorType);
			op = new Ignores();			//默认为忽略操作
		}
		return op;
	}
}
