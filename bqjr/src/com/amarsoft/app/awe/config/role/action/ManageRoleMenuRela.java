package com.amarsoft.app.awe.config.role.action;

import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 主菜单对角色授权处理
 * @author xhgao
 *
 */
public class ManageRoleMenuRela {

	//定义变量
	private String roleID; //角色编号
	private String menuID; //菜单编号
	private String relaValues=""; //关联属性值序列,定义为空串，防止该值为空时传递出错
	
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
	 * 管理角色的关联菜单
	 * @return
	 * @throws Exception 
	 */
	public String addRoleMenus(Transaction Sqlca) throws Exception{
		//先删除指定角色与菜单的关联
		SqlObject asql = new SqlObject("DELETE FROM AWE_ROLE_MENU WHERE RoleID = :RoleID").setParameter("RoleID", roleID);
		Sqlca.executeSQL(asql);
		
		if(relaValues != null){
			//再将新关联关系插入
			String[] menus = relaValues.split("@");
			for(int i=0; i<menus.length; i++){
				if(StringX.isSpace(menus[i])) continue; //有空字符串时不处理
				Sqlca.executeSQL(new SqlObject("INSERT INTO AWE_ROLE_MENU(RoleID,MenuID) values(:RoleID,:MenuID)").setParameter("RoleID", roleID).setParameter("MenuID", menus[i]));
			}
		}
		return "SUCCEEDED";
	}
	
	/**
	 * 管理菜单的可见角色
	 * @return
	 * @throws Exception 
	 */
	public String addMenuRoles(Transaction Sqlca) throws Exception{
		//删除指定菜单与角色的关联
		SqlObject asql = new SqlObject("DELETE FROM AWE_ROLE_MENU WHERE MenuID = :MenuID").setParameter("MenuID", menuID);
		Sqlca.executeSQL(asql);
		
		if(relaValues != null){
			//再将新关联关系插入
			String[] roles = relaValues.split("@");
			for(int i=0; i<roles.length; i++){
				if(StringX.isSpace(roles[i])) continue; //有空字符串时不处理
				Sqlca.executeSQL(new SqlObject("INSERT INTO AWE_ROLE_MENU(RoleID,MenuID) values(:RoleID,:MenuID)").setParameter("MenuID", menuID).setParameter("RoleID", roles[i]));
			}
		}
		return "SUCCEEDED";
	}
}
