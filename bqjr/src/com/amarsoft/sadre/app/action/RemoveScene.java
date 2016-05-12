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

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.RuleScenes;

/**
 * @ SADRERemoveScene.java<p>
 * DESCRIPT: 本类是针对授权场景删除后的后续处理,包括了对场景下规则的删除。<p>
 *     
 * @author zllin@amarsoft.com<p>
 * 
 * @date 2011-5-12 上午10:56:37<p>
 *
 * logs: 1. <p>
 */
public class RemoveScene extends BasicWebAction {
	
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
	
	public int execute(Transaction Sqlca) throws SADREException {
		
		try{
			//--------删除该场景项下的所有授权规则
			/**/
			String sqlo = "delete from SADRE_ASSUMPTION where SCENEID='"+getSceneId()+"'";
			Sqlca.executeSQL(sqlo);
			Sqlca.getConnection().commit();
			
			/*JBO等价实现
			BizObjectQuery bq = JBOFactory.getBizObjectManager("jbo.app.sadre.ASSUMPTION").createQuery("SCENEID=:SCENEID");
			bq.setParameter("SCENEID", getSceneId());
			bq.executeUpdate();
			*/
			
			RuleScenes.removeRuleScene(getSceneId());
			
//			ARE.getLog().debug("授权场景删除成功!场景编号:"+getSceneId());
		}catch(Exception e){
			ARE.getLog().error(e);
			throw new SADREException(e);
		}
		
		return WEB_ACTION_成功;
	}

}
