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
import com.amarsoft.hhcf.app.FinalNum;

/**
 * @web.servlet name=UpdateCheckResult
 * @category： 超期未上传贷后资料处理接口
 * @author yongxu
 * @since 2015/07/15
 */
public class UpdateCheckResult extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======UpdateCheckResult=========]:";
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
	 * PAD端贷后资料超期未如果超期未上传即调用该接口
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");

		String SerialNo = request.getParameter("SerialNo");

		ARE.getLog().debug(OUT_PUT_LOG + "doPost begin ");
		JSONObject jsonObject2 = new JSONObject();
		JSONArray jsonArray = new JSONArray();

		// 创建数据库连接
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("获得config的配置出错", e);
		}
		Statement st = null;
		try {
			int isNum = checkPass(SerialNo);
			if (isNum == 1) {// 判断是否存在该ID
				st = conn.createStatement();
				String sVoerdueStatus = getUploadStatusWhenOverdue(SerialNo);
				String sql = " update check_contract set checkResult2 = '"
						+ sVoerdueStatus + "' where contractserialno = '" + SerialNo
						+ "'";
				ARE.getLog().debug(OUT_PUT_LOG + "sql 1 :" + sql);
				int count = st.executeUpdate(sql);
				if (count > 0) {
					JSONObject jsonObject1 = new JSONObject();
					jsonObject1.put("UpdateResult", "Success");// 合同号
					jsonArray.add(jsonObject1);
				}
				jsonObject2.element("data", jsonArray);
				System.out.println("----------------------------->"
						+ jsonObject2.toString());
				ARE.getLog().debug(
						OUT_PUT_LOG + "output parameter :" + jsonObject2);
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
		} catch (Exception e) {
			// TODO Auto-generated catch block
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

	/*
	 * 根据商品类型查询超期未上传贷后资料后的合同状态
	 */
	public String getUploadStatusWhenOverdue(String sObjectNo) {
		String sOverdueStatus = "";
		// 创建数据库连接
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("获得config的配置出错", e);
		}
		Statement statement = null;
		try {
			// 多个商品子类型可能会配置多个超期未上传状态，若同一合同有多个商品子类型，暂只取第一个
			ResultSet rs = null;
			statement = conn.createStatement();
			String selProductIDSql = "Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID "
					+ " from business_contract where serialno = '"
					+ sObjectNo
					+ "'";
			rs = statement.executeQuery(selProductIDSql);
			String sProductIDs = "";
			String selOverdueStatusSql = "";
			if (rs.next()) {
				sProductIDs = rs.getString("ProductID");
				if (sProductIDs != null && sProductIDs.trim() != "") {
					selOverdueStatusSql = "select OVERDUESTATUS from product_ecm_upload where PRODUCT_TYPE_ID in ("
							+ sProductIDs + ")";
				}
				rs = statement.executeQuery(selOverdueStatusSql);
				if (rs.next()) {
					sOverdueStatus = rs.getString("OVERDUESTATUS");
				}
			}
			rs.close();
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
		return sOverdueStatus;
	}

	// 查询合同记录是否存在
	public int checkPass(String SerialNo) throws SQLException {
		int i = 0;
		String sql = "";
		// 创建数据库连接
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("获得config中的datasource配置出错", e);
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
