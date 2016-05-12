package com.amarsoft.app.awe.framecase.formatdoc.template01;

import com.amarsoft.biz.formatdoc.chart.DrawBar;
import com.amarsoft.biz.formatdoc.model.TestExtClass;

public class D001_00_BarChart extends DrawBar {

	private static final long serialVersionUID = 1L;

	@Override
	protected void initDatas() {
		D001_00 wordDoc = (D001_00)getFormartDoc();
		TestExtClass[] datas = wordDoc.getExtobj1();
		if(datas!=null){
			for(int i=0;i<datas.length;i++){
				String sTitle = datas[i].getAttr1();
				int iValue = Integer.parseInt(datas[i].getAttr4());
				this.addData(sTitle, iValue,"所有分类");
			}
		}
	}
	
	protected void initAttributes() {
		super.initAttributes();
		this.setYTitle("数值");
		this.setXTitle("科目名称");
		this.setV(true);
		this.setMargin(0.3);
		this.setXFontSize(10);
		this.setYFontSize(10);
	}

}
