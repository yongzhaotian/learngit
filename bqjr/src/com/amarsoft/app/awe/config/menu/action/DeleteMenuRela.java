package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 删除指定菜单与所属子系统、可见角色的关联关系
 *
 */
public class DeleteMenuRela {
	private String menuID; //子系统编号
	
	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	/**
	 * 删除指定菜单与所属子系统的关联关系
	 * @return
	 * @throws Exception
	 */
	public String deleteMenuApps(Transaction Sqlca) throws Exception{
		SqlObject asql = new SqlObject("DELETE FROM AWE_APP_MENU where MenuID = :MenuID").setParameter("MenuID", menuID);
		Sqlca.executeSQL(asql);
		return "SUCCEEDED";
	}
	
	/**
	 * 删除指定菜单与可见角色的关联关系
	 * @return
	 * @throws Exception
	 */
	public String deleteMenuRoles(Transaction Sqlca) throws Exception{
		SqlObject asql = new SqlObject("DELETE FROM AWE_ROLE_MENU where MenuID = :MenuID").setParameter("MenuID", menuID);
		Sqlca.executeSQL(asql);
		return "SUCCEEDED";
	}
}
