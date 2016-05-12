package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
/**
 * 
 * @author daihuafeng 20150731 
 * 获取UserID的SaleManager、CityManager
 *
 */
public class GetSaleManagerCityManager extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:GetSaleManagerCityManager=========]:";

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");
		ARE.getLog().debug(OUT_PUT_LOG + "do post begin");
		String sUserID = request.getParameter("userID");
		ARE.getLog().debug(OUT_PUT_LOG + "input parameter 1:" + sUserID);

		JSONObject jsonObject = new JSONObject();
		Connection conn = null;
		Statement st = null,st2 = null,st3 = null;
		ResultSet rs = null,rs2 = null,rs3 = null;
		//判断用户自己是否销售经理
		String sql = "select getUserName('"+sUserID+"') as saleManagerName from STORE_INFO "
				+ " where identType='01' and status='05' and salesmanager='"+sUserID+"'";
		//查询用户(不是销售经理时)的销售经理
		String sql2 = "Select distinct si.salesmanager as saleManagerNo, "
				+ " getUserName(si.salesmanager) as saleManagerName "
                + " from STORERELATIVESALESMAN a,STORE_INFO si "
                + " where si.identType = '01' and si.Status='05' and a.stype is null "
                + " and a.sno=si.sno and a.SalesManNo = '"+sUserID+"'";
		ARE.getLog().debug(OUT_PUT_LOG + "sql:" + sql);
		ARE.getLog().debug(OUT_PUT_LOG + "sql2:" + sql2);
		
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (SQLException e) {
			ARE.getLog().error("获得config的配置出错", e);
		}
		//获取销售经理、城市经理
		try {
			st = conn.createStatement();
			rs = st.executeQuery(sql);
			//判断用户自己是否销售经理
			if(rs.next()){//是
				jsonObject.put("saleManagerNo", sUserID);
				jsonObject.put("saleManagerName", rs.getString("saleManagerName"));
			}else{//否
				st2 = conn.createStatement();
				rs2 = st.executeQuery(sql2);
				//查询用户的销售经理
				if(rs2.next()){
					String saleManagerNo = rs2.getString("saleManagerNo");
					saleManagerNo = (saleManagerNo == null ? "" : saleManagerNo);
					jsonObject.put("saleManagerNo", saleManagerNo);
					jsonObject.put("saleManagerName", rs2.getString("saleManagerName"));
					//查询用户的城市经理
					st3 = conn.createStatement();
					String sql3 = " select SuperID,getUserName(SuperID) as SuperName from user_info "
							+ " where userid='"+saleManagerNo+"'";
					ARE.getLog().debug(OUT_PUT_LOG + "sql3:" + sql3);
					rs3 = st3.executeQuery(sql3);
					if (rs3.next()){
						jsonObject.put("cityManager", rs3.getString("SuperID"));
						jsonObject.put("cityManagerName", rs3.getString("SuperName"));
					}
				}
			}
			
			ARE.getLog().debug(OUT_PUT_LOG + "output parameter :" + jsonObject.toString());
			response.getWriter().write(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				if(rs != null){
					rs.close();
					rs = null;
				}
				if(st != null){
					st.close();
					st = null;
				}
				if(rs2 != null){
					rs2.close();
					rs2 = null;
				}
				if(st2 != null){
					st2.close();
					st2 = null;
				}
				if(rs3 != null){
					rs3.close();
					rs3 = null;
				}
				if(st3 != null){
					st3.close();
					st3 = null;
				}
				if(conn != null){
					conn.close();
					conn = null;
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

}
