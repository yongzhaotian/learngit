package com.amarsoft.app.awe.config.menu.dwhandler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * ҵ������б�ҳ����������
 * @author xhgao
 *
 */
public class AppBizObjectListHandler extends CommonHandler {

	/**
	 * ɾ��ǰ����
	 */
	public void beforeDelete(JBOTransaction tx, BizObject bo) throws Exception  {
		String sObjectType = bo.getAttribute("ObjectType").getString();
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.sys.OBJECTTYPE_RELA");
		tx.join(bom);
		BizObjectQuery q = bom.createQuery("DELETE FROM O WHERE ObjectType = :ObjectType").setParameter("ObjectType", sObjectType);
		q.executeUpdate();
	}
}
