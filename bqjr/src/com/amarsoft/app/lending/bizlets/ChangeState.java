/*
		Author: --cyyu 2009-03-26
		Tester:
		Describe: --启用或停用主菜单项目
		Input Param:
				ItemNo: 项目编号
				IsInUse: 使用状态
				Flag：标志
		Output Param:
				sReturn：返回提示
		HistoryLog:   sxjiang 2010/07/20 在Line41、47添加对System_Menu的操作，使得页面能正常启用和停用模块
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ChangeState extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//获得项目编号
		String sItemNo = (String)this.getAttribute("ItemNo");
		//获得使用状态  锁定 0;正常 1;停用 2;
		String sIsInUse = (String)this.getAttribute("IsInUse");
		//获得是启用还是停用标志  启用 1;停用 2;
		String sFlag = (String)this.getAttribute("Flag");
		
		//将空值转化成空字符串
		if(sItemNo == null) sItemNo = "";
		if(sIsInUse == null) sIsInUse = "";
		if(sFlag == null) sFlag = "";
		SqlObject so ;//声明对象
		//定义变量
		String sSql1 = "",sSql2 = "",sReturn = "false";
		//启用
		if (sFlag.equals("1") && sIsInUse.equals("正常")) {
			sReturn = "1";
		}
		if (sFlag.equals("1") && !sIsInUse.equals("正常") && !sItemNo.equals("")) {
			sSql1 = "Update CODE_LIBRARY set IsInUse='1' where CodeNo='MainMenu' and ItemNo=:ItemNo "; 
			so = new SqlObject(sSql1).setParameter("ItemNo", sItemNo);
			Sqlca.executeSQL(so);
			sSql2 = "Update SYSTEM_MENU set IsInUse='1' where MenuId=:MenuId "; 
			so = new SqlObject(sSql2).setParameter("MenuId", sItemNo);
			Sqlca.executeSQL(so);
			sReturn = "success";
		}
		if (sFlag.equals("2") && !sIsInUse.equals("停用") && !sItemNo.equals("")) {
			sSql1 = "Update CODE_LIBRARY set IsInUse='2' where CodeNo='MainMenu' and ItemNo=:ItemNo "; 
			so = new SqlObject(sSql1).setParameter("ItemNo", sItemNo);
			Sqlca.executeSQL(so);
			sSql2 = "Update SYSTEM_MENU set IsInUse='2' where MenuId=:MenuId ";
			so = new SqlObject(sSql2).setParameter("MenuId", sItemNo);
			Sqlca.executeSQL(so);
			sReturn = "success";
		}
		if (sFlag.equals("2") && sIsInUse.equals("停用")) {
			sReturn = "2";
		}
		return sReturn;
	}

}
