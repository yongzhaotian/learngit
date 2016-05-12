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
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.workflow.action.FlowAction;
import com.amarsoft.proj.action.P2PCreditCommon;

/**
 * Servlet implementation class ChealContract
 */
public class ChealContract extends HttpServlet {
	private static final long serialVersionUID = 1L;
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
		String serialNo=""; String objectType="";
		String oldPhaseNos=""; String sPhaseInfo="";
		String sql="";
		
		String objectNo =  request.getParameter("ContractSerialno");
		String userID =  request.getParameter("UserID");
		JSONObject jsonObject1 = new JSONObject();
		
		 Transaction Sqlca=new Transaction(FinalNum.DATASOUTCE);
//		 Connection  conn=null;
		 try {
//			 conn=ARE.getDBConnection(FinalNum.DATASOUTCE);
//			 Statement st=conn.createStatement();
			 sql="select phaseno,serialno,objecttype from flow_task where serialno in(select max(serialno) from flow_task where objectno='"+objectNo+"')";
			 ASResultSet  rs=Sqlca.getASResultSet(new SqlObject(sql));
			 if(rs.next()){
				 serialNo=rs.getString("serialno");
				 objectType=rs.getString("objectType");
				 oldPhaseNos=rs.getString("phaseno");
			 }
			
			 FlowAction fa=new FlowAction();
			 fa.setSerialNo(serialNo);
			 fa.setObjectNo(objectNo);
			 fa.setOldPhaseNo(oldPhaseNos);
			 fa.setObjectType(objectType);
			 fa.setUserID(userID);
			 sPhaseInfo= fa.CancelTask(Sqlca);
			 
			 if("Success".equals(sPhaseInfo)||"Working".equals(sPhaseInfo)){

				 sql="update business_contract set contractstatus = '100'  where serialno='"+objectNo+"'";
				 Sqlca.executeSQL(new SqlObject(sql));
			//	rs=st.executeQuery(sql);
				//判断是否是P2P,要把额度退回池子
				P2PCreditCommon p2pcommon = new P2PCreditCommon(serialNo,Sqlca);
				if(p2pcommon.isUseP2P()){
					p2pcommon.checkReturnP2pSum();
				}
				 jsonObject1.put("IsStatus", "1");
			 }else{
				 jsonObject1.put("IsStatus", "2");

			 }
	//		 conn.commit();
			 Sqlca.commit(); 
			response.getWriter().write(jsonObject1.toString());
			response.getWriter().flush();
			response.getWriter().close();
			rs.close();
			//st.close();
		}  catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

			if (Sqlca != null)
				try {
					Sqlca.rollback();
				} catch (SQLException exc) {
					exc.printStackTrace();
				}
		} finally {
			/**
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				*/

		}
	}
	
	
	///
}
