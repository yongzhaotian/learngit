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
import com.amarsoft.sadre.app.dict.NameManager;
import com.amarsoft.sadre.app.misc.DynamicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;
import com.amarsoft.web.ui.HTMLTreeView;

 /**
 * <p>Title: DynamicUserDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-28 上午11:05:57
 *
 * logs: 1. 
 */
public class DynamicUserDescribe extends DynamicDescribe {
	
	public DynamicUserDescribe(Transaction to){
		this.Sqlca = to;
	}
	
	@Override
	public HTMLTreeView getRootTree(Transaction tmpSqlca,HTMLTreeView tmpTreeView) throws Exception {

		tmpTreeView.initWithSql("SortNo","OrgName","OrgID","","","from ORG_INFO","Order By SortNo",Sqlca);
		
		return tmpTreeView;
	}

	public List<SelectOption> getValueList(Page arg0) {
		List<SelectOption> sub = new ArrayList<SelectOption>();
		
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select USERID,USERNAME " +
					"from USER_INFO " +
					"where BELONGORG = '"+getParentSortNo()+"' ");
			while(resultset.next()){
				String sUserId = resultset.getString("USERID");
				
				if(sUserId==null || sUserId.length()==0) continue;
				if(isSelected(sUserId)) continue;		//选中不再出现在"待选择"区
				
				String sUserName = resultset.getString("USERNAME")+"("+sUserId+")";

				SelectOption so = new SelectOption(sUserId, sUserName);
				sub.add(so);
			}
			resultset.getStatement().close();
		} catch (Exception e) {
			ARE.getLog().error(e);
		}
		return sub;
	}

	public String getName(String id) {
		try {
			String userName = NameManager.getUserName(id, Sqlca);
			return userName+"("+id+")";
		} catch (Exception e) {
			log.error(e);
		}
		
		return id;
	}
	
	public String clickedNodeField(){
		return "OrgID";
	}

}
