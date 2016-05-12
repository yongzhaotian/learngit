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
 * @web.servlet name=ContractStatus
 * @category：合同状态接口
 * @author xswang
 * @since 2015/05/25
 */
public class ContractStatus extends HttpServlet {
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
		// 创建数据库连接
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("获得config的配置出错", e);
		}
		ResultSet rs = null;
		Statement st = null;
		try {
			int isNum = checkPass(SerialNo);
			if (isNum == 1) {// 判断是否存在该ID
				st = conn.createStatement();
				sql = " select bc.serialno,bc.contractstatus,getitemname('ContractStatus', bc.contractstatus) as contractstatusname," +
						" cc.checkdocstatus,getitemname('CheckDocStatus', cc.checkdocstatus) as checkdocstatusname "+ 
						" from business_contract bc "+ 
						" left join check_contract cc on bc.serialno = cc.contractserialno "+
						" where bc.serialno='"+ SerialNo+ "'";
				ARE.getLog().debug(OUT_PUT_LOG + "sql 1 :" + sql);
				rs = st.executeQuery(sql);
				while (rs.next()) {
					JSONObject jsonObject1 = new JSONObject();
					jsonObject1.put("SerialNo", rs.getString("serialno"));// 合同号
					jsonObject1.put("ContractStatus",
							rs.getString("contractstatus"));// 合同状态
					jsonObject1.put("ContractStatusName",
							rs.getString("contractstatusname"));// 合同状态
					jsonObject1.put("CheckDocStatus",
							rs.getString("checkdocstatus"));// 文件质量检查状态
					jsonObject1.put("CheckDocStatusName",
							rs.getString("checkdocstatusname"));// 文件质量检查状态
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

	// 查询用户是否正确
	public int checkPass(String SerialNo) throws SQLException {
		int i = 0;
		String sql = "", sContractStatus = "";
		// 创建数据库连接
		Connection conn = null;
		String dataSource = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("获得config中的datasource配置出错", e);
		}

		try {
			ResultSet rs = null;
			Statement statement = conn.createStatement();

			sql = "select contractstatus from business_contract where serialno='" + SerialNo + "' ";
			rs = statement.executeQuery(sql);
			while (rs.next()) {
				sContractStatus = rs.getString("contractstatus");
				if (!"".equals(sContractStatus)) {
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
