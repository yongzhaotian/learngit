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
		String updateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// ��ǰϵͳʱ��(����ʱ��)
		String noticeDate = request.getParameter("noticeDate");
		String visibleRole = request.getParameter("visibleRole"); //add by binyang CCS-1252 ������ �ӿɼ���ɫ�ֶ�
		
		// �������ݿ�����
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
			// PreparedStatement֧��SQL�����ʺţ������Զ�̬�滻�������ݡ�
			Reader clobReader = new StringReader(noticeContent); // �� textת������ʽ
			statement.setCharacterStream(1, clobReader, noticeContent.length());// �滻sql����еģ�

			int i =statement.executeUpdate();
			if(i>0){
				msgStr="SUCCESS";
			}
			System.out.println("sql1>>>>" + insertSql);
			
	//		response.sendRedirect(request.getContextPath() + "/Common/WorkFlow/NoticeList.jsp");
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error("���config�е�datasource���ó���", e);
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
		String updateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// ��ǰϵͳʱ��(����ʱ��)
		String visibleRole = request.getParameter("visibleRole"); //add by binyang CCS-1252 ������ �ӿɼ���ɫ�ֶ�
		// �������ݿ�����
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
