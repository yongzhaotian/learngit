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
import com.amarsoft.sadre.app.dict.NameManager;
import com.amarsoft.sadre.app.misc.BasicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;

 /**
 * <p>Title: UserDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 下午1:56:26
 *
 * logs: 1. 
 */
public class UserDescribe extends BasicDescribe {
	
	public UserDescribe(Transaction to){
		this.Sqlca = to;
	}
	
	
	public String getName(String userId) {
		String userName = "";
		try {
			userName = NameManager.getUserName(userId, Sqlca);
		} catch (Exception e) {
			log.debug(e);
			userName = userId;
		}
		return userName;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	public List<SelectOption> getValueList(Page page){
		List<SelectOption> values = new ArrayList<SelectOption>();
		
		try {
/*JBO等价实现
			BizObjectQuery bq = JBOFactory.createBizObjectQuery("jbo.sys.USER_INFO", 
					"select UserName,UserId,BelongOrg from O where Status='1' order by BelongOrg");
			List<BizObject> result = bq.getResultList(false);
			for(int row=0; row<result.size(); row++){
				BizObject tmp = result.get(row);
				String userId = tmp.getAttribute("UserId").getString();
				String userName = tmp.getAttribute("UserName").getString();
				String belongOrg = tmp.getAttribute("BelongOrg").getString();
				String userDesc = userName+"("+NameManager.getOrgName(belongOrg)+")";
				
//				values.put(userId, userDesc);
				
				SelectOption so = new SelectOption(userId, userDesc);
				values.add(so);
			}
*/
			ASResultSet bq = Sqlca.getASResultSet("select UserId,UserName,BelongOrg from USER_INFO where Status='1' order by BelongOrg");
			while(bq.next()){
				String userId 	= bq.getString("UserId");
				String userName = bq.getString("UserName");
				String belongOrg = bq.getString("BelongOrg");
				String userDesc = userName+"("+NameManager.getOrgName(belongOrg, Sqlca)+")";
				
				SelectOption so = new SelectOption(userId, userDesc);
				values.add(so);
			}
			bq.getStatement().close();
			
		} catch (Exception e) {
			log.debug(e);
		}
		
		return values;
	}
	
}
