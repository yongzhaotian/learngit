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

		/** ���ݿ����� */
		Transaction Sqlca = null;
		/** �������� */
		String Today = "";
		String SerialNo = "";// ��ͬ��
		String ApplySerialNo = "";// ��ͬ�ţ������ţ�16λ
		String CustomerName = "";// �ͻ�����
		String CertID = "";// ���֤��
		String CustomerType = "0310";// �ͻ����ͣ����˿ͻ���
		String CertType = "Ind01";// ֤�����ͣ����֤��
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
		String Interiorcode = "";// �Ƿ���Ȩ
		String CreditCycle = "";// // �Ƿ���
		String Productbrand = "";// ��ƷƷ��
		String BusinessRang1 = "";// ��Ʒ����1
		String BusinesType1 = "";// ��Ʒ����1
		String Price1 = "";
		String Paymentrate = "";// �׸�����
		String Paymentsum = "";// �Ը����
		String Insurancefee = "";//���շ���
		double downPayment = 0.0;// �׸����
		String saleManagerNo = "";//���۾���
		String cityManager = "";// ���о���

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
			

			CreditCycle = request.getParameter("Creditcycle");// �Ƿ���
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 12:" + CreditCycle);
			Interiorcode = request.getParameter("Interiorcode");// �Ƿ���Ȩ
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 13:" + Interiorcode);
			str = request.getParameter("Productbrand");// ��ƷƷ�� 

			str = new String(str.getBytes("ISO-8859-1"), "GBK");
			Productbrand = URLDecoder.decode(str, "UTF-8");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 14:" + str);
			BusinessRang1 = request.getParameter("BusinessRang1");// ��Ʒ����1
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 15:" + BusinessRang1);
			BusinesType1 = request.getParameter("BusinesType1");// ��Ʒ����1
			ARE.getLog().debug(
					OUT_PUT_LOG + "input parameter 16:" + BusinesType1);
			Price1 = request.getParameter("Price1");
			ARE.getLog().debug(OUT_PUT_LOG + "input parameter 17:" + Price1);
			Paymentrate = request.getParameter("Paymentrate");// �׸�����
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

			//��ȡ���۾������о������ж��û��Լ��Ƿ����۾���--begin
			String exists = Sqlca.getString(new SqlObject("select 1 from STORE_INFO "
					+ " where identType='01' and status='05' and salesmanager='"+UserID+"'"));
			if(exists == null || !"1".equals(exists)){//����
				saleManagerNo = Sqlca.getString(new SqlObject("Select distinct si.salesmanager as saleManagerNo "
						+ " from STORERELATIVESALESMAN a,STORE_INFO si "
						+ " where si.identType = '01' and si.Status='05' and a.stype is null "
						+ " and a.sno=si.sno and a.SalesManNo = '"+UserID+"'"));
			}else{//��
				saleManagerNo = UserID;
			}
			saleManagerNo = saleManagerNo == null ? "" : saleManagerNo;
			cityManager = Sqlca.getString(new SqlObject("select distinct "
					+ " SuperID from user_info where userid='"+saleManagerNo+"'"));
			cityManager = cityManager == null ? "" : cityManager;
			//��ȡ���۾������о������ж��û��Լ��Ƿ����۾���--end
			
			JBOTransaction tx = JBOFactory.createJBOTransaction();
			tx.join(Sqlca);
			
			Today=StringFunction.getToday();
			List<String> list = saveRecord(Sqlca,CustomerName, CertID,CustomerType,CertType,OrgID,UserID,Today);
			ApplySerialNo = list.get(0);
			CustomerID = list.get(1);
			SerialNo = list.get(2);
			// �����û�ͬ������
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
		System.out.println("��ͬ��ţ�" + sSerialNo);
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
		if (sCustomerID == null) {// ����ͻ������ڣ�������
			sCustomerID = getCustomerId(Sqlca, "IND_INFO", "CUSTOMERID");
			//this.CustomerID = sCustomerID;
			addCustomerAction(sCustomerID,CustomerName,CustomerType,
					CertType,CertID,OrgID,UserID,Today);
		}
		ARE.getLog().debug(OUT_PUT_LOG + "InsertCustomer end");
		return sCustomerID;

	}

	/**
	 * ��ȡ�ͻ���ˮ�� ��object_maxsn���ֶ�ֵ�ڴδ������� tablename �����ƣ�columnname �����ƣ�maxserialno
	 * ��ǰ�����, datefmt ������Ѱ��Сֵ, nofmt ����
	 * 
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getCustomerId(Transaction sqlca, String tableName,
			String colName) throws Exception {
		long lMaxVal = 99999999L;
		String sStep = "11"; // ��ʼ������

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
			// ����Ѿ��������ֵ����Ѱ��Сֵ��+1
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
		// ��CUSTOMER_INFO����һ����¼
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
		// ��IND_INFO����һ����¼
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
		 * Content: ��ȡ��ˮ�� Input Param: ����: TableName ����: ColumnName ��ʽ��
		 * SerialNoFormate Output param: ��ˮ��: SerialNo
		 */
		// ��ȡ�����������͸�ʽ

		String sSerialNo = ""; // ��ˮ��

		sSerialNo = DBKeyHelp.getSerialNo(sTableName, sColumnName, Sqlca);
		return sSerialNo;
	}
	private void syncAppServerCustomerInfo(String CustomerID) throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "syncAppServerCustomerInfo begin");
		Connection conn = null;
		String sql = "";
		System.out.println("----------------�Ͽͻ�--------------------");
		System.out.println("-------------��ʼ��������---------------------");

		conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		Statement st = conn.createStatement();
		System.out.println("----------------APP �Ƿ��и��û�--------------------");
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
			// �򿪷�CUSTOMER_INFO��������
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
			// �򿪷�CUSTOMER_INFO��������
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

	private String CustomerType = "0310";// �ͻ����ͣ����˿ͻ���
	private String CertType = "Ind01";// ֤�����ͣ����֤��
	private String Status = "01";
	private String CustomerOrgType = "0310";

	private String CustomerID;

	private String HaCustomerType;
	/** ���ݿ����� */
	private Transaction Sqlca = null;
	/** �������� */
	private String Today = "";
	/** ���ſͻ���־ */
	private String sGroupType = "";
	// /////////////////////////////////////////////BUSINESS_CONTRACT///////////////////////////////////////////////////
	private String CreditID;
	private String CreditAttribute = "0002";// ���Ѵ���ͬ��ʶ
	private String ApplySerialNo;// ��ͬ�ţ������ţ�16λ
	private String TempSaveFlag = "1";// �Ƿ��־��1���ǣ�2����
	private String InsuranceNo;// ���չ�˾���
	private String SerialNo;// ��ͬ��
	private String OperateDate;// StringFunction.getToday()
	private String UpdateDate;// StringFunction.getToday()
	private String ProductVersion = "V1.0";
	private String CreditPerson;
	private String LandmarkStatus = "1";// �ر�״̬��

	private String InputDate;// DateX.format(new
	private String ContractStatus = "060";// ��ͬ״̬:060�·���
	// ////////////////////////////////////////INPUT
	// PARAMETERS///////////////////////////////////////////////////////
	private String CustomerName;// �ͻ�����
	private String CertID;// ���֤��
	private String UserID;
	private String OrgID;
	private String sNo;
	private String ProductName;
	private String Periods;
	private String ProductID;
	private String BusinessCurrency;
	private String BusinessType;// SJ012

	private String Interiorcode;// �Ƿ���Ȩ
	private String CreditCycle;// // �Ƿ���
	private String Productbrand;// ��ƷƷ��
	private String BusinessRang1;// ��Ʒ����1
	private String BusinesType1;// ��Ʒ����1
	private String Price1;
	private String ObjectType = "BusinessContract";
	private String FeeType = "A12";
	private String Insurancefee;//���շ���
	private double downPayment;// �׸����
	private double monthlyinsurance;// ���շ��� ��
	private String Paymentrate;// �׸�����
	private String saleManagerNo;// ���۾���
	private String cityManager;// ���о���

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
			
			// ȡ�ô�������Ϣ
			getCreditInfo();
			// ȡ�ñ��չ�˾��Ϣ
			getInsuranceInfo();
			// ������Ʒ��Ϣ
			AddBusinessContract();
			// ��ʼ����������
			initWorkFlow();
			

			inserRateInfo();// ���������Ϣ����
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
	 * ��ͬ����Ϊ��ͬ��Ч
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	private void SetBusinessMaturity() throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "SetBusinessMaturity begin");
		//�״λ�����
		String sFirstDueDate = "";
		String sDefaultDueDay = "";
		String temDay = "";
		String sSpecialDay = "";//�Ƿ����ⷢ����
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

		// һ���ͻ������ͬ��������ж��״λ����գ�ȡ�ͻ�֮ǰ����ĺ�ͬ
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
	 * ����ҵ���ӱ�����Ƿ���Ҫ�ϴ����������ֶ�
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	private void insertCheckContract() throws Exception {
		ARE.getLog().debug(OUT_PUT_LOG + "insertCheckContract begin");
		String uploadFlag = "";
		if(BusinesType1 == null || "".equals(BusinesType1)){
			uploadFlag = "3"; //��Ʒ����Ϊ�գ��ϴ���������״̬����Ϊ�����ϴ�
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
	 * �������ʣ����ʽ
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
		// �����������ѯ��������ʾģ�����ơ��������͡��������͡��ݴ��־
		String sFieldName = "", sDisplayTemplet = "", sApplyType = "", sOccurType = "", sTempSaveFlag = "", sProductid = "", sProductcategoryname = "", sProductcategoryId = "";
		// �������������ҵ����֡�����ҵ�����ա�������ˮ�š���ݺ�
		String sOldBusinessCurrency = "", sOldMaturity = "", sRelativeSerialNo = "", dOldSerialNo = "", ssSno = "", sSno = "", sSname = "", ssSname = "", sServiceprovidersname = "", sGenusgroup = "", sCarfactoryid = "", sCreditId = "", sCreditPerson = "", sCity = "", sAttr2 = "", sCarfactory = "";
		// �����������������������Ӧ����������SQL��䡢��Ʒ���͡��ͻ����롢��ʾ���ԡ���Ʒ�汾
		String sMainTable = "", sRelativeTable = "", sSql = "", sBusinessType = "", sCustomerID = "", sColAttribute = "", sThirdParty = "0.0", sProductVersion = "", sSalesexecutive = "", sSalesexecutiveName = "";

		// ���ݶ������ʹӶ������Ͷ�����в�ѯ����Ӧ�����������
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
		ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara sql1:" + sSql);
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter(
				"ObjectType", ObjectType));
		if (rs.next()) {
			sMainTable = DataConvert.toString(rs.getString("ObjectTable"));
			sRelativeTable = DataConvert
					.toString(rs.getString("RelativeTable"));

			// ����ֵת���ɿ��ַ���
			if (sMainTable == null)
				sMainTable = "";
			if (sRelativeTable == null)
				sRelativeTable = "";
		}
		rs.getStatement().close();

		// ��ҵ����л��ҵ��Ʒ��
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

			// ����ֵת���ɿ��ַ���
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
		// ��ȡ������Ʒ�Ĳ���

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
			sRateType = DataConvert.toString(rs.getString("rateType"));// ��������
																		// modify
																		// by
																		// jli5
																		// ����null
			monthcalculationMethod = rs.getString("monthcalculationMethod");// �¹����㷽ʽ
			sRateFloatType = rs.getString("floatingManner");// ���ʸ�����ʽ
			dMonthlyInterstRate = rs.getString("MONTHLYINTERESTRATE");// ��Ʒ������

			highestLoansProportion = rs.getString("highestLoansProportion");// ��ߴ������
			whetherDiscount = rs.getString("whetherDiscount");// �Ƿ���Ϣ
			cProductType = rs.getString("producttype");// ������������/��������
														// 01��������02������
		}
		rs.getStatement().close();

		// �Ƿ��б��շ�
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
			if (CreditAttribute .equals("0002")) {// ���Ѵ�
				String sTermID = "RPT17";// �ȶϢ'
				productManager.setAttribute("TermID", sTermID);
				productManager.setAttribute("ObjectType", ObjectType);
				productManager.setAttribute("ObjectNo", SerialNo);
				productManager.initObjectWithProduct();
				// �̶�����
				productManager.setAttribute("TermID", "RAT002");
				productManager.initObjectWithProduct();
				// ��������
				CreateFeeList createFeeList = new CreateFeeList();
				createFeeList.setAttribute("BusinessType", BusinessType);
				createFeeList.setAttribute("ObjectType", ObjectType);
				createFeeList.setAttribute("ObjectNo", SerialNo);
				createFeeList.setAttribute("UserID", UserID);
				createFeeList.setAttribute("CreditCycle", CreditCycle);

				createFeeList.run(Sqlca);
				Sqlca.commit();
				if (!"1".equals(CreditCycle)) {// ��Ͷ��
					// ɾ������ı��շ� ������Ϣ
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
					updateColValue.run(Sqlca);// ���շ�
				}
				// ��ʱ�˻���Ϣ
				String sql1 = "insert into ACCT_DEPOSIT_ACCOUNTS (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS )"
						+ " values ('"
						+ DBKeyHelp.getSerialNo()
						+ "', '"
						+ SerialNo
						+ "', 'jbo.app.BUSINESS_CONTRACT', '01', 'XFD10500142001', '01', '���Ѵ��ͻ�', '2', '1', '', '00', '0')";
				ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara sql5:" + sql1);
				String sql2 = "insert into ACCT_DEPOSIT_ACCOUNTS (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS) "
						+ "values ('"
						+ DBKeyHelp.getSerialNo()
						+ "', '"
						+ SerialNo
						+ "', 'jbo.app.BUSINESS_CONTRACT', '01', '�����а�Ǫ���ڷ������޹�˾', '01', '�����а�Ǫ���ڷ������޹�˾', '2', '1', '', '01', '0')";
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
			ARE.getLog().debug(OUT_PUT_LOG + "Exception ��"+e.getMessage());
			
		}
		

			ARE.getLog().debug(OUT_PUT_LOG + "inserTermPara end");
		
		
		
	}

	/**
	 * ȡ�ô�������Ϣ
	 * 
	 * @throws Exception
	 */
	private void getCreditInfo() throws Exception {
		// �����������ѯ�����
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo begin");
		ASResultSet rs = null;
		// �����ŵ�
		if (sNo == null)
			sNo = "";

		// �ŵ��ַ
		String sCity = Sqlca
				.getString(new SqlObject(
						"select city from store_info si where si.identtype='01' and si.sno=:sno")
						.setParameter("sno", sNo));
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo sCity:" + sCity);
		// ��ȡ��������Ϣ
		String sSql = "select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName"
				+ " from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '0' " +
						"and pc.serialno=sp.serialno and sp.loaner = '010' and pc.areacode='"+sCity+"'" ;
		
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo sql:" + sSql);
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {
			CreditID = DataConvert.toString(rs.getString("SerialNo"));// �����˱��
			CreditPerson = DataConvert.toString(rs
					.getString("ServiceProvidersName"));// ����������

		}
		// ����ֵת���ɿ��ַ���
		if (CreditID == null)
			CreditID = "";
		if (CreditPerson == null)
			CreditPerson = "";
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo �����˱��:" + CreditID);
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo ����������:" + CreditPerson);
		ARE.getLog().debug(OUT_PUT_LOG + "getCreditInfo end");
	}

	/**
	 * ȡ�ñ��չ�˾��Ϣ
	 * 
	 * @throws SQLException
	 */
	private void getInsuranceInfo() throws SQLException {
		// ͨ���ŵ������ڳ��в�ѯ����Ӧ�������ڵı��չ�˾���
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
		// ͨ����Ʒ���ͻ�ȡ�ñʺ�ͬ�Ƿ���Ҫ�ϴ���������
		String sUploadFlag = "";
		ARE.getLog().debug(OUT_PUT_LOG + "getUploadFlag begin");
		String count = Sqlca.getString(new SqlObject(
				"select count(*) from product_ecm_upload  where product_type_id = :product_type_id").setParameter(
				"product_type_id", businessType1));
		if(new Integer(count).intValue() > 0){
			sUploadFlag = "2";     //��Ҫ�ϴ��������ϣ������ϴ�״̬Ϊδ�ϴ�
		}else {
			sUploadFlag = "3";	   //�����ϴ��������ϣ������ϴ�״̬Ϊ�����ϴ�
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

				+ "','" + downPayment + "','" + price2 + "','03','"+Price1+"','755920947910920"+CustomerID+"','�����а�Ǫ���ڷ������޹�˾','"+OutputDate
				+ "','"+saleManagerNo+"','"+cityManager+"')";//׷�ӷ�����ģʽ

		ARE.getLog().debug(OUT_PUT_LOG + "AddBusinessContract sql:" + sql);
		Connection conn = null;// BusinesType1
		conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
		Statement st = null;
		st = conn.createStatement();
		System.out.println(sql);
		st.executeQuery(sql);
		conn.commit();
		Sqlca.commit();
		// ��Ʒ��Ϣ��ʼ��
		//����ȫ����ҵ���ӱ�
//		insertCheckContract();
		inserTermPara();
		SetBusinessMaturity();
		// ��������
		PutOutLoanTryModule putOutLoanTry = new PutOutLoanTryModule();
		putOutLoanTry.setAttribute("ObjectNO", SerialNo);
		String monthrepayment = (String) putOutLoanTry.run(Sqlca);

		String firstpayment = monthrepayment.split("@")[0];// �״λ�����
		double firstpaymentDouble=(Double.parseDouble(firstpayment));
		BigDecimal   firstpaymentFormat   =   new   BigDecimal(firstpaymentDouble); 
		firstpaymentDouble   =   firstpaymentFormat.setScale(1,   BigDecimal.ROUND_UP).doubleValue(); 
		String secendpayment = monthrepayment.split("@")[1];// ���»�����
		double secendpaymentDouble=(Double.parseDouble(secendpayment));
		BigDecimal   secendpaymentFormat   =   new   BigDecimal(secendpaymentDouble); 
		secendpaymentDouble   =   secendpaymentFormat.setScale(1,   BigDecimal.ROUND_UP).doubleValue();  
		
		
		
		//String sPutOutDate = monthrepayment.split("@")[5];// ������
	
		String sMaturity = monthrepayment.split("@")[6];// ������

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
				String SEQID = loan.getString("SEQID");// �ڴ�
				String PAYPRINCIPALAMT = loan.getString("PAYPRINCIPALAMT");// ������
				String PAYTYPE = loan.getString("PAYTYPE");// ����
															// ACCT_PAYMENT_SCHEDULE
				String PAYINTEAMT = loan.getString("PAYINTEAMT");// Ӧ����Ϣ
				ARE.getLog().debug(
						"###################################PAYINTEAMT======"
								+ PAYINTEAMT);
				if (PAYINTEAMT != null) {
					// Ӧ���ڽ��С�������λ
					String PAYDATE = loan.getString("PAYDATE");// Ӧ������
					String _sql = "";
					ARE.getLog().debug("======OperateDate======" + OperateDate);
					ARE.getLog().debug("======PAYTYPE=====" + PAYTYPE);
					String stampduty = getFeeByPayType("A11", feeList);// ӡ��˰
					String servicecharge = getFeeByPayType("A2", feeList);// �ͻ������
					servicecharge = getFee(servicecharge,
							Integer.parseInt(Periods));
					String managementexpense = getFeeByPayType("A7", feeList);// ������ʷ�
					managementexpense = getFee(managementexpense,
							Integer.parseInt(Periods));
					String addedservice = getFeeByPayType("A12", feeList);// ��ֵ�����
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

	

	// �жϿ������Ƿ��к�ͬ��Ϣ��ͻ�
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
		// ��ʼ������
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
	 * ����������CUSTOMER_BELONG
	 * 
	 * @param attribute
	 *            [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־
	 * @throws JBOException
	 */
	protected void insertCustomerBelong(String attribute, String customerID,
			String userID, String orgID, JBOTransaction tx) throws JBOException {
		String sToday = StringFunction.getToday();
		BizObjectManager m = JBOFactory.getFactory().getManager(
				"jbo.app.CUSTOMER_BELONG");
		BizObject bo = m.newObject();

		bo.setAttributeValue("CustomerID", customerID); // �ͻ�ID
		bo.setAttributeValue("OrgID", orgID); // ��Ȩ����ID
		bo.setAttributeValue("UserID", userID); // ��Ȩ��ID
		bo.setAttributeValue("BelongAttribute", attribute); // ����Ȩ
		bo.setAttributeValue("BelongAttribute1", attribute); // ��Ϣ�鿴Ȩ
		bo.setAttributeValue("BelongAttribute2", attribute); // ��Ϣά��Ȩ
		bo.setAttributeValue("BelongAttribute3", attribute); // ҵ�����Ȩ
		bo.setAttributeValue("BelongAttribute4", attribute);
		bo.setAttributeValue("InputOrgID", orgID); // �Ǽǻ���
		bo.setAttributeValue("InputUserID", userID); // �Ǽ���
		bo.setAttributeValue("InputDate", sToday); // �Ǽ�����
		bo.setAttributeValue("UpdateDate", sToday); // ��������
		tx.join(m);
		m.saveObject(bo);
	}

	/**
	 * ������˾�ͻ��ſ���Ϣ(ENT_INFO)
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

		bo.setAttributeValue("CustomerID", entCustomer.getCustomerID()); // �ͻ�ID
		bo.setAttributeValue("EnterpriseName", entCustomer.getCustomerName()); // �ͻ�����
		bo.setAttributeValue("OrgNature", entCustomer.getOrgNature()); // ��������
		// bo.setAttributeValue("GroupFlag", sGroupType); // ���ſͻ���־
		bo.setAttributeValue("InputOrgID", entCustomer.getInputOrgID()); // �Ǽǻ���
		bo.setAttributeValue("UpdateOrgID", entCustomer.getUpdateOrgID()); // ���»���
		bo.setAttributeValue("InputUserID", entCustomer.getInputUserID()); // �Ǽ���
		bo.setAttributeValue("UpdateUserID", entCustomer.getUpdateDate()); // ������
		bo.setAttributeValue("InputDate", entCustomer.getInputDate()); // �Ǽ�����
		bo.setAttributeValue("UpdateDate", entCustomer.getUpdateDate()); // ��������
		bo.setAttributeValue("TempSaveFlag", "1"); // �ݴ��־

		if ("Ent02".equals(entCustomer.getCertType())) { // ֤������ΪӪҵִ��
			bo.setAttributeValue("LicenseNo", entCustomer.getCertID()); // Ӫҵִ�պ�
		} else { // ����֤�� // if("Ent01".equals(certType)){ // ֤������Ϊ��֯��������
			bo.setAttributeValue("CorpID", entCustomer.getCertID()); // ֤����ţ���֯��������֤��ţ�
		}
		tx.join(m);
		m.saveObject(bo);
	}

	/**
	 * �������˿ͻ��ſ���Ϣ(IND_INFO)
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

		bo.setAttributeValue("CustomerID", indCustomer.getCustomerID()); // �ͻ�ID
		bo.setAttributeValue("CustomerName", indCustomer.getCustomerName()); // �ͻ�����
		bo.setAttributeValue("CertID", indCustomer.getCertID()); // ֤�����
		bo.setAttributeValue("CertType", indCustomer.getCertType()); // ֤������
		bo.setAttributeValue("CertID18", indCustomer.getCertID18()); // 18λ���֤��
		bo.setAttributeValue("InputOrgID", indCustomer.getInputOrgID()); // �Ǽǻ���
		bo.setAttributeValue("UpdateOrgID", indCustomer.getUpdateOrgID()); // ���»���
		bo.setAttributeValue("InputUserID", indCustomer.getInputUserID()); // �Ǽ���
		bo.setAttributeValue("UpdateUserID", indCustomer.getUpdateDate()); // ������
		bo.setAttributeValue("InputDate", indCustomer.getInputDate()); // �Ǽ�����
		bo.setAttributeValue("UpdateDate", indCustomer.getUpdateDate()); // ��������
		bo.setAttributeValue("TempSaveFlag", "1"); // �ݴ��־

		tx.join(m);
		m.saveObject(bo);
	}

	private String runAddCustomAction(Transaction Sqlca) throws Exception {
		/**
		 * ��ȡ����
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
		// ��ȡ�ͻ����
		String sTempCustomerId = Sqlca
				.getString(new SqlObject(
						"SELECT CUSTOMERID FROM IND_INFO WHERE CUSTOMERNAME=:CUSTOMERNAME AND CERTID=:CERTID")
						.setParameter("CUSTOMERNAME", CustomerName)
						.setParameter("CERTID", CertID));
		if (sTempCustomerId != null) {
			return sTempCustomerId;
		} else {
			// ����ͻ������ڣ�������
			GenerateSerialNo generateSeriaNo = new GenerateSerialNo();
			generateSeriaNo.setTableName("IND_INFO");
			generateSeriaNo.setColName("CUSTOMERID");
			CustomerID = generateSeriaNo.getCustomerId(Sqlca);
		}

		/**
		 * ��������
		 */
		String sReturn = "0";

		/**
		 * �����߼�
		 */
		Today = StringFunction.getToday();

		/** ���ݿͻ��������ü��ſͻ����� */
		if (CustomerType.equals("0210")) {
			sGroupType = "1";// һ�༯��
		} else if (CustomerType.equals("0220")) {
			sGroupType = "2";// ���༯��
		} else {
			sGroupType = "0";// ��һ�ͻ�
		}

		// 01Ϊ�޸ÿͻ�
		if (Status.equals("01")) {
			try {
				/**
				 * 1.����CI��
				 */
				insertCustomerInfo(CustomerType);
				/**
				 * 2.����CB��,Ĭ��ȫ�����Ȩ��
				 */
				insertCustomerBelong("1");

				/**
				 * ����ENT_INFO����IND_INFO��
				 */
				// ��˾�ͻ����߼��ſͻ�
				if (CustomerType.substring(0, 2).equals("01")
						|| CustomerType.substring(0, 2).equals("02")) {
					insertEntInfo(CustomerType, CertType);
				} else if (CustomerType.substring(0, 2).equals("03")) {// ���Ѵ����˿ͻ�
					insertIndInfo(CertType);
				} else if (CustomerType.equals("03")) {// ���������˿ͻ�
					insertIndInfo(CertType);
				} else if (CustomerType.equals("04")) {// �������ԹͿͻ�
					insertEntInfo(CustomerType, CertType);
				} else if (CustomerType.equals("05")) {// ��������˾�ͻ�
					insertEntInfo(CustomerType, CertType);
				}
				sReturn = "1";
			} catch (Exception e) {
				throw new Exception("������ʧ�ܣ�" + e.getMessage());
			}
			// �ÿͻ�û�����κ��û�������Ч����
		} else if (Status.equals("04")) {
			if (HaCustomerType.equals(CustomerType)) {
				/**
				 * ����Դ������"2"���"1"
				 */
				String sSql = " update CUSTOMER_INFO set Channel = '1' where CustomerID =:CustomerID ";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",
						CustomerID));
				/**
				 * ����CB��,Ĭ��ȫ�����Ȩ��
				 */
				insertCustomerBelong("1");
				sReturn = "1";
			} else {
				/** ��������ͻ����ʹ��� */
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
	 * ����������CUSTOMER_INFO
	 * 
	 * @param cusotmerType
	 *            �ͻ����ͣ���ͬ�Ŀͻ����ͣ�������ֶλ�������ͬ
	 * @throws Exception
	 */
	private void insertCustomerInfo(String customerType) throws Exception {
		StringBuffer sbSql = new StringBuffer();
		SqlObject so;// ��������
		sbSql.append(" insert into CUSTOMER_INFO(")
				.append(" CustomerID,")
				// 010.�ͻ����
				.append(" CustomerName,")
				// 020.�ͻ�����
				.append(" CustomerType,")
				// 030.�ͻ�����
				.append(" CertType,")
				// 040.֤������
				.append(" CertID,")
				// 050.֤����
				.append(" InputOrgID,")
				// 060.�Ǽǻ���
				.append(" InputUserID,")
				// 070.�Ǽ��û�
				.append(" InputDate,")
				// 080.�Ǽ�����
				.append(" Channel")
				// 090.��Դ����
				.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :InputOrgID, :InputUserID, :InputDate, '1')");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", CustomerID)
				.setParameter("CustomerName", CustomerName)
				.setParameter("CustomerType", CustomerType);
		// ���ſͻ�(��֤�����ͣ�֤����)
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
	 * ����������CUSTOMER_BELONG
	 * 
	 * @param attribute
	 *            [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־
	 * @throws Exception
	 */
	private void insertCustomerBelong(String attribute) throws Exception {
		StringBuffer sbSql = new StringBuffer("");
		SqlObject so;// ��������
		sbSql.append("insert into CUSTOMER_BELONG(")
				.append(" CustomerID,")
				// 010.�ͻ�ID
				.append(" OrgID,")
				// 020.��Ȩ����ID
				.append(" UserID,")
				// 030.��Ȩ��ID
				.append(" BelongAttribute,")
				// 040.����Ȩ
				.append(" BelongAttribute1,")
				// 050.��Ϣ�鿴Ȩ
				.append(" BelongAttribute2,")
				// 060.��Ϣά��Ȩ
				.append(" BelongAttribute3,")
				// 070.ҵ�����Ȩ
				.append(" BelongAttribute4,")
				// 080.
				.append(" InputOrgID,")
				// 090.�Ǽǻ���
				.append(" InputUserID,")
				// 100.�Ǽ���
				.append(" InputDate,")
				// 110.�Ǽ�����
				.append(" UpdateDate")
				// 120.��������
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
	 * ����������ENT_INFO,��ͬ�Ŀͻ������Լ�֤�����ͣ�������ֶλ�������
	 * 
	 * @param customerType
	 *            �ͻ�����
	 * @param certType
	 *            ֤������
	 * @throws Exception
	 */
	private void insertEntInfo(String customerType, String certType)
			throws Exception {
		SqlObject so = null;// ��������
		StringBuffer sbSql = new StringBuffer("");
		// �Ȳ���ͨ����Ϣ
		sbSql.append("insert into ENT_INFO(")
				.append(" CustomerID,")
				// 010.�ͻ�ID
				.append(" CustomerName,")
				// 020.�ͻ�����
				.append(" CustomerType,")
				// 030.�ͻ�����
				.append(" CertType,")
				// 030.֤������
				.append(" CertID,")
				// 050.֤����
				.append(" OrgNature,")
				// 040.��������
				.append(" GroupFlag,")
				// 050.���ſͻ���־
				.append(" InputUserID,")
				// 060.�Ǽ���
				.append(" InputOrgID,")
				// 070.�Ǽǻ���
				.append(" InputDate,")
				// 080.�Ǽ�����
				.append(" UpdateUserID,")
				// 090.������
				.append(" UpdateOrgID,")
				// 100.���»���
				.append(" UpdateDate,")
				// 110.��������
				.append(" TempSaveFlag")
				// 120.�ݴ��־
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

		// �ٸ���������Ϣ
		// [01] ��˾�ͻ� [04]�Թ� [05]��˾
		/*
		 * if(sCustomerType.substring(0,2).equals("01") ||
		 * sCustomerType.equals("04") || sCustomerType.equals("05")){
		 * //֤������ΪӪҵִ�� if(sCertType.equals("Ent02")){ //����Ӫҵִ�պ�
		 * Sqlca.executeSQL(new SqlObject(
		 * "update ENT_INFO set CertID = :CertID where CustomerID = :CustomerID"
		 * ).setParameter("CustomerID", sCustomerID).setParameter("CertID",
		 * sCertID)); //����֤�� }else{ Sqlca.executeSQL(new SqlObject(
		 * "update ENT_INFO set CorpID = :CorpID where CustomerID = :CustomerID"
		 * ).setParameter("CustomerID", sCustomerID).setParameter("CorpID",
		 * sCertID)); } //[02] �������ſͻ� }else
		 * if(sCustomerType.substring(0,2).equals("02")){
		 * //������֯�������루ϵͳ�Զ����⣬ͬ���ſͻ���ţ� Sqlca.executeSQL(new SqlObject(
		 * "update ENT_INFO set CorpID = :CorpID where CustomerID = :CustomerID"
		 * ).setParameter("CustomerID", sCustomerID).setParameter("CorpID",
		 * sCustomerID)); }
		 */
	}

	/**
	 * ����������IND_INFO,��ͬ��֤�����ͣ�������ֶλ�������
	 * 
	 * @throws Exception
	 */
	private void insertIndInfo(String certType) throws Exception {
		String sCertID18 = "";
		StringBuffer sbSql = new StringBuffer("");
		// ���Ϊ���֤,����18λת��
		if (certType.equals("Ind01")) {
			sCertID18 = StringFunction.fixPID(CertID);
		} else {
			sCertID18 = "";
		}

		sbSql.append("insert into IND_INFO(")
				.append(" CustomerID,")
				// 010.�ͻ�ID
				.append(" CustomerName,")
				// 020.�ͻ���
				.append(" CustomerType,")
				// 020.�ͻ�����
				.append(" CertType,")
				// 030.֤������
				.append(" CertID,")
				// 040.֤����
				.append(" CertID18,")
				// 050.18λ֤����
				.append(" InputOrgID,")
				// 060.�Ǽǻ���
				.append(" InputUserID,")
				// 070.�Ǽ���
				.append(" InputDate,")
				// 080.�Ǽ�����
				.append(" UpdateDate,")
				// 090.��������
				.append(" TempSaveFlag")
				// 100.�ݴ��־
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
	 * ���������Ϣ����
	 * 
	 * @throws Exception
	 */
	private void inserRateInfo() throws Exception {

		ASResultSet rs = null;
		String sSql;

		double monthlyinterestrate = 0.00;// ��Ʒ������
		double managementfeesrate = 0.00;// ���˻��������
		double customerservicerates = 0.00;// �¿ͻ��������

		// ���ݶ������ʹӶ������Ͷ�����в�ѯ����Ӧ�����������
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

		// ������ʱ��������
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
		 * public String applyno;//���뵥��ˮ�� public String customname;//�ͻ����� public
		 * String price1;//��Ʒ�۸� public String paymentsum;//�׸���� public String
		 * paymentrate;//�׸����� public String principalcontract;//��ͬ���� public
		 * String monthlyrate;//���������� public String monthlyservicerate;//�����·������
		 * public String monthlyservicecharge;//�����·���� public String
		 * yearservicecharge;//���������� public String
		 * monthlymanagementrate;//�����¹������
		 * 
		 * public String monthlymanagemencharge;//�����¹ܷ���� public String
		 * yearmanagementrate;//������������
		 * 
		 * public String monthlyfinancerate;//�����²��������� public String
		 * monthlyfinance;//�����²������� public String monthlyinsurance;//�����±��շ�
		 * public String monthlyinsurancerate;//�����±��շ��� public String
		 * yearinsurance;//�����걣�շ� public String yearinsurancerate;//�����걣�շ���
		 * 
		 * double monthlyinterestrate=0.00;//��Ʒ������ double
		 * managementfeesrate=0.00;//���˻�������� double
		 * customerservicerates=0.00;//�¿ͻ��������
		 */
		/*Double dBusinesssum = Double.parseDouble(Price1)
				- (Arith.mul(Double.parseDouble(Price1),
						Double.parseDouble(Paymentrate) / 100));// �����*/
		Double dBusinesssum = Double.parseDouble(Price1)-downPayment;// �����
		
		Double monthlyservicecharge = Arith.mul(dBusinesssum,
				customerservicerates / 100);// �����·����
		Double yearservicecharge = Arith.mul(monthlyservicecharge, 12);// ����������
		Double monthlymanagemencharge = (Arith.mul(dBusinesssum,
				managementfeesrate / 100));// �����²�������
		Double yearmanagementrate = Arith.mul(managementfeesrate, 12);// ����������
		Double monthlyfinance = (Arith.mul(dBusinesssum,
				managementfeesrate / 100));
		Double yearinsurance = (Arith.mul(
				monthlyinsurance * dBusinesssum / 100, 12));
		Double monthlyinsuranceMo = (Arith.mul(monthlyinsurance * dBusinesssum
				/ 100, 1));
		Double yearinsurancerate = (Arith.mul(monthlyinsurance, 12));
        
		ARE.getLog().debug(
				OUT_PUT_LOG + "�������=" + dBusinesssum + "�������·���ѡ�=" + monthlyservicecharge + "�����������ѡ�=" + yearservicecharge + "�������²������ѡ�=" + monthlymanagemencharge + "�����������ѡ�=" + yearmanagementrate + "�������걣�շѷѡ�=" + yearinsurance+ "���±��շѡ�=" + monthlyinsuranceMo);
		
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
				// �����²���������
				.setParameter("monthlyfinance", monthlyfinance)
				// �����²�������
				.setParameter("monthlyinsurance", monthlyinsuranceMo)
				.setParameter("monthlyinsurancerate", monthlyinsurance)
				// �����±��շ���??????
				.setParameter("yearinsurance", yearinsurance)
				.setParameter("yearinsurancerate", yearinsurancerate)
				.setParameter("monthlymanagemencharge", monthlymanagemencharge)// �����¹ܷ����
				.setParameter("yearmanagementrate", yearmanagementrate);// ������������
		Sqlca.executeSQL(so);
		Sqlca.commit();

		Sqlca.disConnect();
	}
}