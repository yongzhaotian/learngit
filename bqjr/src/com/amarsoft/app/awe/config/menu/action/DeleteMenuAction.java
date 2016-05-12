package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 主菜单删除处理，删除菜单记录的同时删除其与所属子系统、可见角色的关联关系
 * @author xhgao
 *
 */
public class DeleteMenuAction {

	//定义变量
	private String menuID; //菜单编号

	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	public String deleteMenuAndRela(Transaction Sqlca) throws Exception{
		
		DeleteMenuRela delMenuRela = new DeleteMenuRela();
		delMenuRela.setMenuID(menuID);
		
		//删除指定菜单与所属子系统的关联关系
		//delMenuRela.deleteMenuApps(Sqlca);
		//删除指定菜单与可见角色的关联关系
		delMenuRela.deleteMenuRoles(Sqlca);
		
		//删除指定菜单信息
		Sqlca.executeSQL(new SqlObject("DELETE FROM AWE_MENU_INFO WHERE MenuID = :MenuID").setParameter("MenuID", menuID));
		
		return "SUCCEEDED";
	}
}
