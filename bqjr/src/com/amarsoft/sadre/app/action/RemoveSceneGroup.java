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


import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.RuleScenes;

 /**
 * <p>Title: RemoveSceneGroup.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 ����11:29:18
 *
 * logs: 1. 
 */
public class RemoveSceneGroup extends BasicWebAction {
	
	private String groupID = "";

	public String getGroupID() {
		return groupID;
	}
	
	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.action.WebAction#execute(com.amarsoft.are.jbo.JBOTransaction)
	 */
	
	public int execute(Transaction Sqlca) throws SADREException {
		
		boolean commitStatus = true;
		try {
			commitStatus = Sqlca.getConnection().getAutoCommit();
			//-----���÷��Զ��ύ,�ֶ���������
			Sqlca.getConnection().setAutoCommit(false);
			
			//ȡ�ô�������������·���,�Ա��ں����ӻ������޳���������
			List<String> result = new ArrayList<String>();
			ASResultSet resultset = Sqlca.getASResultSet("select SCENEID " +
					"from SADRE_SCENERELATIVE where GROUPID='"+getGroupID()+"'");
			while(resultset.next()){
				result.add(resultset.getString("SCENEID"));
			}
			resultset.getStatement().close();
			
			/*ɾ����Ȩ������*/
			Sqlca.executeSQL("delete from SADRE_SCENEGROUP where GROUPID='"+getGroupID()+"'");
			
			/*ɾ����Ȩ����������ϵ*/
			Sqlca.executeSQL("delete from SADRE_SCENERELATIVE where GROUPID='"+getGroupID()+"'");
			
			/*��������Ϊ��Ч*/
			for(int i=0; i<result.size(); i++){
				String sSceneId = result.get(i);
				Sqlca.executeSQL("update SADRE_RULESCENE set STATUS='2' where SCENEID='"+sSceneId+"'");	//��Ϊ��Ч			
			}
			
			Sqlca.getConnection().commit();		//�����ύ
			
			/*��ɾ���Ĺ�����Ȩ�����ӻ������޳�*/
			for(int i=0; i<result.size(); i++){
				String sSceneId = result.get(i);
				RuleScenes.removeRuleScene(sSceneId);
			}
			
		} catch (Exception e) {
			try {
				Sqlca.getConnection().rollback();
			} catch (SQLException e1) {
				ARE.getLog().error(e1);
			}
			ARE.getLog().error(e);
			throw new SADREException(e);
		} finally{
			try {
				Sqlca.getConnection().setAutoCommit(commitStatus);
			} catch (SQLException e) {
				ARE.getLog().error(e);
			}
		}
		
		return WEB_ACTION_�ɹ�;
	}
	
}
