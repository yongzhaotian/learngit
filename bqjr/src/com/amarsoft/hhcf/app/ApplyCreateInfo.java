package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.als.bizobject.customer.EntCustomer;
import com.amarsoft.app.als.bizobject.customer.IndCustomer;
import com.amarsoft.app.billions.GenerateSerialNo;
import com.amarsoft.app.lending.bizlets.CreateFeeList;
import com.amarsoft.app.lending.bizlets.InitializeFlow;
import com.amarsoft.app.lending.bizlets.UpdateColValue;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ApplyCreateInfo extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:ApplyCreateInfo=========]:";

	// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public ApplyCreateInfo() {
		super();
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String CustomerID = "";

		/** 数据库连接 */
		Transaction Sqlca = null;
		/** 当天日期 */
		String Today = "";
		String SerialNo = "";// 合同号
		String ApplySerialNo = "";// 合同号（申请编号）16位
		String CustomerName = "";// 客户名称
		String CertID = "";// 身份证号
		String CustomerType = "0310";// 客户类型（个人客户）
		String CertType = "Ind01";// 证件类型（身份证）
		String OrgID = "";
		String UserID = "";
		
		// ////////////////////////////////////////INPUT
		// PARAMETERS///////////////////////////////////////////////////////
		String sNo = "";
		String ProductName = "";
		String Periods = "";
		String ProductID = "";
		String BusinessCurrency = "";
		String BusinessType = "";// SJ012
		String Interiorcode = "";// 是否授权
		String CreditCycle = "";// // 是否保险
		String Productbrand = "";// 商品品牌
		String BusinessRang1 = "";// 商品范畴1
		String BusinesType1 = "";// 商品类型1
		String Price1 = "";
		String Paymentrate = "";// 首付比例
		String Paymentsum = "";// 自付金额
		String Insurancefee = "";//保险费率
		double downPayment = 0.0;// 首付金额
		String saleManagerNo = "";//销售经理
		String cityManager = "";// 城市经理

		Connection conn = null;

		try {
			response.setCharacterEncoding("GBK");
			request.setCharacterEncoding("GBK");
			JSONObject jsonObject = new JSONObject();

			String str = request.getParameter("CustomerName");
			str = new String(str.getBytes("ISO-8859-1"), "GBK");

			CustomerName = URLDecoder.decode(str, "UTF-8");
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 1:" + CustomerName);
			String sCertID = request.getParameter("CertID");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 2:" + sCertID);
			String sOrgID = request.getParameter("OrgID");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 3:" + sOrgID);
			String SUserID = request.getParameter("UserID");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 4:" + SUserID);
			sNo = request.getParameter("Stores");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 5:" + sNo);
			str = request.getParameter("ProductName");
			str = new String(str.getBytes("ISO-8859-1"), "GBK");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 6:" + str);
			ProductName = URLDecoder.decode(str, "UTF-8");
			ARE.getLog()
					.debug(OUT_PUT_LOG + "input parameter 7:" + ProductName);
			Periods = request.getParameter("Periods");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 8:" + Periods);
			ProductID = request.getParameter("ProductID");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 9:" + ProductID);
			BusinessCurrency = request.getParameter("BusinessCurrency");
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 10:" + BusinessCurrency);
			BusinessType = request.getParameter("BusinessType");
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 11:" + BusinessType);
			

			
			CertID = sCertID;
			OrgID = sOrgID;
			UserID = SUserID;
			

			CreditCycle = request.getParameter("Creditcycle");// 是否保险
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 12:" + CreditCycle);
			Interiorcode = request.getParameter("Interiorcode");// 是否授权
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 13:" + Interiorcode);
			str = request.getParameter("Productbrand");// 商品品牌 

			str = new String(str.getBytes("ISO-8859-1"), "GBK");
			Productbrand = URLDecoder.decode(str, "UTF-8");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 14:" + str);
			BusinessRang1 = request.getParameter("BusinessRang1");// 商品范畴1
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 15:" + BusinessRang1);
			BusinesType1 = request.getParameter("BusinesType1");// 商品类型1
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 16:" + BusinesType1);
			Price1 = request.getParameter("Price1");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 17:" + Price1);
			Paymentrate = request.getParameter("Paymentrate");// 首付比例
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 18:" + Paymentrate);
			
			Paymentsum=request.getParameter("Paymentsum");
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 19:" + Paymentsum);
			
			
			Insurancefee = request.getParameter("Insurancefee");
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 20:" + Insurancefee);
			
			if (Paymentrate != null) {
				double rate = Arith
						.div(Double.parseDouble(Paymentrate), 100, 1);
				downPayment = Double.parseDouble(Paymentsum);
				ARE.getLog().debug(
						OUT_PUT_LOG + "input parameter ===downPayment====:"
								+ downPayment);
			}
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
			Sqlca = new Transaction(conn);

			//获取销售经理、城市经理，先判断用户自己是否销售经理--begin
			String exists = Sqlca.getString(new SqlObject("select 1 from STORE_INFO "
					+ " where identType='01' and status='05' and salesmanager='"+UserID+"'"));
			if(exists == null || !"1".equals(exists)){//不是
				saleManagerNo = Sqlca.getString(new SqlObject("Select distinct si.salesmanager as saleManagerNo "
						+ " from STORERELATIVESALESMAN a,STORE_INFO si "
						+ " where si.identType = '01' and si.Status='05' and a.stype is null "
						+ " and a.sno=si.sno and a.SalesManNo = '"+UserID+"'"));
			}else{//是
				saleManagerNo = UserID;
			}
			saleManagerNo = saleManagerNo == null ? "" : saleManagerNo;
			cityManager = Sqlca.getString(new SqlObject("select distinct "
					+ " SuperID from user_info where userid='"+saleManagerNo+"'"));
			cityManager = cityManager == null ? "" : cityManager;
			//获取销售经理、城市经理，先判断用户自己是否销售经理--end
			
			JBOTransaction tx = JBOFactory.createJBOTransaction();
			tx.join(Sqlca);
			
			Today=StringFunction.getToday();
			List<String> list = saveRecord(Sqlca,CustomerName, CertID,CustomerType,CertType,OrgID,UserID,Today);
			ApplySerialNo = list.get(0);
			CustomerID = list.get(1);
			SerialNo = list.get(2);
			// 新老用户同步数据
			syncAppServerCustomerInfo(CustomerID);
			Sqlca.commit();
			
			jsonObject.put("CustomerID", CustomerID);
			jsonObject.put("SerialNo", SerialNo);
			ARE.getLog()
					.debug(OUT_PUT_LOG + "output parameter 1:" + CustomerID);
			ARE.getLog().debug(OUT_PUT_LOG + "output parameter 2:" + SerialNo);
			response.getWriter().write(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
			Thread thread = new Thread(new MyRunnable(CustomerID,
					ApplySerialNo,
					SerialNo,
					CustomerName,
					CertID,
					UserID,
					OrgID,
					sNo,
					ProductName,
					Periods,
					ProductID,
					BusinessCurrency,
					BusinessType,
					Interiorcode,
					CreditCycle,
					Productbrand,
					BusinessRang1,
					BusinesType1,
					Price1,
					downPayment,
					Paymentrate,Insurancefee,saleManagerNo,cityManager));
			thread.start();

		} catch (Exception e) {
			ARE.getLog().debug(OUT_PUT_LOG + "e.printStackTrace()");
			e.printStackTrace();
			
		}finally {

			if(Sqlca!=null){
				
				try {
					Sqlca.disConnect();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			
			if (conn != null)
				try {
					if (!conn.isClosed())
						conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			
		}


	}

	private List<String> saveRecord(Transaction Sqlca,String CustomerName,String CertID,
			String CustomerType,String CertType,String OrgID,String UserID,String Today) throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "saveRecord begin");
		List<String> rtnList = new ArrayList<String>();
		String CustomerID = InsertCustomer(Sqlca, CustomerName, CertID,CustomerType,CertType,OrgID,UserID,Today);
		List<String> list = initSerialNo(Sqlca,CustomerID);
		String ApplySerialNo = list.get(0);
		String SerialNo = list.get(1);
		rtnList.add(ApplySerialNo);
		rtnList.add(CustomerID);
		rtnList.add(SerialNo);
		ARE.getLog().debug(OUT_PUT_LOG + "saveRecord end");
		return rtnList;

	}

	private List<String> initSerialNo(Transaction Sqlca,String CustomerID) throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "initSerialNo begin");
		List<String> rtnList = new ArrayList<String>();
		String ApplySerialNo = getSeriaNo("BUSINESS_CONTRACT", "SerialNo",Sqlca);
		ARE.getLog().debug(
				OUT_PUT_LOG + "initSerialNo apply serial no:" + ApplySerialNo);
		GenerateSerialNo generateSeriaNo = new GenerateSerialNo();
		generateSeriaNo.setSerialNo(CustomerID);
		String sSerialNo = generateSeriaNo.getContractId(Sqlca);
		System.out.println("合同编号：" + sSerialNo);
		rtnList.add(ApplySerialNo);
		rtnList.add(sSerialNo);
		ARE.getLog().debug(
				OUT_PUT_LOG + "initSerialNo end serialNo:" + sSerialNo);
		return rtnList;
	}

	private String InsertCustomer(Transaction Sqlca,String CustomerName,String CertID,
			String CustomerType,String CertType,String OrgID,String UserID,String Today) throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "InsertCustomer begin");
		String sql = "select CustomerID from CUSTOMER_INFO where CustomerName='"
				+ CustomerName + "' and CertID='" + CertID + "'";
		ARE.getLog().debug(OUT_PUT_LOG + "InsertCustomer Sql:" + sql);
		SqlObject sqlObject = new SqlObject(sql);
		ASResultSet rs = Sqlca.getASResultSet(sqlObject);
		String sCustomerID = null;
		while (rs.next()) {
			sCustomerID = rs.getString("CustomerID");
		}
		if (sCustomerID == null) {// 如果客户不存在，则新增
			sCustomerID = getCustomerId(Sqlca, "IND_INFO", "CUSTOMERID");
			//this.CustomerID = sCustomerID;
			addCustomerAction(sCustomerID,CustomerName,CustomerType,
					CertType,CertID,OrgID,UserID,Today);
		}
		ARE.getLog().debug(OUT_PUT_LOG + "InsertCustomer end");
		return sCustomerID;

	}

	/**
	 * 获取客户流水号 表object_maxsn中字段值在次代表意义 tablename 表名称；columnname 段名称；maxserialno
	 * 当前最大编号, datefmt 迭代伦寻最小值, nofmt 步长
	 * 
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getCustomerId(Transaction sqlca, String tableName,
			String colName) throws Exception {
		long lMaxVal = 99999999L;
		String sStep = "11"; // 初始化步长

		Connection conn = null;
		conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		Statement st = null;
		st = conn.createStatement();
		// SqlObject sqlObject = new SqlObject(sql);

		String sCustomerId = sqlca
				.getString(new SqlObject(
						"SELECT MaxSerialno from OBJECT_MAXSN where TableName=:TableName and ColumnName=:ColumnName")
						.setParameter("TableName", tableName).setParameter(
								"ColumnName", colName));
		if (null == sCustomerId) {
			sCustomerId = String.valueOf(Long
					.valueOf(GenerateSerialNo.INIT_CUSTOMERID)
					+ Long.valueOf(sStep));
			// String sql =
			// "INSERT INTO OBJECT_MAXSN(TableName,ColumnName,MaxSerialno,DateFmt,NoFmt) values("+
			// ":TableName,:ColumnName,:MaxSerialno,:DateFmt,:NoFmt)";
			// SqlObject asql = new SqlObject(sql).setParameter("TableName",
			// tableName).setParameter("ColumnName", colName)
			// .setParameter("MaxSerialno", sCustomerId)
			// .setParameter("DateFmt",
			// GenerateSerialNo.INIT_CUSTOMERID).setParameter("NoFmt", sStep);
			//
			String sql = "INSERT INTO OBJECT_MAXSN(TableName,ColumnName,MaxSerialno,DateFmt,NoFmt) values('"
					+ tableName
					+ ","
					+ colName
					+ "','"
					+ sCustomerId
					+ "','"
					+ GenerateSerialNo.INIT_CUSTOMERID + "','" + sStep + "')";
			st.executeQuery(sql);
			// sqlca.executeSQL(asql);
		} else {
			sCustomerId = String.valueOf((Long.valueOf(sCustomerId) + Long
					.valueOf(sStep)));
			// 如果已经到达最大值，伦寻最小值加+1
			if (Long.valueOf(sCustomerId).longValue() > lMaxVal) {
				String sInitMinVal = sqlca
						.getString(new SqlObject(
								"SELECT DateFmt from OBJECT_MAXSN where TableName=:TableName and ColumnName=:ColumnName")
								.setParameter("TableName", tableName)
								.setParameter("ColumnName", colName));
				sInitMinVal = String.valueOf((Long.valueOf(sInitMinVal) + 1));
				sCustomerId = String.valueOf((Long.valueOf(sInitMinVal) + Long
						.valueOf(sStep)));
				// sqlca.executeSQL(new
				// SqlObject("UPDATE OBJECT_MAXSN set MaxSerialno=:MaxSerialno,DateFmt=:DateFmt where  TableName=:TableName and ColumnName=:ColumnName")
				// .setParameter("TableName",
				// tableName).setParameter("ColumnName",
				// colName).setParameter("MaxSerialno", sCustomerId)
				// .setParameter("DateFmt", sInitMinVal));
				String sql = "UPDATE OBJECT_MAXSN set MaxSerialno='"
						+ sCustomerId + "',DateFmt='" + sInitMinVal
						+ "' where  TableName='" + tableName
						+ "' and ColumnName='" + colName + "'";
				st.executeQuery(sql);
			} else {

				// sqlca.executeSQL(new
				// SqlObject("UPDATE OBJECT_MAXSN set MaxSerialno=:MaxSerialno where  TableName=:TableName and ColumnName=:ColumnName")
				// .setParameter("TableName",
				// tableName).setParameter("ColumnName",
				// colName).setParameter("MaxSerialno", sCustomerId));
				String sql = "UPDATE OBJECT_MAXSN set MaxSerialno='"
						+ sCustomerId + "' where  TableName='" + tableName
						+ "' and ColumnName='" + colName + "'";
				st.executeQuery(sql);
			}
		}
		st.close();
		return sCustomerId;
	}

	protected void addCustomerAction(String CustomerID,String CustomerName,String CustomerType,
			String CertType,String CertID,String OrgID,String UserID,String Today) throws SQLException {
		ARE.getLog().debug(OUT_PUT_LOG + "addCustomerAction begin");
		Connection conn = null;
		conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		Statement st = null;
		st = conn.createStatement();
		// 向CUSTOMER_INFO新增一条记录
		String sql = "insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel) values("
				+ "'"
				+ CustomerID
				+ "','"
				+ CustomerName
				+ "','"
				+ CustomerType
				+ "','"
				+ CertType
				+ "','"
				+ CertID
				+ "','"
				+ OrgID + "','" + UserID + "','" + Today + "','1')";
		ARE.getLog().debug(OUT_PUT_LOG + "addCustomerAction Sql:" + sql);
		st.execute(sql);
		// 向IND_INFO新增一条记录
		sql = "insert into IND_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID18,InputOrgID,InputUserID,InputDate,TempSaveFlag,CertID) values("
				+ "'"
				+ CustomerID
				+ "','"
				+ CustomerName
				+ "','"
				+ CustomerType
				+ "','"
				+ CertType
				+ "','"
				+ CertID
				+ "','"
				+ OrgID + "','" + UserID + "','" + Today + "','1','"+CertID+"')";
		ARE.getLog().debug(OUT_PUT_LOG + "addCustomerAction Sql:" + sql);
		st.execute(sql);
		st.close();
		ARE.getLog().debug(OUT_PUT_LOG + "addCustomerAction end");
	}

	private String getSeriaNo(String sTableName, String sColumnName,Transaction Sqlca)
			throws Exception {
		/*
		 * Content: 获取流水号 Input Param: 表名: TableName 列名: ColumnName 格式：
		 * SerialNoFormate Output param: 流水号: SerialNo
		 */
		// 获取表名、列名和格式

		String sSerialNo = ""; // 流水号

		sSerialNo = DBKeyHelp.getSerialNo(sTableName, sColumnName, Sqlca);
		return sSerialNo;
	}
	private void syncAppServerCustomerInfo(String CustomerID) throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "syncAppServerCustomerInfo begin");
		Connection conn = null;
		String sql = "";
		System.out.println("----------------老客户--------------------");
		System.out.println("-------------开始插入数据---------------------");

		conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		Statement st = conn.createStatement();
		System.out.println("----------------APP 是否有该用户--------------------");
		String appCustmerID = null;
		sql = "select customerID from IND_INFO@APPLINK where customerID='"
				+ CustomerID + "'";
		ARE.getLog().debug(
				OUT_PUT_LOG + "syncAppServerCustomerInfo sql1:" + sql);
		ResultSet rs = st.executeQuery(sql);
		while (rs.next()) {
			appCustmerID = rs.getString("customerid");
		}
		rs.close();

		if (appCustmerID == null) {
			// 向开发CUSTOMER_INFO插入数据
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
			Statement st1 = conn.createStatement();

			sql = "insert into ind_info@APPLINK ( "
				+ "customerID,sex,birthday,certtype,certid,sino,country,nationality,nativeplace,politicalface,marriage,relativetype,familyadd,  "
				+ " familyzip,emailadd,familytel,mobiletelephone,unitkind,workcorp,workadd,worktel,occupation,position,employrecord,   "
				+ " edurecord,eduexperience,edudegree,graduateyear,financebelong,creditlevel,evaluatedate,balancesheet,intro,          "
				+ " selfmonthincome,familymonthincome,incomesource,population,loancardno,loancardinsyear,farmersort,regionalism,staff,   "
				+ " creditfarmer,riskinclination,character,dataquality,inputorgid,inputuserid,inputdate,updatedate,remark,updateorgid,   "
				+ " updateuserid,commadd,commzip,nativeadd,workzip,headship,workbegindate,yearincome,payaccount,payaccountbank,familystatus,  "
				+ " tempsaveflag,certid18,customername,issueinstitution,maturitydate,street,community,cellno,flag2,newadd,villagetown,countryside,  "
				+ " villagecenter,plot,room,cellproperty,flag3,unitcountryside,unitstreet,unitroom,unitno,phoneman,cellphoneverify,qqno,wechat,   "
				+ " childrentotal,spousename,spousetel,house,houserent,alimony,kinshipname,kinshiptel,kinshipadd,jobtime,jobtotal,otherrevenue,   "
				+ " severaltimes,falg4,othercontact,contactrelation,contacttel,emailcountryside,emailstreet,emailplot,emailroom,englishname,awarddate, "
				+ " age,livedate,applytype,companyname,employeetype,jobbegindate,faxnumber,flag5,housedate,startroomdate,liveduration,liveroom,livetype, "
				+ " spouseincome,ageincome,monthexpend,rentexpend,creditmonth,monthtotal,netmargin,quarterearning,flag6,oneselfincome,legalperson, "
				+ " organizationcode,businesslicense,creditcard,creditpassword,employeenumber,registeredassets,shareratio,lastyearincome,lastcost,  "
				+ " lastprofit,totalassets,lasttotalassets,companyenglishname,licensedate,organizationnature,registertype,registeradd,nationaltaxno,landtaxno,  "
				+ " setupdate,continuemonth,flag7,degression,profit,lastdegression,ownerequity,lastownerequity,flag8,relevanceid,customertype,socialno, "
				+ " mobileoldphone,customerstatus,flag10 "
				+ " ) (select customerID,sex,birthday,certtype,certid,sino,country,nationality,nativeplace,politicalface,marriage,relativetype,familyadd, "
				+ " familyzip,emailadd,familytel,mobiletelephone,unitkind,workcorp,workadd,worktel,occupation,position,employrecord, "
				+ " edurecord,eduexperience,edudegree,graduateyear,financebelong,creditlevel,evaluatedate,balancesheet,intro,      "
				+ " selfmonthincome,familymonthincome,incomesource,population,loancardno,loancardinsyear,farmersort,regionalism,staff,   "
				+ " creditfarmer,riskinclination,character,dataquality,inputorgid,inputuserid,inputdate,updatedate,remark,updateorgid,   "
				+ " updateuserid,commadd,commzip,nativeadd,workzip,headship,workbegindate,yearincome,payaccount,payaccountbank,familystatus,  "
				+ " tempsaveflag,certid18,customername,issueinstitution,maturitydate,street,community,cellno,flag2,newadd,villagetown,countryside,  "
				+ " villagecenter,plot,room,cellproperty,flag3,unitcountryside,unitstreet,unitroom,unitno,phoneman,cellphoneverify,qqno,wechat,  "
				+ " childrentotal,spousename,spousetel,house,houserent,alimony,kinshipname,kinshiptel,kinshipadd,jobtime,jobtotal,otherrevenue,     "
				+ " severaltimes,falg4,othercontact,contactrelation,contacttel,emailcountryside,emailstreet,emailplot,emailroom,englishname,awarddate,   "
				+ " age,livedate,applytype,companyname,employeetype,jobbegindate,faxnumber,flag5,housedate,startroomdate,liveduration,liveroom,livetype, "
				+ " spouseincome,ageincome,monthexpend,rentexpend,creditmonth,monthtotal,netmargin,quarterearning,flag6,oneselfincome,legalperson,       "
				+ " organizationcode,businesslicense,creditcard,creditpassword,employeenumber,registeredassets,shareratio,lastyearincome,lastcost,  "
				+ " lastprofit,totalassets,lasttotalassets,companyenglishname,licensedate,organizationnature,registertype,registeradd,nationaltaxno,landtaxno,  "
				+ " setupdate,continuemonth,flag7,degression,profit,lastdegression,ownerequity,lastownerequity,flag8,relevanceid,customertype,socialno, "
				+ " mobileoldphone,customerstatus,flag10 from  ind_info where customerID='"
				+ CustomerID + "')";
			ARE.getLog().debug(
					OUT_PUT_LOG + "syncAppServerCustomerInfo sql2:" + sql);
			st1.executeQuery(sql);
			st.close();
			st1.close();
		} else {
			// 向开发CUSTOMER_INFO更新数据
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
			Statement st1 = conn.createStatement();
			sql = "UPDATE ind_info@APPLINK set( "
					+ "sex,birthday,certtype,certid,sino,country,nationality,nativeplace,politicalface,marriage,relativetype,familyadd,  "
					+ " familyzip,emailadd,familytel,mobiletelephone,unitkind,workcorp,workadd,worktel,occupation,position,employrecord,   "
					+ " edurecord,eduexperience,edudegree,graduateyear,financebelong,creditlevel,evaluatedate,balancesheet,intro,          "
					+ " selfmonthincome,familymonthincome,incomesource,population,loancardno,loancardinsyear,farmersort,regionalism,staff,   "
					+ " creditfarmer,riskinclination,character,dataquality,inputorgid,inputuserid,inputdate,updatedate,remark,updateorgid,   "
					+ " updateuserid,commadd,commzip,nativeadd,workzip,headship,workbegindate,yearincome,payaccount,payaccountbank,familystatus,  "
					+ " tempsaveflag,certid18,customername,issueinstitution,maturitydate,street,community,cellno,flag2,newadd,villagetown,countryside,  "
					+ " villagecenter,plot,room,cellproperty,flag3,unitcountryside,unitstreet,unitroom,unitno,phoneman,cellphoneverify,qqno,wechat,   "
					+ " childrentotal,spousename,spousetel,house,houserent,alimony,kinshipname,kinshiptel,kinshipadd,jobtime,jobtotal,otherrevenue,   "
					+ " severaltimes,falg4,othercontact,contactrelation,contacttel,emailcountryside,emailstreet,emailplot,emailroom,englishname,awarddate, "
					+ " age,livedate,applytype,companyname,employeetype,jobbegindate,faxnumber,flag5,housedate,startroomdate,liveduration,liveroom,livetype, "
					+ " spouseincome,ageincome,monthexpend,rentexpend,creditmonth,monthtotal,netmargin,quarterearning,flag6,oneselfincome,legalperson, "
					+ " organizationcode,businesslicense,creditcard,creditpassword,employeenumber,registeredassets,shareratio,lastyearincome,lastcost,  "
					+ " lastprofit,totalassets,lasttotalassets,companyenglishname,licensedate,organizationnature,registertype,registeradd,nationaltaxno,landtaxno,  "
					+ " setupdate,continuemonth,flag7,degression,profit,lastdegression,ownerequity,lastownerequity,flag8,relevanceid,customertype,socialno, "
					+ " mobileoldphone,customerstatus,flag10 "
					+ " )=(select sex,birthday,certtype,certid,sino,country,nationality,nativeplace,politicalface,marriage,relativetype,familyadd, "
					+ " familyzip,emailadd,familytel,mobiletelephone,unitkind,workcorp,workadd,worktel,occupation,position,employrecord, "
					+ " edurecord,eduexperience,edudegree,graduateyear,financebelong,creditlevel,evaluatedate,balancesheet,intro,      "
					+ " selfmonthincome,familymonthincome,incomesource,population,loancardno,loancardinsyear,farmersort,regionalism,staff,   "
					+ " creditfarmer,riskinclination,character,dataquality,inputorgid,inputuserid,inputdate,updatedate,remark,updateorgid,   "
					+ " updateuserid,commadd,commzip,nativeadd,workzip,headship,workbegindate,yearincome,payaccount,payaccountbank,familystatus,  "
					+ " tempsaveflag,certid18,customername,issueinstitution,maturitydate,street,community,cellno,flag2,newadd,villagetown,countryside,  "
					+ " villagecenter,plot,room,cellproperty,flag3,unitcountryside,unitstreet,unitroom,unitno,phoneman,cellphoneverify,qqno,wechat,  "
					+ " childrentotal,spousename,spousetel,house,houserent,alimony,kinshipname,kinshiptel,kinshipadd,jobtime,jobtotal,otherrevenue,     "
					+ " severaltimes,falg4,othercontact,contactrelation,contacttel,emailcountryside,emailstreet,emailplot,emailroom,englishname,awarddate,   "
					+ " age,livedate,applytype,companyname,employeetype,jobbegindate,faxnumber,flag5,housedate,startroomdate,liveduration,liveroom,livetype, "
					+ " spouseincome,ageincome,monthexpend,rentexpend,creditmonth,monthtotal,netmargin,quarterearning,flag6,oneselfincome,legalperson,       "
					+ " organizationcode,businesslicense,creditcard,creditpassword,employeenumber,registeredassets,shareratio,lastyearincome,lastcost,  "
					+ " lastprofit,totalassets,lasttotalassets,companyenglishname,licensedate,organizationnature,registertype,registeradd,nationaltaxno,landtaxno,  "
					+ " setupdate,continuemonth,flag7,degression,profit,lastdegression,ownerequity,lastownerequity,flag8,relevanceid,customertype,socialno, "
					+ " mobileoldphone,customerstatus,flag10 from  ind_info where customerID='"
					+ CustomerID + "')  where customerID='" + CustomerID + "'";
			ARE.getLog().debug(
					OUT_PUT_LOG + "syncAppServerCustomerInfo sql3:" + sql);
			st1.executeQuery(sql);
			st.close();
			st1.close();
		}
		ARE.getLog().debug(OUT_PUT_LOG + "syncAppServerCustomerInfo end");
	}
}

class MyRunnable implements Runnable {
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:ApplyCreateInfo=========]:";

	private String CustomerType = "0310";// 客户类型（个人客户）
	private String CertType = "Ind01";// 证件类型（身份证）
	private String Status = "01";
	private String CustomerOrgType = "0310";

	private String CustomerID;

	private String HaCustomerType;
	/** 数据库连接 */
	private Transaction Sqlca = null;
	/** 当天日期 */
	private String Today = "";
	/** 集团客户标志 */
	private String sGroupType = "";
	// /////////////////////////////////////////////BUSINESS_CONTRACT///////////////////////////////////////////////////
	private String CreditID;
	private String CreditAttribute = "0002";// 消费贷合同标识
	private String ApplySerialNo;// 合同号（申请编号）16位
	private String TempSaveFlag = "1";// 是否标志（1：是；2：否）
	private String InsuranceNo;// 保险公司编号
	private String SerialNo;// 合同号
	private String OperateDate;// StringFunction.getToday()
	private String UpdateDate;// StringFunction.getToday()
	private String ProductVersion = "V1.0";
	private String CreditPerson;
	private String LandmarkStatus = "1";// 地标状态：

	private String InputDate;// DateX.format(new
	private String ContractStatus = "060";// 合同状态:060新发生
	// ////////////////////////////////////////INPUT
	// PARAMETERS///////////////////////////////////////////////////////
	private String CustomerName;// 客户名称
	private String CertID;// 身份证号
	private String UserID;
	private String OrgID;
	private String sNo;
	private String ProductName;
	private String Periods;
	private String ProductID;
	private String BusinessCurrency;
	private String BusinessType;// SJ012

	private String Interiorcode;// 是否授权
	private String CreditCycle;// // 是否保险
	private String Productbrand;// 商品品牌
	private String BusinessRang1;// 商品范畴1
	private String BusinesType1;// 商品类型1
	private String Price1;
	private String ObjectType = "BusinessContract";
	private String FeeType = "A12";
	private String Insurancefee;//保险费率
	private double downPayment;// 首付金额
	private double monthlyinsurance;// 保险费率 月
	private String Paymentrate;// 首付比例
	private String saleManagerNo;// 销售经理
	private String cityManager;// 城市经理

	String LowPrinciPalMin = "", TallPrinciPalMax = "", ShoufuRatio = "",
			ShoufuRatioType = "", sRateType = "", monthcalculationMethod = "",
			sRateFloatType = "", cProductType = "";
	String highestLoansProportion = "", whetherDiscount = "",
			dMonthlyInterstRate = "", managementfeesrate = "",
			customerservicerates = "";

	// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public MyRunnable(
    		
    		String CustomerID,
    		String ApplySerialNo,
    		String  SerialNo,
    		String CustomerName,
    		String CertID,
    		String UserID,
    		String OrgID,
    		String sNo,
    		String ProductName,
    		String Periods,
    		String ProductID,
    		String BusinessCurrency,
    		String BusinessType,
    		String Interiorcode,
    		String CreditCycle,
    		String Productbrand,
    		String BusinessRang1,
    		String BusinesType1,
    		String Price1,


    		double downPayment,
    		String Paymentrate,
    		String Insurancefee,
    		String saleManagerNo,
    		String cityManager)
    {
    	this.CustomerID=CustomerID;
    	this.ApplySerialNo=ApplySerialNo;
    	this.SerialNo=SerialNo;
    	this.CustomerName=CustomerName;
    	this.CertID=CertID;
    	this.UserID=UserID;
    	this.OrgID=OrgID;
    	this.sNo=sNo;
    	this.ProductName=ProductName;
    	this.Periods=Periods;
    	this.ProductID=ProductID;
    	this.BusinessCurrency=BusinessCurrency;
    	this.BusinessType=BusinessType;
    	this.Interiorcode=Interiorcode;
    	this.CreditCycle=CreditCycle;
    	this.Productbrand=Productbrand;
    	this.BusinessRang1=BusinessRang1;
    	this.BusinesType1=BusinesType1;
    	this.Price1=Price1;
    	this.Insurancefee=Insurancefee;

    	this.downPayment=downPayment;
    	this.monthlyinsurance=monthlyinsurance;
    	this.Paymentrate=Paymentrate;
    	this.saleManagerNo=saleManagerNo;
    	this.cityManager=cityManager;
    }
	
	public void run() {
		System.out.println("MyRunnable running");
		Connection conn = null;
		
		try {
			conn=ARE.getDBConnection(FinalNum.DATASOUTCE);
			Sqlca = new Transaction(conn);
			JBOTransaction tx = JBOFactory.createJBOTransaction();
			tx.join(Sqlca);
			
			// 取得贷款人信息
			getCreditInfo();
			// 取得保险公司信息
			getInsuranceInfo();
			// 保存商品信息
			AddBusinessContract();
			// 初始化规则引擎
			initWorkFlow();
			

			inserRateInfo();// 加入费率信息试算
			this.Sqlca.commit();
		} catch (Exception e) {
               System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"+e.getMessage());
		}

		finally {
			if(this.Sqlca!=null){
				try {
					this.Sqlca.disConnect();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (conn != null)
				try {
					if (!conn.isClosed())
						conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}

	}

	/**
	 * 合同保存为合同生效
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	private void SetBusinessMaturity() throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "SetBusinessMaturity begin");
		//首次还款日
		String sFirstDueDate = "";
		String sDefaultDueDay = "";
		String temDay = "";
		String sSpecialDay = "";//是否特殊发放日
		int iDaytemp =0;
		//String businessDate = DateX.format(new java.util.Date(), "yyyy/MM/dd");
		String businessDate =SystemConfig.getBusinessDate();
		temDay = businessDate.substring(8, 10);
		if(temDay.equals("29")){
			temDay = "02";
			sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
			sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
			sSpecialDay = "1";
		}else if(temDay.equals("30")){
			temDay = "03";
		    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
			sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
			sSpecialDay = "1";
		}else if(temDay.equals("31")){
			temDay = "04";
		    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
			sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
			sSpecialDay = "1";
		}else{
			sFirstDueDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 1);
		}
		iDaytemp = DateFunctions.getDays(DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 1), sFirstDueDate);
		
	    System.out.println("******************************************************"+sFirstDueDate+"****************");

		// 一个客户多个合同的情况，判定首次还款日，取客户之前最早的合同
		String sFirstNextDueDate = "";
		int sDays = 0;
		String minSerialNo = Sqlca
				.getString(new SqlObject(
						"SELECT min(serialno) FROM business_contract where finishdate is null and CONTRACTSTATUS = '050' and customerid = :CustomerID and serialno <> :serialno ")
						.setParameter("CustomerID", CustomerID).setParameter(
								"serialno", CustomerID));
		ARE.getLog().debug(
				OUT_PUT_LOG + "SetBusinessMaturity minSerialNo:" + minSerialNo);
		if (minSerialNo == null)
			minSerialNo = "";
		if (!minSerialNo.equals("")) {
			sFirstNextDueDate = Sqlca
					.getString(new SqlObject(
							"SELECT NEXTDUEDATE FROM acct_loan where loanstatus in ('0','1') and putoutno = :minSerialNo ")
							.setParameter("minSerialNo", minSerialNo));
			if (sFirstNextDueDate == null)
				sFirstNextDueDate = "";
			if (!sFirstNextDueDate.equals("")) {
				sDays = DateFunctions.getDays(businessDate, sFirstNextDueDate);
				if (sDays >= 14) {
					sFirstDueDate = sFirstNextDueDate;
				} else {
					sFirstDueDate = DateFunctions
							.getRelativeDate(sFirstNextDueDate,
									DateFunctions.TERM_UNIT_MONTH, 1);
				}
				temDay = sFirstDueDate.substring(8, 10);
			}
		}
		Sqlca.executeSQL("update acct_rpt_segment a set a.firstduedate='"
				+ sFirstDueDate + "',defaultdueday = '" + temDay
				+ "'  where objectno='" + SerialNo + "' ");
		ARE.getLog().debug(
				OUT_PUT_LOG + "SetBusinessMaturity update sql:"
						+ "update acct_rpt_segment a set a.firstduedate='"
						+ sFirstDueDate + "' ,defaultdueday = '" + temDay
						+ "' where objectno='" + SerialNo + "' ");

		Sqlca.executeSQL("update Business_Contract set PUTOUTDATE = '"
				+ businessDate + "',ORIGINALPUTOUTDATE = '" + sFirstDueDate
				+ "',CONTRACTEFFECTIVEDATE='" + businessDate
				+ "'  where SerialNo = '" + SerialNo + "' ");
		ARE.getLog().debug(
				OUT_PUT_LOG + "SetBusinessMaturity update sql:"
						+ "update Business_Contract set PUTOUTDATE = '"
						+ businessDate + "',ORIGINALPUTOUTDATE = '"
						+ sFirstDueDate + "',CONTRACTEFFECTIVEDATE='"
						+ businessDate + "'  where SerialNo = '" + SerialNo
						+ "' ");
		Sqlca.commit();
		ARE.getLog().debug(OUT_PUT_LOG + "SetBusinessMaturity end ");

	}

	/**
	 * 插入业务子表，添加是否需要上传贷后资料字段
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	private void insertCheckContract() throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "insertCheckContract begin");
		String uploadFlag = "";
		if(BusinesType1 == null || "".equals(BusinesType1)){
			uploadFlag = "3"; //商品类型为空，上传贷后资料状态设置为无需上传
		}else {
			uploadFlag = getUploadFlag(BusinesType1);
		}
		String sql = "insert into Check_Contract (CONTRACTSERIALNO, UPLOADFLAG) "
				+ "values ('"
				+ SerialNo
				+ "', '"
				+ uploadFlag
				+"')";
		ARE.getLog().debug(OUT_PUT_LOG + "insertCheckContract sql:" + sql);
		try
		{
			Sqlca.executeSQL(sql);
			Sqlca.commit();
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		ARE.getLog().debug(OUT_PUT_LOG + "insertCheckContract end");
	}
	/**
	 * 加入利率，还款方式
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	private void inserTermPara() throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara begin");
//		Connection  conn=ARE.getDBConnection(FinalNum.DATASOUTCE);
//		Transaction Sqlca = new Transaction(conn);
//		JBOTransaction tx = JBOFactory.createJBOTransaction();
//		tx.join(Sqlca);
		ASResultSet rs = null;
		// 定义变量：查询列名、显示模版名称、申请类型、发生类型、暂存标志
		String sFieldName = "", sDisplayTemplet = "", sApplyType = "", sOccurType = "", sTempSaveFlag = "", sProductid = "", sProductcategoryname = "", sProductcategoryId = "";
		// 定义变量：关联业务币种、关联业务到期日、关联流水号、借据号
		String sOldBusinessCurrency = "", sOldMaturity = "", sRelativeSerialNo = "", dOldSerialNo = "", ssSno = "", sSno = "", sSname = "", ssSname = "", sServiceprovidersname = "", sGenusgroup = "", sCarfactoryid = "", sCreditId = "", sCreditPerson = "", sCity = "", sAttr2 = "", sCarfactory = "";
		// 定义变量：对象主表名、对应关联表名、SQL语句、产品类型、客户代码、显示属性、产品版本
		String sMainTable = "", sRelativeTable = "", sSql = "", sBusinessType = "", sCustomerID = "", sColAttribute = "", sThirdParty = "0.0", sProductVersion = "", sSalesexecutive = "", sSalesexecutiveName = "";

		// 根据对象类型从对象类型定义表中查询到相应对象的主表名
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
		ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara sql1:" + sSql);
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter(
				"ObjectType", ObjectType));
		if (rs.next()) {
			sMainTable = DataConvert.toString(rs.getString("ObjectTable"));
			sRelativeTable = DataConvert
					.toString(rs.getString("RelativeTable"));

			// 将空值转化成空字符串
			if (sMainTable == null)
				sMainTable = "";
			if (sRelativeTable == null)
				sRelativeTable = "";
		}
		rs.getStatement().close();

		// 从业务表中获得业务品种
		sSql = "select ApplyType,RelativeSerialNo,CustomerID,BusinessType,OccurType,TempSaveFlag,ProductVersion from "
				+ sMainTable + " where SerialNo =:SerialNo ";
		ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara sql2:" + sSql);
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",
				SerialNo));
		if (rs.next()) {
			sApplyType = DataConvert.toString(rs.getString("ApplyType"));
			sRelativeSerialNo = DataConvert.toString(rs
					.getString("RelativeSerialNo"));
			sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
			sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
			sOccurType = DataConvert.toString(rs.getString("OccurType"));
			sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag"));
			sProductVersion = DataConvert.toString(rs
					.getString("ProductVersion"));

			// 将空值转化成空字符串
			if (sApplyType == null)
				sApplyType = "";
			if (sRelativeSerialNo == null)
				sRelativeSerialNo = "";
			if (sCustomerID == null)
				sCustomerID = "";
			if (sBusinessType == null)
				sBusinessType = "";
			if (sOccurType == null)
				sOccurType = "";
			if (sTempSaveFlag == null)
				sTempSaveFlag = "";
		}
		rs.getStatement().close();
		// 获取关联产品的参数

		int iPeriods = 0;
		String sSqlBT = " select term,MONTHLYINTERESTRATE,LOWPRINCIPAL,TALLPRINCIPAL,SHOUFURATIO,SHOUFURATIOTYPE,ratetype,monthcalculationMethod,floatingManner,highestLoansProportion,whetherDiscount,producttype,managementfeesrate,customerservicerates from business_type where typeno='"
				+ sBusinessType + "' ";
		ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara sql3:" + sSqlBT);
		rs = Sqlca.getASResultSet(new SqlObject(sSqlBT));
		while (rs.next()) {
			iPeriods = rs.getInt("term");
			LowPrinciPalMin = rs.getString("LOWPRINCIPAL");
			managementfeesrate = rs.getString("managementfeesrate");
			customerservicerates = rs.getString("customerservicerates");
			TallPrinciPalMax = rs.getString("TALLPRINCIPAL");
			ShoufuRatio = rs.getString("SHOUFURATIO");
			ShoufuRatioType = rs.getString("SHOUFURATIOTYPE");
			sRateType = DataConvert.toString(rs.getString("rateType"));// 利率类型
																		// modify
																		// by
																		// jli5
																		// 处理null
			monthcalculationMethod = rs.getString("monthcalculationMethod");// 月供计算方式
			sRateFloatType = rs.getString("floatingManner");// 利率浮动方式
			dMonthlyInterstRate = rs.getString("MONTHLYINTERESTRATE");// 产品月利率

			highestLoansProportion = rs.getString("highestLoansProportion");// 最高贷款比例
			whetherDiscount = rs.getString("whetherDiscount");// 是否贴息
			cProductType = rs.getString("producttype");// 区分汽车金融/融资租赁
														// 01：汽车，02：融资
		}
		rs.getStatement().close();

		// 是否有保险费
		String productobjectno = sBusinessType + "-V1.0";
		Double CredFeeRate = 0.0;
		Double CredFeeRateAll = 0.0;
		String CredTermID = Sqlca
				.getString(new SqlObject(
						"select termid from product_term_library where subtermtype = 'A12' and objecttype='Product' and objectno='"
								+ productobjectno + "' "));
		if (CredTermID == null)
			CredTermID = "";
		if (!"".equals(CredTermID)) {
			CredFeeRate = DataConvert
					.toDouble(Sqlca
							.getString(new SqlObject(
									"select defaultvalue from product_term_para where paraid='FeeRate' and termid = '"
											+ CredTermID
											+ "' and objectno='"
											+ productobjectno + "' ")));
			monthlyinsurance = CredFeeRate;
			CredFeeRateAll = CredFeeRate * iPeriods;
		}

		ARE.getLog().debug(
				OUT_PUT_LOG + "inserTermPara CredFeeRateAll:" + CredFeeRateAll);
		
		try{
			ProductManage productManager = new ProductManage(Sqlca);
			if (CreditAttribute .equals("0002")) {// 消费贷
				String sTermID = "RPT17";// 等额本息'
				productManager.setAttribute("TermID", sTermID);
				productManager.setAttribute("ObjectType", ObjectType);
				productManager.setAttribute("ObjectNo", SerialNo);
				productManager.initObjectWithProduct();
				// 固定利率
				productManager.setAttribute("TermID", "RAT002");
				productManager.initObjectWithProduct();
				// 创建费用
				CreateFeeList createFeeList = new CreateFeeList();
				createFeeList.setAttribute("BusinessType", BusinessType);
				createFeeList.setAttribute("ObjectType", ObjectType);
				createFeeList.setAttribute("ObjectNo", SerialNo);
				createFeeList.setAttribute("UserID", UserID);
				createFeeList.setAttribute("CreditCycle", CreditCycle);

				createFeeList.run(Sqlca);
				Sqlca.commit();
				if (!"1".equals(CreditCycle)) {// 不投保
					// 删除管理的保险费 方案信息
					String sql = "DELETE from acct_fee where feetype='"
							+ FeeType
							+ "' and objecttype='jbo.app.BUSINESS_CONTRACT' and objectno='"
							+ SerialNo + "'";
					ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara sql3:" + sql);
					Sqlca.executeSQL(sql);
				} else {
					UpdateColValue updateColValue = new UpdateColValue();
					updateColValue.setAttribute("ColName", "String@FeeRate@"
							+ CredFeeRateAll);
					updateColValue.setAttribute("TableName", "ACCT_FEE");
					updateColValue.setAttribute("WhereClause",
							"String@FeeType@A12@String@ObjectNo@" + SerialNo);
					updateColValue.run(Sqlca);// 保险费
				}
				// 临时账户信息
				String sql1 = "insert into ACCT_DEPOSIT_ACCOUNTS (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS )"
						+ " values ('"
						+ DBKeyHelp.getSerialNo()
						+ "', '"
						+ SerialNo
						+ "', 'jbo.app.BUSINESS_CONTRACT', '01', 'XFD10500142001', '01', '消费贷客户', '2', '1', '', '00', '0')";
				ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara sql5:" + sql1);
				String sql2 = "insert into ACCT_DEPOSIT_ACCOUNTS (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS) "
						+ "values ('"
						+ DBKeyHelp.getSerialNo()
						+ "', '"
						+ SerialNo
						+ "', 'jbo.app.BUSINESS_CONTRACT', '01', '深圳市佰仟金融服务有限公司', '01', '深圳市佰仟金融服务有限公司', '2', '1', '', '01', '0')";
				ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara sql6:" + sql2);
				try
				{
					Sqlca.executeSQL(sql1);
					Sqlca.executeSQL(sql2);
					Sqlca.commit();
				}
				catch(Exception e)
				{
					System.out.println(e.getMessage());
				}
				this.Sqlca.disConnect();
//				finally {
//					if(Sqlca!=null){
//						try {
//							Sqlca.disConnect();
//						} catch (SQLException e) {
//							e.printStackTrace();
//						}
//					}
//					if (conn != null)
//						try {
//							if (!conn.isClosed())
//								conn.close();
//						} catch (SQLException e) {
//							e.printStackTrace();
//						}
//				}
			}}
		catch(Exception e)
		{
			ARE.getLog().debug(OUT_PUT_LOG + "Exception ："+e.getMessage());
			
		}
		

			ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara end");
		
		
		
	}

	/**
	 * 取得贷款人信息
	 * 
	 * @throws Exception
	 */
	private void getCreditInfo() throws Exception {
		// 定义变量：查询结果集
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo begin");
		ASResultSet rs = null;
		// 销售门店
		if (sNo == null)
			sNo = "";

		// 门店地址
		String sCity = Sqlca
				.getString(new SqlObject(
						"select city from store_info si where si.identtype='01' and si.sno=:sno")
						.setParameter("sno", sNo));
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo sCity:" + sCity);
		// 获取贷款人信息
		String sSql = "select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName"
				+ " from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '0' " +
						"and pc.serialno=sp.serialno and sp.loaner = '010' and pc.areacode='"+sCity+"'" ;
		
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo sql:" + sSql);
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {
			CreditID = DataConvert.toString(rs.getString("SerialNo"));// 贷款人编号
			CreditPerson = DataConvert.toString(rs
					.getString("ServiceProvidersName"));// 贷款人名称

		}
		// 将空值转化成空字符串
		if (CreditID == null)
			CreditID = "";
		if (CreditPerson == null)
			CreditPerson = "";
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo 贷款人编号:" + CreditID);
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo 贷款人名称:" + CreditPerson);
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo end");
	}

	/**
	 * 取得保险公司信息
	 * 
	 * @throws SQLException
	 */
	private void getInsuranceInfo() throws SQLException {
		// 通过门店编号所在城市查询到对应城市所在的保险公司编号
		ARE.getLog().debug(OUT_PUT_LOG + "getInsuranceInfo begin");
		String cityNo = Sqlca.getString(new SqlObject(
				"select city from store_info where sno=:sno").setParameter(
				"sno", sNo));
		InsuranceNo = Sqlca
				.getString(new SqlObject(
						"select insuranceno from InsuranceCity_Info  where cityno=:cityno")
						.setParameter("cityno", cityNo));

		ARE.getLog().debug(
				OUT_PUT_LOG + "getInsuranceInfo InsuranceNo:" + InsuranceNo);
		ARE.getLog().debug(OUT_PUT_LOG + "getInsuranceInfo end");
	}
	
	
	private String getUploadFlag(String businessType1) throws SQLException {
		// 通过商品类型获取该笔合同是否需要上传贷后资料
		String sUploadFlag = "";
		ARE.getLog().debug(OUT_PUT_LOG + "getUploadFlag begin");
		String count = Sqlca.getString(new SqlObject(
				"select count(*) from product_ecm_upload  where product_type_id = :product_type_id").setParameter(
				"product_type_id", businessType1));
		if(new Integer(count).intValue() > 0){
			sUploadFlag = "2";     //需要上传贷后资料，设置上传状态为未上传
		}else {
			sUploadFlag = "3";	   //无需上传贷后资料，设置上传状态为无需上传
		}
		ARE.getLog().debug(OUT_PUT_LOG + "getUploadFlag end");
		ARE.getLog().debug(
				OUT_PUT_LOG + "UploadFlag:" + sUploadFlag);
		return sUploadFlag;
	}

	@SuppressWarnings("deprecation")
	private void AddBusinessContract() throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "AddBusinessContract begin");
		OperateDate = StringFunction.getToday();
		UpdateDate = StringFunction.getToday();

		double price2 = Arith.sub(Double.parseDouble(Price1), downPayment);

		//InputDate = DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss");
		InputDate = SystemConfig.getBusinessTime();
		//String OutputDate = DateX.format(new java.util.Date(), "yyyy/MM/dd");
		String OutputDate = SystemConfig.getBusinessDate();
		
		String sql = "insert into BUSINESS_CONTRACT ("
				+ "insurancesum,suretype,CreditID,CreditAttribute,InputOrgID,ApplySerialNo,TempSaveFlag,BusinessType,CertID,"
				+ "InsuranceNo,OperateOrgID,ProductName,CustomerType,Stores,Periods,SerialNo,OperateDate,"
				+ "UpdateDate,CustomerName,ProductVersion,CreditPerson,InputUserID,ProductID,LandmarkStatus,"
				+ "CertType,BusinessCurrency,OperateUserID,InputDate,CustomerID,ContractStatus,"
				+ "businessrange1,businesstype1,Creditcycle,Interiorcode,price1,"
				+ "totalsum1,BusinessSum,BrandType1,Manufacturer1,totalsum,BusinessSum1,OperatorMode,"
				+ "TOTALPRICE,Repaymentno,Repaymentname,putoutdate,salesmanager,citymanager,uploadflag) "
				+ "values ('"+Insurancefee+"','APP','"
				+ CreditID
				+ "','"
				+ CreditAttribute
				+ "','"
				+ OrgID
				+ "','"
				+ ApplySerialNo
				+ "','"
				+ TempSaveFlag
				+ "','"
				+ ProductID
				+ "','"
				+ CertID
				+ "',"
				+ "'"
				+ InsuranceNo
				+ "','"
				+ OrgID
				+ "','"
				+ ProductName
				+ "','"
				+ CustomerType
				+ "','"
				+ sNo
				+ "','"
				+ Periods
				+ "',"
				+ "'"
				+ SerialNo
				+ "','"
				+ OperateDate
				+ "','"
				+ UpdateDate
				+ "','"
				+ CustomerName
				+ "','"
				+ ProductVersion
				+ "','"
				+ CreditPerson
				+ "','"
				+ UserID
				+ "','"
				+ "030"
				+ "','"
				+ LandmarkStatus
				+ "','"
				+ CertType
				+ "','"
				+ BusinessCurrency
				+ "','"
				+ UserID
				+ "',"
				+ "'"
				+ InputDate
				+ "','"
				+ CustomerID
				+ "','"
				+ ContractStatus
				+ "','"
				+ BusinessRang1
				+ "','"
				+ BusinesType1
				+ "','"
				+ CreditCycle
				+ "','"
				+ Interiorcode

				+ "','"
				+ Price1

				+ "','"
				+ downPayment
				+ "','"
				+ price2
				+ "','"
				+ Productbrand
				+ "','" + BusinesType1

				+ "','" + downPayment + "','" + price2 + "','03','"+Price1+"','755920947910920"+CustomerID+"','深圳市佰仟金融服务有限公司','"+OutputDate
				+ "','"+saleManagerNo+"','"+cityManager+"')";//追加非中峪模式

		ARE.getLog().debug(OUT_PUT_LOG + "AddBusinessContract sql:" + sql);
		Connection conn = null;// BusinesType1
		conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		Statement st = null;
		st = conn.createStatement();
		System.out.println(sql);
		st.executeQuery(sql);
		conn.commit();
		Sqlca.commit();
		// 商品信息初始化
		//更新全流程业务子表
//		insertCheckContract();
		inserTermPara();
		SetBusinessMaturity();
		// 还款试算
		PutOutLoanTryModule putOutLoanTry = new PutOutLoanTryModule();
		putOutLoanTry.setAttribute("ObjectNO", SerialNo);
		String monthrepayment = (String) putOutLoanTry.run(Sqlca);

		String firstpayment = monthrepayment.split("@")[0];// 首次还款金额
		double firstpaymentDouble=(Double.parseDouble(firstpayment));
		BigDecimal   firstpaymentFormat   =   new   BigDecimal(firstpaymentDouble); 
		firstpaymentDouble   =   firstpaymentFormat.setScale(1,   BigDecimal.ROUND_UP).doubleValue(); 
		String secendpayment = monthrepayment.split("@")[1];// 次月还款金额
		double secendpaymentDouble=(Double.parseDouble(secendpayment));
		BigDecimal   secendpaymentFormat   =   new   BigDecimal(secendpaymentDouble); 
		secendpaymentDouble   =   secendpaymentFormat.setScale(1,   BigDecimal.ROUND_UP).doubleValue();  
		
		
		
		//String sPutOutDate = monthrepayment.split("@")[5];// 发放日
	
		String sMaturity = monthrepayment.split("@")[6];// 到期日

		String updatebc = "update Business_Contract set FIRSTDRAWINGDATE = '"
				+ firstpaymentDouble + "',monthrepayment='"
				+ secendpaymentDouble + "',putoutdate = '"
				+ OutputDate+ "',Maturity = '" + sMaturity
				+ "' where serialno='" + SerialNo + "' ";
		Sqlca.executeSQL(updatebc);
		ARE.getLog().debug("======SerialNo======" + SerialNo);

		List<BusinessObject> feeList = putOutLoanTry.getFeeList();
		ARE.getLog().debug("======feeList======" + feeList);

		List<BusinessObject> psloans = putOutLoanTry.getPsloans();
		ARE.getLog().debug("======psloans======" + psloans);

		if (feeList != null && psloans != null) {
			for (BusinessObject loan : psloans) {
				String SEQID = loan.getString("SEQID");// 期次
				String PAYPRINCIPALAMT = loan.getString("PAYPRINCIPALAMT");// 本金金额
				String PAYTYPE = loan.getString("PAYTYPE");// 类型
															// ACCT_PAYMENT_SCHEDULE
				String PAYINTEAMT = loan.getString("PAYINTEAMT");// 应还利息
				ARE.getLog().debug(
						"###################################PAYINTEAMT======"
								+ PAYINTEAMT);
				if (PAYINTEAMT != null) {
					// 应还期金额小数点后两位
					String PAYDATE = loan.getString("PAYDATE");// 应还日期
					String _sql = "";
					ARE.getLog().debug("======OperateDate======" + OperateDate);
					ARE.getLog().debug("======PAYTYPE=====" + PAYTYPE);
					String stampduty = getFeeByPayType("A11", feeList);// 印花税
					String servicecharge = getFeeByPayType("A2", feeList);// 客户服务费
					servicecharge = getFee(servicecharge,
							Integer.parseInt(Periods));
					String managementexpense = getFeeByPayType("A7", feeList);// 财务顾问费
					managementexpense = getFee(managementexpense,
							Integer.parseInt(Periods));
					String addedservice = getFeeByPayType("A12", feeList);// 增值服务费
					addedservice = getFee(addedservice,
							Integer.parseInt(Periods));
					_sql = "insert into repayment_plan_info@applink(applyno,period,createdate,createuser,businesssum,interest,repaymentdate,"
							+ "stampduty,servicecharge,managementexpense,valueaddedservice)"
							+ " values('"
							+ SerialNo
							+ "','"
							+ SEQID
							+ "',to_date('"
							+ OperateDate
							+ "','yyyy/MM/dd'),'amar','"
							+ ""
							+ PAYPRINCIPALAMT
							+ "','"
							+ PAYINTEAMT
							+ "',to_date('"
							+ PAYDATE
							+ "','yyyy/MM/dd'),'"
							+ stampduty
							+ "',"
							+ "'"
							+ servicecharge
							+ "','"
							+ managementexpense + "','" + addedservice + "')";

					ARE.getLog().debug(
							OUT_PUT_LOG + "AddBusinessContract sql:" + _sql);
					Sqlca.executeSQL(_sql);
				}

			}
			Sqlca.commit();
			this.Sqlca.disConnect();
		}
		ARE.getLog().debug(OUT_PUT_LOG + "AddBusinessContract end");
	}

	private String getFee(String amount, double size) {
		if (amount != null && !amount.equals("0.0")) {
			try {
				Double input = Double.valueOf(amount);

				return Arith.div(input, size, 2) + "";
			} catch (Exception e) {

			}
		}
		return "0.0";
	}

	private String getFeeByPayType(String paytype, List<BusinessObject> feelist)
			throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "getFeeByPayType begin");
		if (feelist != null) {
			for (BusinessObject fee : feelist) {
				// ARE.getLog().debug(OUT_PUT_LOG+fee.getString("FEETYPE"));
				// ARE.getLog().debug(OUT_PUT_LOG+fee.getString("AMOUNT"));
				if (fee.getString("FEETYPE") != null
						&& fee.getString("FEETYPE").equals(paytype)) {
					ARE.getLog().debug(OUT_PUT_LOG + "getFeeByPayType end");
					return fee.getString("AMOUNT");
				}
			}
		}
		ARE.getLog().debug(OUT_PUT_LOG + "getFeeByPayType end");
		return "0.0";
	}

	

	// 判断开发库是否有合同信息或客户
	public boolean toCustomerID(String CertID, String sCustmerName) {
		boolean flag = false;
		Connection conn = null;
		String sql = "";
		String temp = "";
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
			Statement st = conn.createStatement();
			sql = "select count(1) as count from customer_info where customerName='"
					+ sCustmerName + "' and certID='" + CertID + "'";
			ResultSet rs = st.executeQuery(sql);
			if (rs.next()) {
				temp = rs.getString("count");
				if (temp.equals("1")) {
					flag = true;
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return flag;
	}

	private void initWorkFlow() throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "initWorkFlow begin");
		// 初始化流程
		Bizlet bzInitFlow = new InitializeFlow();

		bzInitFlow.setAttribute("ObjectType", "BusinessContract");
		bzInitFlow.setAttribute("ObjectNo", SerialNo);
		bzInitFlow.setAttribute("ApplyType", "CreditLineApply");
		bzInitFlow.setAttribute("UserID", UserID);
		bzInitFlow.setAttribute("OrgID", OrgID);
		bzInitFlow.setAttribute("FlowNo", "CreditFlow");
		bzInitFlow.setAttribute("PhaseNo", "0010");
		bzInitFlow.setAttribute("PhaseType", "1010");
		bzInitFlow.run(Sqlca);
		Sqlca.getTransaction().commit();
		Sqlca.disConnect();
		ARE.getLog().debug(OUT_PUT_LOG + "initWorkFlow end");
	}

	/**
	 * 插入数据至CUSTOMER_BELONG
	 * 
	 * @param attribute
	 *            [主办权，信息查看权，信息维护权，业务办理权]标志
	 * @throws JBOException
	 */
	protected void insertCustomerBelong(String attribute, String customerID,
			String userID, String orgID, JBOTransaction tx) throws JBOException {
		String sToday = StringFunction.getToday();
		BizObjectManager m = JBOFactory.getFactory().getManager(
				"jbo.app.CUSTOMER_BELONG");
		BizObject bo = m.newObject();

		bo.setAttributeValue("CustomerID", customerID); // 客户ID
		bo.setAttributeValue("OrgID", orgID); // 有权机构ID
		bo.setAttributeValue("UserID", userID); // 有权人ID
		bo.setAttributeValue("BelongAttribute", attribute); // 主办权
		bo.setAttributeValue("BelongAttribute1", attribute); // 信息查看权
		bo.setAttributeValue("BelongAttribute2", attribute); // 信息维护权
		bo.setAttributeValue("BelongAttribute3", attribute); // 业务办理权
		bo.setAttributeValue("BelongAttribute4", attribute);
		bo.setAttributeValue("InputOrgID", orgID); // 登记机构
		bo.setAttributeValue("InputUserID", userID); // 登记人
		bo.setAttributeValue("InputDate", sToday); // 登记日期
		bo.setAttributeValue("UpdateDate", sToday); // 更新日期
		tx.join(m);
		m.saveObject(bo);
	}

	/**
	 * 新增公司客户概况信息(ENT_INFO)
	 * 
	 * @param entCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void insertEntInfo(EntCustomer entCustomer,
			JBOTransaction tx) throws JBOException {
		BizObjectManager m = JBOFactory.getFactory().getManager(
				"jbo.app.ENT_INFO");
		BizObject bo = m.newObject();

		bo.setAttributeValue("CustomerID", entCustomer.getCustomerID()); // 客户ID
		bo.setAttributeValue("EnterpriseName", entCustomer.getCustomerName()); // 客户名称
		bo.setAttributeValue("OrgNature", entCustomer.getOrgNature()); // 机构性质
		// bo.setAttributeValue("GroupFlag", sGroupType); // 集团客户标志
		bo.setAttributeValue("InputOrgID", entCustomer.getInputOrgID()); // 登记机构
		bo.setAttributeValue("UpdateOrgID", entCustomer.getUpdateOrgID()); // 更新机构
		bo.setAttributeValue("InputUserID", entCustomer.getInputUserID()); // 登记人
		bo.setAttributeValue("UpdateUserID", entCustomer.getUpdateDate()); // 更新人
		bo.setAttributeValue("InputDate", entCustomer.getInputDate()); // 登记日期
		bo.setAttributeValue("UpdateDate", entCustomer.getUpdateDate()); // 更新日期
		bo.setAttributeValue("TempSaveFlag", "1"); // 暂存标志

		if ("Ent02".equals(entCustomer.getCertType())) { // 证件类型为营业执照
			bo.setAttributeValue("LicenseNo", entCustomer.getCertID()); // 营业执照号
		} else { // 其他证件 // if("Ent01".equals(certType)){ // 证件类型为组织机构代码
			bo.setAttributeValue("CorpID", entCustomer.getCertID()); // 证件编号（组织机构代码证编号）
		}
		tx.join(m);
		m.saveObject(bo);
	}

	/**
	 * 新增个人客户概况信息(IND_INFO)
	 * 
	 * @param entCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void insertIndInfo(IndCustomer indCustomer,
			JBOTransaction tx) throws JBOException {
		BizObjectManager m = JBOFactory.getFactory().getManager(
				"jbo.app.IND_INFO");
		BizObject bo = m.newObject();

		bo.setAttributeValue("CustomerID", indCustomer.getCustomerID()); // 客户ID
		bo.setAttributeValue("CustomerName", indCustomer.getCustomerName()); // 客户名称
		bo.setAttributeValue("CertID", indCustomer.getCertID()); // 证件编号
		bo.setAttributeValue("CertType", indCustomer.getCertType()); // 证件类型
		bo.setAttributeValue("CertID18", indCustomer.getCertID18()); // 18位身份证号
		bo.setAttributeValue("InputOrgID", indCustomer.getInputOrgID()); // 登记机构
		bo.setAttributeValue("UpdateOrgID", indCustomer.getUpdateOrgID()); // 更新机构
		bo.setAttributeValue("InputUserID", indCustomer.getInputUserID()); // 登记人
		bo.setAttributeValue("UpdateUserID", indCustomer.getUpdateDate()); // 更新人
		bo.setAttributeValue("InputDate", indCustomer.getInputDate()); // 登记日期
		bo.setAttributeValue("UpdateDate", indCustomer.getUpdateDate()); // 更新日期
		bo.setAttributeValue("TempSaveFlag", "1"); // 暂存标志

		tx.join(m);
		m.saveObject(bo);
	}

	private String runAddCustomAction(Transaction Sqlca) throws Exception {
		/**
		 * 获取参数
		 */

		if (CustomerType == null)
			CustomerType = "";
		if (CustomerName == null)
			CustomerName = "";
		if (CertType == null)
			CertType = "";
		if (CertID == null)
			CertID = "";
		if (CustomerID == null)
			CustomerID = "";
		if (CustomerOrgType == null)
			CustomerOrgType = "";
		if (Status == null)
			Status = "";
		if (UserID == null)
			UserID = "";
		if (OrgID == null)
			OrgID = "";
		if (HaCustomerType == null)
			HaCustomerType = "";

		this.Sqlca = Sqlca;
		// 获取客户编号
		String sTempCustomerId = Sqlca
				.getString(new SqlObject(
						"SELECT CUSTOMERID FROM IND_INFO WHERE CUSTOMERNAME=:CUSTOMERNAME AND CERTID=:CERTID")
						.setParameter("CUSTOMERNAME", CustomerName)
						.setParameter("CERTID", CertID));
		if (sTempCustomerId != null) {
			return sTempCustomerId;
		} else {
			// 如果客户不存在，则新增
			GenerateSerialNo generateSeriaNo = new GenerateSerialNo();
			generateSeriaNo.setTableName("IND_INFO");
			generateSeriaNo.setColName("CUSTOMERID");
			CustomerID = generateSeriaNo.getCustomerId(Sqlca);
		}

		/**
		 * 变量定义
		 */
		String sReturn = "0";

		/**
		 * 程序逻辑
		 */
		Today = StringFunction.getToday();

		/** 根据客户类型设置集团客户类型 */
		if (CustomerType.equals("0210")) {
			sGroupType = "1";// 一类集团
		} else if (CustomerType.equals("0220")) {
			sGroupType = "2";// 二类集团
		} else {
			sGroupType = "0";// 单一客户
		}

		// 01为无该客户
		if (Status.equals("01")) {
			try {
				/**
				 * 1.插入CI表
				 */
				insertCustomerInfo(CustomerType);
				/**
				 * 2.插入CB表,默认全部相关权限
				 */
				insertCustomerBelong("1");

				/**
				 * 插入ENT_INFO或者IND_INFO表
				 */
				// 公司客户或者集团客户
				if (CustomerType.substring(0, 2).equals("01")
						|| CustomerType.substring(0, 2).equals("02")) {
					insertEntInfo(CustomerType, CertType);
				} else if (CustomerType.substring(0, 2).equals("03")) {// 消费贷个人客户
					insertIndInfo(CertType);
				} else if (CustomerType.equals("03")) {// 汽车贷个人客户
					insertIndInfo(CertType);
				} else if (CustomerType.equals("04")) {// 汽车贷自雇客户
					insertEntInfo(CustomerType, CertType);
				} else if (CustomerType.equals("05")) {// 汽车贷公司客户
					insertEntInfo(CustomerType, CertType);
				}
				sReturn = "1";
			} catch (Exception e) {
				throw new Exception("事务处理失败！" + e.getMessage());
			}
			// 该客户没有与任何用户建立有效关联
		} else if (Status.equals("04")) {
			if (HaCustomerType.equals(CustomerType)) {
				/**
				 * 将来源渠道由"2"变成"1"
				 */
				String sSql = " update CUSTOMER_INFO set Channel = '1' where CustomerID =:CustomerID ";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",
						CustomerID));
				/**
				 * 插入CB表,默认全部相关权限
				 */
				insertCustomerBelong("1");
				sReturn = "1";
			} else {
				/** 存在引入客户类型错误 */
				sReturn = "2";
			}
		} else if (Status.equals("05")) {
			if (HaCustomerType.equals(CustomerType)) {
				insertCustomerBelong("2");
				sReturn = "1";
			} else {
				sReturn = "2";
			}
		}
		this.Sqlca.commit();
		this.Sqlca.disConnect();
		return sReturn;

	}

	/**
	 * 插入数据至CUSTOMER_INFO
	 * 
	 * @param cusotmerType
	 *            客户类型，不同的客户类型，插入的字段会有所不同
	 * @throws Exception
	 */
	private void insertCustomerInfo(String customerType) throws Exception {
		StringBuffer sbSql = new StringBuffer();
		SqlObject so;// 声明对象
		sbSql.append(" insert into CUSTOMER_INFO(")
				.append(" CustomerID,")
				// 010.客户编号
				.append(" CustomerName,")
				// 020.客户名称
				.append(" CustomerType,")
				// 030.客户类型
				.append(" CertType,")
				// 040.证件类型
				.append(" CertID,")
				// 050.证件号
				.append(" InputOrgID,")
				// 060.登记机构
				.append(" InputUserID,")
				// 070.登记用户
				.append(" InputDate,")
				// 080.登记日期
				.append(" Channel")
				// 090.来源渠道
				.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :InputOrgID, :InputUserID, :InputDate, '1')");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", CustomerID)
				.setParameter("CustomerName", CustomerName)
				.setParameter("CustomerType", CustomerType);
		// 集团客户(无证件类型，证件号)
		if (customerType.substring(0, 2).equals("02")) {
			so.setParameter("CertType", "").setParameter("CertID", "");
		} else {
			so.setParameter("CertType", CertType)
					.setParameter("CertID", CertID);
		}
		so.setParameter("InputOrgID", OrgID)
				.setParameter("InputUserID", UserID)
				.setParameter("InputDate", Today);
		Sqlca.executeSQL(so);
	}

	/**
	 * 插入数据至CUSTOMER_BELONG
	 * 
	 * @param attribute
	 *            [主办权，信息查看权，信息维护权，业务办理权]标志
	 * @throws Exception
	 */
	private void insertCustomerBelong(String attribute) throws Exception {
		StringBuffer sbSql = new StringBuffer("");
		SqlObject so;// 声明对象
		sbSql.append("insert into CUSTOMER_BELONG(")
				.append(" CustomerID,")
				// 010.客户ID
				.append(" OrgID,")
				// 020.有权机构ID
				.append(" UserID,")
				// 030.有权人ID
				.append(" BelongAttribute,")
				// 040.主办权
				.append(" BelongAttribute1,")
				// 050.信息查看权
				.append(" BelongAttribute2,")
				// 060.信息维护权
				.append(" BelongAttribute3,")
				// 070.业务办理权
				.append(" BelongAttribute4,")
				// 080.
				.append(" InputOrgID,")
				// 090.登记机构
				.append(" InputUserID,")
				// 100.登记人
				.append(" InputDate,")
				// 110.登记日期
				.append(" UpdateDate")
				// 120.更新日期
				.append(" )values(:CustomerID, :OrgID1, :UserID1, :attribute, :attribute1, :attribute2, :attribute3, :attribute4, :OrgID2, :UserID2, :InputDate, :UpdateDate)");
		so = new SqlObject(sbSql.toString())
				.setParameter("CustomerID", CustomerID)
				.setParameter("OrgID1", OrgID).setParameter("UserID1", UserID)
				.setParameter("attribute", attribute)
				.setParameter("attribute1", attribute)
				.setParameter("attribute2", attribute)
				.setParameter("attribute3", attribute)
				.setParameter("attribute4", attribute)
				.setParameter("OrgID2", OrgID).setParameter("UserID2", UserID)
				.setParameter("InputDate", Today)
				.setParameter("UpdateDate", Today);
		Sqlca.executeSQL(so);
	}

	/**
	 * 插入数据至ENT_INFO,不同的客户类型以及证件类型，插入的字段会有区别
	 * 
	 * @param customerType
	 *            客户类型
	 * @param certType
	 *            证件类型
	 * @throws Exception
	 */
	private void insertEntInfo(String customerType, String certType)
			throws Exception {
		SqlObject so = null;// 声明对象
		StringBuffer sbSql = new StringBuffer("");
		// 先插入通用信息
		sbSql.append("insert into ENT_INFO(")
				.append(" CustomerID,")
				// 010.客户ID
				.append(" CustomerName,")
				// 020.客户名称
				.append(" CustomerType,")
				// 030.客户类型
				.append(" CertType,")
				// 030.证件类型
				.append(" CertID,")
				// 050.证件号
				.append(" OrgNature,")
				// 040.机构性质
				.append(" GroupFlag,")
				// 050.集团客户标志
				.append(" InputUserID,")
				// 060.登记人
				.append(" InputOrgID,")
				// 070.登记机构
				.append(" InputDate,")
				// 080.登记日期
				.append(" UpdateUserID,")
				// 090.更新人
				.append(" UpdateOrgID,")
				// 100.更新机构
				.append(" UpdateDate,")
				// 110.更新日期
				.append(" TempSaveFlag")
				// 120.暂存标志
				.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :OrgNature, :GroupFlag, :InputUserID, :InputOrgID, :InputDate, :UpdateUserID, :UpdateOrgID, :UpdateDate, '1')");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", CustomerID)
				.setParameter("CustomerName", CustomerName)
				.setParameter("CustomerType", CustomerType)
				.setParameter("CertType", CertType)
				.setParameter("CertID", CertID)
				.setParameter("OrgNature", CustomerOrgType)
				.setParameter("GroupFlag", sGroupType);
		so.setParameter("InputUserID", UserID)
				.setParameter("InputOrgID", OrgID)
				.setParameter("InputDate", Today);
		so.setParameter("UpdateUserID", UserID)
				.setParameter("UpdateOrgID", OrgID)
				.setParameter("UpdateDate", Today);
		Sqlca.executeSQL(so);

		// 再更新特殊信息
		// [01] 公司客户 [04]自雇 [05]公司
		/*
		 * if(sCustomerType.substring(0,2).equals("01") ||
		 * sCustomerType.equals("04") || sCustomerType.equals("05")){
		 * //证件类型为营业执照 if(sCertType.equals("Ent02")){ //更新营业执照号
		 * Sqlca.executeSQL(new SqlObject(
		 * "update ENT_INFO set CertID = :CertID where CustomerID = :CustomerID"
		 * ).setParameter("CustomerID", sCustomerID).setParameter("CertID",
		 * sCertID)); //其他证件 }else{ Sqlca.executeSQL(new SqlObject(
		 * "update ENT_INFO set CorpID = :CorpID where CustomerID = :CustomerID"
		 * ).setParameter("CustomerID", sCustomerID).setParameter("CorpID",
		 * sCertID)); } //[02] 关联集团客户 }else
		 * if(sCustomerType.substring(0,2).equals("02")){
		 * //更新组织机构代码（系统自动虚拟，同集团客户编号） Sqlca.executeSQL(new SqlObject(
		 * "update ENT_INFO set CorpID = :CorpID where CustomerID = :CustomerID"
		 * ).setParameter("CustomerID", sCustomerID).setParameter("CorpID",
		 * sCustomerID)); }
		 */
	}

	/**
	 * 插入数据至IND_INFO,不同的证件类型，插入的字段会有区别
	 * 
	 * @throws Exception
	 */
	private void insertIndInfo(String certType) throws Exception {
		String sCertID18 = "";
		StringBuffer sbSql = new StringBuffer("");
		// 如果为身份证,则作18位转换
		if (certType.equals("Ind01")) {
			sCertID18 = StringFunction.fixPID(CertID);
		} else {
			sCertID18 = "";
		}

		sbSql.append("insert into IND_INFO(")
				.append(" CustomerID,")
				// 010.客户ID
				.append(" CustomerName,")
				// 020.客户名
				.append(" CustomerType,")
				// 020.客户类型
				.append(" CertType,")
				// 030.证件类型
				.append(" CertID,")
				// 040.证件号
				.append(" CertID18,")
				// 050.18位证件号
				.append(" InputOrgID,")
				// 060.登记机构
				.append(" InputUserID,")
				// 070.登记人
				.append(" InputDate,")
				// 080.登记日期
				.append(" UpdateDate,")
				// 090.更新日期
				.append(" TempSaveFlag")
				// 100.暂存标志
				.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :CertID18, :sOrgID, :sUserID, :InputDate, :UpdateDate, '1')");
		SqlObject so = new SqlObject(sbSql.toString())
				.setParameter("CustomerID", CustomerID)
				.setParameter("CustomerName", CustomerName)
				.setParameter("CustomerType", CustomerType)
				.setParameter("CertType", CertType)
				.setParameter("CertID", CertID)
				.setParameter("CertID18", sCertID18)
				.setParameter("sOrgID", OrgID).setParameter("sUserID", UserID)
				.setParameter("InputDate", Today)
				.setParameter("UpdateDate", Today);
		Sqlca.executeSQL(so);
	}

	/**
	 * 加入费率信息试算
	 * 
	 * @throws Exception
	 */
	private void inserRateInfo() throws Exception {

		ASResultSet rs = null;
		String sSql;

		double monthlyinterestrate = 0.00;// 产品月利率
		double managementfeesrate = 0.00;// 月账户管理费率
		double customerservicerates = 0.00;// 月客户服务费率

		// 根据对象类型从对象类型定义表中查询到相应对象的主表名
		sSql = " select * from BUSINESS_TYPE where TYPENO =:TYPENO ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TYPENO",
				BusinessType));
		if (rs.next()) {
			monthlyinterestrate = DataConvert.toDouble(rs
					.getString("monthlyinterestrate"));
			managementfeesrate = DataConvert.toDouble(rs
					.getString("managementfeesrate"));
			customerservicerates = DataConvert.toDouble(rs
					.getString("customerservicerates"));
		}

		rs.getStatement().close();

		// 插入临时费率试算
		String sql1 = "INSERT INTO RATE_INFO@applink " + "(" + "APPLYNO, "
				+ "CUSTOMNAME, " + "PRICE1," + "PAYMENTSUM," + "PAYMENTRATE, "
				+ "PRINCIPALCONTRACT," + "MONTHLYRATE, "
				+ "MONTHLYSERVICERATE," + "MONTHLYSERVICECHARGE, "
				+ "YEARSERVICECHARGE," + "MONTHLYMANAGEMENTRATE,"
				+ " MONTHLYFINANCERATE," + "MONTHLYFINANCE,"
				+ " MONTHLYINSURANCE," + "MONTHLYINSURANCERATE,"
				+ " YEARINSURANCE," + "YEARINSURANCERATE, "
				+ "MONTHLYMANAGEMENCHARGE," + "YEARMANAGEMENTRATE"
				+ ")VALUES (" + ":applyno," + ":customname," + " :price1,"
				+ " :paymentsum," + ":paymentrate," + " :principalcontract,"
				+ " :monthlyrate," + ":monthlyservicerate,"
				+ " :monthlyservicecharge," + " :yearservicecharge,"
				+ ":monthlymanagementrate,"
				+ " :monthlyfinancerate, :monthlyfinance,"
				+ ":monthlyinsurance," + " :monthlyinsurancerate,"
				+ " :yearinsurance," + ":yearinsurancerate,"
				+ " :monthlymanagemencharge," + " :yearmanagementrate)";
		/*
		 * public String applyno;//申请单流水号 public String customname;//客户姓名 public
		 * String price1;//商品价格 public String paymentsum;//首付金额 public String
		 * paymentrate;//首付比例 public String principalcontract;//合同本金 public
		 * String monthlyrate;//贷款月利率 public String monthlyservicerate;//贷款月服务费率
		 * public String monthlyservicecharge;//贷款月服务费 public String
		 * yearservicecharge;//贷款年服务费 public String
		 * monthlymanagementrate;//贷款月管理费率
		 * 
		 * public String monthlymanagemencharge;//贷款月管服务费 public String
		 * yearmanagementrate;//贷款年管理费率
		 * 
		 * public String monthlyfinancerate;//贷款月财务管理费率 public String
		 * monthlyfinance;//贷款月财务管理费 public String monthlyinsurance;//贷款月保险费
		 * public String monthlyinsurancerate;//贷款月保险费率 public String
		 * yearinsurance;//贷款年保险费 public String yearinsurancerate;//贷款年保险费率
		 * 
		 * double monthlyinterestrate=0.00;//产品月利率 double
		 * managementfeesrate=0.00;//月账户管理费率 double
		 * customerservicerates=0.00;//月客户服务费率
		 */
		/*Double dBusinesssum = Double.parseDouble(Price1)
				- (Arith.mul(Double.parseDouble(Price1),
						Double.parseDouble(Paymentrate) / 100));// 贷款本金*/
		Double dBusinesssum = Double.parseDouble(Price1)-downPayment;// 贷款本金
		
		Double monthlyservicecharge = Arith.mul(dBusinesssum,
				customerservicerates / 100);// 贷款月服务费
		Double yearservicecharge = Arith.mul(monthlyservicecharge, 12);// 贷款年服务费
		Double monthlymanagemencharge = (Arith.mul(dBusinesssum,
				managementfeesrate / 100));// 贷款月财务管理费
		Double yearmanagementrate = Arith.mul(managementfeesrate, 12);// 贷款年管理费
		Double monthlyfinance = (Arith.mul(dBusinesssum,
				managementfeesrate / 100));
		Double yearinsurance = (Arith.mul(
				monthlyinsurance * dBusinesssum / 100, 12));
		Double monthlyinsuranceMo = (Arith.mul(monthlyinsurance * dBusinesssum
				/ 100, 1));
		Double yearinsurancerate = (Arith.mul(monthlyinsurance, 12));
        
		ARE.getLog().debug(
				OUT_PUT_LOG + "【贷款本金】=" + dBusinesssum + "【贷款月服务费】=" + monthlyservicecharge + "【贷款年服务费】=" + yearservicecharge + "【贷款月财务管理费】=" + monthlymanagemencharge + "【贷款年管理费】=" + yearmanagementrate + "【贷款年保险费费】=" + yearinsurance+ "【月保险费】=" + monthlyinsuranceMo);
		
		SqlObject so = new SqlObject(sql1)

				.setParameter("applyno", SerialNo)
				.setParameter("customname", CustomerName)
				.setParameter("price1", Price1)
				.setParameter(
						"paymentsum",
						Arith.mul(Double.parseDouble(Price1),
								Double.parseDouble(Paymentrate) / 100))
				.setParameter("paymentrate", Paymentrate)
				.setParameter("principalcontract", Price1)
				.setParameter("monthlyrate", dMonthlyInterstRate)
				.setParameter("monthlyservicerate", customerservicerates)
				.setParameter("monthlyservicecharge", monthlyservicecharge)
				.setParameter("yearservicecharge", yearservicecharge)
				.setParameter("monthlymanagementrate", managementfeesrate)
				.setParameter("monthlyfinancerate", managementfeesrate)
				// 贷款月财务管理费率
				.setParameter("monthlyfinance", monthlyfinance)
				// 贷款月财务管理费
				.setParameter("monthlyinsurance", monthlyinsuranceMo)
				.setParameter("monthlyinsurancerate", monthlyinsurance)
				// 贷款月保险费率??????
				.setParameter("yearinsurance", yearinsurance)
				.setParameter("yearinsurancerate", yearinsurancerate)
				.setParameter("monthlymanagemencharge", monthlymanagemencharge)// 贷款月管服务费
				.setParameter("yearmanagementrate", yearmanagementrate);// 贷款年管理费率
		Sqlca.executeSQL(so);
		Sqlca.commit();

		Sqlca.disConnect();
	}
}