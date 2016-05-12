package com.amarsoft.app.awe.config.orguser.action;

import com.amarsoft.are.ARE;
import com.amarsoft.are.security.MessageDigest;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class ClearPasswordAction {
	
	private String userID;
	private String initPwd;
	
    public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	
	public String getInitPwd() {
		if(initPwd == null) initPwd = "welcome!bqjr88"; //Ĭ�ϵĳ�ʼ������
		return initPwd;
	}
	public void setInitPwd(String initPwd) {
		this.initPwd = initPwd;
	}
	public String initPWD(Transaction Sqlca) {
		try{
			//�Գ�ʼ���������MD5����
			String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", initPwd);
			
			//��ָ���û����������Ϊ��ʼ����
			SqlObject asql = new SqlObject("update USER_INFO set Password = :Password where UserID = :UserID ");
			asql.setParameter("UserID", userID).setParameter("Password", sPassword);
			Sqlca.executeSQL(asql);
			
			return "SUCCESS";
		} catch (Exception e) {
			ARE.getLog().debug("��ʼ����ʧ�ܣ�");
			return "FAILED";
		}
	}
}
