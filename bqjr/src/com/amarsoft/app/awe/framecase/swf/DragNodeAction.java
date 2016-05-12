/**
 * 
 */
package com.amarsoft.app.awe.framecase.swf;

import com.amarsoft.awe.ui.chart.DragChart;

/**
 * @author A3WebDemo
 *
 */
public class DragNodeAction {
	
	private String userID;
	
	/**
	 * @param userID the userID to set
	 */
	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getChart() throws Exception{
		DragChart chart = new DragNodeChart();
	    chart.initData(userID);
	    chart.setChartName("用户【"+userID+"】关联信息");
	    chart.setFromTo(true);
		String data = chart.getChart();
		return data;
	}
}
