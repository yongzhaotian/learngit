package com.amarsoft.app.awe.config.menu.dwhandler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * ҵ�����������������
 * @author xhgao
 *
 */
public class AppBizObjectRelaHandler extends CommonHandler {

	/**
	 * ������ʼ��
	 */
	public void initDisplayForAdd(BizObject bo) throws Exception  {
		String sObjectType = asPage.getParameter("ObjectType");
		if(sObjectType==null) sObjectType="";
		
		bo.setAttributeValue("ObjectType",sObjectType);
	}
}
