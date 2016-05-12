package com.amarsoft.app.als.process.util;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * �û�����
 * <p>
 * ��������ʹ��,������;������ʹ�á� ��������һ���û���ӦΨһ��������������һ���û���Ӧ���������
 * </p>
 * 
 * @author zszhang
 * 
 */
public class PSUserObject {
	private static final long serialVersionUID = 1L;
	private String userID; // �û����
	private String userName; // �û�����
	private String orgID; // �������
	private String status; // �û�״̬
	private String password; // �û�����
	private PSOrgObject belongOrg; // �û�������������

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
		if (getBelongOrg() != null) {
			return getBelongOrg().getOrgName();
		} else {
			return "";
		}
	}

	public String getOrgSortNo() {
		if (getBelongOrg() != null) {
			return getBelongOrg().getSortNo();
		} else {
			return "";
		}
	}

	public String getOrgLevel() {
		if (getBelongOrg() != null) {
			return getBelongOrg().getOrgLevel();
		} else {
			return "";
		}
	}

	public String getParentOrgID() {
		if (getBelongOrg() != null) {
			return getBelongOrg().getParentOrgID();
		} else {
			return "";
		}
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

	public PSOrgObject getBelongOrg() {
		return belongOrg;
	}

	public void setBelongOrg(PSOrgObject belongOrg) {
		this.belongOrg = belongOrg;
	}

	private PSUserObject(String userID) {
		this.userID = userID;
	}

	/**
	 * ����UserID�򵥹����û��������ڳ�����ȡ���û��������ԡ�
	 * 
	 * @param userID
	 * @return PSUserObject
	 * @throws Exception
	 */
	static public PSUserObject getUser(String userID) throws Exception {

		// �����û�����
		PSUserObject user = new PSUserObject(userID);

		// �жϴ���userID�Ƿ�Ϊ��,���򷵻�һ���յ��û�����
		if ("".equals(userID) || userID == null) {
			ARE.getLog().warn("��ǰ�����û�Ϊ�գ�");
			user.setUserID(userID);
			return user;
		}

		// �жϴ����useID�����Ƿ��������û���
		// ������û�����@�ָ�����@test11@test12@��������û�����ȥ�ָ������test11
		if (userID.split(",").length > 2) {
			userID = userID.replace(",", "@");
			ARE.getLog().warn("��ǰ���ڶ��û�[" + userID + "]��");
		} else {
			userID = userID.replace(",", "");

			// �����û�����
			try {
				BizObjectQuery q = JBOFactory.getFactory().getManager(
						"jbo.sys.USER_INFO").createQuery(
						"UserID = :UserID and Status = :Status");
				q.setParameter("UserID", userID);
				q.setParameter("Status", "1");
				BizObject bo = q.getSingleResult(false);
				if (bo != null) {
					user.setUserID(bo.getAttribute("UserID").getString());
					user.setUserName(bo.getAttribute("UserName").getString());
					user.setOrgID(bo.getAttribute("BelongOrg").getString());
					user.setStatus(bo.getAttribute("Status").getString());
					user.setPassword(bo.getAttribute("Password").getString());
					user.setBelongOrg(new PSOrgObject(bo.getAttribute(
							"BelongOrg").getString()));
				} else if ("als".equals(userID) || "system".equals(userID)) {
					PSOrgObject belongOrg = new PSOrgObject();
					belongOrg.setOrgID("system");
					belongOrg.setOrgName("system");
					user.setBelongOrg(belongOrg);
					user.setUserID("system");
					user.setUserName("system");
				} else {
					ARE.getLog().warn("�û�[" + userID + "]�����ݿ��в����ڣ�");
				}
			} catch (Exception e) {
				ARE.getLog().error("ʵ�����û�����[" + userID + "]�쳣��", e);
			}
		}
		return user;
	}
}
