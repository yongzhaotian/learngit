package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.security.SecurityOptionManager;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 本类是保存安全选项的Bizlet
 * @author sxjiang   2010/07/13
 *
 */
public class SaveAuditOption extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//获得从AuditOptionInfo页面传递的5个参数
		String sItemNo = (String)this.getAttribute("ItemNo");
		String sItemValue = (String)this.getAttribute("ItemValue");
		String sIsInUse = (String)this.getAttribute("IsInUse");
		String schangeUserId = (String)this.getAttribute("changeUserId");
		String schangeUserName = (String)this.getAttribute("changeUserName");
				
		//保存数据，保存用户操作
		SecurityOptionManager.setRulesState(Sqlca, sItemNo, sItemValue, sIsInUse,schangeUserId,schangeUserName);
		
		//不抛异常则返回1，在页面中判断处理是否成功
		return "1";
	}
}
