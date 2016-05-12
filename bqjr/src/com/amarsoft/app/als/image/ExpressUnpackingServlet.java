package com.amarsoft.app.als.image;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.RuntimeContext;
import com.amarsoft.context.ASUser;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ExpressUnpackingServlet extends HttpServlet {

	/**
	 * 
	 */
	static final long serialVersionUID = 5490805165054548998L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}

	@SuppressWarnings("deprecation")
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ARE.getLog().debug("快递拆包。。。。");
		String returnMsg = "success";
		RuntimeContext CurARC = (RuntimeContext)req.getSession().getAttribute("CurARC");
		ASUser CurUser = CurARC.getUser();
		
		String inputUser = CurUser.getUserID();
		String inputOrg = CurUser.getOrgID();
		String inputTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");
		
		//更新地标状态
		String sql1 = "update business_contract set landmarkStatus=? where serialNo=?";
		//String sql1 = "update business_contract set landmarkStatus=(select t.itemattribute from code_library t where codeno='ExpressType' and itemno = ?) where serialNo=?";
		//录入快递信息
		String sql2 = "insert into business_contract_express (serialNo,contractNo,expressNo,expressType,inputUser,inputOrg,inputTime,sortNo)"+ 
				       "values (?,?,?,?,'"+inputUser+"','"+inputOrg+"','"+inputTime+"',?)";
		System.out.println(sql2);
		//查询地标状态
		String sql3 = "select t.itemno,t.itemattribute from code_library t where codeno='ExpressType'";
		
		String param = req.getParameter("param");
		JSONArray array = JSONArray.fromObject(param);
		String expressNo = "";
		String contractNo = "";
		String expressType = "";
		String serialNo = "";
		String sortNo = "";
		String landMarkStatus = "";
		ExpressUnpackingBean expressUnpacking = null;
		
		Connection conn = null;
		PreparedStatement  updateLandMark = null,selLandMark = null,insertExpress = null;
		ResultSet rs = null;
		String dataSource = null;
		try {
			dataSource = Configure.getInstance().getDataSource();
			conn = ARE.getDBConnection(dataSource==null?"als":dataSource);
			conn.setAutoCommit(false);
		} catch (Exception e) {
			ARE.getLog().error("获得awe config中的datasource配置出错", e);
		}
		
		Map<String, String> markMap = new HashMap<String, String>();
		try {
			String itemno = "";
			String itemattribute = "";
			selLandMark = conn.prepareStatement(sql3);
			updateLandMark = conn.prepareStatement(sql1);
			insertExpress = conn.prepareStatement(sql2);
			rs = selLandMark.executeQuery();
			while(rs.next()){
				itemno =  rs.getString("itemno");
				itemattribute = rs.getString("itemattribute");
				markMap.put(itemno, itemattribute);
			}
			
			for(int i=0;i<array.size();i++){
				JSONObject object = JSONObject.fromObject(array.get(i));
				expressUnpacking = (ExpressUnpackingBean) JSONObject.toBean(object,ExpressUnpackingBean.class);
				expressNo = expressUnpacking.getExpressNo();
				contractNo = expressUnpacking.getContractNo();
				expressType = expressUnpacking.getExpressType();
				serialNo = expressUnpacking.getSerialNo();
				sortNo = expressUnpacking.getSortNo();
				landMarkStatus = markMap.get(expressType);
				
				if(landMarkStatus != null && !"".equals(landMarkStatus)){
					updateLandMark.setString(1, landMarkStatus);
					updateLandMark.setString(2, contractNo);
					updateLandMark.addBatch();
				}
				
				insertExpress.setString(1, serialNo);
				insertExpress.setString(2, contractNo);
				insertExpress.setString(3, expressNo);
				insertExpress.setString(4, expressType);
				insertExpress.setString(5, sortNo);
				insertExpress.addBatch();
			}
			
			updateLandMark.executeBatch();
			insertExpress.executeBatch();
			conn.commit();
		} catch (SQLException e) {
			ARE.getLog().fatal("快递拆包出错",e);
			returnMsg = "false-"+e.getMessage();
		}finally{
			try {
				if(rs!=null) rs.close();
				if(updateLandMark!=null) updateLandMark.close();
				if(insertExpress!=null) insertExpress.close();
				if(selLandMark!=null) selLandMark.close();
				if(conn!=null) conn.close();
			} catch (SQLException e) {
				ARE.getLog().error("关闭数据库连接出错",e); 
				returnMsg = "false-"+e.getMessage();
			  }
		}
		resp.getWriter().write(returnMsg);
		resp.getWriter().flush();
		resp.getWriter().close();
	}
	
	
	
	

}
