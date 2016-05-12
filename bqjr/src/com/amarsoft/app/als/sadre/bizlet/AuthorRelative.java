/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.app.als.sadre.bizlet;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.app.action.WebAction;

/**
 * <p>Title: AuthorRelative.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2012-4-11 下午9:26:47</p>
 *
 * logs: 1. </p>
 */
public class AuthorRelative extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	@Override
	public Object run(Transaction Sqlca) throws Exception {
		//方案编号
		String sceneId 	= DataConvert.toString((String)this.getAttribute("SceneId"));
		//组别编号
		String groupId 	= DataConvert.toString((String)this.getAttribute("GroupId"));
		ARE.getLog().debug("sceneId="+sceneId);
		ARE.getLog().debug("groupId="+groupId);
		if(groupId==null || groupId.length()==0) throw new SADREException("授权方案关联的组别编号为空.");
		
		Sqlca.executeSQL("insert into SADRE_SCENERELATIVE (GROUPID,SCENEID) values ('"+groupId+"','"+sceneId+"')");
		
		return WebAction.ACTION_DESC_成功;
	}

}
