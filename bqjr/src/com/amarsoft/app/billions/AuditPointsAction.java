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
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;

public class AuditPointsAction extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String msgStr = "ERROR";
		String auditpointsNO = DBKeyUtils.getSerialNo();//��ˮ��
		String sFlowNo = request.getParameter("FlowNo");//���̱��
		String sPhaseNo = request.getParameter("PhaseNo");//�׶α��
		String sAuditPoints = request.getParameter("AuditPoints");//���Ҫ����Ϣ

		//String sUserId = request.getParameter("inputuser");//�����˱��
		//String sUserName = request.getParameter("inputusername");//����������

		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = ""; 
		
		// �������ݿ�����
		Connection conn = null;
		String dataSource = null;
		String insertSql = "";

		try {
			dataSource = Configure.getInstance().getDataSource();
			conn = ARE.getDBConnection(dataSource == null ? "als" : dataSource);
			PreparedStatement statement = null;
			insertSql = "insert into auditpoints(auditpointsNO,flowno,phaseno,auditpoints,filename,time) values('"
					+ auditpointsNO
					+ "','"
					+ sFlowNo
					+ "','"
					+ sPhaseNo
					+ "',?,'',to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')"
					+ ")";

			statement = conn.prepareStatement(insertSql);
			Reader clobReader = new StringReader(sAuditPoints); // �� textת������ʽ
			statement.setCharacterStream(1, clobReader, sAuditPoints.length());// �滻sql����еģ�

			int i =statement.executeUpdate();
			if(i>0){
				msgStr="SUCCESS";
				conn.commit();
			}
			System.out.println("sql1>>>>" + insertSql);
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
		
		PrintWriter out = response.getWriter();
		out.print(msgStr);
	}
}
