package com.amarsoft.app.awe.config.role.action;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �Խ�ɫ�������ò˵���Ȩ
 * @author xhgao
 *
 */
public class AddMuchRoleMenusAction {

	private String configType; //���÷�ʽ��1����������,2����������
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
	 * �������÷�ʽ����������ѡ��Ľ�ɫ���˵�������ϵ
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String addMuchRoleMenus(Transaction Sqlca) throws Exception{
		
		try{
			String[] roleIDArray = roleIDs.split("@");
			String[] menuIDArray = menuIDs.split("@");
			if(configType.equals("1")){ //��������
				for(int i=0;i<roleIDArray.length;i++){
					for(int j=0;j<menuIDArray.length;j++){
						try{
							//��ɾ��ָ����ɫ��ָ���˵��Ĺ�����ϵ
							SqlObject asql = new SqlObject("delete from AWE_ROLE_MENU where RoleID=:RoleID and MenuID=:MenuID");
							asql.setParameter("RoleID", roleIDArray[i]).setParameter("MenuID", menuIDArray[j]);
							Sqlca.executeSQL(asql);
							
							asql = new SqlObject("insert into AWE_ROLE_MENU(RoleID,MenuID) values(:RoleID,:MenuID)");
							asql.setParameter("RoleID", roleIDArray[i]).setParameter("MenuID", menuIDArray[j]);
							Sqlca.executeSQL(asql);
						}catch (Exception e) {
							ARE.getLog().error("������ʽ��������ϵͳ���˵�������ϵʧ�ܣ�"+e.toString());
						}
					}
				}
			}else{ //��������
				for(int i=0;i<roleIDArray.length;i++){
					//��ɾ��ָ����ϵͳ�����й�����ϵ
					SqlObject asql = new SqlObject("delete from AWE_ROLE_MENU where RoleID=:RoleID");
					asql.setParameter("RoleID", roleIDArray[i]);
					Sqlca.executeSQL(asql);
					for(int j=0;j<menuIDArray.length;j++){
						try{
							asql = new SqlObject("insert into AWE_ROLE_MENU(RoleID,MenuID) values(:RoleID,:MenuID)");
							asql.setParameter("RoleID", roleIDArray[i]).setParameter("MenuID", menuIDArray[j]);
							Sqlca.executeSQL(asql);
						}catch (Exception e) {
							ARE.getLog().error("���Ƿ�ʽ��������ϵͳ���˵�������ϵʧ�ܣ�"+e.toString());
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
