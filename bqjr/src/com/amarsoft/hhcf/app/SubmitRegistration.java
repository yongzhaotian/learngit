package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * Servlet implementation class SubmitRegistration
 */
public class SubmitRegistration extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:SubmitRegistration=========]:";
  
   
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");
		
		String sSerialNo =  request.getParameter("ContractSerialno");
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 1:"+sSerialNo);
		SimpleDateFormat sm=new SimpleDateFormat("yyyy/MM/dd");
		String nowDate=sm.format(new Date());
		
		SimpleDateFormat smtime=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		String nowDateTime=sm.format(new Date());
		
		JSONObject jsonObject = new JSONObject();

		String sql="";
		//创建数据库连接
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
			Statement st=conn.createStatement();
			ResultSet rs=null;
			sql="update business_contract set CONTRACTEFFECTIVEDATE='"+nowDate+"',contractstatus='020',SIGNEDDATE='"+nowDate+"' where serialno='"+sSerialNo+"'";
			ARE.getLog().debug(OUT_PUT_LOG+"sql 1:"+sql);
			rs=st.executeQuery(sql);
			jsonObject.element("IsStatus", "1");
			// 插入业务子表，添加是否需要上传贷后资料字段
			insertCheckCustomer(sSerialNo);
			
			conn.commit() ;
			rs.close();
			st.close();
		} catch (Exception e) {
			jsonObject.element("IsStatus", "2");
		}finally{
			if(conn!=null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		ARE.getLog().debug(OUT_PUT_LOG+"output parameter 1:"+jsonObject);
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
		
	}
    
	/**
	 * 插入业务子表，添加是否需要上传贷后资料字段
	 * 
	 * @param Sqlca
	 * @param sObjectNo
	 */
	@SuppressWarnings("deprecation")
	public void insertCheckCustomer(String sObjectNo) {
		ARE.getLog().debug("-----------insertCheckContract begin-------------");
		String sToday = StringFunction.getTodayNow();
		String sUploadFlag = "";
		//创建数据库连接
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
			Statement st=conn.createStatement();
			ResultSet rs=null;
			String businessType1 = "",businessType2 = "",businessType3 = "";  //商品类型
			String sql1 = "select businessType1, businessType2, businessType3 from Business_Contract where SerialNo = '"+sObjectNo+"'";
			ARE.getLog().debug(OUT_PUT_LOG+"sql1:"+sql1);
			rs=st.executeQuery(sql1);
			if(rs.next()){
				businessType1 = StringUtil.getString(rs.getString("businessType1"));   
				businessType2 = StringUtil.getString(rs.getString("businessType2"));   
				businessType3 = StringUtil.getString(rs.getString("businessType3"));   
			}else{
				ARE.getLog().debug(OUT_PUT_LOG+":没有商品类型");
			}
			
			int count1 = 0;
			if (businessType1 == null || "".equals(businessType1)) {
				sUploadFlag = "3"; // 商品类型为空，上传贷后资料状态设置为无需上传
			} else {
				String sql2 = "select count(1) from product_ecm_upload  where product_type_id = '"+businessType1+"'";
				if(!"".equals(businessType2)){
					sql2+=" or product_type_id = '"+businessType2+"'";
				}else if(!"".equals(businessType3)){
					sql2+=" or product_type_id = '"+businessType3+"'";
				}
				rs=st.executeQuery(sql2);
				if(rs.next()){
					count1 = rs.getInt(1);  
				}else{
					ARE.getLog().debug(OUT_PUT_LOG+":没有商品类型");
				}
				if (count1 > 0) {
					sUploadFlag = "2"; // 需要上传贷后资料，设置上传状态为未上传
				} else {
					sUploadFlag = "3"; // 无需上传贷后资料，设置上传状态为无需上传
				}
			}
			String sql3 = "select count(1) from Check_Contract  where contractSerialNo = "+sObjectNo;
			ARE.getLog().debug(OUT_PUT_LOG+"sql3:"+sql3);
			rs=st.executeQuery(sql3);
			int count2 = 0;
			if(rs.next()){
				count2 = rs.getInt(1);   
			}
			String sql4 = "";
			if (count2 > 0) {
				sql4 = "update Check_Contract set CHECKDOCSTATUS = '1', PASSTIME = '" + sToday + "', UPLOADFLAG = '" + sUploadFlag + "' where CONTRACTSERIALNO = '" + sObjectNo + "'";
			} else {
				sql4 = "insert into Check_Contract (CONTRACTSERIALNO, CHECKDOCSTATUS, PASSTIME, UPLOADFLAG) " + "values ('" + sObjectNo + "', '1','" + sToday + "','" + sUploadFlag + "')";
			}
			ARE.getLog().debug(OUT_PUT_LOG+"sql4:"+sql4);
			rs=st.executeQuery(sql4);
			conn.commit() ;
			rs.close();
			st.close();
		} catch (Exception e) {
			ARE.getLog().debug(OUT_PUT_LOG+"Error:"+e.getMessage());
		}finally{
			if(conn!=null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
	}
	
}
