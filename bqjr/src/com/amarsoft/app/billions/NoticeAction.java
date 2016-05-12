package com.amarsoft.app.billions;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;

public class NoticeAction extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		String noticeId = request.getParameter("noticeId");
		String msgStr = "";
		if(noticeId.equals("")){
			msgStr = insertNotice(noticeId,request,response);
		}else {
			msgStr = updateNotice(noticeId,request,response);
		}
		PrintWriter out = response.getWriter();
		out.print(msgStr);
	}
	
	protected String insertNotice(String noticeId,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String noticeTitle = request.getParameter("noticeTitle");
		String noticePeopleId = request.getParameter("noticePeopleId");
		String noticeContent = request.getParameter("noticeContent");
		String inputOrgId = request.getParameter("inputOrgId");
		String updateUserId = request.getParameter("updateUserId");
		String updateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// 当前系统时间(更新时间)
		String noticeDate = request.getParameter("noticeDate");
		String visibleRole = request.getParameter("visibleRole"); //add by binyang CCS-1252 公告栏 加可见角色字段
		
		// 创建数据库连接
		Connection conn = null;
		String dataSource = null;
		String insertSql = "";
		String msgStr="ERROR";

		try {
			dataSource = Configure.getInstance().getDataSource();
			conn = ARE.getDBConnection(dataSource == null ? "als" : dataSource);
			PreparedStatement statement = null;
			if (noticeId.equals("")) {
				noticeId = DBKeyUtils.getSerialNo();
			}
			insertSql = "insert into NOTICE_INFO (NOTICEID,NOTICETITLE,NOTICEPEOPLE,NOTICECONTENT,INPUTORG,UPDATEUSER,noticeDate,updateTime,VISIBLEROLE) values ("
					+ getvalus(noticeId)
					+ ","
					+ getvalus(noticeTitle)
					+ ","
					+ getvalus(noticePeopleId)
					+ ",?"
					+ ","
					+ getvalus(inputOrgId)
					+ ","
					+ getvalus(updateUserId)
					+ ","
					+ getvalus(noticeDate)
					+ ","
					+ getvalus(updateTime)
					+ ","
					+ getvalus(visibleRole)
					+ ")";
			statement = conn.prepareStatement(insertSql);
			// PreparedStatement支持SQL带有问号？，可以动态替换？的内容。
			Reader clobReader = new StringReader(noticeContent); // 将 text转成流形式
			statement.setCharacterStream(1, clobReader, noticeContent.length());// 替换sql语句中的？

			int i =statement.executeUpdate();
			if(i>0){
				msgStr="SUCCESS";
			}
			System.out.println("sql1>>>>" + insertSql);
			
	//		response.sendRedirect(request.getContextPath() + "/Common/WorkFlow/NoticeList.jsp");
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error("获得config中的datasource配置出错", e);
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return msgStr;
	}
	
	protected String updateNotice(String noticeId,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String noticeTitle = request.getParameter("noticeTitle");
		String noticeContent = request.getParameter("noticeContent");
		String updateUserId = request.getParameter("updateUserId");
		String updateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// 当前系统时间(更新时间)
		String visibleRole = request.getParameter("visibleRole"); //add by binyang CCS-1252 公告栏 加可见角色字段
		// 创建数据库连接
		Connection conn = null;
		String dataSource = null;
		String updateSql = "";
		String msgStr="ERROR";
		try {
			dataSource = Configure.getInstance().getDataSource();
			conn = ARE.getDBConnection(dataSource == null ? "als" : dataSource);
			PreparedStatement statement = null;
			updateSql = "update NOTICE_INFO t  set t.noticetitle='"
					+ noticeTitle + "' , t.noticecontent='" + noticeContent
					+ "',t.updateuser='" + updateUserId + "',t.updatetime='"
					+ updateTime + "',t.visiblerole='"+visibleRole+"' where t.noticeid='" + noticeId + "'";
			statement = conn.prepareStatement(updateSql);
			int i =statement.executeUpdate(updateSql);
			if(i>0){
				msgStr="SUCCESS";
			}
			System.out.println("sql2>>>>" + updateSql);
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return msgStr;
	}

	private String getvalus(String val) {
		if (null == val) {
			return val;
		}
		if ("undefined".equals(val)) {
			return null;
		}

		return "'" + val + "'";
	}

}
