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
package com.amarsoft.sadre.rules.op;

import javax.naming.OperationNotSupportedException;

/**
 * <p>Title: NotContainsAny.java </p>
 * <p>Description: NotContainsAny ά��ֵ(��ֵ)������Ŀ��ֵ�е���һ </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-11-1 ����4:26:17</p>
 *
 * logs: 1. </p>
 */
public class NotContainsAny implements Operator {

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateString(java.lang.String, java.lang.String)
	 */
	
	public boolean validateString(String source, String target)
			throws OperationNotSupportedException {
		//null notin null?
		if(source==null || target==null) return true;
		
		boolean valNoContains = true;
		boolean exists = false;
		String[] arraySource = source.split("\\,");
		String[] arrayTarget = target.split("\\,");
		
		for(int src=0; src<arraySource.length; src++){		//�κ�һ��dest����������src��
		
			for(int dest=0; dest<arrayTarget.length; dest++){
				if(arraySource[src].equals(arrayTarget[dest])){		//�����һ��dest������src,������Ը�dest���ж�
					exists = true;
					break;
				}
			}
			if(exists){			//һ��dest��������src��,����������ж�
				valNoContains = false;
				break;
			}
		}
		
		return valNoContains;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateNumber(double, double)
	 */
	
	public boolean validateNumber(double source, double target)
			throws OperationNotSupportedException {
		throw new OperationNotSupportedException("��������֧��'NotContainsAny'����");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateInteger(int, int)
	 */
	
	public boolean validateInteger(int source, int target)
			throws OperationNotSupportedException {
		throw new OperationNotSupportedException("������֧��'NotContainsAny'����");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateBoolean(boolean, boolean)
	 */
	
	public boolean validateBoolean(boolean source, boolean target)
			throws OperationNotSupportedException {
		throw new OperationNotSupportedException("����ֵ��֧��'NotContainsAny'����");
	}

}
