package com.amarsoft.app.awe.framecase.formatdoc.template01;

import java.util.ArrayList;

import com.amarsoft.biz.formatdoc.chart.DrawLine;
import com.amarsoft.biz.formatdoc.model.TestExtClass;

public class D001_00_LineChart extends DrawLine {

	private static final long serialVersionUID = 1L;

	@Override
	protected void initDatas() {
		
		D001_00 wordDoc = (D001_00)getFormartDoc();
		TestExtClass[] datas = wordDoc.getExtobj1();
		ArrayList list1 = new ArrayList();
		ArrayList list2 = new ArrayList();
		
		if(datas!=null){
			for(int i=0;i<datas.length;i++){
				String sType = datas[i].getAttr3();
				if(sType.trim().equals(""))sType = "";
				if(sType.equals("010")){
					list2.add(datas[i]);
				}
				else{
					list1.add(datas[i]);
				}
			}
			this.setXYPointList("xxx");
			for(int j=0;j<list1.size();j++){
				int iValue = Integer.parseInt(((TestExtClass)list1.get(j)).getAttr4());
				this.addPoint(j+1, iValue);
			}
			this.addPointList();
			this.setXYPointList("010");
			for(int j=0;j<list2.size();j++){
				int iValue = Integer.parseInt(((TestExtClass)list2.get(j)).getAttr4());
				this.addPoint(j+1, iValue);
			}
			this.addPointList();
		}
		
		
	}
}
