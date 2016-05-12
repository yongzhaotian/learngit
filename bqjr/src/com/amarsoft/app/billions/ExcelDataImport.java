package com.amarsoft.app.billions;

import java.io.File;
import java.math.BigDecimal;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.security.MessageDigest;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

import java.text.DateFormat; 
import java.text.SimpleDateFormat; 
import java.util.Date; 
import java.util.regex.Matcher; 
import java.util.regex.Pattern; 

import javax.swing.JOptionPane;
/**
 * 执行xls导入
 * 
 * @author Administrator
 * 
 */
public class ExcelDataImport {

	private String filePath; // 文件路径
	private String importType;
	private String userid;
	private String orgid;
	private String inputdate;
	private String BlackListModel;
	private String BlackListColumn;
	private String small_type;
	private String loanType;
	private String flag;
	private String channelSerialNo;
	
	public String getChannelSerialNo() {
		return channelSerialNo;
	}

	public void setChannelSerialNo(String channelSerialNo) {
		this.channelSerialNo = channelSerialNo;
	}

	private String sExceptionName = "Success";

	
	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getSmall_type() {
		return small_type;
	}

	public void setSmall_type(String small_type) {
		this.small_type = small_type;
	}

	public String getLoanType() {
		return loanType;
	}

	public void setLoanType(String loanType) {
		this.loanType = loanType;
	}

	public String getBlackListModel() {
		return BlackListModel;
	}

	public void setBlackListModel(String blackListModel) {
		BlackListModel = blackListModel;
	}

	public String getBlackListColumn() {
		return BlackListColumn;
	}

	public void setBlackListColumn(String blackListColumn) {
		BlackListColumn = blackListColumn;
	}

	public String getInputdate() {
		return inputdate;
	}

	public void setInputdate(String inputdate) {
		this.inputdate = inputdate;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getOrgid() {
		return orgid;
	}

	public void setOrgid(String orgid) {
		this.orgid = orgid;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getImportType() {
		return importType;
	}

	public void setImportType(String importType) {
		this.importType = importType;
	}

	public String importIndInfo(Transaction Sqlca) {

		try {

			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

			// 参数初始化区域 BEGIN
			String[][] indInfoArray = dataExcelCommon.getAllData();
			System.out.println(indInfoArray);
			String sql = "INSERT INTO IND_INFO_TEMP (CUSTOMERID,CUSTOMERNAME,SEX,CERTTYPE,CERTID,ISSUEINSTITUTION,MATURITYDATE,NATIVEPLACE,VILLAGETOWN,STREET,COMMUNITY,CELLNO,COMMZIP,FLAG2,FAMILYADD,COUNTRYSIDE,VILLAGECENTER,PLOT,ROOM,FAMILYZIP,WORKCORP,WORKADD,UNITCOUNTRYSIDE,UNITSTREET,UNITROOM,UNITNO,WORKZIP,EMPLOYRECORD,HEADSHIP,UNITKIND,CELLPROPERTY,COMMADD,EMAILCOUNTRYSIDE,EMAILSTREET,EMAILPLOT,EMAILROOM,FLAG8,MOBILETELEPHONE,FAMILYTEL,PHONEMAN,WORKTEL,QQNO,WECHAT,MARRIAGE,CHILDRENTOTAL,SPOUSENAME,SPOUSETEL,HOUSE,ALIMONY,KINSHIPNAME,KINSHIPTEL,KINSHIPADD,RELATIVETYPE,EDUEXPERIENCE,FAMILYMONTHINCOME,JOBTOTAL,JOBTIME,WORKBEGINDATE,OTHERREVENUE,FALG4,CONTACTRELATION,OTHERCONTACT,CONTACTTEL) "
					+ "VALUES(:CUSTOMERID,:CUSTOMERNAME,:SEX,:CERTTYPE,:CERTID,:ISSUEINSTITUTION,:MATURITYDATE,:NATIVEPLACE,:VILLAGETOWN,:STREET,:COMMUNITY,:CELLNO,:COMMZIP,:FLAG2,:FAMILYADD,:COUNTRYSIDE,:VILLAGECENTER,:PLOT,:ROOM,:FAMILYZIP,:WORKCORP,:WORKADD,:UNITCOUNTRYSIDE,:UNITSTREET,:UNITROOM,:UNITNO,:WORKZIP,:EMPLOYRECORD,:HEADSHIP,:UNITKIND,:CELLPROPERTY,:COMMADD,:EMAILCOUNTRYSIDE,:EMAILSTREET,:EMAILPLOT,:EMAILROOM,:FLAG8,:MOBILETELEPHONE,:FAMILYTEL,:PHONEMAN,:WORKTEL,:QQNO,:WECHAT,:MARRIAGE,:CHILDRENTOTAL,:SPOUSENAME,:SPOUSETEL,:HOUSE,:ALIMONY,:KINSHIPNAME,:KINSHIPTEL,:KINSHIPADD,:RELATIVETYPE,:EDUEXPERIENCE,:FAMILYMONTHINCOME,:JOBTOTAL,:JOBTIME,:WORKBEGINDATE,:OTHERREVENUE,:FALG4,:CONTACTRELATION,:OTHERCONTACT,:CONTACTTEL)";

			insertXlsData(Sqlca, sql, indInfoArray);
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}

		return "Success";
	}

	public String dataImportSafApproveStore(Transaction Sqlca) {
			String sSerialNo="";
			StringBuffer sb = new StringBuffer("");
		try {
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
			String[][] allData = dataExcelCommon.getAllData11();
			String sql1 = " select agreementapprovestatus from store_info where status in ('02','04') and primaryapprovestatus = '1' and serialno=:serialno";
			String sql = "update store_info set SAFDEPAPPROVETIME=:SAFDEPAPPROVETIME, STATUS=:STATUS, "
					+ "SAFDEPAPPROVESTATUS=:SAFDEPAPPROVESTATUS, SAFAPPROVEREMARK=:SAFAPPROVEREMARK, AGREEMENTAPPROVESTATUS = :AGREEMENTAPPROVESTATUS where SerialNo=:SerialNo";

			//-- add tangyb 处理不通过数据  20151231 --//
			String agreementapprovestatus = ""; //协议审核状态[1：通过；2：不通过；3：待处理；4：审核中]
			String status = "02"; // 门店状态[01：新增；02：审核中；03：准入；04：拒绝；07：暂时关闭；05：激活；06：关闭]
			
			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];
				sSerialNo = arow[1];
				//添加返回excel中所有SerialNo
				if(i == 0){
					sb.append(sSerialNo);
				}else{
					sb.append("|").append(sSerialNo);
				}
				if(!"1".equals(arow[5]) && !"2".equals(arow[5])){
					return "error"+"@"+arow[1];
				}
				ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql1)
						.setParameter("serialno", arow[1]));
				if (rs.next()) {
					agreementapprovestatus = rs.getString("agreementapprovestatus");
					// 安全部审核“同意”，协议审核
					if ("1".equals(arow[5]) && "2".equals(agreementapprovestatus)) {
						agreementapprovestatus = "4"; // 审核中
					}

					Sqlca.executeSQL(new SqlObject(sql)
							.setParameter("SAFDEPAPPROVETIME", arow[6])
							.setParameter("STATUS", status)
							.setParameter("SAFDEPAPPROVESTATUS", arow[5])
							.setParameter("SAFAPPROVEREMARK", arow[7])
							.setParameter("AGREEMENTAPPROVESTATUS", agreementapprovestatus)
							.setParameter("SerialNo", arow[1]));
				}
				rs.getStatement().close();
			}
			//-- end --//

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
				tmpFile.delete();
			}
			//添加返回excel中所有SerialNo
			return "Success@"+sb.toString();
		} catch (Exception e) {

			e.printStackTrace();
			return "error";
		}

	}

	public String dataImportSafApproveRetail(Transaction Sqlca) {
		String sSerialNo="";
		StringBuffer sb = new StringBuffer("");
		try {
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
			String[][] allData = dataExcelCommon.getAllData11();
			String sql1 = "select agreementapprovestatus from retail_info where status in ('02','04') and primaryapprovestatus = '1' and serialno=:serialno";

			String sql = "UPDATE RETAIL_INFO SET SAFDEPAPPROVETIME=:SAFDEPAPPROVETIME, STATUS=:STATUS, "
					+ "SAFDEPAPPROVESTATUS=:SAFDEPAPPROVESTATUS, AGREEMENTAPPROVESTATUS = :AGREEMENTAPPROVESTATUS where SERIALNO=:SERIALNO";
			
			//-- add tangyb 处理不通过数据  20151231 --//
			String agreementapprovestatus = ""; //协议审核状态[1：通过；2：不通过；3：待处理；4：审核中]
			String status = "02"; // 门店状态[01：新增；02：审核中；03：准入；04：拒绝；07：暂时关闭；05：激活；06：关闭]
			
			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];
				sSerialNo = arow[1];
				//添加返回excel中所有SerialNo
				if(i == 0){
					sb.append(sSerialNo);
				}else{
					sb.append("|").append(sSerialNo);
				}
				ARE.getLog().info(sSerialNo);
				if(!"1".equals(arow[5]) && !"2".equals(arow[5])){
					return "error"+"@"+arow[1];
				}
				ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql1).setParameter("serialno", arow[1]));
				if (rs.next()) {
					agreementapprovestatus = rs.getString("agreementapprovestatus");
					// 安全部审核“同意”，协议审核
					if ("1".equals(arow[5]) && "2".equals(agreementapprovestatus)) {
						agreementapprovestatus = "4"; // 审核中
					}
					
					Sqlca.executeSQL(new SqlObject(sql)
							.setParameter("SAFDEPAPPROVETIME", arow[6])
							.setParameter("STATUS", status)
							.setParameter("SAFDEPAPPROVESTATUS", arow[5])
							.setParameter("AGREEMENTAPPROVESTATUS", agreementapprovestatus)
							.setParameter("SERIALNO", arow[1]));
				}
				rs.getStatement().close();
			}
			//-- end --//

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
				tmpFile.delete();

			}
			//添加返回excel中所有SerialNo
			return "Success@"+sb.toString();
		} catch (Exception e) {

			e.printStackTrace();
			return "error";
		}

	}

	public String importContract(Transaction Sqlca) {

		try {
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

			// 参数初始化区域 BEGIN
			String[][] indInfoArray = dataExcelCommon.getAllData();
			System.out.println(indInfoArray);
			String sql = "Insert Into BUSINESS_CONTRACT_INFO_TEMP (BUSINESSRANGE1,BUSINESSTYPE1,PRICE1,BRANDTYPE1,MANUFACTURER1,TOTALSUM1,BUSINESSSUM1,BUSINESSRANGE2,BUSINESSTYPE2,PRICE2,MANUFACTURER2,BRANDTYPE2,TOTALSUM2,BUSINESSSUM2,TOTALPRICE,BUSINESSSUM,INTERIORCODE,PERIODS,BUSINESSTYPE,PRODUCTNAME,STORES,SALESEXECUTIVE,MONTHREPAYMENT,REPLACEACCOUNT,REPAYMENTWAY,REPLACENAME,ANNOTATION) "
					+ " VALUES (:BUSINESSRANGE1,:BUSINESSTYPE1,:PRICE1,:BRANDTYPE1,:MANUFACTURER1,:TOTALSUM1,:BUSINESSSUM1,:BUSINESSRANGE2,:BUSINESSTYPE2,:PRICE2,:MANUFACTURER2,:BRANDTYPE2,:TOTALSUM2,:BUSINESSSUM2,:TOTALPRICE,:BUSINESSSUM,:INTERIORCODE,:PERIODS,:BUSINESSTYPE,:PRODUCTNAME,:STORES,:SALESEXECUTIVE,:MONTHREPAYMENT,:REPLACEACCOUNT,:REPAYMENTWAY,:REPLACENAME,:ANNOTATION)";

			insertXlsData(Sqlca, sql, indInfoArray);
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}

		return "Success";
	}

	/**
	 * 此方法在JS中调用
	 * 
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String dataImport(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		if (allData[0].length == 8) {
			sql = "INSERT INTO STORERELATIVEPRODUCT (SERIALNO,SNo,PName,PNo,BASEAMOUNT,SERVICERATIO,FIXSERVICEAMOUNT,FIXCOMMISSIONAMOUNT,COMMISSIONRATIO,SPSTARTDATE,SPENDDATE) "
					+ "VALUES(:SERIALNO,:SNo,:PName,:PNo,:BASEAMOUNT,:SERVICERATIO,:FIXSERVICEAMOUNT,:FIXCOMMISSIONAMOUNT,:COMMISSIONRATIO,:SPSTARTDATE,:SPENDDATE)";
		} else if (allData[0].length == 4) {
			sql = "INSERT INTO STORERELATIVEPRODUCT (SERIALNO,SNo,PNo,SPSTARTDATE,SPENDDATE) VALUES(:SERIALNO,:SNo,:PNo,:SPSTARTDATE,:SPENDDATE)";
		} else if (allData[0].length == 9) {
			// String sPassword = MessageDigest.getDigestAsUpperHexString("MD5",
			// "000000als");
			sql = "INSERT INTO USER_INFO (USERID,LOGINID,USERNAME,PASSWORD,BELONGORG,USERTYPE,STATUS,CITY,CERTID,MOBILETEL,EMAIL,ISCAR) VALUES(:USERID,:LOGINID,:USERNAME,:PASSWORD,:BELONGORG,:USERTYPE,:STATUS,:CITY,:CERTID,:MOBILETEL,:EMAIL,:ISCAR)";
		}

		String[][] allDataExtend = new String[allData.length][allData[0].length + 1];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(
							"STORERELATIVEPRODUCT", "SerialNo");
				else
					allDataExtend[i][j] = arow[j - 1];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

	public String dataImportCarModel(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		// 车型库维护
		sql = "INSERT INTO CAR_MODEL_INFO (MODELSID,MODELSBRAND,MODELSSERIES,CARMODEL,CARMODELCODE,BODYTYPE,MANUFACTURERS,SALESSTARTTIME,ENGINESIZE,COLOR,PRICE) "
				+ "VALUES(:MODELSID,:MODELSBRAND,:MODELSSERIES,:CARMODEL,:CARMODELCODE,:BODYTYPE,:MANUFACTURERS,:SALESSTARTTIME,:ENGINESIZE,:COLOR,:PRICE)";

		String[][] allDataExtend = new String[allData.length][allData[0].length + 1];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(
							"CAR_MODEL_INFO", "MODELSID");
				else
					allDataExtend[i][j] = arow[j - 1];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

	public String dataImportUser(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData();
		String sql = "INSERT INTO USER_INFO (USERID,LOGINID,USERNAME,PASSWORD,BELONGORG,USERTYPE,STATUS,CITY,CERTID,MOBILETEL,EMAIL,ISCAR) VALUES(:USERID,:LOGINID,:USERNAME,:PASSWORD,:BELONGORG,:USERTYPE,:STATUS,:CITY,:CERTID,:MOBILETEL,:EMAIL,:ISCAR)";

		int xlsFieldLength = allData[0].length;
		String[][] allDataExtend = new String[allData.length][xlsFieldLength + 4];
		GenerateSerialNo generator = new GenerateSerialNo();
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allData[i].length; j++) {

				if (j == 0) {
					generator.setTableName("USER_INFO");
					generator.setColName("USERID");
					generator.setEmpType(arow[2]);
					// tableName=USER_INFO,colName=USERID,empType
					String empNo = generator.getEmpNo(sqlca);
					String sDefPaswd = MessageDigest.getDigestAsUpperHexString(
							"MD5", "000000als");
					allDataExtend[i][0] = empNo;
					allDataExtend[i][1] = empNo;
					allDataExtend[i][2] = arow[j];
					allDataExtend[i][3] = sDefPaswd;
					allDataExtend[i][xlsFieldLength + 3] = "02";
					continue;
				}
				allDataExtend[i][j + 3] = arow[j];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";

	}

	public String dataImportUserInfo(Transaction sqlca) {
		try {
			int t = 0;
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
			System.out.println("================" + filePath);
			// 参数初始化区域 BEGIN
			String[][] allData = dataExcelCommon.getAllData11();
			String sql = "INSERT INTO USER_INFO (USERID,LOGINID,USERNAME,PASSWORD,USERTYPE ,BELONGORG,STATUS,CITY,CERTID,MOBILETEL,EMAIL,SUPERID) VALUES(:USERID,:LOGINID,:USERNAME,:PASSWORD,:USERTYPE,:BELONGORG,:STATUS,:CITY,:CERTID,:MOBILETEL,:EMAIL,:SUPERID)";

			int xlsFieldLength = allData[0].length;
			String[][] allDataExtend = new String[allData.length][xlsFieldLength];
			GenerateSerialNo generator = new GenerateSerialNo();

			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];

				for (int j = 0; j < allData[i].length; j++) {
					System.out.println("allData=" + i + j + allData[i][j]);

					String count = sqlca.getString(new SqlObject(
							"select count(*) from user_info where userid='"
									+ allData[i][0] + "'"));
					// System.err.println("cout"+count);
					if (!count.equalsIgnoreCase("0")) {
						t++;
						System.out.print("t=" + t);
						break;
					} else {

						allDataExtend[i - t][j] = arow[j];

					}
				}

			}

			System.out.println("----------------------t=" + t);
			String[][] allDataExtend1 = new String[allData.length - t][xlsFieldLength];
			int t1 = 0;
			for (int i = 0; i < allData.length - t; i++) {
				String[] arow = allDataExtend[i];

				for (int j = 0; j < allData[i].length; j++) {
					System.out.println("allData=" + i + j + allData[i][j]);

					String count1 = sqlca.getString(new SqlObject(
							"select count(*) from user_info where userid='"
									+ allDataExtend[i][0] + "'"));
					System.err.println("cout1" + count1);
					if (!count1.equalsIgnoreCase("0")) {
						t1++;
						// System.out.print("t1="+t1);
						// System.out.print("t="+t);
						break;
					} else {

						allDataExtend1[i - t1][j] = arow[j];

						// System.out.println("---------------"+(i-7)+","+j+","+allDataExtend[i-7][j]);
					}
				}

			}

			insertXlsData(sqlca, sql, allDataExtend1);

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile())
				tmpFile.delete();

			return "success";
		} catch (SQLException e) {

			e.printStackTrace();
			return "error";
		} catch (Exception e) {

			e.printStackTrace();
			return "error";
		}

	}

	public String dataImportUserRoleInfo(Transaction sqlca) throws Exception {

		try {
			int t = 0;
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
			System.out.println("================" + filePath);
			// 参数初始化区域 BEGIN
			String[][] allData = dataExcelCommon.getAllData11();
			String sql = "INSERT INTO USER_ROLE (USERID,ROLEID,GRANTOR,BEGINTIME) VALUES(:USERID,:ROLEID,:GRANTOR,:BEGINTIME)";

			int xlsFieldLength = allData[0].length;
			String[][] allDataExtend = new String[allData.length][xlsFieldLength];

			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];

				for (int j = 0; j < allData[i].length; j++) {

					String count = sqlca.getString(new SqlObject(
							"select count(*) from USER_ROLE where USERID='"
									+ allData[i][0] + "'  and ROLEID='"
									+ allData[i][1] + "'"));
					System.err.println("cout=" + count);
					if (!count.equalsIgnoreCase("0")) {
						t++;
						System.out.print("t=" + t);
						break;

					} else {

						allDataExtend[i - t][j] = arow[j];

					}
				}

			}

			System.out.println("----------------------t=" + t);
			String[][] allDataExtend1 = new String[allData.length - t][xlsFieldLength];
			int t1 = 0;
			for (int i = 0; i < allData.length - t; i++) {
				String[] arow = allDataExtend[i];

				for (int j = 0; j < allData[i].length; j++) {
					System.out.println("allData=" + i + j + allData[i][j]);

					String count1 = sqlca.getString(new SqlObject(
							"select count(*) from USER_ROLE where USERID='"
									+ allDataExtend[i][0] + "'  and ROLEID='"
									+ allDataExtend[i][1] + "'"));
					System.err.println("cout1=" + count1);
					if (!count1.equalsIgnoreCase("0")) {
						t1++;

						break;
					} else {

						allDataExtend1[i - t1][j] = arow[j];

						// System.out.println("---------------"+(i-7)+","+j+","+allDataExtend[i-7][j]);
					}
				}

			}

			insertXlsData(sqlca, sql, allDataExtend1);

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile())
				tmpFile.delete();

			return "success";
		} catch (SQLException e) {

			e.printStackTrace();
			return "error";
		} catch (Exception e) {

			e.printStackTrace();
			return "error";
		}

	}

	public String dataImportResCashAccessCustomerInfo(Transaction sqlca)
			throws Exception {
		try {
			int t = 0;
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
			System.out.println("================" + filePath);
			// 参数初始化区域 BEGIN
			String[][] allData = dataExcelCommon.getAllData12();
			//CCS-1112  车主现金贷系统设活动有效期 update huzp  添加了EVENTENDDATE字段
			String resCustomersql = "INSERT INTO RESCASHACCESSCUSTOMER (SERIALNO,CUSTOMERID,CUSTOMERNAME,SEX,TELEPHONE,CERTID,PROVINCE,CITY,WORKADDRESS,ADDRESS,PRODUCTTYPE,PRODUCTFEATURE,EVENTNAME,EVENTDATE,EVENTENDDATE,EVENTPHASE,AMOUNTLIMIT,TOPMONTHPAYMENT,TERM,BATCHNO,INPUTDATE) values (:SERIALNO,:CUSTOMERID,:CUSTOMERNAME,:SEX,:TELEPHONE,:CERTID,:PROVINCE,:CITY,:WORKADDRESS,:ADDRESS,:PRODUCTTYPE,:PRODUCTFEATURE,:EVENTNAME,:EVENTDATE,:EVENTENDDATE,:EVENTPHASE,:AMOUNTLIMIT,:TOPMONTHPAYMENT,:TERM,:BATCHNO,:INPUTDATE)";
			String customerSql = "INSERT INTO CUSTOMER_INFO (CUSTOMERID,CERTTYPE,INPUTORGID,INPUTUSERID,INPUTDATE,CUSTOMERTYPE,CUSTOMERNAME,CERTID) VALUES (:CUSTOMERID,:CERTTYPE,:INPUTORGID,:INPUTUSERID,:INPUTDATE,:CUSTOMERTYPE,:CUSTOMERNAME,:CERTID)";
			String indSql = "INSERT INTO IND_INFO(CUSTOMERID,CERTTYPE,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,FAMILYADD,SEX,CUSTOMERNAME,CERTID,MOBILETELEPHONE,COUNTRYSIDE,VILLAGECENTER,PLOT,ROOM) VALUES (:CUSTOMERID,:CERTTYPE,:INPUTORGID,:INPUTUSERID,:INPUTDATE,:UPDATEDATE,:FAMILYADD,:SEX,:CUSTOMERNAME,:CERTID,:MOBILETELEPHONE,:COUNTRYSIDE,:VILLAGECENTER,:PLOT,:ROOM)";
			
			int acessCellLength = 21;//CCS-1112  车主现金贷系统设活动有效期 update huzp   原值为20
			int customerlength = 8;
			int indLength =15;
			String[][] allAccessDataExtend = new String[allData.length][acessCellLength];
			String[][] allCustomerDataExtend = new String[allData.length][customerlength];
			String[][] allIndDataExtend = new String[allData.length][indLength];

			if(allData.length == 0){
				throw new RuntimeException("请确认xls文件已提供数据！");
			}else {//CCS-1112  车主现金贷系统设活动有效期 update huzp 验证活动开始时间字段不为空
				for(int i = 0; i < allData.length; i++){
					String[] arow = allData[i];//读取一行数据
					if(arow[11]==""||arow[11].equals("")||arow[11]==null){
						throw new RuntimeException("请确认xls文件已提供活动开始时间数据！");
					}else {
						String flag =checkDate(arow[11]);
						if(flag.equals("0")){
							throw new RuntimeException("活动开始时间格式有误，请检查!");
						}
					}
					
					if(arow[12]==""||arow[12].equals("")||arow[12]==null){
						
					}else{
						String flag =checkDate(arow[12]);
						if(flag.equals("0")){
							throw new RuntimeException("活动结束时间格式有误，请检查!");
						}else{
							String beginTime="";
							String endTime="";
							if (arow[11] != null && !arow[11].equals("")) {
								if (arow[11].split("/").length > 1) {
									beginTime=arow[11].replaceAll("[/\\s:]","-");//开始时间 
								}else{
									beginTime=arow[11];
								}
							}
							if (arow[12] != null && !arow[12].equals("")) {
								if (arow[12].split("/").length > 1) {
									endTime = arow[12].replaceAll("[/\\s:]","-");//结束时间 
								}else {
									endTime = arow[12];
								}
							}
							
							java.text.DateFormat df = new java.text.SimpleDateFormat( "yyyy-MM-dd");
							java.util.Calendar c1 = java.util.Calendar.getInstance();
							java.util.Calendar c2 = java.util.Calendar.getInstance();
								c1.setTime(df.parse(beginTime));//开始时间 
								c2.setTime(df.parse(endTime));//结束时间 
							int result = c1.compareTo(c2);
							if (result == 0){
//								System.out.println("c1相等c2");
								throw new RuntimeException("活动开始时间与活动结束时间一致，请检查!");
							}else if (result < 0){
//								System.out.println("c1小于c2");
							}else{
//								System.out.println("c1大于c2");
								throw new RuntimeException("活动开始时间在活动结束时间之后，请检查!");
							}

						}
					}
				}
			}
			
			//对导入数据做预处理
			for(int i = 0; i < allData.length; i++){
				String[] arow = allData[i];//读取一行数据
				
				System.out.println("Excel字段总数量："+arow.length);
				/********beging*******CCS-1112 车主现金贷系统设活动有效期 update huzp*************************/
				/* 原先逻辑是如果准入客户里已经存在该客户那么则删除对应的客户数据，改后逻辑为，导入客户信息时删除原先所有客户信息*/
				
				/*
				//如果准入客户里已经存在该客户，则重新导入
				String accessCustomerID = sqlca.getString(new SqlObject(
						"SELECT CUSTOMERID FROM RESCASHACCESSCUSTOMER WHERE CUSTOMERNAME='"+arow[0]+"' AND CERTID='"+arow[3]+"'"));
				if(accessCustomerID!=null){
					sqlca.executeSQL(new SqlObject(
							"DELETE  FROM RESCASHACCESSCUSTOMER WHERE CUSTOMERNAME='"+arow[0]+"' AND CERTID='"+arow[3]+"'"));
				}
				*/
				sqlca.executeSQL(new SqlObject("DELETE  FROM RESCASHACCESSCUSTOMER "));
				/********end *********************************************/
				//校验数据库中是否已经有该客户数据
				ARE.getLog().info("allData[i][0]="+arow[0]+","+"allData[i][3]="+arow[3]);
				String customerID = sqlca.getString(new SqlObject(
						"SELECT CUSTOMERID FROM CUSTOMER_INFO WHERE CUSTOMERNAME='"+arow[0]+"' AND CERTID='"+arow[3]+"'"));
				/** --update Object_Maxsn取号优化 tangyb 20150817 start-- */
				//allAccessDataExtend[i][0] = DBKeyHelp.getSerialNo("RESCASHACCESSCUSTOMER", "SERIALNO");//准入客户序列号
				allAccessDataExtend[i][0] = DBKeyUtils.getSerialNo("RC"); //获取准入客户序列号
				/** --end --*/
				if (customerID!=null) {
					//如果导入的客户存在数据库中，则导入准入客户名单时使用该客户原来的客户ID
					allAccessDataExtend[i][1] = customerID;
					t++;
					System.out.print("t=" + t);
				} else {
					//如果导入的客户存在数据库中，则生成新的客户ID
					GenerateSerialNo generateSerialNo = new GenerateSerialNo();
					generateSerialNo.setTableName("IND_INFO");
					generateSerialNo.setColName("CUSTOMERID");
					allAccessDataExtend[i][1] = generateSerialNo.getCustomerId(sqlca);
					
					//导入的客户不存在数据库中时，导入客户数据到customer_info以及ind_info表中
					//Customer_info 数据
					//客户编号
					allCustomerDataExtend [i-t][0]=allAccessDataExtend[i][1];
					//证件类型
					allCustomerDataExtend [i-t][1]="Ind01";
					//所属机构
					allCustomerDataExtend [i-t][2]=orgid;
					//数据导入用户
					allCustomerDataExtend [i-t][3]=userid;
					//导入时间
					allCustomerDataExtend [i-t][4]=inputdate;
					// 客户类型
					allCustomerDataExtend [i-t][5]="0310";
					//客户姓名
					allCustomerDataExtend [i-t][6]=arow[0];
					//客户身份证号
					allCustomerDataExtend [i-t][7]=arow[3];
					
				    //ind_info后台插入数据
					//客户编号
					allIndDataExtend[i-t][0]=allAccessDataExtend[i][1];
					//证件类型
					allIndDataExtend[i-t][1]="Ind01";
					//所属机构
					allIndDataExtend[i-t][2]=orgid;
					//数据导入用户
					allIndDataExtend[i-t][3]=userid;
					//导入时间
					allIndDataExtend[i-t][4]=inputdate;
					//ind_info 更新时间
					allIndDataExtend[i-t][5]="";
					//ind_info 客户现住地址
					ARE.getLog().info("arow[22]="+arow[22]);//CCS-1112  车主现金贷系统设活动有效期 update huzp  添加了EVENTENDDATE字段 。原值21，因新增了一个字段所以改为22
					allIndDataExtend[i-t][6] = sqlca.getString(new SqlObject("SELECT ITEMNO FROM CODE_LIBRARY CL WHERE CL.CODENO = 'AreaCode' AND CL.ITEMNAME = '"+arow[22]+"'"));
					//客户性别
					allIndDataExtend[i-t][7] = sqlca.getString(new SqlObject("SELECT ITEMNO FROM CODE_LIBRARY CL WHERE CL.CODENO = 'Sex' AND CL.ITEMNAME = '"+arow[1]+"'"));
					//客户姓名
					allIndDataExtend[i-t][8] =arow[0];
					//证件号码
					allIndDataExtend[i-t][9] =arow[3];
					//手机号码
					allIndDataExtend[i-t][10] =arow[2];
					//区县镇(现居)
					allIndDataExtend[i-t][11] =arow[18];//CCS-1112  车主现金贷系统设活动有效期 update huzp  原来值arow[17],以下递增
					//街道/村
					allIndDataExtend[i-t][12] =arow[19];
					//小区/楼盘
					allIndDataExtend[i-t][13] =arow[20];
					//栋/单元/房间号
					allIndDataExtend[i-t][14] =arow[21];
				}
				//导入数据到准入客户名单
				for(int j=0;j<acessCellLength-2;j++){
					if(j == 18){//CCS-1112  车主现金贷系统设活动有效期 update huzp  原来值17
						allAccessDataExtend[i][j+2]=inputdate; //第20个字段“导入时间”直接赋值
					}else if(j == 12){//CCS-1112  车主现金贷系统设活动有效期 update huzp  新增的判断条件，主要用来判断文件中未填活动结束时间的客户信息默认为“9999/12/31”
						if(arow[j]==""||arow[j].equals("")||arow[j]==null){
							allAccessDataExtend[i][j+2]="9999/12/31";
						}else {
							allAccessDataExtend[i][j+2]=arow[j];
						}
					}else{
						allAccessDataExtend[i][j+2]=arow[j];
					}
				}
			}
			
			String[][] allCustomerDataExtendEx=new String[allData.length-t][customerlength];
			String[][] allIndDataExtendEx=new String[allData.length-t][indLength];
			for(int i=0;i<allData.length-t;i++){
				for(int j=0;j<customerlength;j++){
					 allCustomerDataExtendEx[i][j] = allCustomerDataExtend[i][j];
				}
				
				for(int j=0;j<indLength;j++){
					allIndDataExtendEx[i][j]=allIndDataExtend[i][j];
				}
			}
			
			//将值插入到数据库中执行方法
			if(allAccessDataExtend != null && allAccessDataExtend.length > 0 ){
				insertXlsData(sqlca, resCustomersql, allAccessDataExtend);
			}
			
			//将值插入到数据库中执行方法
			if(allAccessDataExtend != null && allCustomerDataExtendEx.length > 0 ){
				insertXlsData(sqlca, customerSql, allCustomerDataExtendEx);
			}
			
			//将值插入到数据库中执行方法
			if(allAccessDataExtend != null && allIndDataExtendEx.length > 0 ){
				insertXlsData(sqlca, indSql, allIndDataExtendEx);
			}

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
				tmpFile.delete();
			}
			return sExceptionName;

		} catch (Exception e) {

			e.printStackTrace();
			return "error@"+e.getMessage();
		}

	}

	public String dataImportStoreInfo(Transaction sqlca) throws Exception {
		try {
			int t = 0;
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
			System.out.println("================" + filePath);
			// 参数初始化区域 BEGIN
			String[][] allData = dataExcelCommon.getAllData11();
			String sql = "INSERT INTO STORE_INFO (SERIALNO,SNO,SNAME,OPERATEMODE,STORETYPE ,SHOPHOURS,REPONSIBLEMAN,REPONSIBLEMANPHONE,FINANCIALEMAIL,ISNETBANK,ACCOUNTBANKCITY,ACCOUNT,ACCOUNTNAME,ACCOUNTBANK,PRODUCTCATEGORYNAME,MAINBUSINESSTYPENAME,PREDICTLOANAMOUNT,CITY,CITYMANAGER,ADDRESS,SALESMANAGER,SALESMANEMAIL,SALESMANPHONE,RSERIALNO,INPUTDATE,BRANCHCODE,STATUS) VALUES(:SERIALNO,:SNO,:SNAME,:OPERATEMODE,:STORETYPE ,:SHOPHOURS,:REPONSIBLEMAN,:REPONSIBLEMANPHONE,:FINANCIALEMAIL,:ISNETBANK,:ACCOUNTBANKCITY,:ACCOUNT,:ACCOUNTNAME,:ACCOUNTBANK,:PRODUCTCATEGORYNAME,:MAINBUSINESSTYPENAME,:PREDICTLOANAMOUNT,:CITY,:CITYMANAGER,:ADDRESS,:SALESMANAGER,:SALESMANEMAIL,:SALESMANPHONE,:RSERIALNO,:INPUTDATE,:BRANCHCODE,:STATUS)";

			int xlsFieldLength = allData[0].length;
			String[][] allDataExtend = new String[allData.length][xlsFieldLength];

			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];

				for (int j = 0; j < allData[i].length; j++) {

					if (j == 0) {
						allDataExtend[i][j] = DBKeyHelp.getSerialNo(
								"STORE_INFO", "SERIALNO");
					}
					if (j > 0) {
						String count = sqlca.getString(new SqlObject(
								"select count(*) from Store_info where sno='"
										+ allData[i][1] + "'"));
						// System.err.println("cout"+count);
						if (!count.equalsIgnoreCase("0")) {
							t++;
							System.out.print("t=" + t);
							break;
						} else {

							allDataExtend[i - t][j] = arow[j];

						}
					}

				}
			}
			System.out.println("----------------------t=" + t);
			String[][] allDataExtend1 = new String[allData.length - t][xlsFieldLength];
			int t1 = 0;
			for (int i = 0; i < allData.length - t; i++) {
				String[] arow = allDataExtend[i];

				for (int j = 0; j < allData[i].length; j++) {
					System.out.println("allData=" + i + j + allData[i][j]);
					if (j == 0) {
						allDataExtend1[i][j] = DBKeyHelp.getSerialNo(
								"STORE_INFO", "SERIALNO");
					}
					if (j > 0) {
						String count1 = sqlca.getString(new SqlObject(
								"select count(*) from Store_info where sno='"
										+ allDataExtend[i][1] + "'"));
						System.err.println("cout1" + count1);
						if (!count1.equalsIgnoreCase("0")) {
							t1++;
							// System.out.print("t1="+t1);
							// System.out.print("t="+t);
							break;
						} else {

							allDataExtend1[i - t1][j] = arow[j];

							// System.out.println("---------------"+(i-7)+","+j+","+allDataExtend[i-7][j]);
						}
					}
				}

			}

			insertXlsData(sqlca, sql, allDataExtend1);

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
				tmpFile.delete();
			}
			return sExceptionName;

		} catch (Exception e) {

			e.printStackTrace();
			return "error";
		}

	}

	public String dataImportBankInfo(Transaction sqlca) throws Exception {

		try {
			int t = 0;
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
			System.out.println("================" + filePath);
			// 参数初始化区域 BEGIN
			String[][] allData = dataExcelCommon.getAllData11();
			String sql = "INSERT INTO BANKPUT_INFO (BANKNO,BANKNAME,CITY) VALUES(:BANKNO,:BANKNAME,:CITY)";

			int xlsFieldLength = allData[0].length;
			String[][] allDataExtend = new String[allData.length][xlsFieldLength];
			GenerateSerialNo generator = new GenerateSerialNo();

			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];

				for (int j = 0; j < allData[i].length; j++) {
					System.out.println("allData=" + i + j + allData[i][j]);

					String count = sqlca.getString(new SqlObject(
							"select count(*) from BANKPUT_INFO where BANKNO='"
									+ allData[i][0] + "'"));
					// System.err.println("cout"+count);
					if (!count.equalsIgnoreCase("0")) {
						t++;
						System.out.print("t=" + t);
						break;
					} else {

						allDataExtend[i - t][j] = arow[j];

					}
				}

			}

			System.out.println("----------------------t=" + t);
			String[][] allDataExtend1 = new String[allData.length - t][xlsFieldLength];
			int t1 = 0;
			for (int i = 0; i < allData.length - t; i++) {
				String[] arow = allDataExtend[i];

				for (int j = 0; j < allData[i].length; j++) {
					System.out.println("allData=" + i + j + allData[i][j]);

					String count1 = sqlca.getString(new SqlObject(
							"select count(*) from BANKPUT_INFO where BANKNO='"
									+ allDataExtend[i][0] + "'"));
					System.err.println("cout1" + count1);
					if (!count1.equalsIgnoreCase("0")) {
						t1++;
						// System.out.print("t1="+t1);
						// System.out.print("t="+t);
						break;
					} else {

						allDataExtend1[i - t1][j] = arow[j];

						// System.out.println("---------------"+(i-7)+","+j+","+allDataExtend[i-7][j]);
					}
				}

			}

			insertXlsData(sqlca, sql, allDataExtend1);

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile())
				tmpFile.delete();

			return "success";
		} catch (SQLException e) {

			e.printStackTrace();
			return "error";
		} catch (Exception e) {

			e.printStackTrace();
			return "error";
		}

	}

	public String dataImportRetailInfo(Transaction sqlca) {

		try {
			int t = 0;
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
			System.out.println("================" + filePath);
			// 参数初始化区域 BEGIN
			String[][] allData = dataExcelCommon.getAllData11();
			String sql = "INSERT INTO RETAIL_INFO (SERIALNO,RNO,RNAME,REGCODE,ISSUPER ,ISRELATIVE,SUPERNO,LAWPERSON,LAWPERSONCARDNO,LINKNAME,LINKTEL,LINKEMAIL,FINANCIALNAME,FINANCIALTEL,FINANCIALEMAIL,ACCOUNTBANKCITY,ACCOUNT,ACCOUNTNAME,ACCOUNTBANK,CITY,ADDRESS,BUSINESSSCOPE,BUSINESSSCOPENAME,STORENUM,PERMITTYPE,RTYPE,INPUTDATE,BRANCHCODE,STATUS) VALUES (:SERIALNO,:RNO,:RNAME,:REGCODE,:ISSUPER ,:ISRELATIVE,:SUPERNO,:LAWPERSON,:LAWPERSONCARDNO,:LINKNAME,:LINKTEL,:LINKEMAIL,:FINANCIALNAME,:FINANCIALTEL,:FINANCIALEMAIL,:ACCOUNTBANKCITY,:ACCOUNT,:ACCOUNTNAME,:ACCOUNTBANK,:CITY,:ADDRESS,:BUSINESSSCOPE,:BUSINESSSCOPENAME,:STORENUM,:PERMITTYPE,:RTYPE,:INPUTDATE,:BRANCHCODE:STATUS)";

			int xlsFieldLength = allData[0].length;
			String[][] allDataExtend = new String[allData.length][xlsFieldLength];

			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];

				for (int j = 0; j < allData[i].length; j++) {

					if (j == 0) {
						allDataExtend[i][j] = DBKeyHelp.getSerialNo(
								"RETAIL_INFO", "SERIALNO");
					}
					if (j > 0) {
						String count = sqlca.getString(new SqlObject(
								"select count(*) from retail_info where rno='"
										+ allData[i][1] + "'"));
						// System.err.println("cout"+count);
						if (!count.equalsIgnoreCase("0")) {
							t++;
							System.out.print("t=" + t);
							break;
						} else {

							allDataExtend[i - t][j] = arow[j];

						}
					}

				}
			}
			System.out.println("----------------------t=" + t);
			String[][] allDataExtend1 = new String[allData.length - t][xlsFieldLength];
			int t1 = 0;
			for (int i = 0; i < allData.length - t; i++) {
				String[] arow = allDataExtend[i];

				for (int j = 0; j < allData[i].length; j++) {
					System.out.println("allData=" + i + j + allData[i][j]);
					if (j == 0) {
						allDataExtend1[i][j] = DBKeyHelp.getSerialNo(
								"RETAIL_INFO", "SERIALNO");
					}
					if (j > 0) {
						String count1 = sqlca.getString(new SqlObject(
								"select count(*) from retail_info where rno='"
										+ allDataExtend[i][1] + "'"));
						System.err.println("cout1" + count1);
						if (!count1.equalsIgnoreCase("0")) {
							t1++;
							// System.out.print("t1="+t1);
							// System.out.print("t="+t);
							break;
						} else {

							allDataExtend1[i - t1][j] = arow[j];

							// System.out.println("---------------"+(i-7)+","+j+","+allDataExtend[i-7][j]);
						}
					}
				}

			}

			insertXlsData(sqlca, sql, allDataExtend1);

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
				tmpFile.delete();
			}
			return sExceptionName;

		} catch (Exception e) {

			e.printStackTrace();
			return "error";
		}

	}

	public String importCommusModel(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		// 车型库维护
		sql = "insert into CONSUME_Outsourcing_INFO (serialno ,imputdate ,imputuserid, flag,ID_CREDIT,contractNO ,customerid ,cpdDays ,OVERDUELSUM ,payoutsourcesum ,TRANSFERDATE ,endDate ,Company,Province ,city ,"
				+ " COMMISSION_RATE ) values(:serialno ,:imputdate ,:imputuserid,:flag,:ID_CREDIT,:contractNO ,:customerid ,:cpdDays ,:OVERDUELSUM ,:payoutsourcesum,:TRANSFERDATE ,:endDate ,:Company,:Province ,:city ,"
				+ " :COMMISSION_RATE )";

		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(
							"CONSUME_Outsourcing_INFO", "serialno");
				if (j == 1)
					allDataExtend[i][j] = inputdate;
				if (j == 2)
					allDataExtend[i][j] = userid;
				if (j == 3)
					allDataExtend[i][j] = flag;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

	public String importCommusModel1(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		// 车型库维护
		sql = "insert into CONSUME_TIQIANOUTSOURCING_INFO (serialno ,imputdate ,imputuserid, flag,ID_CREDIT,contractNO ,customerid ,cpdDays ,OVERDUELSUM ,payoutsourcesum ,TRANSFERDATE ,endDate ,Company,Province ,city ,"
				+ " COMMISSION_RATE ) values(:serialno ,:imputdate ,:imputuserid,:flag,:ID_CREDIT,:contractNO ,:customerid ,:cpdDays ,:OVERDUELSUM ,:payoutsourcesum,:TRANSFERDATE ,:endDate ,:Company,:Province ,:city ,"
				+ " :COMMISSION_RATE )";

		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(
							"CONSUME_TIQIANOutsourcing_INFO", "serialno");
				if (j == 1)
					allDataExtend[i][j] = inputdate;
				if (j == 2)
					allDataExtend[i][j] = userid;
				if (j == 3)
					allDataExtend[i][j] = flag;
				
				if (j > 3){
					allDataExtend[i][j] = arow[j - 4];
					if(j == 6){
						updatePhaseType1ByCustomerid(sqlca,allDataExtend[i][j]);}
				}
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	
	public String updatePhaseType1ByCustomerid(Transaction Sqlca,String customerid) {
	try {
		String sql="update CONSUME_COLLECTION_INFO c set PhaseType1='0090' where c.customerid=:customerid  and overduedate >= 1 and overduedate <= 90  and (phasetype1 = '0012' or phasetype1 = '0013' or  phasetype1 = '0011') ";
		Sqlca.executeSQL(new SqlObject(sql).setParameter("customerid", customerid));
		return "Success";
	} catch (Exception e) {

		e.printStackTrace();
		return "error";
	}

}

	// 处理客户黑名单的导入
	public String importCustomerBlackListModel(Transaction sqlca)
			throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into CustomerBlackList(serialno,inputuser,inputorg,inputdate,customername,cardno ,upreason ,namesource) "
				+ "values(:serialno ,:inputuser ,:inputorg,:inputdate,:customername,:cardno ,:upreason ,:namesource)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(
							"CustomerBlackList", "serialno");
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];

			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	
	// 处理客户白名单的导入
		public String importCustomerWhiteListModel(Transaction sqlca)
				throws Exception {
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

			// 参数初始化区域 BEGIN
			String[][] allData = dataExcelCommon.getAllData11();
			String sql = "";
			ARE.getLog().debug("数据表列数：" + allData[0].length);
			sql = "insert into INVESTIGATORLIST (SERIALNO, QUARRY, CAUSATION, INPUTORG, REMARK, CREATE_TIME, NAME, IDENT) "
					+ "values(:serialno  ,:quarry ,:causation,:inputorg,:remark,:create_time,:name,:ident)";
			String[][] allDataExtend = new String[allData.length][allData[0].length + 6];
			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];
				for (int j = 0; j < allDataExtend[i].length; j++) {
					if (j == 0)
						allDataExtend[i][j] = DBKeyHelp.getSerialNo(
								"INVESTIGATORLIST", "serialno");
					
					if (j == 1)
						allDataExtend[i][j] = "调查部";
					if (j == 2)
						allDataExtend[i][j] = "暗访人员";
					if (j == 3)
						allDataExtend[i][j] = orgid;
					if (j == 4)
						allDataExtend[i][j] = inputdate;
					if (j == 5)
						allDataExtend[i][j] = inputdate;
					
					if (j > 5)
						allDataExtend[i][j] = arow[j-6];

				}
			}
			insertXlsData(sqlca, sql, allDataExtend);

			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile())
				tmpFile.delete();

			return "";
		}

	// 处理地址黑名单的导入
	public String importAddressBlackListModel(Transaction sqlca)
			throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into AddressBlackList(serialno,inputuser,inputorg,inputdate,area,town,villege,cell,houseno,upreason ,namesource) "
				+ "values(:serialno ,:inputuser ,:inputorg,:inputdate,:area,:town,:villege,:cell,:houseno,:upreason ,:namesource)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(
							"AddressBlackList", "serialno");
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];

			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

	// 处理其他黑名单的导入
	public String importBlackListModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into "
				+ BlackListModel
				+ " (serialno,inputuser,inputorg,inputdate,updateorg,updateuser,updatedate,"
				+ BlackListColumn
				+ ",upreason ,namesource) "
				+ "values(:serialno ,:inputuser ,:inputorg,:inputdate,:updateorg,:updateuser,:updatedate,:"
				+ BlackListColumn + ",:upreason ,:namesource)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 7];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(BlackListModel,
							"serialno");
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j == 4)
					allDataExtend[i][j] = orgid;
				if (j == 5)
					allDataExtend[i][j] = userid;
				if (j == 6)
					allDataExtend[i][j] = inputdate;
				if (j > 6)
					allDataExtend[i][j] = arow[j - 7];

			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	
	// 处理同业客户黑名单的导入
	//add by clhuang 2015/04/23 CCS-687 PRM-325 增加同业黑名单模块 
	public String importInterbankBlackListModel(Transaction sqlca)
			throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into InterbankBlackList(serialno,inputuser,inputorg,inputdate,customername,cardno ,telephonenum,upreason ,namesource) "
				+ "values(:serialno ,:inputuser ,:inputorg,:inputdate,:customername,:cardno ,:telephonenum ,:upreason ,:namesource)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(
							"InterbankBlackList", "serialno");
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];

			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	//end by clhuang 2015/04/23

	/**
	 * 将值插入到数据库中执行方法
	 * 
	 * @param sqlca
	 * @param sql
	 * @param allData
	 * @throws Exception
	 */
	private void insertXlsData(Transaction sqlca, String sql, String[][] allData) {

		// 如果allData无数据，请先提供数据
		// 获取表字段元数据
		ASResultSet rs;
		try {
			
			if (allData == null || allData.length == 0)
				throw new RuntimeException("请确认xls文件已提供数据！");

			String sSqlUpper = sql.toUpperCase();
			SqlObject sqlObj = new SqlObject(sSqlUpper);

			int firstPos = sSqlUpper.indexOf("(");
			// 获取插入的所有字段
			String sFields = sSqlUpper.substring(firstPos + 1,
					sSqlUpper.indexOf(")", firstPos)).trim();

			System.out.println("+++++++++++++" + sFields);
			System.out.println("=============" + sFields.split(",").length);
			System.out.println("--------------" + allData[0].length);

			// 检查xls中数据列与sql中字段数目是否相同
			if (sFields.split(",").length != allData[0].length)
				throw new RuntimeException("传入数据列与输入列数量不匹配，请确认！");
			// 获取目标表名称
			String sTableName = sSqlUpper.substring(
					sSqlUpper.toUpperCase().indexOf("INTO") + 5, firstPos)
					.trim();
			rs = sqlca.getASResultSet(new SqlObject("SELECT " + sFields
					+ " FROM " + sTableName));
			ResultSetMetaData rsmd = rs.getMetaData();

			String[] valTypes = new String[rsmd.getColumnCount()];
			String[] sFidldArray = new String[rsmd.getColumnCount()];
			// 去掉字段之间的空格
			for (int i = 0; i < sFidldArray.length; i++) {
				sFidldArray[i] = sFields.split(",")[i].trim();
			}
			// 获取各字段的类型 fixme: 目前只有NUMBER，STRING两种类型
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				valTypes[i] = rs.getColumnTypeName(i + 1);
			}

			// 执行XLS中数据插入到表中
			for (int rownum = 0; rownum < allData.length; rownum++) {
				String[] arow = allData[rownum];
				for (int colnum = 0; colnum < arow.length; colnum++) {
					if ("NUMBER".equals(valTypes[colnum])) {
						sqlObj.setParameter(sFidldArray[colnum],
								Float.parseFloat(arow[colnum]));
						continue;
					}
					sqlObj.setParameter(sFidldArray[colnum],
							allData[rownum][colnum]);
				}
				ARE.getLog().info("后台日志查询：>>>>>姓名:"+allData[rownum][2]+",联系号码:"+allData[rownum][4]+",身份证:"+allData[rownum][5]);
				sqlca.executeSQL(sqlObj);
			}
			if (rs != null)
				rs.getStatement().close();

		} catch (Exception e) {
			sExceptionName = "error";
			e.printStackTrace();
		}
	}

	/**
	 * 小企业贷商户信息导入
	 * 
	 * @author lishui
	 * @date 2015-02-13 14:35:133
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String dataImportLoanCustomerInfo(Transaction sqlca)
			throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
		System.out.println("================" + filePath);
		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		StringBuffer sql = new StringBuffer();
		sql.append("   insert into BUSINESSLOANCUSTOMER(SMALL_TYPE, MERCHANTNAME,MERCHANTLEVEL,                           ");
		sql.append("   COOPERATIONSTARTTIME, COOPERATIONSTART, LOADSERVICEFEE , MANAGERFEE ,EARLYDEFAULTRATE, STATE  )    ");
		sql.append("   values(:SMALL_TYPE,:MERCHANTNAME,:MERCHANTLEVEL,:COOPERATIONSTARTTIME,                             ");
		sql.append("   :COOPERATIONSTART,:LOADSERVICEFEE,:MANAGERFEE,:EARLYDEFAULTRATE,:STATE)                            ");

		int xlsFieldLength = allData[0].length;

		System.out.println(xlsFieldLength);
		System.out.println(allData.length);

		System.out.println("allData.length:" + allData.length);
		String[][] allDataExtend = new String[allData.length][allData[0].length + 1];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0) {
					allDataExtend[i][j] = this.small_type;
				}
				if (j > 0) {
					allDataExtend[i][j] = arow[j - 1];
					System.out.println("_________" + i + "," + j
							+ allDataExtend[i][j]);
				}
			}
		}
		insertXlsData(sqlca, sql.toString(), allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";

	}

	/**
	 * CCS-574 PRM-256 原地复活计划安硕系统需求
	 * @author rqiao
	 * @date 20150401
	 */
	public String ImportReconsiderInfo(Transaction sqlca) throws Exception {
		
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
		System.out.println("================" + filePath);
		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		StringBuffer sql = new StringBuffer();
		sql.append("insert into Reconsider_Quota_Record(SerialNo,InputUserID,InputTime,SaleName,SaleID,CertID,City,SuperID,MonthlyQuota,RemainingQuota,BeginTime,EndTime)values(:SerialNo,:InputUserID,:InputTime,:SaleName,:SaleID,:CertID,:City,:SuperID,:MonthlyQuota,:RemainingQuota,:BeginTime,:EndTime)");
		
		int xlsFieldLength = allData[0].length;
		
		System.out.println("xlsFieldLength:"+xlsFieldLength);
		System.out.println("allData:"+allData.length);
		
		System.out.println("allData.length:" + allData.length);
		String[][] allDataExtend = new String[allData.length][allData[0].length + 3];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyHelp.getSerialNo("Reconsider_Quota_Record","SerialNo");
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = StringFunction.getTodayNow();
				if (j > 2) {
					allDataExtend[i][j] = arow[j - 3];
					System.out.println("_________" + i + "," + j
							+ allDataExtend[i][j]);
				}
			}
		}
		insertXlsData(sqlca, sql.toString(), allDataExtend);
		
		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();
		
		return "";
		
		}
	
	public static void main(String[] args) throws Exception {

		String t = "2.0090102E9";
		int a = 1231213;
		BigDecimal b = new BigDecimal(t);
		System.out.println(b.toPlainString());
		DecimalFormat df = new DecimalFormat();
		System.out.println(df.format(a));
		System.out.println(df.format(a) instanceof String);

	}
	public String importChannelDetailList(Transaction sqlca) throws Exception {

		int index = filePath.lastIndexOf("@");
		if(index<=0) return "";
		String actualFilePath = filePath.substring(0, index);
		String loadType = filePath.substring(index+1);
		DataExcelCommon dataExcelCommon = new DataExcelCommon(actualFilePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		String sqlSel ="select bankname from REPAYMENT_CHANNEL_LIST where CHANNELSERIALNO=:channelSerialNo";
		//删除原有数据
		String sqlDel = "delete from REPAYMENT_CHANNEL_LIST where CHANNELSERIALNO=:channelSerialNo";
		String sql = "insert into REPAYMENT_CHANNEL_LIST(SERIALNO,CHANNELSERIALNO,BANKNAME,MOBILEBANK,ONLINEBANK,COUNTERTRANSFER,SELFTRANSFER,INPUTUSER,INPUTORG,INPUTTIME) values(:serialno,:channelSerialNo,:bankName,:mobileBank,:onlineBank,:countertransfer,:selftransfer,:inputUser,:inputOrg,:inputtime)";
		
		String[][] allDataExtend = new String[allData.length][allData[0].length + 5];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0){
					allDataExtend[i][j] = DBKeyHelp.getSerialNo(
							"REPAYMENT_CHANNEL_LIST", "serialno");
				}
				else if(j ==1 ){
					allDataExtend[i][j] = channelSerialNo;
				}else if(j == 7){
					allDataExtend[i][j] = userid;
				}else if(j == 8){
					allDataExtend[i][j] = orgid;
				}else if(j == 9){
					allDataExtend[i][j] = StringFunction.getTodayNow();
				}else{
					allDataExtend[i][j] = arow[j - 2];
				}
			}
		}
		
		if(loadType.equals("append")){
			SqlObject sqlObj = new SqlObject(sqlSel);
			sqlObj.setParameter("channelSerialNo", channelSerialNo);
			ASResultSet rs = sqlca.getASResultSet(sqlObj);
			List<String> serialNoList = new ArrayList<String>();
			while(rs.next()){
				serialNoList.add(rs.getString("bankname"));
			}
			if(!serialNoList.isEmpty()){
				List<String[]> list = new ArrayList<String[]>();
				for(int i=0;i<allDataExtend.length;i++){
					String[] array = allDataExtend[i];
					if(!serialNoList.contains(array[2])){
						list.add(array);
					}
				}
				if(list.isEmpty()){
					allDataExtend = null;
				}else{
					allDataExtend = list.toArray(new String[list.size()][]);
				}
			}
			
		}else if(loadType.equals("cover")){
			SqlObject sqlObj = new SqlObject(sqlDel);
			sqlObj.setParameter("channelSerialNo", channelSerialNo);
			sqlca.executeSQL(sqlObj);
		}
		if(allDataExtend != null){
			insertXlsData(sqlca, sql, allDataExtend);
		}

		// 删除长传文件路径
		File tmpFile = new File(actualFilePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	/*********检查字段类型为日期性的合法性方法 huzp ***************/
	public static String checkDate(String checkValue) throws Exception {
		String flag = "0";
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date d = null;
		if (checkValue != null && !checkValue.equals("")) {
			if (checkValue.split("/").length > 1) {
				dateFormat = new SimpleDateFormat("yyyy/MM/dd");
			}
			if (checkValue.split("-").length > 1) {
				dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			}
		} else {
			return flag;
		}
		try {
			d = dateFormat.parse(checkValue);
			System.out.println(d);
		} catch (Exception e) {
			System.out.println("格式错误");
			return flag;
		}
		String eL = "^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-9]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
		Pattern p = Pattern.compile(eL);
		Matcher m = p.matcher(checkValue);
		boolean b = m.matches();
		if (b) {
			System.out.println("格式正确");
			flag="1";
			return flag;

		} else {
			System.out.println("格式错误");
			flag="0";
			return flag;
		}
	}
	
	
	// 处理手机号码灰名单的导入
	public String importGrayListMobileModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into GrayListMobile(serialno,inputuser,inputorg,inputdate,phone,quarry,causation)"
				+ "values(:serialno,:inputuser,:inputorg,:inputdate,:phone,:quarry,:causation)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyUtils.getSerialNo();
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// 处理单位名称灰名单的导入
	public String importGrayListUnitNameModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into GrayListUnitName(serialno,inputuser,inputorg,inputdate,company,quarry,causation)"
				+ "values(:serialno,:inputuser,:inputorg,:inputdate,:company,:quarry,:causation)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyUtils.getSerialNo();
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// 处理单位地址灰名单的导入
	public String importGrayListUnitAddressModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into GrayListUnitAddress(serialno,inputuser,inputorg,inputdate,province,city,area,town,villege,cell,houseno,quarry,causation)"
				+ "values(:serialno,:inputuser,:inputorg,:inputdate,:province,:city,:area,:town,:villege,:cell,:houseno,:quarry,:causation)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyUtils.getSerialNo();
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// 处理家庭电话灰名单的导入
	public String importGrayListHomeTelModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into GrayListHomeTel(serialno,inputuser,inputorg,inputdate,tel,quarry,causation)"
				+ "values(:serialno,:inputuser,:inputorg,:inputdate,:tel,:quarry,:causation)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyUtils.getSerialNo();
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// 处理办公电话灰名单的导入
	public String importGrayListOfficeTelModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into GrayListOfficeTel(serialno,inputuser,inputorg,inputdate,tel,quarry,causation)"
				+ "values(:serialno,:inputuser,:inputorg,:inputdate,:tel,:quarry,:causation)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyUtils.getSerialNo();
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// 处理家庭地址灰名单的导入
	public String importGrayListHomeAddressModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("数据表列数：" + allData[0].length);
		sql = "insert into GrayListHomeAddress(serialno,inputuser,inputorg,inputdate,province,city,area,town,villege,cell,houseno,quarry,causation)"
				+ "values(:serialno,:inputuser,:inputorg,:inputdate,:province,:city,:area,:town,:villege,:cell,:houseno,:quarry,:causation)";
		String[][] allDataExtend = new String[allData.length][allData[0].length + 4];
		for (int i = 0; i < allData.length; i++) {
			String[] arow = allData[i];
			for (int j = 0; j < allDataExtend[i].length; j++) {
				if (j == 0)
					allDataExtend[i][j] = DBKeyUtils.getSerialNo();
				if (j == 1)
					allDataExtend[i][j] = userid;
				if (j == 2)
					allDataExtend[i][j] = orgid;
				if (j == 3)
					allDataExtend[i][j] = inputdate;
				if (j > 3)
					allDataExtend[i][j] = arow[j - 4];
			}
		}
		insertXlsData(sqlca, sql, allDataExtend);

		// 删除长传文件路径
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

}
