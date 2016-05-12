package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
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
import com.amarsoft.awe.Configure;

/**
 * Servlet implementation class UserSotreInfo
 */
public class UserSotreInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:UserSotreInfo=========]:";
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
		
		String phone =  request.getParameter("phone");
		String userID =  request.getParameter("UserID");
		
		ARE.getLog().debug(OUT_PUT_LOG+"doPost begin ");
		JSONObject jsonObject2 = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		String sql="";
		//创建数据库连接
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("获得config的配置出错", e);
		}
		ResultSet rs=null;
		Statement st=null;
		
		
		
	    try {
	    	// 重写联系人的联系方式
	    	if(phone != null){
	    		st=conn.createStatement();
				ARE.getLog().debug(OUT_PUT_LOG+"sql 1 :"+sql);
				int isNum=checkPass(userID);
				if(isNum==1){//判断是否存在该ID
					st=conn.createStatement();
					sql="update user_info set  resetmobiletel='"+phone +"' where userid='" + userID+"'";
					ARE.getLog().debug(OUT_PUT_LOG+"sql 1 :"+sql);
					st.executeUpdate(sql);
					st.close();
					JSONObject jsonObject1 = new JSONObject();
					jsonObject1.put("code", "1000");
					response.getWriter().write(jsonObject1.toString());
					response.getWriter().flush();
					response.getWriter().close();
				}else{
					jsonObject2.element("code", "4000");
					response.getWriter().write(jsonObject2.toString());
					response.getWriter().flush();
					response.getWriter().close();
				}
				
				return  ;
			}
	    	
	    	int isNum=checkPass(userID);
			if(isNum==1){//判断是否存在该ID
				st=conn.createStatement();
				sql="select SNo,SName,ProductCategory,Salesmanager,Citymanager,City from store_info where identtype = '01' and STATUS='05'   and sno in (select sno from storerelativesalesman  where salesmanno='"+userID+"' and stype is null)";
				ARE.getLog().debug(OUT_PUT_LOG+"sql 1 :"+sql);
				rs=st.executeQuery(sql);
				while(rs.next()){
					 JSONObject jsonObject1 = new JSONObject();
					 jsonObject1.put("SNO", rs.getString("sno"));
					 jsonObject1.put("SName", rs.getString("SName"));
					 jsonObject1.put("ProductCategory", rs.getString("ProductCategory"));
					 jsonObject1.put("Salesmanager", rs.getString("Salesmanager"));
					 jsonObject1.put("Citymanager", rs.getString("Citymanager"));
					 jsonObject1.put("City", rs.getString("City"));
					 jsonArray.add(jsonObject1);
				}
				jsonObject2.element("data", jsonArray);
				System.out.println("----------------------------->"+jsonObject2.toString());
				ARE.getLog().debug(OUT_PUT_LOG+"output parameter :"+jsonObject2);
				rs.close();
				st.close();
				response.getWriter().write(jsonObject2.toString());
				response.getWriter().flush();
				response.getWriter().close();
			}else{
				jsonObject2.element("data", "[{}]");
				response.getWriter().write(jsonObject2.toString());
				response.getWriter().flush();
				response.getWriter().close();
			}	
			
			conn.commit();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			
			e.printStackTrace();
		}finally{
			if(conn!=null)
				try {
					conn.close();
					
				} catch (SQLException e) {
					e.printStackTrace();
				}
			
			
	    }
	 
		
	}
    
	//查询用户是否正确
		public int checkPass(String userID) throws SQLException{
			int i=0;
			String sql="",userid="";
			//创建数据库连接
			Connection conn = null;
			String dataSource = null;
			try {
				conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
			} catch (Exception e) {
				ARE.getLog().error("获得config中的datasource配置出错", e);
			}
			
			try{
				ResultSet rs = null;
				Statement statement = conn.createStatement();

				 sql = "select ui.userid from user_info ui where ui.userid='"+userID+"' ";
				 rs = statement.executeQuery(sql);
				 while(rs.next()){
					 userid = rs.getString("userid");
					 if(!"".equals(userid)){
						 i=1;
					 }
				 }
				 rs.close();
				 statement.close();
				
			}catch (Exception e) {
				e.printStackTrace();
			}finally{
				if(conn!=null)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
		    }

			return i;
		}
		
}
