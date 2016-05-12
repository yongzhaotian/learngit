package com.amarsoft.app.util;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class DataObjectLibListAction {
	private String DONO;
	private String colIndex;

	/**
	 * ¸´ÖÆ
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public String quickCopyLib(JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getBizObjectManager("jbo.sys.DATAOBJECT_LIBRARY");
		tx.join(m);
		BizObject lib = m.createQuery("DONO = :DONO and ColIndex = :ColIndex").setParameter("DONO", DONO).setParameter("ColIndex", colIndex).getSingleResult(false);
		
		String colindex_copy = colIndex +"_copy";
		BizObject newLib = m.newObject();
		newLib.setAttributesValue(lib);
		newLib.setAttributeValue("ColIndex", colindex_copy);
		m.saveObject(newLib);
		return "SUCCESS";
	}
	
	public String getDONO() {
		return DONO;
	}

	public void setDONO(String dONO) {
		DONO = dONO;
	}

	public String getColIndex() {
		return colIndex;
	}

	public void setColIndex(String colIndex) {
		this.colIndex = colIndex;
	}
}