package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.app.als.customer.group.model.GroupCustomerChart;
import com.amarsoft.awe.ui.chart.DragChart;

/**
 * @author bwang1 2011-03-10
 * @desc  集团家谱关系图展示
 * 
 */
public class GetFamilyChartXmlAction {
	private String groupID;
	private String refVersionSeq;
	
	public String getGroupID() {
		return groupID;
	}
	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}
	public String getRefVersionSeq() {
		return refVersionSeq;
	}

	public void setRefVersionSeq(String refVersionSeq) {
		this.refVersionSeq = refVersionSeq;
	}



	/**
	 * 获取DragChart所需的Xml串
	 * @throws Exception 
	 * 
	 */
	public String getChart() throws Exception{
	    DragChart chart = new  GroupCustomerChart(getGroupID(),getRefVersionSeq());
	    chart.initData(getGroupID());
	    chart.setChartName("集团家谱关系图展示");
	    chart.setFromTo(true);
	    //ARE.getLog().debug(chart.getChart());
		return chart.getChart();
	}
}
