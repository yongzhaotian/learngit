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
package com.amarsoft.sadre.app.dict;

import com.amarsoft.awe.util.Transaction;

 /**
 * <p>Title: NameManager.java </p>
 * <p>Description: ������Ϊ��ά����ALS7������ͬ�ӿڽӿڶ�ʵ�� </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-3-2 ����6:03:18
 *
 * logs: 1. 
 */
public class NameManager {
	/**
	 * ���ݻ�����Ż�ȡ��������
	 * @param orgId
	 * @return
	 */
	public static String getOrgName(String orgId, Transaction Sqlca) throws Exception{
		return Sqlca.getString("select OrgName from ORG_INFO where OrgId = '"+orgId+"'");
	}
	
	/**
	 * �����û���Ż�ȡ�û�����
	 * @param userId
	 * @return
	 */
	public static String getUserName(String userId, Transaction Sqlca) throws Exception{
		return Sqlca.getString("select UserName from USER_INFO where UserId = '"+userId+"'");
	}
}
