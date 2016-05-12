package com.amarsoft.app.awe.config.menu.dwhandler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 业务对象列表页面事务处理类
 * @author xhgao
 *
 */
public class AppBizObjectListHandler extends CommonHandler {

	/**
	 * 删除前处理
	 */
	public void beforeDelete(JBOTransaction tx, BizObject bo) throws Exception  {
		String sObjectType = bo.getAttribute("ObjectType").getString();
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.sys.OBJECTTYPE_RELA");
		tx.join(bom);
		BizObjectQuery q = bom.createQuery("DELETE FROM O WHERE ObjectType = :ObjectType").setParameter("ObjectType", sObjectType);
		q.executeUpdate();
	}
}
