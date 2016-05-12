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
package com.amarsoft.sadre.app.widget;

import java.text.DecimalFormat;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.sadre.app.widget.tree.ITreeNode;
import com.amarsoft.sadre.app.widget.tree.LeafNode;
import com.amarsoft.sadre.app.widget.tree.RootNode;
import com.amarsoft.web.ui.HTMLTreeView;

 /**
 * <p>Title: ImportSceneTree.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-8 上午10:42:30
 *
 * logs: 1. 
 */
public class ImportSceneTree implements ITreeNode {
	
	private Map<String,SceneTreeNode> sceneTreeMap = new LinkedHashMap<String,SceneTreeNode>();
	
	private DecimalFormat format = new DecimalFormat("0000");

	/* (non-Javadoc)
	 * @see com.amarsoft.awe.ui.widget.tree.IGetNodes#getNodes(java.util.Map, com.amarsoft.awe.util.Transaction)
	 */
	
	public void appendTreeNode(HTMLTreeView tviTemp,
			Map<String, String> attributes, Transaction sqlca) {

		String curSceneId = attributes.get("CurSceneId");
		/*
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.sadre.ASSUMPTION");
		BizObjectQuery boq = bom.createQuery("select SCENEID as v.SCENEID,R.SCENENAME,ASSUMPTIONID as v.ASSUMPTIONID,PRIORITY as v.PRIORITY,DECISION as v.DECISION " +
				"from o,jbo.app.sadre.RULESCENE R " +
				"where R.SceneId = O.SceneId " +
				"and R.SceneId not in (:CurSceneId) " +
				"and R.Status='1' " +
				"order by R.SCENEID,O.PRIORITY,O.ASSUMPTIONID");
		boq.setParameter("CurSceneId", curSceneId);
		List<BizObject> resutl = boq.getResultList(false);
		for(BizObject bo:resutl){
			String sceneId 	 = bo.getAttribute("SCENEID").getString();
			String sceneName = bo.getAttribute("SCENENAME").getString();
			String ruleId 	 = bo.getAttribute("ASSUMPTIONID").getString();
			String priority  = bo.getAttribute("PRIORITY").getString();
			String decision  = bo.getAttribute("DECISION").getString();
//			ARE.getLog().debug(sceneId+" "+sceneName+" "+ruleId);
			SceneTreeNode sceneNode = null;
			if(sceneTreeMap.containsKey(sceneId)){
				sceneNode = sceneTreeMap.get(sceneId);
			}else{
				sceneNode = new SceneTreeNode(sceneId,sceneName);
				sceneNode.setSortNo(format.format(sceneTreeMap.size()));
				sceneTreeMap.put(sceneId, sceneNode);
			}
			sceneNode.addLeaf(new RuleTreeNode(ruleId,priority,decision));
			
		}
		*/
		try {
			ASResultSet resultset = sqlca.getASResultSet("select O.SCENEID,R.SCENENAME,O.ASSUMPTIONID,O.PRIORITY,O.DECISION " +
					"from SADRE_ASSUMPTION O, SADRE_RULESCENE R " +
					"where R.SceneId = O.SceneId " +
					"and R.SceneId not in ('"+curSceneId+"') " +
					"and R.Status='1' " +
					"order by R.SCENEID,O.PRIORITY,O.ASSUMPTIONID");
			while(resultset.next()){
				String sceneId 	 = resultset.getString("SCENEID");
				String sceneName = resultset.getString("SCENENAME");
				String ruleId 	 = resultset.getString("ASSUMPTIONID");
				String priority  = resultset.getString("PRIORITY");
				String decision  = resultset.getString("DECISION");
//				ARE.getLog().debug(sceneId+" "+sceneName+" "+ruleId);
				SceneTreeNode sceneNode = null;
				if(sceneTreeMap.containsKey(sceneId)){
					sceneNode = sceneTreeMap.get(sceneId);
				}else{
					sceneNode = new SceneTreeNode(sceneId,sceneName);
					sceneNode.setSortNo(format.format(sceneTreeMap.size()));
					sceneTreeMap.put(sceneId, sceneNode);
				}
				sceneNode.addLeaf(new RuleTreeNode(ruleId,priority,decision, sqlca));
			}
			resultset.getStatement().close();
		} catch (Exception e) {
			ARE.getLog().error(e);
		}
		
		int folderCount = 1;
		Iterator<SceneTreeNode> tk = sceneTreeMap.values().iterator();
		while(tk.hasNext()){
//			String sceneId = tk.next();
			SceneTreeNode sceneNode = tk.next();
			/*以方案作为1st目录*/
			String sTmpFolder = tviTemp.insertFolder("root",sceneNode.getDescribe(),"",folderCount++);
			
			/*项下的授权规则列表*/
			int iLeaf = 1;
			Iterator<LeafNode> rtor = sceneNode.getLeafs().values().iterator();
			while(rtor.hasNext()){
				LeafNode ruleNode = rtor.next();
				tviTemp.insertPage(sTmpFolder,ruleNode.getDescribe(),sceneNode.getId()+"@"+ruleNode.getId(),"",iLeaf++);
			}
		}
		
	}
	
	private class SceneTreeNode extends RootNode{
		
		public SceneTreeNode(String id,String name){
			this.treeId = id;
			this.treeName = name;
		}

		
		public String getDescribe() {
			return "["+getId()+"] "+getName();
		}
		
	}
	
	private class RuleTreeNode extends LeafNode{
		String priority  = "";
		String decision  = "";
		Transaction Sqlca = null;
		public RuleTreeNode(String id,String pro,String desc, Transaction to){
			this.nodeId = id;
			this.priority = pro;
			this.decision = desc;
			this.Sqlca = to;
		}
		
		
		public String getDescribe(){
			try {
				return getId()+" "+CodeManager.getItemName("RulePriority", this.priority)+" "+CodeManager.getItemName("RuleDecision", this.decision);
			} catch (Exception e) {
				ARE.getLog().debug(e);
			}
			return getId()+" "+this.priority;
		}

	}
}

