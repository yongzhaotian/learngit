package com.amarsoft.app.als.customer.group.model;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.ui.chart.DragChart;
import com.amarsoft.awe.ui.chart.DragChartNode;

/**
 * 集团关系网视图类
 */
public class GroupCustomerChart extends DragChart {
	private JBOFactory factory = JBOFactory.getFactory();
	private String sGroupID;
	private String sVersionSeq;

	/**
	 * 视图实例化
	 */
	
	public GroupCustomerChart() {
	}
	public GroupCustomerChart(String sGroupID, String sVersionSeq) throws JBOException {
		this.sGroupID = sGroupID;
		this.sVersionSeq = sVersionSeq;
	}

	/**
	 * 判断子成员客户是否正式存在
	 */
	private String customerState(String sMemberCustomerID) throws JBOException {
		BizObjectManager manager = factory.getManager("jbo.app.CUSTOMER_INFO");
		BizObjectQuery query = manager.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sMemberCustomerID);
		return query.getSingleResult() != null ? "EXIST" : "NOTEXIST";
	}

	public boolean initData() throws Exception {
		BizObjectManager manager = factory.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObjectQuery query = manager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq");
		query.setParameter("GroupID",sGroupID).setParameter("VersionSeq",sVersionSeq);
		List jbos = query.getResultList();
		BizObject jbo = null;
		DragChartNode node = null;
		String sMemberID,sParentMemberID,sMemberCustomerID;
		String sShow, sTool;
		
		for(int i = 0; i < jbos.size(); i++){
			jbo = (BizObject) jbos.get(i);
			sShow = "成员名称：";
			sTool = "成员编号：";
			sMemberID = jbo.getAttribute("MemberID").getString();
			sMemberCustomerID = jbo.getAttribute("MemberCustomerID").getString(); 
			sParentMemberID = jbo.getAttribute("ParentMemberID").getString();
			if("None".equals(sParentMemberID)){
				sShow = "母公司名称：";
				sTool = "母公司编号：";
			}
			sShow += jbo.getAttribute("MemberName").getString();
			sTool += sMemberCustomerID + "\n" + sShow;
			
			// 成员节点
			node = new DragChartNode(sMemberCustomerID,sParentMemberID,sShow,sTool,"gotoLink(\""+this.customerState(sMemberCustomerID)+"\",\""+sMemberCustomerID+"\")");
			node.setWidth(100.0);
			// node.setColor("BAE01F");
			this.addNode(node);
		}
		
		// 变色
		int n = this.getFloor();
		List nodes = this.getNodes();
		for(int i = 0; i <= n; i++){
			for(int j = 0; j < nodes.size(); j++){
				node = (DragChartNode) nodes.get(j);
				if(this.getInFloor(node) == i){
					switch (i) {
						case 0:node.setColor("FF0000");break;
						case 1:node.setColor("FF00FF");break;
						default:node.setColor("5FAE45");break;
					}
				}
			}
		}
		return true;
	}

	public boolean initData(String sKey) throws Exception {
		sGroupID = sKey;
		initData();
		return true;
	}
}
	