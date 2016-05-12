package com.amarsoft.app.als.rule.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class NewModelRecord {
	
	String serialNo;   //流水号
	String params;     //记录信息

	public String saveRecord(JBOTransaction tx) throws Exception {
		BizObjectManager bm = null;
		BizObject bo = null;
		params = params.replace("@", ";");
		params = params.replace(":", "=");
		if(params.startsWith(";"))params=params.substring(1);
		//新增RULE_MODEL_RECORD记录
		bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
		bo = bm.newObject();
		bo.getAttribute("RULEMODRECORDID").setNull();
		bo.setAttributeValue("BOMTEXTIN", params);
		tx.join(bm);
		bm.saveObject(bo);
		return bo.getAttribute("RULEMODRECORDID").toString();
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getParams() {
		return params;
	}

	public void setParams(String params) {
		this.params = params;
	}
}
