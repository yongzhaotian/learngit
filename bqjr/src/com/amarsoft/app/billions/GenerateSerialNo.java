package com.amarsoft.app.billions;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class GenerateSerialNo {

	public static final String INIT_CUSTOMERID = "10000000";

	private String serialNo;
	private String tableName; // ����
	private String colName; // �����ƣ����ݴ��ֶλ�����к�
	private String prefix = ""; // ���к�ǰ׺
	private String empType = "";
	private String cityCode;
	private Object synObj = "Sync";

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getColName() {
		return colName;
	}

	public void setColName(String colName) {
		this.colName = colName;
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public String getEmpType() {
		return empType;
	}

	public void setEmpType(String empType) {
		this.empType = empType;
	}

	public String getCityCode() {
		return cityCode;
	}

	public void setCityCode(String cityCode) {
		this.cityCode = cityCode;
	}

	/**
	 * ��object_maxsn���ֶ�ֵ�ڴδ������� tablename �����ƣ�columnname �����ƣ�maxserialno �����,
	 * datefmt Ա������, nofmt ��ʽ
	 * 
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getEmpNo(Transaction sqlca) throws Exception {

		String empNo = sqlca
				.getString(new SqlObject(
						"SELECT MaxSerialno from OBJECT_MAXSN where TableName=:TableName and ColumnName=:ColumnName and DateFmt=:DateFmt")
						.setParameter("TableName", tableName)
						.setParameter("ColumnName", colName)
						.setParameter("DateFmt", empType));
		if (null == empNo) {
			String sql = "INSERT INTO OBJECT_MAXSN(TableName,ColumnName,MaxSerialno,DateFmt,NoFmt) values("
					+ ":TableName,:ColumnName,:MaxSerialno,:DateFmt,:NoFmt)";
			SqlObject asql = new SqlObject(sql)
					.setParameter("TableName", tableName)
					.setParameter("ColumnName", colName)
					.setParameter("DateFmt", empType);
			if ("01".equals(empType)) {
				empNo = "200001";
				asql.setParameter("MaxSerialno", "200001").setParameter(
						"NoFmt", "000000");
			} else if ("02".equals(empType)) {
				empNo = "6000001";
				asql.setParameter("MaxSerialno", "6000001").setParameter(
						"NoFmt", "0000000");
			}
			sqlca.executeSQL(asql);
		} else {
			empNo = String.valueOf(Long.valueOf(empNo) + 1);
			sqlca.executeSQL(new SqlObject(
					"UPDATE OBJECT_MAXSN set MaxSerialno=:MaxSerialno where  TableName=:TableName and ColumnName=:ColumnName and DateFmt=:DateFmt")
					.setParameter("TableName", tableName)
					.setParameter("ColumnName", colName)
					.setParameter("DateFmt", empType)
					.setParameter("MaxSerialno", empNo));
		}

		return empNo;
	}
	/**
	 * ��ȡ�ŵ��ţ� ���д���+6λ��ˮ�� example��11A+000005
	 * 
	 * @param sqlca
	 * @return 11A000005
	 */
	public String getMobilePosNo(Transaction sqlca) {

		synchronized (synObj) {

			String sMobilePosNo = "";
			try {
				String sSNo = sqlca
						.getString(new SqlObject(
								"select max(MOBLIEPOSNO) from MobilePos_Info where MOBLIEPOSNO is not null and City=:cityCode and MOBLIEPOSNO like City||'%' and length(MOBLIEPOSNO)=12 order by SerialNo DESC")
								.setParameter("cityCode", cityCode));
				sMobilePosNo = cityCode + "000001";
				if (sSNo != null) {
					int iSerialNo = Integer.valueOf(sSNo.substring(cityCode
							.length()));
					sMobilePosNo = cityCode
							+ paddingChar(String.valueOf(++iSerialNo), 6, "0");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return sMobilePosNo;
		}
	}

	/**
	 * ��ȡ�ŵ��ţ� ���д���+5λ��ˮ�� example��11A+00005
	 * 
	 * @param sqlca
	 * @return 11A00005
	 */
	public String getStoreNo(Transaction sqlca) {

		synchronized (synObj) {

			String sStoreNo = "";
			try {
				String sSNo = sqlca
						.getString(new SqlObject(
								"select max(substr(SNo,1,11)) from Store_Info where SNo like :cityCode||'%' and length(sNo)>=11")
								.setParameter("cityCode", cityCode));
				sStoreNo = cityCode + "00001";
				if (sSNo != null) {
					int iSerialNo = Integer.valueOf(sSNo.substring(cityCode.length()));
					sStoreNo = cityCode
							+ paddingChar(String.valueOf(++iSerialNo), 5, "0");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			ARE.getLog().info("sStoreNo==========="+sStoreNo);
			return sStoreNo;
		}
	}

	public String batchGenerateStoreNo(Transaction Sqlca) {

		try {
			ASResultSet rs = Sqlca
					.getASResultSet(new SqlObject(
							"select SerialNo,City from Store_Info where RSSerialNo=:RSSerialNo")
							.setParameter("RSSerialNo", serialNo));

			while (rs.next()) {
				cityCode = rs.getString("City");
				String sStoreNo = getStoreNo(Sqlca);
				String storeSerialNo = rs.getString("SerialNo");
				Sqlca.executeSQL(new SqlObject(
						"Update Store_Info set SNo=:SNo where SerialNo=:SerialNo and Status='03'")
						.setParameter("SNo", sStoreNo).setParameter("SerialNo",
								storeSerialNo));
			}
			rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}

		return "Success";
	}

	/**
	 * ��ȡ���̻���ţ����д���+4λ��ˮ�� example��11A+0001
	 * 
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getRetailNo(Transaction sqlca) throws Exception {

		String sRetailNo = "";
		synchronized (synObj) {
			String sRNo = sqlca
					.getString(new SqlObject(
							"select max(substr(RNo,1,10)) from Retail_Info where RNo like :cityCode||'%' and length(RNo)>=10")
							.setParameter("cityCode", cityCode));
			sRetailNo = cityCode + "0001";

			if (sRNo != null) {
				int iSerialNo = Integer.valueOf(sRNo.substring(cityCode
						.length()));
				sRetailNo = cityCode
						+ paddingChar(String.valueOf(++iSerialNo), 4, "0");
			}
		}
		ARE.getLog().info("sRetailNo=============="+sRetailNo);
		return sRetailNo;
	}

	/**
	 * �����ַ�������λ���ض��ַ�
	 * 
	 * @param str
	 *            �����ַ���
	 * @param len
	 *            ����ַ�������
	 * @param padChar
	 *            �����ַ���
	 * @return
	 */
	private String paddingChar(String str, int len, String padChar) {
		String targetStr = str;

		if (targetStr == null)
			targetStr = "";
		if (targetStr.length() >= len)
			return targetStr.substring(0, len);

		String tempStr = "";
		for (int i = 0; i < len - targetStr.length(); i++) {
			tempStr += padChar;
		}

		return tempStr + targetStr;
	}

	/**
	 * ��ȡ�ͻ���ˮ�� ��object_maxsn���ֶ�ֵ�ڴδ������� tablename �����ƣ�columnname �����ƣ�maxserialno
	 * ��ǰ�����, datefmt ������Ѱ��Сֵ, nofmt ����
	 * 
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getCustomerId(Transaction sqlca) throws Exception {
		
		String customerId = null; // �ͻ���
		
		// �Ӻ���ر������ȡһ���ͻ���
		String sql = "select customerid from customerid_pool SAMPLE(20) where rownum=1 for update";
		ASResultSet rs = sqlca.getASResultSet(new SqlObject(sql));
		if (rs.next()) {
			customerId = rs.getString("customerid");
		}
		rs.getStatement().close();
		
		if (customerId != null && !"".equals(customerId)) {
			// ��ȡ���ź󣬴Ӻ����ɾ����ʹ�ú���
			sql = "delete from customerid_pool where customerid = :CUSTOMERID";
			sqlca.executeSQL(new SqlObject(sql).setParameter("CUSTOMERID", customerId));
			
			ARE.getLog().debug("���߼�ȡ��CustomerId==============" + customerId);
			sqlca.commit();
		} else {
			ARE.getLog().info("GETCUSTOMERID���߼�ȡ��ϵͳ��æ");
		}
		
		return customerId;
	}
	
	/**
	 * ��ȡ�ͻ���ˮ�� ��object_maxsn���ֶ�ֵ�ڴδ������� tablename �����ƣ�columnname �����ƣ�maxserialno
	 * ��ǰ�����, datefmt ������Ѱ��Сֵ, nofmt ����
	 * 
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getCustomerIdOld(Transaction sqlca) throws Exception {
		
		long lMaxVal = 99999999L;
		String sql = "SELECT MAXSERIALNO, NOFMT FROM OBJECT_MAXSN WHERE TABLENAME = :TABLENAME AND COLUMNNAME = :COLUMNNAME";
		ASResultSet rs = sqlca.getASResultSet(new SqlObject(sql)
							.setParameter("TABLENAME", tableName)
							.setParameter("COLUMNNAME", colName));
		String customerId = null;
		String step = null;
		if (rs.next()) {
			customerId = rs.getString("MAXSERIALNO");
			step = rs.getString("NOFMT");
		}
		if (step == null || "".equals(step)) {
			step = "1";
		}
		rs.getStatement().close();
		if (customerId == null || "".equals(customerId)) {
			customerId = String.valueOf(Long
					.valueOf(GenerateSerialNo.INIT_CUSTOMERID)
					+ Long.valueOf(step));
			sql = "INSERT INTO OBJECT_MAXSN(TABLENAME, COLUMNNAME, MAXSERIALNO, DATEFMT, NOFMT) VALUES ("
				+ ":TABLENAME, :COLUMNNAME, :MAXSERIALNO, :DATEFMT, :NOFMT)";
			SqlObject asql = new SqlObject(sql)
					.setParameter("TABLENAME", tableName)
					.setParameter("COLUMNNAME", colName)
					.setParameter("MAXSERIALNO", customerId)
					.setParameter("DATEFMT", GenerateSerialNo.INIT_CUSTOMERID)
					.setParameter("NOFMT", step);
			sqlca.executeSQL(asql);
		} else {
			customerId = String.valueOf((Long.valueOf(customerId) + Long
					.valueOf(step)));
			// ����Ѿ��������ֵ����Ѱ��Сֵ��+1
			if (Long.valueOf(customerId).longValue() > lMaxVal) {
				String sInitMinVal = sqlca
						.getString(new SqlObject(
								"SELECT DATEFMT FROM OBJECT_MAXSN WHERE TABLENAME = :TABLENAME AND COLUMNNAME = :COLUMNNAME")
								.setParameter("TABLENAME", tableName)
								.setParameter("COLUMNNAME", colName));
				sInitMinVal = String.valueOf((Long.valueOf(sInitMinVal) + 1));
				customerId = String.valueOf((Long.valueOf(sInitMinVal) + Long
						.valueOf(step)));
				sqlca.executeSQL(new SqlObject(
						"UPDATE OBJECT_MAXSN SET MAXSERIALNO = :MAXSERIALNO, DATEFMT = :DATEFMT WHERE TABLENAME = :TABLENAME AND COLUMNNAME = :COLUMNNAME")
						.setParameter("TABLENAME", tableName)
						.setParameter("COLUMNNAME", colName)
						.setParameter("MAXSERIALNO", customerId)
						.setParameter("DATEFMT", sInitMinVal));
			} else {
				sqlca.executeSQL(new SqlObject(
						"UPDATE OBJECT_MAXSN SET MAXSERIALNO = :MAXSERIALNO WHERE TABLENAME = :TABLENAME AND COLUMNNAME = :COLUMNNAME")
						.setParameter("TABLENAME", tableName)
						.setParameter("COLUMNNAME", colName)
						.setParameter("MAXSERIALNO", customerId));
			}
		}

		return customerId;
	}

	/**
	 * ��ȡ��ͬ��ˮ��
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getContractId(Transaction sqlca) throws Exception {

		if (serialNo == null) {
			throw new RuntimeException("�봫��ͻ���ţ�");
		}
		String contractNO = serialNo + "001";
		String sSerialNo = sqlca
				.getString(new SqlObject(
						"SELECT SERIALNO FROM BUSINESS_CONTRACT WHERE CUSTOMERID = :CUSTOMERID ORDER BY SERIALNO DESC")
						.setParameter("CUSTOMERID", serialNo));
		Long val = null;
		if (sSerialNo != null) {
			val = Long.valueOf(sSerialNo
					.substring(sSerialNo.length() - 3)) + 1L;
			if (val != null) {
				if (val % 10L == 0) {
					val ++;
				}
			}
			contractNO = serialNo
					+ paddingChar(String.valueOf(val), 3, "0");
		}
		
		return contractNO;
	}
}
