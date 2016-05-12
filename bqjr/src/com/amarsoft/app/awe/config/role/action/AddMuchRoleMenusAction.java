package com.amarsoft.app.awe.config.role.action;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 对角色批量配置菜单授权
 * @author xhgao
 *
 */
public class AddMuchRoleMenusAction {

	private String configType; //配置方式：1、增量配置,2、覆盖配置
	private String roleIDs;
	private String menuIDs;
	
	public String getConfigType() {
		return configType;
	}

	public void setConfigType(String configType) {
		this.configType = configType;
	}

	public String getRoleIDs() {
		return roleIDs;
	}

	public void setRoleIDs(String roleIDs) {
		this.roleIDs = roleIDs;
	}

	public String getMenuIDs() {
		return menuIDs;
	}

	public void setMenuIDs(String menuIDs) {
		this.menuIDs = menuIDs;
	}

	/**
	 * 根据配置方式，批量处理选择的角色、菜单关联关系
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String addMuchRoleMenus(Transaction Sqlca) throws Exception{
		
		try{
			String[] roleIDArray = roleIDs.split("@");
			String[] menuIDArray = menuIDs.split("@");
			if(configType.equals("1")){ //增量配置
				for(int i=0;i<roleIDArray.length;i++){
					for(int j=0;j<menuIDArray.length;j++){
						try{
							//先删除指定角色、指定菜单的关联关系
							SqlObject asql = new SqlObject("delete from AWE_ROLE_MENU where RoleID=:RoleID and MenuID=:MenuID");
							asql.setParameter("RoleID", roleIDArray[i]).setParameter("MenuID", menuIDArray[j]);
							Sqlca.executeSQL(asql);
							
							asql = new SqlObject("insert into AWE_ROLE_MENU(RoleID,MenuID) values(:RoleID,:MenuID)");
							asql.setParameter("RoleID", roleIDArray[i]).setParameter("MenuID", menuIDArray[j]);
							Sqlca.executeSQL(asql);
						}catch (Exception e) {
							ARE.getLog().error("增量方式批处理子系统、菜单关联关系失败！"+e.toString());
						}
					}
				}
			}else{ //覆盖配置
				for(int i=0;i<roleIDArray.length;i++){
					//先删除指定子系统的所有关联关系
					SqlObject asql = new SqlObject("delete from AWE_ROLE_MENU where RoleID=:RoleID");
					asql.setParameter("RoleID", roleIDArray[i]);
					Sqlca.executeSQL(asql);
					for(int j=0;j<menuIDArray.length;j++){
						try{
							asql = new SqlObject("insert into AWE_ROLE_MENU(RoleID,MenuID) values(:RoleID,:MenuID)");
							asql.setParameter("RoleID", roleIDArray[i]).setParameter("MenuID", menuIDArray[j]);
							Sqlca.executeSQL(asql);
						}catch (Exception e) {
							ARE.getLog().error("覆盖方式批处理子系统、菜单关联关系失败！"+e.toString());
						}
					}
				}
			}
			Sqlca.commit();
			return "SUCCEEDED";
		}catch (Exception e) {
			Sqlca.rollback();
			return "FAILED";
		}
	}
}
