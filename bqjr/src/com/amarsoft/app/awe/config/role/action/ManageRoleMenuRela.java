package com.amarsoft.app.awe.config.role.action;

import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���˵��Խ�ɫ��Ȩ����
 * @author xhgao
 *
 */
public class ManageRoleMenuRela {

	//�������
	private String roleID; //��ɫ���
	private String menuID; //�˵����
	private String relaValues=""; //��������ֵ����,����Ϊ�մ�����ֹ��ֵΪ��ʱ���ݳ���
	
	public String getRoleID() {
		return roleID;
	}

	public void setRoleID(String roleID) {
		this.roleID = roleID;
	}

	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	public String getRelaValues() {
		return relaValues;
	}

	public void setRelaValues(String relaValues) {
		this.relaValues = relaValues;
	}

	/**
	 * �����ɫ�Ĺ����˵�
	 * @return
	 * @throws Exception 
	 */
	public String addRoleMenus(Transaction Sqlca) throws Exception{
		//��ɾ��ָ����ɫ��˵��Ĺ���
		SqlObject asql = new SqlObject("DELETE FROM AWE_ROLE_MENU WHERE RoleID = :RoleID").setParameter("RoleID", roleID);
		Sqlca.executeSQL(asql);
		
		if(relaValues != null){
			//�ٽ��¹�����ϵ����
			String[] menus = relaValues.split("@");
			for(int i=0; i<menus.length; i++){
				if(StringX.isSpace(menus[i])) continue; //�п��ַ���ʱ������
				Sqlca.executeSQL(new SqlObject("INSERT INTO AWE_ROLE_MENU(RoleID,MenuID) values(:RoleID,:MenuID)").setParameter("RoleID", roleID).setParameter("MenuID", menus[i]));
			}
		}
		return "SUCCEEDED";
	}
	
	/**
	 * ����˵��Ŀɼ���ɫ
	 * @return
	 * @throws Exception 
	 */
	public String addMenuRoles(Transaction Sqlca) throws Exception{
		//ɾ��ָ���˵����ɫ�Ĺ���
		SqlObject asql = new SqlObject("DELETE FROM AWE_ROLE_MENU WHERE MenuID = :MenuID").setParameter("MenuID", menuID);
		Sqlca.executeSQL(asql);
		
		if(relaValues != null){
			//�ٽ��¹�����ϵ����
			String[] roles = relaValues.split("@");
			for(int i=0; i<roles.length; i++){
				if(StringX.isSpace(roles[i])) continue; //�п��ַ���ʱ������
				Sqlca.executeSQL(new SqlObject("INSERT INTO AWE_ROLE_MENU(RoleID,MenuID) values(:RoleID,:MenuID)").setParameter("MenuID", menuID).setParameter("RoleID", roles[i]));
			}
		}
		return "SUCCEEDED";
	}
}
