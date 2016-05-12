package com.amarsoft.app.awe.config.orguser.action;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ������Ա����
 * @author xhgao
 */
public class UserManageAction {

	private String userID; //�û����
	
	private String orgID; //�����������
	
	/** CODE_LIBRARY.ITEMNO **/
	private String itemNO;
	
	private String userIdList;	// �û�ID list
	
	private String username;	// �û�����
	
	/**
	 * ������Ա����,�������û������������û�״̬
	 * @return SUCCESS
	 * @throws Exception
	 */
	public String addUser(Transaction Sqlca) throws Exception{
		
		SqlObject asql = new SqlObject("UPDATE USER_INFO set BelongOrg = :BelongOrg ,Status ='1' WHERE UserID = :UserID");
		asql.setParameter("BelongOrg", orgID).setParameter("UserID", userID);
		Sqlca.executeSQL(asql);
		
		return "SUCCESS";
	}
	
	/**
	 * �ӵ�ǰ������ͣ�ø���Ա
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String disableUser(Transaction Sqlca) throws Exception{
		//�߼�ɾ���û��������û�״̬��Ϊͣ��
		SqlObject asql = new SqlObject("UPDATE USER_INFO SET Status = '2' WHERE UserID = :UserID").setParameter("UserID", userID);
		Sqlca.executeSQL(asql);
		
		return "SUCCESS";
	}
	
	/**
	 * �ӵ�ǰ���������ø���Ա
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String enableUser(Transaction Sqlca) throws Exception {
		SqlObject asql = new SqlObject("UPDATE USER_INFO SET Status = '1' WHERE UserID = :UserID").setParameter("UserID", userID);
		Sqlca.executeSQL(asql);

		return "SUCCESS";
	}
	
	/**
	 * ����������Ա��Ϣ
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String enableUserList(Transaction transaction) throws Exception {
		
		String[] array = null;
		if (userIdList == null || "".equals(userIdList)) {
			return "������ѡ��һ���û���Ϣ��";
		} else {
			array = userIdList.split("\\|");
		}
		
		String sql = "UPDATE USER_INFO A SET A.STATUS = '1' WHERE A.USERID = :USERID";
		for (String str : array) {
			transaction.executeSQL(new SqlObject(sql).setParameter("USERID", str));
		}
		transaction.commit();
		
		return "SUCCESS";
	}
	
	/**
	 * ��ȡְλ����
	 * @param transaction
	 * @return
	 */
	public String getJobTitleName (Transaction transaction) {
		
		String sql = "SELECT ITEMNAME FROM CODE_LIBRARY WHERE CODENO = 'JobTitle' AND ITEMNO = :ITEMNO";
		String str = "";
		ASResultSet rs = null;
		try {
			rs = transaction.getASResultSet(new SqlObject(sql).setParameter("ITEMNO", itemNO));
			if (rs.next()) {
				str = rs.getString("ITEMNAME");
			}
			if (str == null || "".equals(str)) {
				str = itemNO;
			}
			return str;
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				transaction.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
				return "";
			}
			return "";
		} finally {
			if (rs != null) {
				try {
					rs.getStatement().close();
				} catch (SQLException e) {
					e.printStackTrace();
					return "";
				}
			}
		}
		
	}
	
	/**
	 * �ӵ�ǰ������ͣ�ø���Ա
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String suoUser(Transaction Sqlca) throws Exception{
		//�߼�ɾ���û��������û�״̬��Ϊͣ��
		SqlObject asql = new SqlObject("UPDATE USER_INFO SET Status = '0' WHERE UserID = :UserID").setParameter("UserID", userID);
		Sqlca.executeSQL(asql);
		
		return "SUCCESS";
	}
	
	/**
	 * �����û�ID��ȡ�û�����
	 * @param transaction
	 * @return
	 */
	public String judgeName(Transaction transaction) {
		
		String sql = "SELECT COUNT(1) AS CNT FROM USER_INFO WHERE TRIM(USERNAME) = TRIM(:USERNAME)";
		String count = "";
		ASResultSet rs = null;
		try {
			rs = transaction.getASResultSet(new SqlObject(sql).setParameter("USERNAME", username));
			if (rs.next()) {
				count = rs.getString("CNT");
				if (count == null || "".equals(count)) {
					count = "0";
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return "ERROR";
		}
		return count;
	}
	
	public String getUserID() {
		return userID;
	}
	
	public void setUserID(String userID) {
		this.userID = userID;
	}
	
	public String getOrgID() {
		return orgID;
	}
	
	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getItemNO() {
		return itemNO;
	}

	public void setItemNO(String itemNO) {
		this.itemNO = itemNO;
	}

	public String getUserIdList() {
		return userIdList;
	}

	public void setUserIdList(String userIdList) {
		this.userIdList = userIdList;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
}
