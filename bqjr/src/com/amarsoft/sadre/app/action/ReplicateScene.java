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
package com.amarsoft.sadre.app.action;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.rules.aco.RuleScene;

/**
 * <p>Title: SADREReplicateScene.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-22 ����07:14:18</p>
 *
 * logs: 1. </p>
 */
public class ReplicateScene extends BasicWebAction {
	
	private String sceneId = "";

	public String getSceneId() {
		return sceneId==null?"":sceneId;
	}

	public void setSceneId(String sceneId) {
		this.sceneId = sceneId;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	
	public int execute(Transaction sqlca) throws SADREException {
		
		int iStatus = RuleScenes.replicateScene(getSceneId(), sqlca);
		
		if(iStatus==RuleScene.��Ȩ����_���Ƴɹ�){
			return WEB_ACTION_�ɹ�;
		}
		return WEB_ACTION_ʧ��;
	}
	
	public String executeSqlca(Transaction sqlca) throws SADREException {
		return describe(execute(sqlca)); 
	}

}
