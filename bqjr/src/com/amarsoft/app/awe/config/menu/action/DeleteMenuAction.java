package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���˵�ɾ������ɾ���˵���¼��ͬʱɾ������������ϵͳ���ɼ���ɫ�Ĺ�����ϵ
 * @author xhgao
 *
 */
public class DeleteMenuAction {

	//�������
	private String menuID; //�˵����

	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	public String deleteMenuAndRela(Transaction Sqlca) throws Exception{
		
		DeleteMenuRela delMenuRela = new DeleteMenuRela();
		delMenuRela.setMenuID(menuID);
		
		//ɾ��ָ���˵���������ϵͳ�Ĺ�����ϵ
		//delMenuRela.deleteMenuApps(Sqlca);
		//ɾ��ָ���˵���ɼ���ɫ�Ĺ�����ϵ
		delMenuRela.deleteMenuRoles(Sqlca);
		
		//ɾ��ָ���˵���Ϣ
		Sqlca.executeSQL(new SqlObject("DELETE FROM AWE_MENU_INFO WHERE MenuID = :MenuID").setParameter("MenuID", menuID));
		
		return "SUCCEEDED";
	}
}
