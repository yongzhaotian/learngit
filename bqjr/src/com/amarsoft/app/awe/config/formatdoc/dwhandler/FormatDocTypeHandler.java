package com.amarsoft.app.awe.config.formatdoc.dwhandler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 操作格式化报告分类的类
 *
 */
public class FormatDocTypeHandler extends CommonHandler {

	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
		setSortNo(bo);
	}
	
	private void setSortNo(BizObject bo)throws JBOException{
		String sTypeNo=bo.getAttribute("TypeNo").getString();
		if(sTypeNo==null)sTypeNo="";
		String sSql="select max(SortNo) as v.SortNo from O where attribute1='1' and length(SortNo)=4";
		BizObjectQuery query=manager.createQuery(sSql);
		int maxSort=query.getSingleResult(false).getAttribute("SortNo").getInt();
		String sSortNo;
		if(maxSort == 0){
			sSortNo = "0010";
		}else{
			sSortNo = String.valueOf(maxSort + 10);
		}
		while(sSortNo.length() < 4){
			sSortNo = "0" + sSortNo;
		}
		bo.setAttributeValue("SortNo", sSortNo);
		bo.setAttributeValue("TypeNo", sSortNo);
		bo.setAttributeValue("attribute1", "1");
	}
}