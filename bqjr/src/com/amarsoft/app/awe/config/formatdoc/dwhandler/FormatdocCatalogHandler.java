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
		this.errors = "操作失败！";
		try {
			if (bo == null) return false;
			String docid = bo.getAttribute("DOCID").getString();
			if (docid == null) return false;
			String startDate = bo.getAttribute("startDate").getString();
			this.errors = "起始时间和结束时间不能为空！";
			if (startDate == null || "".equals(startDate))
				return false;// 如果起始时间为空则不插入
			String endDate = bo.getAttribute("endDate").getString();
			if (endDate == null || "".equals(endDate))
				return false;// 如果结束时间为空则不插入
			this.errors = "起始时间必需小于结束时间！";
			if (startDate.compareTo(endDate) > 0)
				return false;// 如果起始时间大于结束时间则不插入
			BizObjectManager manager = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_CATALOG");
			BizObjectQuery bq = manager.createQuery("select * from O where doctype=:doctype and docid<>:docid");
			bq.setParameter("doctype", bo.getAttribute("doctype").getString()).setParameter("docid", docid);
			@SuppressWarnings("unchecked")
			List<BizObject> list = bq.getResultList(false);
			this.errors = "起始时间与结束时间区间不能与其他时间区间有交叉！";
			for (BizObject bizObject : list) {
				String startTime = bizObject.getAttribute("startDate").getString();
				if (startTime == null) break;
				String endTime = bizObject.getAttribute("endDate").getString();
				if (endTime == null) break;
				// 如果起始时间小于结束时间并且结束时间大于开始时间则不插入
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
