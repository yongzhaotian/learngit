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

public class DocAuditPointsAction extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String msgStr = "ERROR";
		//String auditpointsNO = DBKeyUtils.getSerialNo();// 流水号
		String typeNo = request.getParameter("TypeNo");//
		String sAuditPoints = request.getParameter("AuditPoints");// 审核要点信息
		String addTime =DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");// 当前系统时间(更新时间)

		if (typeNo == null) typeNo = "";

		// 创建数据库连接
		Connection conn = null;
		String dataSource = null;
		String updateSql = "";
		try {
			dataSource = Configure.getInstance().getDataSource();
			conn = ARE.getDBConnection(dataSource == null ? "als" : dataSource);
			PreparedStatement statement = null;
			updateSql = "UPDATE ecm_image_type SET AUDITPOINTS='"+sAuditPoints+"',ADDTIME='"+addTime+"' WHERE TYPENO='" + typeNo+"'";
			statement = conn.prepareStatement(updateSql);
			int i = statement.executeUpdate(updateSql);
			if (i > 0) {
				msgStr = "SUCCESS";
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

		PrintWriter out = response.getWriter();
		out.print(msgStr);
	}
}
