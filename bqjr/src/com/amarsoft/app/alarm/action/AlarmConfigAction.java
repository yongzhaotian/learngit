package com.amarsoft.app.alarm.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 探测分组引入检查项操作
 * @author xhgao
 *
 */
public class AlarmConfigAction {

	private String scenarioID;
	private String groupID;
	private String modelIDs;

	public String getScenarioID() {
		return scenarioID;
	}

	public void setScenarioID(String scenarioID) {
		this.scenarioID = scenarioID;
	}

	public String getGroupID() {
		return groupID;
	}

	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}

	public String getModelIDs() {
		return modelIDs;
	}

	public void setModelIDs(String modelIDs) {
		this.modelIDs = modelIDs;
	}

	public String addGroupItems(JBOTransaction tx) throws Exception{
		try{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.SCENARIO_RELATIVE");
			tx.join(bm);
			//先删除该分组下的关联关系
			BizObjectQuery bq = bm.createQuery("delete from O where ScenarioID = :ScenarioID and O.GroupID = :GroupID");
			bq.setParameter("ScenarioID", scenarioID).setParameter("GroupID", groupID);
			bq.executeUpdate();
			
			//再根据配置新增指定关联关系
			String[] modelIDArray = modelIDs.split("@");
			for(int i=0;i<modelIDArray.length;i++){
				BizObject bo = bm.newObject();
				bo.setAttributeValue("ScenarioID", scenarioID).setAttributeValue("GroupID", groupID).setAttributeValue("ModelID", modelIDArray[i]);
				bm.saveObject(bo);
			}
			tx.commit();
			return "SUCCEEDED";
		}catch (Exception e) {
			tx.rollback();
			return "FAILED";
		}
	}
	
	public String delGroupItems(JBOTransaction tx) throws Exception{
		try{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.SCENARIO_RELATIVE");
			tx.join(bm);
			//先删除该分组下的关联关系
			BizObjectQuery bq = bm.createQuery("delete from O where ScenarioID = :ScenarioID and O.GroupID = :GroupID");
			bq.setParameter("ScenarioID", scenarioID).setParameter("GroupID", groupID);
			bq.executeUpdate();
			tx.commit();
			return "SUCCEEDED";
		}catch (Exception e) {
			tx.rollback();
			return "FAILED";
		}
	}
}
