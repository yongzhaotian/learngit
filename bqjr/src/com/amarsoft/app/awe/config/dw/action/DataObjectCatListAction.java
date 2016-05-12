package com.amarsoft.app.awe.config.dw.action;


import java.util.Iterator;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class DataObjectCatListAction {
	private String DONO;
	private String newDONO;
	
	public String quickCopyCatalog() throws JBOException{
		//复制catalog表数据
		JBOTransaction tx = JBOFactory.getFactory().createTransaction();
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_CATALOG");
		BizObject catalog = m.createQuery("DONO = :DONO").setParameter("DONO", DONO).getSingleResult();
		if (catalog == null)
			throw new RuntimeException("无效的模板编号:" + DONO);
		BizObject new_catalog = m.newObject();
		new_catalog.setAttributesValue(catalog);
		new_catalog.setAttributeValue("DONO", newDONO);
		tx.join(m);
		m.saveObject(new_catalog);
		//复制Item表数据
		m = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_LIBRARY");
		List items = m.createQuery("DONO = :DONO").setParameter("DONO", DONO).getResultList();
		tx.join(m);
		for (Iterator iterator = items.iterator(); iterator.hasNext();) {
			BizObject bizObject = (BizObject) iterator.next();
			BizObject newItem = m.newObject();
			newItem.setAttributesValue(bizObject);
			newItem.setAttributeValue("DONO", newDONO);
			//newItem.setAttributeValue("IsInUse", "1");
			m.saveObject(newItem);
		}
		tx.commit();
		return "SUCCESS";
	}
	
	public String renameCatalog() throws JBOException {
		JBOTransaction tx = JBOFactory.getFactory().createTransaction();
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_CATALOG");
		tx.join(m);
		m.createQuery("update O set DONO=:DONO where DONO=:OLD").setParameter("DONO", newDONO).setParameter("OLD", DONO).executeUpdate();
		
		m = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_LIBRARY");
		tx.join(m);
		m.createQuery("update O set DONO=:DONO where DONO=:OLD").setParameter("DONO", newDONO).setParameter("OLD", DONO).executeUpdate();
		
		tx.commit();
		
		return "SUCCESS";
	}
	
	public String removeCatalog() throws JBOException {
		JBOTransaction tx = JBOFactory.getFactory().createTransaction();
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_CATALOG");
		tx.join(m);
		m.createQuery("delete from O where DONO=:DONO").setParameter("DONO", DONO).executeUpdate();
		
		m = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_LIBRARY");
		tx.join(m);
		m.createQuery("delete from O where DONO=:DONO").setParameter("DONO", DONO).executeUpdate();
		
		tx.commit();
		
		return "SUCCESS";
	}

	public String getDONO() {
		return DONO;
	}

	public void setDONO(String dONO) {
		DONO = dONO;
	}

	public String getNewDONO() {
		return newDONO;
	}

	public void setNewDONO(String newDONO) {
		this.newDONO = newDONO;
	}
}
