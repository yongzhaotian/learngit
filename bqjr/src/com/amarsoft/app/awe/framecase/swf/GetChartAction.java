package com.amarsoft.app.awe.framecase.swf;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.ui.chart.ChartCatalog;
import com.amarsoft.awe.ui.chart.ChartData;

public class GetChartAction {
	public String getChart() {
	 	ChartData chart = new ChartData("bar","Barֱ��ͼ");
	 	ChartCatalog catalog;
	 	catalog = new ChartCatalog("��������");
	 	catalog.addItem("Ŀ����ҵ","2.176");
	 	catalog.addItem("������ҵ","25.41");
	 	catalog.addItem("�е���ҵ","44.106");
	 	catalog.addItem("�����ҵ","14.041");
	 	chart.addCategory(catalog);

	 	catalog = new ChartCatalog("��Ȩ����");
 		catalog.addItem("Ŀ����ҵ","64.01");
 		catalog.addItem("������ҵ","15.367");
 		catalog.addItem("�е���ҵ","10.551");
 		catalog.addItem("�����ҵ","-32.248");
	 	chart.addCategory(catalog); 		
	 	catalog = new ChartCatalog("���ʲ���̶��ʲ�����");

	 	catalog.addItem("Ŀ����ҵ","6.649");
	 	catalog.addItem("������ҵ","29.743");
	 	catalog.addItem("�е���ҵ","6.052");
	 	catalog.addItem("�����ҵ","81.07");
	 	chart.addCategory(catalog);
	 	ARE.getLog().info(chart.getJson());
	 	return chart.getJson();
	}

}
