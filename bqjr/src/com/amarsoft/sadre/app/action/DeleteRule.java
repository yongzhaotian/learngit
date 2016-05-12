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
package com.amarsoft.sadre.app.action;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.rules.aco.RuleScene;

 /**
 * <p>Title: DeleteRule.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-28 下午04:22:51
 *
 * logs: 1. 
 */
public class DeleteRule extends BasicWebAction {
	
	private String ruleId = "";
	private String sceneId = "";

	public String getRuleId() {
		return ruleId;
	}

	public void setRuleId(String ruleId) {
		this.ruleId = ruleId;
	}

	public String getSceneId() {
		return sceneId;
	}

	public void setSceneId(String sceneId) {
		this.sceneId = sceneId;
	}

	
	public int execute(Transaction sqlca) throws SADREException {
		RuleScene rulescene = RuleScenes.getRuleScene(getSceneId());
		if(rulescene==null){
			log.warn("规则场景["+getSceneId()+"]不存在");
			return WEB_ACTION_失败;
		}
		
		int procFlg = rulescene.removeRule(getRuleId(),sqlca);
		switch(procFlg){
			case RuleScene.规则处理_成功:
				return WEB_ACTION_成功;
			default:
				return WEB_ACTION_失败;
		}
	}
	
	public String executeSqlca(Transaction sqlca) throws SADREException {
		return describe(execute(sqlca)); 
	}

}
