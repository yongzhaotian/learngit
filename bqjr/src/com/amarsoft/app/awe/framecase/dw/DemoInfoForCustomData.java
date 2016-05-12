package com.amarsoft.app.awe.framecase.dw;

import java.util.Hashtable;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.ui.htmlfactory.InfoHtmlWithASDataObjectGenerator;

public class DemoInfoForCustomData extends InfoHtmlWithASDataObjectGenerator {

	public void run(BusinessProcessData bpData) throws Exception {
		data = new Hashtable();
		int iIndex = Integer.parseInt(this.paramstr)-100000;
		data.put("SERIALNO",(100000 + iIndex) +"");
		data.put("CUSTOMERNAME","name" + iIndex);
		data.put("TELEPHONE","135649");
		data.put("ISINUSE",(iIndex % 2)+"");
		data.put("ADDRESS","2011");
	}
}

