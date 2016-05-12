package com.amarsoft.app.als.rule.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 更新模型记录
 * @author zszhang
 *
 */
public class UpdateModelRecord {
	public String serialNo;
	
	public void updateBom(JBOTransaction tx) throws Exception{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
		bq = bm.createQuery("RefRatingRecordID=:SerialNo");
		bq.setParameter("SerialNo", serialNo);
		bo = bq.getSingleResult();
		if(bo!=null){
			bo.setAttributeValue("BomTextIn02", "");
			bo.setAttributeValue("BomTextIn03", "");
		}
		tx.join(bm);
		bm.saveObject(bo);
	}
	
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
}
