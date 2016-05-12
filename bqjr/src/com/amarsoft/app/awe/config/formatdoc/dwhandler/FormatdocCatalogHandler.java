package com.amarsoft.app.awe.config.formatdoc.dwhandler;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class FormatdocCatalogHandler extends CommonHandler {

	protected boolean validityCheck(BizObject bo, boolean isInsert) {
		this.errors = "����ʧ�ܣ�";
		try {
			if (bo == null) return false;
			String docid = bo.getAttribute("DOCID").getString();
			if (docid == null) return false;
			String startDate = bo.getAttribute("startDate").getString();
			this.errors = "��ʼʱ��ͽ���ʱ�䲻��Ϊ�գ�";
			if (startDate == null || "".equals(startDate))
				return false;// �����ʼʱ��Ϊ���򲻲���
			String endDate = bo.getAttribute("endDate").getString();
			if (endDate == null || "".equals(endDate))
				return false;// �������ʱ��Ϊ���򲻲���
			this.errors = "��ʼʱ�����С�ڽ���ʱ�䣡";
			if (startDate.compareTo(endDate) > 0)
				return false;// �����ʼʱ����ڽ���ʱ���򲻲���
			BizObjectManager manager = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_CATALOG");
			BizObjectQuery bq = manager.createQuery("select * from O where doctype=:doctype and docid<>:docid");
			bq.setParameter("doctype", bo.getAttribute("doctype").getString()).setParameter("docid", docid);
			@SuppressWarnings("unchecked")
			List<BizObject> list = bq.getResultList(false);
			this.errors = "��ʼʱ�������ʱ�����䲻��������ʱ�������н��棡";
			for (BizObject bizObject : list) {
				String startTime = bizObject.getAttribute("startDate").getString();
				if (startTime == null) break;
				String endTime = bizObject.getAttribute("endDate").getString();
				if (endTime == null) break;
				// �����ʼʱ��С�ڽ���ʱ�䲢�ҽ���ʱ����ڿ�ʼʱ���򲻲���
				if (startDate.compareTo(endTime) < 0
						&& endDate.compareTo(startTime) > 0)
					return false;
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return true;
	}
}
