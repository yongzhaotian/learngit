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
 * Servlet implementation class SelContractStatus
 */
public class SelContractStatus extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG="[APP INTERFACE==========][=======METHOD:SelContractStatus=========]:";
	 
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
		ARE.getLog().debug(OUT_PUT_LOG+"SelContractStatus dopost begin ");
		String sUserID =  request.getParameter("UserID");
		String SyncData =  request.getParameter("SyncData");//1同步 
		String pageNo =  request.getParameter("pageNo");//页数
		
		String contractno =  request.getParameter("contractno");
		String status =  request.getParameter("status");//1同步 
		String sno =  request.getParameter("sno");//页数
		String customname =  request.getParameter("customname");//页数
		
		
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 1:"+sUserID);
		JSONObject jsonObject1 = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		boolean flag=false;
		
		Connection conn=null;
		String sql="";
		try {
			conn=ARE.getDBConnection(FinalNum.DATASOUTCE);
			Statement st=conn.createStatement();
			if("1".equals(SyncData)){
				String sqlSync="";
				ARE.getLog().debug(OUT_PUT_LOG+"-----APP SEARCH DATA START---- ");
				sqlSync="DELETE from BUSSINESS_TYPE1@APPLINK";
				
				st.executeQuery(sqlSync);

				sqlSync="INSERT INTO BUSSINESS_TYPE1@APPLINK (CODE, NAME, SORTNO, RANGECODE) SELECT productctypeid,productctypename,productctypeid,productcategoryid from Product_CType where isinuse = '1'";
				st.executeQuery(sqlSync);
				st.getConnection().commit();
				
				sqlSync="DELETE from PRODUCT_CATEGORY@APPLINK";
				st.executeQuery(sqlSync);

				sqlSync="INSERT INTO PRODUCT_CATEGORY@APPLINK (productcategoryid,productcategoryname,isinuse,inputuser,inputtime,inputorg) SELECT productcategoryid,productcategoryname,isinuse,inputuser,inputtime,inputorg from PRODUCT_CATEGORY";
				st.executeQuery(sqlSync);
				
				sqlSync="DELETE from user_info@APPLINK";
				st.executeQuery(sqlSync);

				sqlSync="Insert Into user_info@applink(USERID, LOGINID, USERNAME, PASSWORD, BELONGORG, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE, DESCRIBE1, DESCRIBE2, DESCRIBE3, DESCRIBE4, STATUS, CERTTYPE, CERTID, COMPANYTEL, MOBILETEL, EMAIL, ACCOUNTID, ID1, ID2, SUM1, SUM2, INPUTORG, INPUTUSER, INPUTDATE, UPDATEDATE, INPUTTIME, UPDATEUSER, UPDATETIME, REMARK, BIRTHDAY, GENDER, FAMILYADD, EDUCATIONALBG, AMLEVEL, TITLE, EDUCATIONEXP, VOCATIONEXP, POSITION, QUALIFICATION, NTID, BELONGTEAM, SKINPATH, USERTYPE, CITY, SUPERID, HIREDATE, ISCAR, RGROUP) Select USERID, LOGINID, USERNAME, PASSWORD, BELONGORG, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE, DESCRIBE1, DESCRIBE2, DESCRIBE3, DESCRIBE4, STATUS, CERTTYPE, CERTID, COMPANYTEL, MOBILETEL, EMAIL, ACCOUNTID, ID1, ID2, SUM1, SUM2, INPUTORG, INPUTUSER, INPUTDATE, UPDATEDATE, INPUTTIME, UPDATEUSER, UPDATETIME, REMARK, BIRTHDAY, GENDER, FAMILYADD, EDUCATIONALBG, AMLEVEL, TITLE, EDUCATIONEXP, VOCATIONEXP, POSITION, QUALIFICATION, NTID, BELONGTEAM, SKINPATH, USERTYPE, CITY, SUPERID, HIREDATE, ISCAR, RGROUP From user_info";
				st.executeQuery(sqlSync);
				
				sqlSync="DELETE from code_library@APPLINK";
				st.executeQuery(sqlSync);

				sqlSync="Insert Into code_library@applink Select * From code_library";
				st.executeQuery(sqlSync);
				
				sqlSync="DELETE from store_info@APPLINK";
				st.executeQuery(sqlSync);

				sqlSync="Insert Into store_info@applink(SERIALNO, SNO, SNAME, OPERATEMODE, STORETYPE, ADDRESS, SHOPHOURS, SALESMAN, SALESMANPHONE, BUSINESSTYPE, TEL, ACCOUNT, ACCOUNTNAME, ACCOUNTBANK, PRODUCTCATEGORY, MAINBUSINESSTYPE, PREDICTLOANAMOUNT, CITY, SALESMANEMAIL, REPONSIBLEMAN, REPONSIBLEMANPHONE, REMARK, RSERIALNO, STATUS, GROUPNO, PERMITTYPE, SALESMANAGER, ISPOST, ATTR1, ATTR2, ATTR3, INPUTORG, INPUTUSER, INPUTDATE, UPDATEORG, UPDATEUSER, UPDATEDATE, RSSERIALNO, FINANCIALEMAIL, IDENTTYPE, PRODUCTCATEGORYNAME, MAINBUSINESSTYPENAME, DEALERMANAGER, DEALERSPECIALIST, ACCOUNTBANKCITY, ISNETBANK, CITYMANAGER, REGCODE, BRANCHCODE, OPENBRANCH, SELLERPLACENUM, CRGROUP, DEALERSPECIALISTPHONE, LONGITUDE, LATITUDE, COMPETITOR, OPENCOLSENAME, OPENCOLSEDATE) Select SERIALNO, SNO, SNAME, OPERATEMODE, STORETYPE, ADDRESS, SHOPHOURS, SALESMAN, SALESMANPHONE, BUSINESSTYPE, TEL, ACCOUNT, ACCOUNTNAME, ACCOUNTBANK, PRODUCTCATEGORY, MAINBUSINESSTYPE, PREDICTLOANAMOUNT, CITY, SALESMANEMAIL, REPONSIBLEMAN, REPONSIBLEMANPHONE, REMARK, RSERIALNO, STATUS, GROUPNO, PERMITTYPE, SALESMANAGER, ISPOST, ATTR1, ATTR2, ATTR3, INPUTORG, INPUTUSER, INPUTDATE, UPDATEORG, UPDATEUSER, UPDATEDATE, RSSERIALNO, FINANCIALEMAIL, IDENTTYPE, PRODUCTCATEGORYNAME, MAINBUSINESSTYPENAME, DEALERMANAGER, DEALERSPECIALIST, ACCOUNTBANKCITY, ISNETBANK, CITYMANAGER, REGCODE, BRANCHCODE, OPENBRANCH, SELLERPLACENUM, CRGROUP, DEALERSPECIALISTPHONE, LONGITUDE, LATITUDE, COMPETITOR, OPENCOLSENAME, OPENCOLSEDATE From store_info";
				st.executeQuery(sqlSync);
				
				//sqlSync="Insert Into user_shop@applink(USERID, SNO) select (salesmanno,sno) from storerelativesalesman where salesmanno is not null and sno is not null";
				//st.executeQuery(sqlSync);
				sqlSync="DELETE from photo_type@APPLINK";
				
				st.executeQuery(sqlSync);
				sqlSync="Insert Into photo_type@applink (code, name,displayindex,type,url,required) select typeno,typename,sortno," +
						"case   when typename like '%学信网截图%' or typename like '%社保网站截图%' then '2' else '1' end as type ," +
						"case   when typename like '%学信网截图%' then 'http://www.chsi.com.cn' when typename like '%社保网站截图%' " +
						"then 'http://www.12333sb.com' else '' end as url," +
						"case   when typename like '%客户身份证正面%' then '1' when typename like '%客户身份证背面%' then '1'" +
						"when typename like '%客户现场照片%' then '1' else '' end as required  from ecm_image_type where isinuse='1'";
				st.executeQuery(sqlSync);
				st.getConnection().commit();
				ARE.getLog().debug(OUT_PUT_LOG+"-----APP SEARCH DATA END---- ");
								
			}else {	
//				if(pageNo==null||pageNo.equals(""))
//				{
//					pageNo="0";
//				}
//				sql="select contractstatus,serialno,checkDocStatus, checkStatus,uploadFlag from business_contract where inputuserid='"+sUserID+"' and  SureType='APP' and to_char((sysdate-10),'yyyy/MM/dd') <= substr(inputdate,0,10) and " + (Integer.parseInt(pageNo) * 10 +1 ) + " >= rownum and rownum <= " + (Integer.parseInt(pageNo) * 10 + 10);
//				if(contractno != null && !"".equals(contractno)){
//					sql += " and serialno = '"  + contractno +"'" ;
//				}
//				if(status != null && !"".equals(status)){
//					sql += " and contractstatus = '" + status +"'";
//				}
//				if(sno != null && !"".equals(sno)){
//					sql += " and stores = '" + sno +"'";
//				}f
//				if(customname != null && !"".equals(customname)){
//					sql += " and customname = '" + customname + "'";
//				}
//				
//				sql += " order by inputdate desc";
//				
//				ARE.getLog().debug(OUT_PUT_LOG+"sql 1:"+sql);
//				ResultSet rs=st.executeQuery(sql);
//				while(rs.next()){
//					JSONObject jsonObject2 = new JSONObject();
//					jsonObject2.put("Contractstatus", rs.getString("contractstatus"));
//					jsonObject2.put("Serialno", rs.getString("serialno"));
//					jsonObject2.put("checkDocStatus", rs.getString("checkDocStatus"));//贷前状态
//					jsonObject2.put("checkStatus", rs.getString("checkStatus"));//贷后状态
//					jsonObject2.put("qutStatus", rs.getString("uploadFlag"));//是否必填状态   	
////					if(douploadfilecheck(rs.getString("serialno")))
////					{
////						jsonObject2.put("qutStatus", 3);//是否必填状态   	
////					}
////					else{
////						jsonObject2.put("qutStatus", 2);//是否必填状态
////					}
////					
//					jsonArray.add(jsonObject2);
//					flag=true;
//					
//					
//				}
				//同步APP合同数据
				sql = " UPDATE business_contract@applink t1  SET (t1.contractstatus,t1.checkstatus,t1.checkdocstatus,t1.uploadflag,t1.registrationdate) =(SELECT t2.contractstatus,cc.checkstatus,cc.checkdocstatus,cc.uploadflag,t2.registrationdate	FROM business_contract t2 left join check_contract cc on t2.serialno=cc.contractserialno WHERE t2.serialno = t1.serialno and t1.inputuserid= '"+sUserID+"') WHERE  EXISTS(SELECT 1 FROM business_contract T3 WHERE T3.SERIALNO = T1.SERIALNO AND T3.INPUTUSERID='"+sUserID+"')";
				st.executeQuery(sql);
				//st.getConnection().commit();
				//同步contract_list
				sql = " UPDATE contract_list@applink t1  SET (t1.status,t1.checkstatus,t1.checkdocstatus,t1.qutstatus) =(SELECT t2.contractstatus,cc.checkstatus,cc.checkdocstatus,cc.uploadflag	FROM business_contract t2 left join check_contract cc on t2.serialno=cc.contractserialno WHERE t2.serialno = t1.contractno and t2.inputuserid= '"+sUserID+"') WHERE  EXISTS(SELECT 1 FROM business_contract T3 WHERE T3.SERIALNO = T1.CONTRACTNO AND T3.INPUTUSERID='"+sUserID+"')";
				st.executeQuery(sql);
				st.getConnection().commit();
			//	st.getConnection().commit();
				if(!flag){
					response.getWriter().write("{[]}");
				}else{
					jsonObject1.element("ContractList", jsonArray);
					response.getWriter().write(jsonObject1.toString());
				}
				response.getWriter().flush();
				response.getWriter().close();
//				rs.close();
			}
			st.close();
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
		ARE.getLog().debug(OUT_PUT_LOG+"SelContractStatus dopost end ");
		
	}
	protected boolean douploadfilecheck(String serialNo) throws ServletException, IOException {
		
		
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
	    	st=conn.createStatement();
			//		sql = " select Image_Type_No, Image_Type_Name from product_ecm_upload where PRODUCT_TYPE_ID in (Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID  from business_contract where serialno = '"+serialNo+"')";
					sql = "select u.Image_Type_No, u.Image_Type_Name, u.uploadcity from product_ecm_upload u where INSTR(','||(Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID from business_contract where serialno = '"+serialNo+"')||',',','||u.PRODUCT_TYPE_ID||',') > 0";
					ARE.getLog().debug(OUT_PUT_LOG+"sql 1 :"+sql);
					rs=st.executeQuery(sql);
					boolean uploadEnable = false;
					while(rs.next()){
						uploadEnable = true;
						JSONObject jsonObject1 = new JSONObject();
						jsonObject1.put("ImageNo",
								rs.getString("Image_Type_No"));// 影像编号
						jsonObject1.put("ImageName",
								rs.getString("Image_Type_Name"));// 影像名称
						jsonObject1.put("UploadCity",
								rs.getString("uploadcity"));// 贷后资料上传城市限制
						jsonArray.add(jsonObject1);
					}
					if(jsonArray.size()==0){
						return true;
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
	    return false;
		
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
