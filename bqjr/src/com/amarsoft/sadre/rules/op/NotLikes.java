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
 * <p>Title: NotLikes.java </p>
 * <p>Description: ֧������not Like�Ĳ���,�Ƚ�Դ�ַ�������not like����Ŀ���ַ�����Ϊ��������</p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author hwang@amarsoft.com
 * @version 
 * @date 2013-1-23 ����02:41:33
 *
 * logs: 1. 
 */
public class NotLikes implements Operator {

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateString(java.lang.String, java.lang.String)
	 */
	
	public boolean validateString(String source, String target)
			throws OperationNotSupportedException {
		//null in null?
		if(source==null || target==null ||target.trim().length()==0) return false;
		
		boolean valIn = true;
		boolean notlikes = true;
		String[] arraySource = source.split("\\,");
		String[] arrayTarget = target.split("\\,");
		
		for(int src=0; src<arraySource.length; src++){
			
			notlikes = true;		//reset exists-flag
			for(int dest=0; dest<arrayTarget.length; dest++){
				if(arraySource[src].startsWith(arrayTarget[dest])){		//�����һ��src like dest%,������Ը�src���ж�
					notlikes = false;
					break;
				}
			}
			if(!notlikes){		//һ��src������dest��,����������ж�
				valIn = false;
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
		throw new OperationNotSupportedException("��������֧��'Likes'����");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateInteger(int, int)
	 */
	
	public boolean validateInteger(int source, int target)
			throws OperationNotSupportedException {
		throw new OperationNotSupportedException("������֧��'Likes'����");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.op.Operator#validateBoolean(boolean, boolean)
	 */
	
	public boolean validateBoolean(boolean source, boolean target)
			throws OperationNotSupportedException {
		throw new OperationNotSupportedException("������֧��'Likes'����");
	}

}
