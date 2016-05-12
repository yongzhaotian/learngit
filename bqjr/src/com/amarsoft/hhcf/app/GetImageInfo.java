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
 * @web.servlet name=GetImageInfo
 * @category����ȡ��ǰ���Ͻӿ�
 * @author yongxu
 * @since 2015/05/25
 */
public class GetImageInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:GetImageInfo=========]:";
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
	 * �ṩ��PAD�˸��ݵ�ǰ��ͬ�Ĳ�Ʒ���ͻ�ȡ�����õ�Ӱ������
	 *
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");
		
//		String productID =  request.getParameter("ProductID");
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
				sql="Select distinct IMAGE_TYPE_NO, IMAGE_TYPE_NAME from PRODUCT_ECM_TYPE where PRODUCT_TYPE_ID in (Select PRODUCT_TYPE_ID  from PRODUCT_TYPE_CTYPE where PRODUCT_ID in (Select businessType from business_contract where serialNo = '"+serialNo+"'))";
				rs=st.executeQuery(sql);
				while(rs.next()){
					 JSONObject jsonObject1 = new JSONObject();
					 jsonObject1.put("ImageNo", rs.getString("IMAGE_TYPE_NO"));
					 jsonObject1.put("ImageName", rs.getString("IMAGE_TYPE_NAME"));
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
