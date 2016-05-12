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
 * <p>Title: OrgDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 ÏÂÎç1:56:26
 *
 * logs: 1. 
 */
public class OrgDescribe extends BasicDescribe {
	
	public OrgDescribe(Transaction to){
		this.Sqlca = to;
	}
	
	
	public String getName(String orgId) {
		String orgName = "";
		try {
			orgName = NameManager.getOrgName(orgId, Sqlca);
		} catch (Exception e) {
			log.debug(e);
			orgName = orgId;
		}
		return orgName;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	
	public List<SelectOption> getValueList(Page page){
		List<SelectOption> values = new ArrayList<SelectOption>();
		
		try {
			/*
			BizObjectQuery bq = JBOFactory.createBizObjectQuery("jbo.sys.ORG_INFO", 
					"select OrgName,OrgId from O where Status='1' order by SortNo");
			List<BizObject> result = bq.getResultList(false);
			for(int row=0; row<result.size(); row++){
				BizObject tmp = result.get(row);
				String orgId = tmp.getAttribute("OrgId").getString();
				String orgName = tmp.getAttribute("OrgName").getString();
				
//				values.put(orgId, orgName);
				SelectOption so = new SelectOption(orgId, orgName);
				values.add(so);
			}
			*/
			ASResultSet bq = Sqlca.getASResultSet("select OrgName,OrgId from ORG_INFO where Status='1' order by SortNo ");
			while(bq.next()){
				String orgId   = bq.getString("OrgId");
				String orgName = bq.getString("OrgName");
				
				SelectOption so = new SelectOption(orgId, orgName);
				values.add(so);
			}
			bq.getStatement().close();
			
		} catch (Exception e) {
			log.debug(e);
		}
		
		return values;
	}
	
}
