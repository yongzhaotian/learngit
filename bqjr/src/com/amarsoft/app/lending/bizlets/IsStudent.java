package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.DataConvertTools;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class IsStudent extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception {
		//获取参数：对象类型、对象编号、当前用户、当前角色,若参数值为null,则转成空字符串
		String sObjectType = DataConvertTools.nullToEmptyString((String)this.getAttribute("ObjectType"));
		String sObjectNo = DataConvertTools.nullToEmptyString((String)this.getAttribute("ObjectNo"));
		String sUserID = DataConvertTools.nullToEmptyString((String)this.getAttribute("UserID"));
		String sRoleID = DataConvertTools.nullToEmptyString((String)this.getAttribute("RoleID"));
		
		//写判断是否是学生的逻辑

		
		return "true";
	}
}

