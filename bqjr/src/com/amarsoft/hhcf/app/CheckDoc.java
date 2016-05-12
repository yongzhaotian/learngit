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

/**
 * @web.servlet name=CheckDoc
 * @category���ļ��������ӿ�
 * @author xswang
 * @since 2015/05/25
 */
public class CheckDoc extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:CheckDoc=========]:";

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
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");

		String SerialNo = request.getParameter("SerialNo");

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
		ResultSet rs = null;
		Statement st = null;
		try {
			int isNum = checkPass(SerialNo);
			if (isNum == 1) {// �ж��Ƿ���ڸ�ID
				st = conn.createStatement();
				sql = " select bc.contractserialno,bc.checkdocstatus,getitemname('CheckDocStatus', bc.checkdocstatus) as checkdocstatusname, "
						+ " eio.typeno,eit.typename, "
						+ " eio.opinion1,getitemname('Opinion',eio.opinion1) as opinion1value, "
						+ " eio.QualityMark1 as QualityMark1,eio.QualityMark2 as QualityMark2, "
						+ " eio.opinion2,getitemname('Opinion',eio.opinion2) as opinion2value, "
						+ " eio.remark as remark "
						+ " from Check_contract bc "
						+ " left join ecm_image_opinion eio on bc.contractserialno = eio.objectno "
						+ " left join ECM_IMAGE_TYPE eit on eio.typeno = eit.typeno "
						+ "where bc.contractserialno='"
						+ SerialNo
						+ "' and bc.checkdocstatus is not null and eio.opinion1 ='2' ";
				ARE.getLog().debug(OUT_PUT_LOG + "sql 1 :" + sql);
				rs = st.executeQuery(sql);
				while (rs.next()) {
					JSONObject jsonObject1 = new JSONObject();
					jsonObject1.put("SerialNo", rs.getString("contractserialno"));// ��ͬ��
					jsonObject1.put("CheckDocStatus",
							rs.getString("checkdocstatus"));// �ļ��������״̬
					jsonObject1.put("CheckDocStatusName",
							rs.getString("checkdocstatusname"));// �ļ��������״̬
					jsonObject1.put("TypeNo", rs.getString("typeno"));// Ӱ���������
					jsonObject1.put("TypeName", rs.getString("typename"));// Ӱ����������
					jsonObject1.put("Opinion1", rs.getString("opinion1"));// �������
					jsonObject1.put("Opinion1Value",
							rs.getString("opinion1value"));// �������
					jsonObject1.put("QualityMark1",
							rs.getString("QualityMark1"));// ����������ע
					jsonObject1.put("Opinion2", rs.getString("opinion2"));// �������
					jsonObject1.put("Opinion2Value",
							rs.getString("opinion2value"));// �������
					jsonObject1.put("QualityMark2",
							rs.getString("QualityMark2"));// ����������ע
					jsonObject1.put("Remark", rs.getString("remark"));// ��ע
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
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
	}

	// ��ѯ��ͬ���Ƿ����
	public int checkPass(String SerialNo) throws SQLException {
		int i = 0;
		String sql = "", sSerialNo = "";
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
				sSerialNo = rs.getString("contractserialno");
				if (!"".equals(sSerialNo)) {
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
