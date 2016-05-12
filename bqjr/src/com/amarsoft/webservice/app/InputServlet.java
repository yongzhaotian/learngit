package com.amarsoft.webservice.app;

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
import com.amarsoft.are.security.MessageDigest;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;

/**
 * app �ӿڷ����
 * @author lwang 2014/07/25
 * @ �����û������룬�����ŵ���Ϣ��
 */
public class InputServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		super.doGet(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			//����������������
			req.setCharacterEncoding("GBK");
			resp.setCharacterEncoding("GBK");
			
			
			String userName =  req.getParameter("UserName");
			String userPass =  req.getParameter("UserPass");

			//MD5����
			String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", userPass);
			//�������ݿ��ѯ��������ѯ��¼��Ϣ�Ƿ���ȷ
			int isNum=checkPass(userName, sPassword);
			
			JSONObject jsonObject=new JSONObject();
			JSONArray jsonArray = new JSONArray();
			
			if(isNum==1){//��¼�û�������ȷ����ѯ�ŵ���Ϣ
				jsonArray=this.createJSONObject(userName);
				jsonObject.element("date", jsonArray);
				
				resp.getWriter().write(jsonObject.toString());
				resp.getWriter().flush();
				resp.getWriter().close();
			}else{
				jsonObject.element("date","[{}]");
				resp.getWriter().write(jsonObject.toString());
				resp.getWriter().flush();
				resp.getWriter().close();
			}

		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}
	
	//��ѯ�û��Ƿ���ȷ
	public int checkPass(String user,String pass) throws SQLException{
		int i=0;
		String sql="",userid="";
		//�������ݿ�����
		Connection conn = null;
		String dataSource = null;
		try {
			dataSource = Configure.getInstance().getDataSource();
			conn = ARE.getDBConnection(dataSource==null?"als":dataSource);
		} catch (Exception e) {
			ARE.getLog().error("���config�е�datasource���ó���", e);
		}
		
		try{
			ResultSet rs = null;
			Statement statement = conn.createStatement();

			 sql = "select ui.userid from user_info ui where ui.userid='"+user+"' and password='"+pass+"' ";
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
	
	/**
	 * ��ѯ�ŵ���Ϣ
	 * @param userName
	 * @return JSONArray
	 */
	private static JSONArray createJSONObject(String userName) {
		//���������
		String sql="",uSNo="",uSName="";
		Connection conn = null;
		String dataSource = null;
		JSONArray jsonArray = new JSONArray();
		
		try {
				//��������Դ
				dataSource = Configure.getInstance().getDataSource();
				conn = ARE.getDBConnection(dataSource==null?"als":dataSource);
		} catch (Exception e) {
				ARE.getLog().error("���config�е�datasource���ó���", e);
		}
		 
		try{
				ResultSet rs = null;
				Statement statement = conn.createStatement();
				
				//���ݵ�¼�û���ѯ�ŵ���Ϣ
				 sql = "select SNo,SName from store_info where identtype = '01' and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo = '"+userName+"') ";
				 rs = statement.executeQuery(sql);
				 while(rs.next()){
					 JSONObject jsonObject = new JSONObject();
					 uSNo = rs.getString("SNo");
					 uSName = rs.getString("SName");
				     jsonObject.put("SNo", uSNo);
				     jsonObject.put("SName", uSName);
				     jsonArray.add(jsonObject);
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
		 
	        return jsonArray;
	 }

}
