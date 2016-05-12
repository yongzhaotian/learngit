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
import com.amarsoft.sadre.app.action.BasicWebAction;
import com.amarsoft.sadre.app.action.DeleteRule;
import com.amarsoft.sadre.app.action.WebAction;

/**
 * <p>Title: AuthorDeleteRule.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2012-4-10 下午3:17:39</p>
 *
 * logs: 1. </p>
 */
public class AuthorDeleteRule extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	@Override
	public Object run(Transaction sqlca) throws Exception {
		//规则编号
		String ruleId 	= DataConvert.toString((String)this.getAttribute("RuleId"));
		//授权方案编号
		String sceneId 	= DataConvert.toString((String)this.getAttribute("SceneId"));
		
		if(ruleId.length()==0 || sceneId.length()==00){
			ARE.getLog().warn("参数非法,不允许为空! RuleId="+ruleId+" |SceneId="+sceneId);
			return WebAction.ACTION_DESC_失败;
		}
		
		DeleteRule action = new DeleteRule();
		action.setRuleId(ruleId);
		action.setSceneId(sceneId);
				
		return BasicWebAction.describe(action.execute(sqlca));
	}

}
