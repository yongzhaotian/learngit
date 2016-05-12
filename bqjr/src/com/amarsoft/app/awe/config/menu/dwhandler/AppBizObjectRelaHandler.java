package com.amarsoft.app.awe.config.menu.dwhandler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 业务对象详情事务处理类
 * @author xhgao
 *
 */
public class AppBizObjectRelaHandler extends CommonHandler {

	/**
	 * 新增初始化
	 */
	public void initDisplayForAdd(BizObject bo) throws Exception  {
		String sObjectType = asPage.getParameter("ObjectType");
		if(sObjectType==null) sObjectType="";
		
		bo.setAttributeValue("ObjectType",sObjectType);
	}
}
