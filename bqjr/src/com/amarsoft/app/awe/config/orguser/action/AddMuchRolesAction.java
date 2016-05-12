package com.amarsoft.app.awe.config.orguser.action;

import com.amarsoft.awe.security.SecurityAudit;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * ������Ա����,�����޸��û���ɫ
 * @author xhgao
 *
 */
public class AddMuchRolesAction {

	private String userID;
	private String usersID;
	private String rolesID;
	private String action;
	
	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getUsersID() {
		return usersID;
	}

	public void setUsersID(String usersID) {
		this.usersID = usersID;
	}

	public String getRolesID() {
		return rolesID;
	}

	public void setRolesID(String rolesID) {
		this.rolesID = rolesID;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	/**
	 * ִ�б���/ɾ��/���µȲ���,����¼�û���ɫ�����Ϣ
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String addMuchRoles(Transaction Sqlca) throws Exception{
		ASUser CurUser = ASUser.getUser(userID, Sqlca);
		//ִ�б���/ɾ��/���µȲ���,����¼�û���ɫ�����Ϣ
		String sReturn = SecurityAudit.logRoleChangeInfo(Sqlca, CurUser, usersID, rolesID, action);
		return sReturn;
	}
}
