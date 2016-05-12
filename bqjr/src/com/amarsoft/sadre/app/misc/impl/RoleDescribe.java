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
package com.amarsoft.sadre.app.misc.impl;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.app.dict.RoleManager;
import com.amarsoft.sadre.app.misc.BasicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;

 /**
 * <p>Title: RoleDescribe.java </p>
 * <p>Description: 获取角色序列的中文描述 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 下午1:56:26
 *
 * logs: 1. 
 */
public class RoleDescribe extends BasicDescribe {
	
	public RoleDescribe(Transaction to){
		this.Sqlca = to;
	}

	
	public String getName(String roleId) {
		String roleName = "";
		try {
			roleName = RoleManager.getRoleName(roleId, Sqlca);
		} catch (Exception e) {
			log.debug(e);
			roleName = roleId;
		}
		return roleName;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	
	public List<SelectOption> getValueList(Page page){
		List<SelectOption> values = new ArrayList<SelectOption>();
		try {
			/*
			BizObjectQuery bq = JBOFactory.createBizObjectQuery("jbo.sys.ROLE_INFO", "select RoleName,RoleId from O where RoleStatus='1'");
			List<BizObject> result = bq.getResultList(false);
			for(int row=0; row<result.size(); row++){
				BizObject tmp = result.get(row);
//				values.put(tmp.getAttribute("RoleId").getString(), tmp.getAttribute("RoleName").getString());
				
				SelectOption so = new SelectOption(tmp.getAttribute("RoleId").getString(), tmp.getAttribute("RoleName").getString());
				values.add(so);
			}
			*/
			
			ASResultSet bq = Sqlca.getASResultSet("select RoleId,RoleName from ROLE_INFO where RoleStatus='1' ");
			while(bq.next()){
				String sRoleId 	= bq.getString("RoleId");
				String sRoleName = bq.getString("RoleName");
				
				SelectOption so = new SelectOption(sRoleId, sRoleName);
				values.add(so);
			}
			bq.getStatement().close();
			
		} catch (Exception e) {
			log.debug(e);
		}
		
		return values;
	}
}
