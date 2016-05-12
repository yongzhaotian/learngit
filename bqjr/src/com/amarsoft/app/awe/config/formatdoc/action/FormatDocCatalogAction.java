package com.amarsoft.app.awe.config.formatdoc.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class FormatDocCatalogAction {
	private String docID;

	public String getDocID() {
		return docID;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}

	/**
	 * 删除格式化报告目录信息
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public String delete(JBOTransaction tx)throws JBOException{
		BizObjectManager m0=JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_CATALOG");
		tx.join(m0);
		m0.createQuery("delete from O where DocID=:DocID").setParameter("DocID", docID).executeUpdate();
		
		BizObjectManager m1=JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DEF");
		tx.join(m1);
		m1.createQuery("delete from O where DocID=:DocID").setParameter("DocID", docID).executeUpdate();
		
		BizObjectManager m2=JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_PARA");
		tx.join(m2);
		m2.createQuery("delete from O where DocID=:DocID").setParameter("DocID", docID).executeUpdate();
		
		return "SUCCESS";
	}
	
	/**
	 * 复制格式化报告目录信息
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public String copy(JBOTransaction tx) throws JBOException{
		if(docID == null || docID.endsWith("_copy")) return "请先处理信息["+docID+"]";
		BizObjectManager manager=JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_CATALOG");
		BizObject bizx = manager.createQuery("select 1 from O where DocId = :DocId").setParameter("DocId", docID+"_copy").getSingleResult(false);
		if(bizx != null) return "该信息已复制过，请先处理复制信息["+docID+"_copy]";

		BizObject biz = manager.createQuery("DocId=:DocId").setParameter("DocId", docID).getSingleResult(false);
		BizObject newBiz=manager.newObject();
		newBiz.setAttributesValue(biz);
		newBiz.setAttributeValue("docid",biz.getAttribute("DocId").getString()+"_copy");
		newBiz.setAttributeValue("docname",biz.getAttribute("docname").getString()+"_copy");
		tx.join(manager);
		manager.saveObject(newBiz);
		copyFormatDocRelevance(tx, biz.getAttribute("docID").getString(), newBiz.getAttribute("docID").getString(), "jbo.app.FORMATDOC_DEF");
		copyFormatDocRelevance(tx, biz.getAttribute("docID").getString(), newBiz.getAttribute("docID").getString(), "jbo.app.FORMATDOC_PARA");
		return "SUCCESS";
	}
	
	/**
	 * 复制格式化报告目录相关联信息
	 * @param tx
	 * @param docId
	 * @param newDocId
	 * @param jboPackName
	 * @throws JBOException
	 */
	public void copyFormatDocRelevance(JBOTransaction tx,String docId,String newDocId,String jboPackName)throws JBOException{
		BizObjectManager manager=JBOFactory.getFactory().getManager(jboPackName);
		tx.join(manager);
		@SuppressWarnings("unchecked")
		List<BizObject> list=manager.createQuery("DOCID=:docid").setParameter("docid", docId).getResultList(false);
		for (BizObject bizObject : list) {
			BizObject newBiz=manager.newObject();
			newBiz.setAttributesValue(bizObject);
			newBiz.setAttributeValue("docid", newDocId);
			manager.saveObject(newBiz);
		}
	}
}
