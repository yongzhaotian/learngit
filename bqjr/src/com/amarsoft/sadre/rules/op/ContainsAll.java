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
 * <p>Title: ContainsAll.java </p>
 * <p>Description:  ����Ŀ��Ԫ���е�����</p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-21 ����05:09:40
 *
 * logs: 1. 
 */
public class ContainsAll implements Operator {

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateString(java.lang.String, java.lang.String)
	 */
	
	public boolean validateString(String source, String target) {
		//null in null?
		if(source==null || target==null) return false;
		
		boolean valIn = true;
		boolean exists = false;
		String[] arraySource = source.split("\\,");
		String[] arrayTarget = target.split("\\,");
		if(arraySource.length<arrayTarget.length){		//ԴԪ��С��Ŀ��Ԫ�ظ������������������Ҫ��
			return false;
		}
		
		for(int dest=0; dest<arrayTarget.length; dest++){	//desc�е�����Ԫ�ض���src��,Ϊin�������෴
			
			exists = false;		//reset exists-flag
			for(int src=0; src<arraySource.length; src++){
				if(arrayTarget[dest].equals(arraySource[src])){		//�����һ��dest������src,������Ը�dest���ж�
					exists = true;
					break;
				}
			}
			if(!exists){		//һ��dest��������src��,����������ж�
				valIn = false;
				break;
			}
		}
		
		return valIn;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateNumber(double, double)
	 */
	
	public boolean validateNumber(double source, double target) throws OperationNotSupportedException{
		throw new OperationNotSupportedException("��������֧��'ContainsAll'����");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateInteger(int, int)
	 */
	
	public boolean validateInteger(int source, int target) throws OperationNotSupportedException{
		throw new OperationNotSupportedException("������֧��'ContainsAll'����");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateBoolean(boolean, boolean)
	 */
	
	public boolean validateBoolean(boolean source, boolean target) throws OperationNotSupportedException{
		throw new OperationNotSupportedException("������֧��'ContainsAll'����");
	}

}
