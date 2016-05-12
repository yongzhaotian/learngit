package com.amarsoft.app.contentmanage.action;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
/**
 * 附件表相关操作: 查询、更新docId到附件表doc_attachment
 */
public class AttachmentTool {

	private String fileNetDocId;
	private String dataSource;
	private String docNo;
	private String attachmentNo;
	private Connection conn;
	
	public String getFileNetDocId() {
		return fileNetDocId;
	}
	public void setFileNetDocId(String fileNetDocId) {
		this.fileNetDocId = fileNetDocId;
	}
	public String getDataSource() {
		return dataSource;
	}
	public void setDataSource(String dataSource) {
		this.dataSource = dataSource;
	}
	public String getDocNo() {
		return docNo;
	}
	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}
	public String getAttachmentNo() {
		return attachmentNo;
	}
	public void setAttachmentNo(String attachmentNo) {
		this.attachmentNo = attachmentNo;
	}

	public String  fetchFileNetDocId(){
		String ret = "";
		getConn();
		if(conn==null) return ret;
		try{
			ResultSet rs = conn.createQuery("select fileNetDocId from  doc_attachment  where docNo=:docNo and attachmentNo=:attachmentNo")
				.setParameter("docNo", docNo).setParameter("attachmentNo", attachmentNo).getResultSet();
			if(rs.next()){
				ret = rs.getString("fileNetDocId");
				ARE.getLog().trace(ret);
			}
		}catch(SQLException e){
			ARE.getLog().error("更新filenetDocId出错");
		}
		try {
			ret = URLEncoder.encode(ret, "utf-8");
		} catch (UnsupportedEncodingException e) {
			ARE.getLog().error("转换为utf-8出错");
		}
		return ret;
	}
	
	public String updateFileNetDocId(){
		getConn();
		if(conn==null) return "FAILED";
		try{
			conn.createQuery("update doc_attachment set fileNetDocId=:fileNetDocId where docNo=:docNo and attachmentNo=:attachmentNo")
				.setParameter("fileNetDocId", fileNetDocId).setParameter("docNo", docNo)
				.setParameter("attachmentNo", attachmentNo).executeUpdate();
		}catch(SQLException e){
			ARE.getLog().error("更新filenetDocId出错");
			return "FAILED";
		}
		return "SUCCESS";
	}
	
	private void getConn(){
		try {
			conn = ARE.getDBConnection(dataSource);
		} catch (SQLException e) {
			ARE.getLog().error("ARE.getDBConn出错");
		}
	}
}
