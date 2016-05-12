package com.amarsoft.app.util;

import java.io.Serializable;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;


/** ��JBO���ɵ��û����� */
public class ASUserObject implements Serializable{
	private static final long serialVersionUID = 1L;
	private String userID;//�û����
	private String userName;//�û�����
	private String orgID;//�������
	private String status;//�û�״̬
	private String password;//�û�����
	private String belongLOB = null;
	private ASOrgObject belongOrg;//�û���������
	
	/**
	 * ȡ��ǰ�û����ڻ����ĺ��Ļ�����
	 * @return
	 */
	public String getMainFrameOrgID() {
		return getBelongOrg().getMainFrameOrgID();
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getOrgName() {
		return getBelongOrg().getOrgName();
	}

	public String getOrgSortNo() {
		return getBelongOrg().getSortNo();
	}

	public String getOrgLevel() {
		return getBelongOrg().getOrgLevel();
	}

	public String getRelativeOrgID() {
		return getBelongOrg().getRelativeOrgID();
	}
	
	public String getBelongOrgID() {
		return getBelongOrg().getBelongOrgID();
	}
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getBelongLOB() {
		return belongLOB;
	}

	public void setBelongLOB(String belongLOB) {
		this.belongLOB = belongLOB;
	}

	public ASOrgObject getBelongOrg() {
		return belongOrg;
	}

	public void setBelongOrg(ASOrgObject belongOrg) {
		this.belongOrg = belongOrg;
	}

	private ASUserObject(String sUserID) {
		this.userID = sUserID;
	}

	/**
	 * ����UserID�򵥹����û��������ڳ�����ȡ���û���������
	 * @param sUserID
	 * @param transSql
	 * @return
	 * @throws Exception
	 */
	static public ASUserObject getUser(String sUserID) throws Exception {
		ASUserObject user = new ASUserObject(sUserID);
		try {
			BizObjectQuery q = JBOFactory.getFactory().getManager("jbo.sys.USER_INFO").createQuery("UserID = :UserID and Status = :Status");
			q.setParameter("UserID", sUserID).setParameter("Status", "1");
			BizObject bo = q.getSingleResult();
			if (bo != null) {
				user.setUserName(bo.getAttribute("UserName").getString());
				user.setOrgID(bo.getAttribute("BelongOrg").getString());
				user.setStatus(bo.getAttribute("Status").getString());
				user.setPassword(bo.getAttribute("Password").getString());
				user.setBelongOrg(new ASOrgObject(bo.getAttribute("BelongOrg").getString()));
			} else {
				ARE.getLog().warn("�û�["+sUserID+"]�����ݿ��в����ڣ�");
			}
		} catch (Exception e) {
			ARE.getLog().error("ʵ�����û�����["+sUserID+"]�쳣��",e);
		}
		return user;
	}
	
	public boolean hasRole(String sRoleID) throws Exception {
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.sys.USER_ROLE") ;
		BizObjectQuery boq = bom.createQuery("UserID=:UserID and RoleID=:RoleID and Status='1'");
		BizObject bo = boq.setParameter("UserID", userID).setParameter("RoleID", sRoleID).getSingleResult(false);
		if (bo != null) {
			return true ;
		}else{
			return false ;
		}
	}
}