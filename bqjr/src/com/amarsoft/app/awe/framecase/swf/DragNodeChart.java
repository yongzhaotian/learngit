/**
 * 
 */
package com.amarsoft.app.awe.framecase.swf;

import java.util.ArrayList;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectKey;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.ui.chart.DragChart;
import com.amarsoft.awe.ui.chart.DragChartNode;

/**
 * @author A3WebDemo
 *
 */
public class DragNodeChart extends DragChart {

	public boolean initData(String sUserID) throws Exception {
		// 查找用户信息
		BizObjectManager userManager = JBOFactory.getFactory().getManager("jbo.sys.USER_INFO");
		BizObject user = userManager.getObject(userManager.getKey().setAttributeValue("UserID", sUserID));
		if(user == null){
			ARE.getLog().debug("用户信息查询失败["+sUserID+"]");
			return false;
		}
		String sOrgID = user.getAttribute("BelongOrg").getString();
		ArrayList<BizObject> belongOrgs = new ArrayList<BizObject>();
		
		// 查找关联机构信息
		BizObject org = null;
		String sRelativeOrgID = null;
		BizObjectManager orgManager = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO");
		BizObjectKey orgKey = orgManager.getKey();
		do {
			if(sRelativeOrgID != null) sOrgID = sRelativeOrgID;
			orgManager = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO");
			org = orgManager.getObject(orgKey.setAttributeValue("OrgID", sOrgID));
			if(org == null){
				ARE.getLog().debug("机构信息查询失败["+sOrgID+"]");
				return false;
			}
			belongOrgs.add(org);
			sRelativeOrgID = org.getAttribute("RelativeOrgID").getString();
		}while(org != null && !sOrgID.equals(sRelativeOrgID));
		
		// 组装节点
		DragChartNode node = null;
		String sId, sRelationId, sShow = null, sTool = null;
		boolean level = true;
		for(int i = belongOrgs.size(); i > 0;){
			DragChartNode otherOrgNode = null, otherUserNode = null;
			org = belongOrgs.get(--i);
			
			// 查找并生成关联的其他机构及其他用户
			sRelationId = org.getAttribute("RelativeOrgID").getString();
			if(level){
				sTool = "无关联机构";
				level = false;
			}else{
				sTool = "关联机构为："+sShow;
				if(orgManager.createQuery("RelativeOrgID = :RelativeOrgID").setParameter("RelativeOrgID", sRelationId).getTotalCount() > 0){
					otherOrgNode = new DragChartNode(sRelationId+"Org", sRelationId, "关联的其他机构", "关联机构为【"+sShow+"】的其他机构", "gotoOtherOrg(\""+sRelationId+"\")");
					otherOrgNode.setColor("00FF00");
				}
				if(userManager.createQuery("BelongOrg = :BelongOrg").setParameter("BelongOrg", sRelationId).getTotalCount() > 0){
					otherUserNode = new DragChartNode(sRelationId+"User", sRelationId, "关联的其他用户", "所属机构为【"+sShow+"】的其他用户", "gotoOtherUser(\""+sRelationId+"\")");
					otherUserNode.setColor("FFFF00");
				}
			}

			sId = org.getAttribute("OrgID").getString();
			sShow = org.getAttribute("OrgName").getString();
			if(sId.equals(sRelationId)) sRelationId = "Root";
			node = new DragChartNode(sId, sRelationId, sShow, sTool, "gotoOrg(\""+sId+"\")");
			
			if(otherOrgNode != null) addNode(otherOrgNode);
			addNode(node);
			if(otherUserNode != null) addNode(otherUserNode);
		}
		
		// 查找并生成关联的其他机构及其他用户
		sRelationId = user.getAttribute("BelongOrg").getString();
		DragChartNode otherOrgNode = null, otherUserNode = null;
		if(orgManager.createQuery("RelativeOrgID = :RelativeOrgID").setParameter("RelativeOrgID", sRelationId).getTotalCount() > 0){
			otherOrgNode = new DragChartNode(sRelationId+"Org", sRelationId, "关联的其他机构", "关联机构为【"+sShow+"】的其他机构", "gotoOtherOrg(\""+sRelationId+"\")");
			otherOrgNode.setColor("00FF00");
		}
		if(userManager.createQuery("BelongOrg = :BelongOrg").setParameter("BelongOrg", sRelationId).getTotalCount() > 0){
			otherUserNode = new DragChartNode(sRelationId+"User", sRelationId, "关联的其他用户", "所属机构为【"+sShow+"】的其他用户", "gotoOtherUser(\""+sRelationId+"\")");
			otherUserNode.setColor("FFFF00");
		}
		
		// 生成用户节点
		sId = user.getAttribute("UserID").getString();
		sTool = "所属机构为："+sShow;
		sShow = user.getAttribute("UserName").getString();
		node = new DragChartNode(sId, sRelationId, sShow, sTool, "gotoUser(\""+sId+"\")");
		node.setColor("FF0000");
		
		if(otherOrgNode != null) addNode(otherOrgNode);
		addNode(node);
		if(otherUserNode != null) addNode(otherUserNode);
		
		return true;
	}
	
}
