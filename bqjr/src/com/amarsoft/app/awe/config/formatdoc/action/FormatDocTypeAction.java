package com.amarsoft.app.awe.config.formatdoc.action;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class FormatDocTypeAction {
	private String typeNo;

	public String getTypeNo() {
		return typeNo;
	}

	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}
	
	public String delete(JBOTransaction tx) throws JBOException {
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_TYPE");
		tx.join(m);
		m.createQuery("delete from O where TypeNo=:TypeNo").setParameter("TypeNo", typeNo).executeUpdate();
		
		return "SUCCESS";
	}
	
	public String getSortNo(JBOTransaction tx)throws JBOException{
		String sSql="select max(SortNo) as v.SortNo from O where attribute1='1' and  length(SortNo)=4";
		BizObjectQuery query=JBOFactory.createBizObjectQuery("jbo.app.FORMATDOC_TYPE", sSql);
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
		return sSortNo;
	}
}
