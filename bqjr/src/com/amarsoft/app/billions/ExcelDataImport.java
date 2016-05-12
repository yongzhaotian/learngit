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
 * ִ��xls����
 * 
 * @author Administrator
 * 
 */
public class ExcelDataImport {

	private String filePath; // �ļ�·��
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

			// ������ʼ������ BEGIN
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

			//-- add tangyb ����ͨ������  20151231 --//
			String agreementapprovestatus = ""; //Э�����״̬[1��ͨ����2����ͨ����3��������4�������]
			String status = "02"; // �ŵ�״̬[01��������02������У�03��׼�룻04���ܾ���07����ʱ�رգ�05�����06���ر�]
			
			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];
				sSerialNo = arow[1];
				//��ӷ���excel������SerialNo
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
					// ��ȫ����ˡ�ͬ�⡱��Э�����
					if ("1".equals(arow[5]) && "2".equals(agreementapprovestatus)) {
						agreementapprovestatus = "4"; // �����
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

			// ɾ�������ļ�·��
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
				tmpFile.delete();
			}
			//��ӷ���excel������SerialNo
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
			
			//-- add tangyb ����ͨ������  20151231 --//
			String agreementapprovestatus = ""; //Э�����״̬[1��ͨ����2����ͨ����3��������4�������]
			String status = "02"; // �ŵ�״̬[01��������02������У�03��׼�룻04���ܾ���07����ʱ�رգ�05�����06���ر�]
			
			for (int i = 0; i < allData.length; i++) {
				String[] arow = allData[i];
				sSerialNo = arow[1];
				//��ӷ���excel������SerialNo
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
					// ��ȫ����ˡ�ͬ�⡱��Э�����
					if ("1".equals(arow[5]) && "2".equals(agreementapprovestatus)) {
						agreementapprovestatus = "4"; // �����
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

			// ɾ�������ļ�·��
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
				tmpFile.delete();

			}
			//��ӷ���excel������SerialNo
			return "Success@"+sb.toString();
		} catch (Exception e) {

			e.printStackTrace();
			return "error";
		}

	}

	public String importContract(Transaction Sqlca) {

		try {
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

			// ������ʼ������ BEGIN
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
	 * �˷�����JS�е���
	 * 
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String dataImport(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

	public String dataImportCarModel(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
		// ���Ϳ�ά��
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

	public String dataImportUser(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
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

		// ɾ�������ļ�·��
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
			// ������ʼ������ BEGIN
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

			// ɾ�������ļ�·��
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
			// ������ʼ������ BEGIN
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

			// ɾ�������ļ�·��
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
			// ������ʼ������ BEGIN
			String[][] allData = dataExcelCommon.getAllData12();
			//CCS-1112  �����ֽ��ϵͳ����Ч�� update huzp  �����EVENTENDDATE�ֶ�
			String resCustomersql = "INSERT INTO RESCASHACCESSCUSTOMER (SERIALNO,CUSTOMERID,CUSTOMERNAME,SEX,TELEPHONE,CERTID,PROVINCE,CITY,WORKADDRESS,ADDRESS,PRODUCTTYPE,PRODUCTFEATURE,EVENTNAME,EVENTDATE,EVENTENDDATE,EVENTPHASE,AMOUNTLIMIT,TOPMONTHPAYMENT,TERM,BATCHNO,INPUTDATE) values (:SERIALNO,:CUSTOMERID,:CUSTOMERNAME,:SEX,:TELEPHONE,:CERTID,:PROVINCE,:CITY,:WORKADDRESS,:ADDRESS,:PRODUCTTYPE,:PRODUCTFEATURE,:EVENTNAME,:EVENTDATE,:EVENTENDDATE,:EVENTPHASE,:AMOUNTLIMIT,:TOPMONTHPAYMENT,:TERM,:BATCHNO,:INPUTDATE)";
			String customerSql = "INSERT INTO CUSTOMER_INFO (CUSTOMERID,CERTTYPE,INPUTORGID,INPUTUSERID,INPUTDATE,CUSTOMERTYPE,CUSTOMERNAME,CERTID) VALUES (:CUSTOMERID,:CERTTYPE,:INPUTORGID,:INPUTUSERID,:INPUTDATE,:CUSTOMERTYPE,:CUSTOMERNAME,:CERTID)";
			String indSql = "INSERT INTO IND_INFO(CUSTOMERID,CERTTYPE,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,FAMILYADD,SEX,CUSTOMERNAME,CERTID,MOBILETELEPHONE,COUNTRYSIDE,VILLAGECENTER,PLOT,ROOM) VALUES (:CUSTOMERID,:CERTTYPE,:INPUTORGID,:INPUTUSERID,:INPUTDATE,:UPDATEDATE,:FAMILYADD,:SEX,:CUSTOMERNAME,:CERTID,:MOBILETELEPHONE,:COUNTRYSIDE,:VILLAGECENTER,:PLOT,:ROOM)";
			
			int acessCellLength = 21;//CCS-1112  �����ֽ��ϵͳ����Ч�� update huzp   ԭֵΪ20
			int customerlength = 8;
			int indLength =15;
			String[][] allAccessDataExtend = new String[allData.length][acessCellLength];
			String[][] allCustomerDataExtend = new String[allData.length][customerlength];
			String[][] allIndDataExtend = new String[allData.length][indLength];

			if(allData.length == 0){
				throw new RuntimeException("��ȷ��xls�ļ����ṩ���ݣ�");
			}else {//CCS-1112  �����ֽ��ϵͳ����Ч�� update huzp ��֤���ʼʱ���ֶβ�Ϊ��
				for(int i = 0; i < allData.length; i++){
					String[] arow = allData[i];//��ȡһ������
					if(arow[11]==""||arow[11].equals("")||arow[11]==null){
						throw new RuntimeException("��ȷ��xls�ļ����ṩ���ʼʱ�����ݣ�");
					}else {
						String flag =checkDate(arow[11]);
						if(flag.equals("0")){
							throw new RuntimeException("���ʼʱ���ʽ��������!");
						}
					}
					
					if(arow[12]==""||arow[12].equals("")||arow[12]==null){
						
					}else{
						String flag =checkDate(arow[12]);
						if(flag.equals("0")){
							throw new RuntimeException("�����ʱ���ʽ��������!");
						}else{
							String beginTime="";
							String endTime="";
							if (arow[11] != null && !arow[11].equals("")) {
								if (arow[11].split("/").length > 1) {
									beginTime=arow[11].replaceAll("[/\\s:]","-");//��ʼʱ�� 
								}else{
									beginTime=arow[11];
								}
							}
							if (arow[12] != null && !arow[12].equals("")) {
								if (arow[12].split("/").length > 1) {
									endTime = arow[12].replaceAll("[/\\s:]","-");//����ʱ�� 
								}else {
									endTime = arow[12];
								}
							}
							
							java.text.DateFormat df = new java.text.SimpleDateFormat( "yyyy-MM-dd");
							java.util.Calendar c1 = java.util.Calendar.getInstance();
							java.util.Calendar c2 = java.util.Calendar.getInstance();
								c1.setTime(df.parse(beginTime));//��ʼʱ�� 
								c2.setTime(df.parse(endTime));//����ʱ�� 
							int result = c1.compareTo(c2);
							if (result == 0){
//								System.out.println("c1���c2");
								throw new RuntimeException("���ʼʱ��������ʱ��һ�£�����!");
							}else if (result < 0){
//								System.out.println("c1С��c2");
							}else{
//								System.out.println("c1����c2");
								throw new RuntimeException("���ʼʱ���ڻ����ʱ��֮������!");
							}

						}
					}
				}
			}
			
			//�Ե���������Ԥ����
			for(int i = 0; i < allData.length; i++){
				String[] arow = allData[i];//��ȡһ������
				
				System.out.println("Excel�ֶ���������"+arow.length);
				/********beging*******CCS-1112 �����ֽ��ϵͳ����Ч�� update huzp*************************/
				/* ԭ���߼������׼��ͻ����Ѿ����ڸÿͻ���ô��ɾ����Ӧ�Ŀͻ����ݣ��ĺ��߼�Ϊ������ͻ���Ϣʱɾ��ԭ�����пͻ���Ϣ*/
				
				/*
				//���׼��ͻ����Ѿ����ڸÿͻ��������µ���
				String accessCustomerID = sqlca.getString(new SqlObject(
						"SELECT CUSTOMERID FROM RESCASHACCESSCUSTOMER WHERE CUSTOMERNAME='"+arow[0]+"' AND CERTID='"+arow[3]+"'"));
				if(accessCustomerID!=null){
					sqlca.executeSQL(new SqlObject(
							"DELETE  FROM RESCASHACCESSCUSTOMER WHERE CUSTOMERNAME='"+arow[0]+"' AND CERTID='"+arow[3]+"'"));
				}
				*/
				sqlca.executeSQL(new SqlObject("DELETE  FROM RESCASHACCESSCUSTOMER "));
				/********end *********************************************/
				//У�����ݿ����Ƿ��Ѿ��иÿͻ�����
				ARE.getLog().info("allData[i][0]="+arow[0]+","+"allData[i][3]="+arow[3]);
				String customerID = sqlca.getString(new SqlObject(
						"SELECT CUSTOMERID FROM CUSTOMER_INFO WHERE CUSTOMERNAME='"+arow[0]+"' AND CERTID='"+arow[3]+"'"));
				/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- */
				//allAccessDataExtend[i][0] = DBKeyHelp.getSerialNo("RESCASHACCESSCUSTOMER", "SERIALNO");//׼��ͻ����к�
				allAccessDataExtend[i][0] = DBKeyUtils.getSerialNo("RC"); //��ȡ׼��ͻ����к�
				/** --end --*/
				if (customerID!=null) {
					//�������Ŀͻ��������ݿ��У�����׼��ͻ�����ʱʹ�øÿͻ�ԭ���Ŀͻ�ID
					allAccessDataExtend[i][1] = customerID;
					t++;
					System.out.print("t=" + t);
				} else {
					//�������Ŀͻ��������ݿ��У��������µĿͻ�ID
					GenerateSerialNo generateSerialNo = new GenerateSerialNo();
					generateSerialNo.setTableName("IND_INFO");
					generateSerialNo.setColName("CUSTOMERID");
					allAccessDataExtend[i][1] = generateSerialNo.getCustomerId(sqlca);
					
					//����Ŀͻ����������ݿ���ʱ������ͻ����ݵ�customer_info�Լ�ind_info����
					//Customer_info ����
					//�ͻ����
					allCustomerDataExtend [i-t][0]=allAccessDataExtend[i][1];
					//֤������
					allCustomerDataExtend [i-t][1]="Ind01";
					//��������
					allCustomerDataExtend [i-t][2]=orgid;
					//���ݵ����û�
					allCustomerDataExtend [i-t][3]=userid;
					//����ʱ��
					allCustomerDataExtend [i-t][4]=inputdate;
					// �ͻ�����
					allCustomerDataExtend [i-t][5]="0310";
					//�ͻ�����
					allCustomerDataExtend [i-t][6]=arow[0];
					//�ͻ����֤��
					allCustomerDataExtend [i-t][7]=arow[3];
					
				    //ind_info��̨��������
					//�ͻ����
					allIndDataExtend[i-t][0]=allAccessDataExtend[i][1];
					//֤������
					allIndDataExtend[i-t][1]="Ind01";
					//��������
					allIndDataExtend[i-t][2]=orgid;
					//���ݵ����û�
					allIndDataExtend[i-t][3]=userid;
					//����ʱ��
					allIndDataExtend[i-t][4]=inputdate;
					//ind_info ����ʱ��
					allIndDataExtend[i-t][5]="";
					//ind_info �ͻ���ס��ַ
					ARE.getLog().info("arow[22]="+arow[22]);//CCS-1112  �����ֽ��ϵͳ����Ч�� update huzp  �����EVENTENDDATE�ֶ� ��ԭֵ21����������һ���ֶ����Ը�Ϊ22
					allIndDataExtend[i-t][6] = sqlca.getString(new SqlObject("SELECT ITEMNO FROM CODE_LIBRARY CL WHERE CL.CODENO = 'AreaCode' AND CL.ITEMNAME = '"+arow[22]+"'"));
					//�ͻ��Ա�
					allIndDataExtend[i-t][7] = sqlca.getString(new SqlObject("SELECT ITEMNO FROM CODE_LIBRARY CL WHERE CL.CODENO = 'Sex' AND CL.ITEMNAME = '"+arow[1]+"'"));
					//�ͻ�����
					allIndDataExtend[i-t][8] =arow[0];
					//֤������
					allIndDataExtend[i-t][9] =arow[3];
					//�ֻ�����
					allIndDataExtend[i-t][10] =arow[2];
					//������(�־�)
					allIndDataExtend[i-t][11] =arow[18];//CCS-1112  �����ֽ��ϵͳ����Ч�� update huzp  ԭ��ֵarow[17],���µ���
					//�ֵ�/��
					allIndDataExtend[i-t][12] =arow[19];
					//С��/¥��
					allIndDataExtend[i-t][13] =arow[20];
					//��/��Ԫ/�����
					allIndDataExtend[i-t][14] =arow[21];
				}
				//�������ݵ�׼��ͻ�����
				for(int j=0;j<acessCellLength-2;j++){
					if(j == 18){//CCS-1112  �����ֽ��ϵͳ����Ч�� update huzp  ԭ��ֵ17
						allAccessDataExtend[i][j+2]=inputdate; //��20���ֶΡ�����ʱ�䡱ֱ�Ӹ�ֵ
					}else if(j == 12){//CCS-1112  �����ֽ��ϵͳ����Ч�� update huzp  �������ж���������Ҫ�����ж��ļ���δ������ʱ��Ŀͻ���ϢĬ��Ϊ��9999/12/31��
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
			
			//��ֵ���뵽���ݿ���ִ�з���
			if(allAccessDataExtend != null && allAccessDataExtend.length > 0 ){
				insertXlsData(sqlca, resCustomersql, allAccessDataExtend);
			}
			
			//��ֵ���뵽���ݿ���ִ�з���
			if(allAccessDataExtend != null && allCustomerDataExtendEx.length > 0 ){
				insertXlsData(sqlca, customerSql, allCustomerDataExtendEx);
			}
			
			//��ֵ���뵽���ݿ���ִ�з���
			if(allAccessDataExtend != null && allIndDataExtendEx.length > 0 ){
				insertXlsData(sqlca, indSql, allIndDataExtendEx);
			}

			// ɾ�������ļ�·��
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
			// ������ʼ������ BEGIN
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

			// ɾ�������ļ�·��
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
			// ������ʼ������ BEGIN
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

			// ɾ�������ļ�·��
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
			// ������ʼ������ BEGIN
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

			// ɾ�������ļ�·��
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

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
		// ���Ϳ�ά��
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

	public String importCommusModel1(Transaction sqlca) throws Exception {

		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
		// ���Ϳ�ά��
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

		// ɾ�������ļ�·��
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

	// ����ͻ��������ĵ���
	public String importCustomerBlackListModel(Transaction sqlca)
			throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	
	// ����ͻ��������ĵ���
		public String importCustomerWhiteListModel(Transaction sqlca)
				throws Exception {
			DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

			// ������ʼ������ BEGIN
			String[][] allData = dataExcelCommon.getAllData11();
			String sql = "";
			ARE.getLog().debug("���ݱ�������" + allData[0].length);
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
						allDataExtend[i][j] = "���鲿";
					if (j == 2)
						allDataExtend[i][j] = "������Ա";
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

			// ɾ�������ļ�·��
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile())
				tmpFile.delete();

			return "";
		}

	// �����ַ�������ĵ���
	public String importAddressBlackListModel(Transaction sqlca)
			throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

	// ���������������ĵ���
	public String importBlackListModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	
	// ����ͬҵ�ͻ��������ĵ���
	//add by clhuang 2015/04/23 CCS-687 PRM-325 ����ͬҵ������ģ�� 
	public String importInterbankBlackListModel(Transaction sqlca)
			throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	//end by clhuang 2015/04/23

	/**
	 * ��ֵ���뵽���ݿ���ִ�з���
	 * 
	 * @param sqlca
	 * @param sql
	 * @param allData
	 * @throws Exception
	 */
	private void insertXlsData(Transaction sqlca, String sql, String[][] allData) {

		// ���allData�����ݣ������ṩ����
		// ��ȡ���ֶ�Ԫ����
		ASResultSet rs;
		try {
			
			if (allData == null || allData.length == 0)
				throw new RuntimeException("��ȷ��xls�ļ����ṩ���ݣ�");

			String sSqlUpper = sql.toUpperCase();
			SqlObject sqlObj = new SqlObject(sSqlUpper);

			int firstPos = sSqlUpper.indexOf("(");
			// ��ȡ����������ֶ�
			String sFields = sSqlUpper.substring(firstPos + 1,
					sSqlUpper.indexOf(")", firstPos)).trim();

			System.out.println("+++++++++++++" + sFields);
			System.out.println("=============" + sFields.split(",").length);
			System.out.println("--------------" + allData[0].length);

			// ���xls����������sql���ֶ���Ŀ�Ƿ���ͬ
			if (sFields.split(",").length != allData[0].length)
				throw new RuntimeException("������������������������ƥ�䣬��ȷ�ϣ�");
			// ��ȡĿ�������
			String sTableName = sSqlUpper.substring(
					sSqlUpper.toUpperCase().indexOf("INTO") + 5, firstPos)
					.trim();
			rs = sqlca.getASResultSet(new SqlObject("SELECT " + sFields
					+ " FROM " + sTableName));
			ResultSetMetaData rsmd = rs.getMetaData();

			String[] valTypes = new String[rsmd.getColumnCount()];
			String[] sFidldArray = new String[rsmd.getColumnCount()];
			// ȥ���ֶ�֮��Ŀո�
			for (int i = 0; i < sFidldArray.length; i++) {
				sFidldArray[i] = sFields.split(",")[i].trim();
			}
			// ��ȡ���ֶε����� fixme: Ŀǰֻ��NUMBER��STRING��������
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				valTypes[i] = rs.getColumnTypeName(i + 1);
			}

			// ִ��XLS�����ݲ��뵽����
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
				ARE.getLog().info("��̨��־��ѯ��>>>>>����:"+allData[rownum][2]+",��ϵ����:"+allData[rownum][4]+",���֤:"+allData[rownum][5]);
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
	 * С��ҵ���̻���Ϣ����
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
		// ������ʼ������ BEGIN
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";

	}

	/**
	 * CCS-574 PRM-256 ԭ�ظ���ƻ���˶ϵͳ����
	 * @author rqiao
	 * @date 20150401
	 */
	public String ImportReconsiderInfo(Transaction sqlca) throws Exception {
		
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
		System.out.println("================" + filePath);
		// ������ʼ������ BEGIN
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
		
		// ɾ�������ļ�·��
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

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
		String sqlSel ="select bankname from REPAYMENT_CHANNEL_LIST where CHANNELSERIALNO=:channelSerialNo";
		//ɾ��ԭ������
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

		// ɾ�������ļ�·��
		File tmpFile = new File(actualFilePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	/*********����ֶ�����Ϊ�����ԵĺϷ��Է��� huzp ***************/
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
			System.out.println("��ʽ����");
			return flag;
		}
		String eL = "^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-9]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
		Pattern p = Pattern.compile(eL);
		Matcher m = p.matcher(checkValue);
		boolean b = m.matches();
		if (b) {
			System.out.println("��ʽ��ȷ");
			flag="1";
			return flag;

		} else {
			System.out.println("��ʽ����");
			flag="0";
			return flag;
		}
	}
	
	
	// �����ֻ�����������ĵ���
	public String importGrayListMobileModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// ����λ���ƻ������ĵ���
	public String importGrayListUnitNameModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// ����λ��ַ�������ĵ���
	public String importGrayListUnitAddressModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// �����ͥ�绰�������ĵ���
	public String importGrayListHomeTelModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// ����칫�绰�������ĵ���
	public String importGrayListOfficeTelModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}
	// �����ͥ��ַ�������ĵ���
	public String importGrayListHomeAddressModel(Transaction sqlca) throws Exception {
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);

		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData11();
		String sql = "";
		ARE.getLog().debug("���ݱ�������" + allData[0].length);
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

		// ɾ�������ļ�·��
		File tmpFile = new File(filePath);
		if (tmpFile != null && tmpFile.isFile())
			tmpFile.delete();

		return "";
	}

}
