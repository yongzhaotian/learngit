package com.amarsoft.app.awe.framecase.formatdoc.template01;

import com.amarsoft.biz.formatdoc.chart.DrawPie;

public class D001_00_PieChart extends DrawPie {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void initDatas() {
		D001_00 wordDoc = (D001_00)getFormartDoc();
		this.addData("ÆÖ¶«", Double.parseDouble(wordDoc.getExtobj0().getAttr5()));
		this.addData("ÆÖÎ÷", Double.parseDouble(wordDoc.getExtobj0().getAttr6()));
	}
}
