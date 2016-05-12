package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.are.util.StringFunction;

/**
 * @web.servlet name=UpdateCheckDocStatus
 * @category���ļ��������״̬���½ӿ�
 * @author xswang
 * @since 2015/06/18
 */
public class UpdateCheckDocStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======UpdateUploadStatus=========]:";

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */

	/*
	 * �ṩ��PAD�˶����ļ���������д��󲹳����Ϻ�����ļ��������״̬�Ը�ע�Ჿ���и���
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");

		String serialNo = request.getParameter("SerialNo");
		String sCheckDocStatus = "";
		String sTime = StringFunction.getTodayNow();
		ResultSet rs = null;

		ARE.getLog().debug(OUT_PUT_LOG + "doPost begin ");
		JSONObject jsonObject2 = new JSONObject();
		JSONArray jsonArray = new JSONArray();

		String sql = "";
		// �������ݿ�����
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("���config�����ó���", e);
		}
		Statement st = null;
		try {
			int isNum = checkPass(serialNo);
			if (isNum == 1) {// �ж��Ƿ���ڸ�ID
				st = conn.createStatement();
				rs = st.executeQuery(" select CheckDocStatus from Check_contract where contractserialno = '"
						+ serialNo + "' ");
				while (rs.next()) {
					sCheckDocStatus = rs.getString("CheckDocStatus");
				}
				if ("4".equals(sCheckDocStatus)) {// ���״̬Ϊ���������ϡ�
					sql = " update Check_contract set CheckDocStatus = '6',adddocendtime = '"
							+ sTime + "' where contractserialno = '" + serialNo + "'";
				}
				ARE.getLog().debug(OUT_PUT_LOG + "sql 1 :" + sql);
				int count = st.executeUpdate(sql);
				if (count > 0) {
					JSONObject jsonObject1 = new JSONObject();
					jsonObject1.put("UpdateResult", "Success");// ����״̬�ɹ�
					jsonArray.add(jsonObject1);
				}
				jsonObject2.element("data", jsonArray);
				System.out.println("----------------------------->"
						+ jsonObject2.toString());
				ARE.getLog().debug(
						OUT_PUT_LOG + "output parameter :" + jsonObject2);
				rs.close();
				st.close();
				response.getWriter().write(jsonObject2.toString());
				response.getWriter().flush();
				response.getWriter().close();
			} else {
				jsonObject2.element("data", "[{}]");
				response.getWriter().write(jsonObject2.toString());
				response.getWriter().flush();
				response.getWriter().close();
			}
			conn.commit();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
					//rs.getStatement().close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
	}

	// ��ѯ��ͬ��¼�Ƿ����
	public int checkPass(String SerialNo) throws SQLException {
		int i = 0;
		String sql = "";
		// �������ݿ�����
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("���config�е�datasource���ó���", e);
		}

		try {
			ResultSet rs = null;
			Statement statement = conn.createStatement();

			sql = "select contractserialno from check_contract where contractserialno='"
					+ SerialNo + "' ";
			rs = statement.executeQuery(sql);
			while (rs.next()) {
				SerialNo = rs.getString("contractserialno");
				if (!"".equals(SerialNo)) {
					i = 1;
				}
			}
			rs.close();
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
		return i;
	}

}
