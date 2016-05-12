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
		if(initPwd == null) initPwd = "welcome!bqjr88"; //默认的初始化密码
		return initPwd;
	}
	public void setInitPwd(String initPwd) {
		this.initPwd = initPwd;
	}
	public String initPWD(Transaction Sqlca) {
		try{
			//对初始化密码进行MD5加密
			String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", initPwd);
			
			//将指定用户的密码更新为初始密码
			SqlObject asql = new SqlObject("update USER_INFO set Password = :Password where UserID = :UserID ");
			asql.setParameter("UserID", userID).setParameter("Password", sPassword);
			Sqlca.executeSQL(asql);
			
			return "SUCCESS";
		} catch (Exception e) {
			ARE.getLog().debug("初始密码失败！");
			return "FAILED";
		}
	}
}
