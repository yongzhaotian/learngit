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
package com.amarsoft.app.als.sadre.widget;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.app.dict.RoleManager;
import com.amarsoft.sadre.app.misc.DynamicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;
import com.amarsoft.web.ui.HTMLTreeView;

 /**
 * <p>Title: DynamicRoleDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-28 下午6:20:40
 *
 * logs: 1. 
 */
public class DynamicRoleDescribe extends DynamicDescribe {
	
	public DynamicRoleDescribe(Transaction to){
		this.Sqlca = to;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	public List<SelectOption> getValueList(Page page) {
		List<SelectOption> sub = new ArrayList<SelectOption>();
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select ROLEID,ROLENAME " +
					"from ROLE_INFO " +
					"where ROLEID like '"+getParentSortNo()+"%' and ROLEID not in ('"+getParentSortNo()+"') " +
					"order by ROLEID");
			while(resultset.next()){
				String sRoleId = resultset.getString("ROLEID");
				
				if(sRoleId==null || sRoleId.length()==0) continue;
				if(isSelected(sRoleId)) continue;		//选中不再出现在"待选择"区
				
				String sRoleName = resultset.getString("ROLENAME")+"("+sRoleId+")";

				SelectOption so = new SelectOption(sRoleId, sRoleName);
				sub.add(so);
			}
			resultset.getStatement().close();
		} catch (Exception e) {
			ARE.getLog().error(e);
		}
		
		return sub;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DynamicDescribe#getRootTree()
	 */
	@Override
	public HTMLTreeView getRootTree(Transaction Sqlca,HTMLTreeView tmpTreeView) throws Exception {
		int iLeaf = 1;
		tmpTreeView.insertPage("root","总行角色","0","",iLeaf++);
		tmpTreeView.insertPage("root","分行角色","2","",iLeaf++);
		tmpTreeView.insertPage("root","支行角色","4","",iLeaf++);
		tmpTreeView.insertPage("root","其他角色","8","",iLeaf++);
		
		return tmpTreeView;
	}
	
	public String getName(String id) {
		try {
			String roleName = RoleManager.getRoleName(id, Sqlca);
			return roleName;
		} catch (Exception e) {
			log.error(e);
		}
		
		return id;
	}

}
