package com.amarsoft.app.awe.framecase.swf;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.ui.chart.ChartCatalog;
import com.amarsoft.awe.ui.chart.ChartData;

public class GetChartAction {
	public String getChart() {
	 	ChartData chart = new ChartData("bar","Bar直方图");
	 	ChartCatalog catalog;
	 	catalog = new ChartCatalog("流动比率");
	 	catalog.addItem("目标企业","2.176");
	 	catalog.addItem("最优企业","25.41");
	 	catalog.addItem("中等企业","44.106");
	 	catalog.addItem("最差企业","14.041");
	 	chart.addCategory(catalog);

	 	catalog = new ChartCatalog("产权比率");
 		catalog.addItem("目标企业","64.01");
 		catalog.addItem("最优企业","15.367");
 		catalog.addItem("中等企业","10.551");
 		catalog.addItem("最差企业","-32.248");
	 	chart.addCategory(catalog); 		
	 	catalog = new ChartCatalog("总资产与固定资产比率");

	 	catalog.addItem("目标企业","6.649");
	 	catalog.addItem("最优企业","29.743");
	 	catalog.addItem("中等企业","6.052");
	 	catalog.addItem("最差企业","81.07");
	 	chart.addCategory(catalog);
	 	ARE.getLog().info(chart.getJson());
	 	return chart.getJson();
	}

}
