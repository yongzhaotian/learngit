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
 * @web.servlet name=UpdateUploadStatus
 * @category：贷后资料上传状态更新接口
 * @author yongxu
 * @since 2015/05/25
 */
public class UpdateUploadStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======UpdateUploadStatus=========]:";
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	
	/*
	 * 提供给PAD端上传完贷后资料后更新合同状态已给注册部进行贷后资料检查
	 *
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");
		
		String sTodayNow = StringFunction.getTodayNow();
		String serialNo =  request.getParameter("SerialNo");
		String uploadPeriod = request.getParameter("UploadPeriod");
		
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
		Statement st=null;
	    try {
			int isNum=checkPass(serialNo);
			if(isNum==1){//判断是否存在该ID
				st=conn.createStatement();
				//param:uploadPeriod{0:第一次上传;1:第二次上传(补充资料)}
				if("1".equals(uploadPeriod)){
					sql = " update check_contract set uploadFlag = '1', checkstatus = '6', checkendtime = '"+sTodayNow+"' where contractserialno = '"+serialNo+"'";
				}else {
					sql = " update check_contract set uploadFlag = '1', checkstatus = '2', checktime = '"+sTodayNow+"' where contractserialno = '"+serialNo+"'";
				}
				ARE.getLog().debug(OUT_PUT_LOG+"sql 1 :"+sql);
				int count = st.executeUpdate(sql);
				if(count > 0){
					JSONObject jsonObject1 = new JSONObject();
					jsonObject1.put("UpdateResult", "Success");// 合同号
					jsonArray.add(jsonObject1);
				}
				jsonObject2.element("data", jsonArray);
				System.out.println("----------------------------->"+jsonObject2.toString());
				ARE.getLog().debug(OUT_PUT_LOG+"output parameter :"+jsonObject2);
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

