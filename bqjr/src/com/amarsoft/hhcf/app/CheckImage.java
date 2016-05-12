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
 * @category：贷后资料检查接口
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
	 * 提供给PAD端对影像文件检查后的错误文件进行补充
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
					jsonObject1.put("SerialNo", rs.getString("contractSerialNo"));// 合同号
					jsonObject1.put("CheckStatus",
							rs.getString("checkstatus"));// 贷后资料检查状态
					jsonObject1.put("CheckStatusName",
							rs.getString("checkstatusname"));// 贷后资料检查状态
					jsonObject1.put("CheckResult",
							rs.getString("checkresult"));// 贷后资料检查结果
					jsonObject1.put("CheckResultName",
							rs.getString("checkresultname"));// 贷后资料检查结果
					jsonObject1.put("ImageNo", rs.getString("typeno"));// 影像资料序号
					jsonObject1.put("ImageName", rs.getString("typename"));// 影像资料名称
					jsonObject1.put("Opinion1", rs.getString("checkopinion1"));// 初审意见
					jsonObject1.put("Opinion1Value",
							rs.getString("opinion1value"));// 初审意见
					jsonObject1.put("QualityMarkLoan1",
							rs.getString("QualityMarkLoan1"));// 初审质量标注
					jsonObject1.put("Opinion2", rs.getString("checkopinion2"));// 复审意见
					jsonObject1.put("Opinion2Value",
							rs.getString("opinion2value"));// 复审意见
					jsonObject1.put("QualityMarkLoan2",
							rs.getString("QualityMarkLoan2"));// 复审质量标注
					jsonObject1.put("Remark",
							rs.getString("remark"));// 备注
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
