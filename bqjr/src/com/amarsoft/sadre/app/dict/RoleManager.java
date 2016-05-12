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
 * <p>Title: RoleManager.java </p>
 * <p>Description: 本类是为了维持与ALS7具有相同接口接口而实现 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-3-2 下午6:05:50
 *
 * logs: 1. 
 */
public class RoleManager {

	/**
	 * 根据角色编号获取角色名称
	 * @param roleId
	 * @return
	 */
	public static String getRoleName(String roleId, Transaction Sqlca) throws Exception{
		return Sqlca.getString("select RoleName from ROLE_INFO where RoleId = '"+roleId+"'");
	}
}
