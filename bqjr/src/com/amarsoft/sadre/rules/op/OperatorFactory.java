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
 * @date 2011-4-19 ����04:22:26
 *
 * logs: 1. 
 */
public class OperatorFactory {
	public static Operator getOperator(String operatorType){
		Operator op = null; 
		if(operatorType.equals(Operator.����)){
			op = new Equals();
		}else if(operatorType.equals(Operator.������)){
			op = new NotEquals();
		}else if(operatorType.equals(Operator.����)){
			op = new Greater();
		}else if(operatorType.equals(Operator.С��)){
			op = new Lesser();
		}else if(operatorType.equals(Operator.���ڵ���)){
			op = new GreaterEquals();
		}else if(operatorType.equals(Operator.С�ڵ���)){
			op = new LesserEquals();
		}else if(operatorType.equals(Operator.������)){
			op = new Within();
		}else if(operatorType.equals(Operator.��������)){
			op = new NotWithin();
		}else if(operatorType.equals(Operator.��������)){
			op = new ContainsAll();
		}else if(operatorType.equals(Operator.��������֮һ)){
			op = new ContainsOne();
		}else if(operatorType.equals(Operator.��������һ)){
			op = new NotContains();
		}else if(operatorType.equals(Operator.����������)){
			op = new NotContainsAny();
		}else if(operatorType.equals(Operator.������)){
			op = new Likes();
		}else if(operatorType.equals(Operator.��������)){
			op = new NotLikes();
		}else if(operatorType.equals(Operator.������)){
			op = new Limits();
		}else if(operatorType.equals(Operator.��������)){
			op = new Unlimits();
		}else{
			ARE.getLog().warn("ȱ�ٸò�����!"+operatorType);
			op = new Ignores();			//Ĭ��Ϊ���Բ���
		}
		return op;
	}
}
