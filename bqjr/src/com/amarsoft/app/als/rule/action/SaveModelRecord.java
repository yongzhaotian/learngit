package com.amarsoft.app.als.rule.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class SaveModelRecord {
	private String recordID;
	private String bomTextIn;
	private String doTranStage;//≤‚À„Ω◊∂Œ
	
	/**
	 * ±£¥Ê∆¿º∂≤‚À„÷∏±Í°£
	 * @param tx
	 * @throws JBOException
	 */
	public String saveRecord(JBOTransaction tx)throws JBOException{
		bomTextIn = bomTextIn.replace("@",";");
		bomTextIn = bomTextIn.replace(":","=");
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("RULEMODRECORDID=:RecordID");
		bq.setParameter("RecordID",recordID);
		BizObject bo = bq.getSingleResult(true);
		if(bo != null){
			if("1".equals(doTranStage))
				bo.getAttribute("BomTextIN").setValue(bomTextIn);
			else if("2".equals(doTranStage))
				bo.getAttribute("BOMTEXTIN02").setValue(bomTextIn);
			else
				bo.getAttribute("BOMTEXTIN03").setValue(bomTextIn);
			bm.saveObject(bo);
			return "SUCCESS";
		}else{
			return "FAILURE";
		}
	}
	public String getRecordID() {
		return recordID;
	}
	public void setRecordID(String recordID) {
		this.recordID = recordID;
	}
	public String getBomTextIn() {
		return bomTextIn;
	}
	public void setBomTextIn(String bomTextIn) {
		this.bomTextIn = bomTextIn;
	}
	public String getDoTranStage() {
		return doTranStage;
	}
	public void setDoTranStage(String doTranStage) {
		this.doTranStage = doTranStage;
	}	
	
	
	
}
