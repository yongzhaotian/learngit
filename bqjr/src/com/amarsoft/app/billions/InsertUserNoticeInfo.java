package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 录入员工已阅公告信息记录表user_notice
 * @author huzp 
 * @date 2015-05-19
 */
public class InsertUserNoticeInfo {
	private String userID; //员工ID
	private String noticeId;//公告ID
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getNoticeId() {
		return noticeId;
	}
	public void setNoticeId(String noticeId) {
		this.noticeId = noticeId;
	}
	
	
	public void addUser_Notice(Transaction Sqlca) throws Exception {
		SqlObject  osql = null;
		String sql = "insert into USER_NOTICE ("
				+ "USERID,"
				+ "NOTICEID,"
				+ "ISFLAG"
				+ ") values ("
				+ getvalus(userID)+","
				+ getvalus(noticeId)+","
				+ "'1')"; //这里因为是做已阅添加，故ISFLAG字段默认为1
		osql = new SqlObject(sql);
		Sqlca.executeSQL(osql);
	}
	
	private String getvalus(String val){
		if(null==val){
			return val;
		}
		if("undefined".equals(val)){
			return null;
		}
		
		return  "'"+val+"'";
	}
}
