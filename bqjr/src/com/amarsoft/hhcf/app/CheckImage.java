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
 * @web.servlet name=CheckImage
 * @category���������ϼ��ӿ�
 * @author yongxu
 * @since 2015/05/25
 */
public class CheckImage extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======CheckImage=========]:";

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
	 * �ṩ��PAD�˶�Ӱ���ļ�����Ĵ����ļ����в���
	 *
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
				sql = " select cc.contractSerialNo,cc.checkstatus,getitemname('checkstatus', cc.checkstatus) as checkstatusname, "
						+ " cc.checkresult, getitemname('Opinion', cc.checkresult) as checkresultname, "
						+ " eio.typeno,eit.typename, "
						+ " eio.checkopinion1,getitemname('Opinion',eio.checkopinion1) as opinion1value, "
						+ " eio.QualityMarkLoan1, eio.QualityMarkLoan2, "
						+ " eio.checkopinion2,getitemname('Opinion',eio.checkopinion2) as opinion2value, "
						+ " eio.remark as remark "
						+ " from check_contract cc "
						+ " left join ecm_image_opinion eio on cc.contractserialno = eio.objectno "
						+ " left join ECM_IMAGE_TYPE eit on eio.typeno = eit.typeno "
						+ "where cc.contractserialno='"
						+ SerialNo +"' "
						+ " and cc.checkstatus is not null and (eio.checkopinion1 ='2' or eio.checkopinion1 = '3') and eio.checkopinion2 is null ";
				ARE.getLog().debug(OUT_PUT_LOG + "sql 1 :" + sql);
				rs = st.executeQuery(sql);
				while (rs.next()) {
					JSONObject jsonObject1 = new JSONObject();
					jsonObject1.put("SerialNo", rs.getString("contractSerialNo"));// ��ͬ��
					jsonObject1.put("CheckStatus",
							rs.getString("checkstatus"));// �������ϼ��״̬
					jsonObject1.put("CheckStatusName",
							rs.getString("checkstatusname"));// �������ϼ��״̬
					jsonObject1.put("CheckResult",
							rs.getString("checkresult"));// �������ϼ����
					jsonObject1.put("CheckResultName",
							rs.getString("checkresultname"));// �������ϼ����
					jsonObject1.put("ImageNo", rs.getString("typeno"));// Ӱ���������
					jsonObject1.put("ImageName", rs.getString("typename"));// Ӱ����������
					jsonObject1.put("Opinion1", rs.getString("checkopinion1"));// �������
					jsonObject1.put("Opinion1Value",
							rs.getString("opinion1value"));// �������
					jsonObject1.put("QualityMarkLoan1",
							rs.getString("QualityMarkLoan1"));// ����������ע
					jsonObject1.put("Opinion2", rs.getString("checkopinion2"));// �������
					jsonObject1.put("Opinion2Value",
							rs.getString("opinion2value"));// �������
					jsonObject1.put("QualityMarkLoan2",
							rs.getString("QualityMarkLoan2"));// ����������ע
					jsonObject1.put("Remark",
							rs.getString("remark"));// ��ע
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
