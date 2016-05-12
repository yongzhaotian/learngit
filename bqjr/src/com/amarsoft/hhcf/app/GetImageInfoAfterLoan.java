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
 * @web.servlet name=GetImageInfoAfterLoan
 * @category�����������ϴ���֤�ӿ�
 * @author yongxu
 * @since 2015/05/25
 */
public class GetImageInfoAfterLoan extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======GetImageInfoAfterLoan=========]:";
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
	 * �ṩ��PAD����֤��ǰ��ͬ�Ƿ���Ҫ�ϴ��������ϣ������Ƿ��д�������Ӱ���������ؽ����ж�
	 *
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");
		
		
		String serialNo =  request.getParameter("SerialNo");
		
		ARE.getLog().debug(OUT_PUT_LOG+"doPost begin ");
		JSONObject jsonObject2 = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		String sql="";
		//�������ݿ�����
		Connection conn = null;
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		} catch (Exception e) {
			ARE.getLog().error("���config�����ó���", e);
		}
		ResultSet rs=null;
		Statement st=null;
	    try {
			int isNum=checkPass(serialNo);
			if(isNum==1){//�ж��Ƿ���ڸ�ID
				st=conn.createStatement();
		//		sql = " select Image_Type_No, Image_Type_Name from product_ecm_upload where PRODUCT_TYPE_ID in (Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID  from business_contract where serialno = '"+serialNo+"')";
				sql = "select u.Image_Type_No, u.Image_Type_Name, u.uploadcity, u.uploadDayLimit from product_ecm_upload u where INSTR(','||(Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID from business_contract where serialno = '"+serialNo+"')||',',','||u.PRODUCT_TYPE_ID||',') > 0";
				ARE.getLog().debug(OUT_PUT_LOG+"sql 1 :"+sql);
				rs=st.executeQuery(sql);
				boolean uploadEnable = false;
				while(rs.next()){
					uploadEnable = true;
					JSONObject jsonObject1 = new JSONObject();
					jsonObject1.put("ImageNo",
							rs.getString("Image_Type_No"));// Ӱ����
					jsonObject1.put("ImageName",
							rs.getString("Image_Type_Name"));// Ӱ������
					jsonObject1.put("UploadCity",
							rs.getString("uploadcity"));// ���������ϴ���������
					jsonObject1.put("UploadLimitDay",
							rs.getString("uploadDayLimit"));// ���������ϴ�ʱ������
					jsonArray.add(jsonObject1);
				}
				/*if(uploadEnable){
					sql = "update business_contract set uploadFlag = '2' where serialno = '"+serialNo+"'"; 
				}else {
					sql = "update business_contract set uploadFlag = '3' where serialno = '"+serialNo+"'";
				}*/
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

				sql = "select serialno from business_contract where serialno='"
						+ SerialNo + "' ";
				rs = statement.executeQuery(sql);
				while (rs.next()) {
					SerialNo = rs.getString("serialno");
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
