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
 * <p>Description: 本类是为了维持与ALS7具有相同接口接口而实现 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-3-2 下午6:03:18
 *
 * logs: 1. 
 */
public class NameManager {
	/**
	 * 根据机构编号获取机构名称
	 * @param orgId
	 * @return
	 */
	public static String getOrgName(String orgId, Transaction Sqlca) throws Exception{
		return Sqlca.getString("select OrgName from ORG_INFO where OrgId = '"+orgId+"'");
	}
	
	/**
	 * 根据用户编号获取用户名称
	 * @param userId
	 * @return
	 */
	public static String getUserName(String userId, Transaction Sqlca) throws Exception{
		return Sqlca.getString("select UserName from USER_INFO where UserId = '"+userId+"'");
	}
}
