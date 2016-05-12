package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ɾ��ָ���˵���������ϵͳ���ɼ���ɫ�Ĺ�����ϵ
 *
 */
public class DeleteMenuRela {
	private String menuID; //��ϵͳ���
	
	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	/**
	 * ɾ��ָ���˵���������ϵͳ�Ĺ�����ϵ
	 * @return
	 * @throws Exception
	 */
	public String deleteMenuApps(Transaction Sqlca) throws Exception{
		SqlObject asql = new SqlObject("DELETE FROM AWE_APP_MENU where MenuID = :MenuID").setParameter("MenuID", menuID);
		Sqlca.executeSQL(asql);
		return "SUCCEEDED";
	}
	
	/**
	 * ɾ��ָ���˵���ɼ���ɫ�Ĺ�����ϵ
	 * @return
	 * @throws Exception
	 */
	public String deleteMenuRoles(Transaction Sqlca) throws Exception{
		SqlObject asql = new SqlObject("DELETE FROM AWE_ROLE_MENU where MenuID = :MenuID").setParameter("MenuID", menuID);
		Sqlca.executeSQL(asql);
		return "SUCCEEDED";
	}
}
