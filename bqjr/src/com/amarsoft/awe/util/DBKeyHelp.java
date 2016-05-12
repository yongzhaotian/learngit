package com.amarsoft.awe.util;

import com.amarsoft.are.ARE;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

public class DBKeyHelp {
	public static String sDataSource = "";

	private static String sLockSql = "update OBJECT_MAXSN set MaxSerialNo=MaxSerialNo where TableName=:TableName and ColumnName=:ColumnName and DateFmt=:DateFmt and NoFmt=:NoFmt";
	private static String sQuerySql = "select MaxSerialNo from OBJECT_MAXSN where TableName=:TableName and ColumnName=:ColumnName and DateFmt=:DateFmt and NoFmt=:NoFmt";
	private static String sUpdateSql = "update OBJECT_MAXSN set MaxSerialNo=:MaxSerialNo where TableName=:TableName and ColumnName=:ColumnName and DateFmt=:DateFmt and NoFmt=:NoFmt";
	private static String sInsertSql = "insert into OBJECT_MAXSN (TableName,ColumnName,MaxSerialNo,DateFmt,NoFmt) values (:TableName,:ColumnName,:MaxSerialNo,:DateFmt,:NoFmt)";
	
	private static String sQueryWorkNoSql = "select workNo_Seq.nextVal workno from dual"; //取序列
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd"); //获取日期号
	private static DecimalFormat df = new DecimalFormat("00000000");//格式化数字

	private static long iCount = 100000L;

	public static String getDataSource() {
		return sDataSource;
	}

	public static void setDataSource(String dataSource) {
		sDataSource = dataSource;
	}

	public static String getSerialNo() {
		return getSerialNo("T");
	}

	public static String getSerialNo(String sPrefix) {
		if (iCount > 999998L)
			iCount = 100000L;
		return sPrefix + RandomTools.getTimeString() + iCount++;
	}

	public static String getUUID() {
		return UUID.randomUUID().toString().replace("_", "");
	}

	public static String getSerialNo(String sTable, String sColumn)
			throws Exception {
		return getSerialNo(sTable, sColumn, "yyyyMMdd", "00000000", new Date());
	}

	public static String getSerialNo(String sTable, String sColumn,
			Transaction Sqlca) throws Exception {
		return getSerialNo(sTable, sColumn);
	}

	public static String getSerialNo(String sTable, String sColumn, String sPrefix) throws Exception {
		if ((sPrefix == null) || (sPrefix.equals("")))
			sPrefix = "";
		else {
			sPrefix = "'" + sPrefix + "'";
		}
		return getSerialNo(sTable, sColumn, sPrefix + "yyyyMMdd", "00000000", new Date());
	}

	public static String getSerialNo(String sTable, String sColumn, String sPrefix, Transaction Sqlca) throws Exception {
		return getSerialNo(sTable, sColumn, sPrefix);
	}

	public static String getSerialNo(String sTable, String sColumn, String sDateFmt, String sNoFmt, Date today, Transaction Sqlca) throws Exception {
		return getSerialNo(sTable, sColumn, sDateFmt, sNoFmt, today);
	}

	public static String getSerialNo(String sTable, String sColumn, String sDateFmt, String sNoFmt, Date today)
			throws Exception {
		Transaction Sqlca = null;
		String sNewSerialNo = "";
		try {
			Sqlca = new Transaction(sDataSource);
			sNewSerialNo = getSerialNoByCon(sTable, sColumn, sDateFmt, sNoFmt, today, Sqlca);
		} catch (Exception e) {
			throw new Exception("getSerialNo...失败！" + e.getMessage());
		} finally {
			if (Sqlca != null)
				Sqlca.disConnect();
		}
		return sNewSerialNo;
	}

	private static String getSerialNoByCon(String sTable, String sColumn, String sDateFmt, String sNoFmt, Date today, Transaction Sqlca)
			throws Exception {
		SimpleDateFormat simpledateformat = new SimpleDateFormat(sDateFmt);
		DecimalFormat decimalformat = new DecimalFormat(sNoFmt);
		String sDate = simpledateformat.format(today);
		int iDateLen = sDate.length();
		String sNewSerialNo = "";

		sTable = sTable.toUpperCase();
		sColumn = sColumn.toUpperCase();

		int iMaxNo = 0;
		try {
			SqlObject objLock = new SqlObject(sLockSql);
			objLock.setParameter("TableName", sTable)
					.setParameter("ColumnName", sColumn)
					.setParameter("DateFmt", sDateFmt)
					.setParameter("NoFmt", sNoFmt);
			Sqlca.executeSQL(objLock);

			SqlObject objQuery = new SqlObject(sQuerySql);
			objQuery.setParameter("TableName", sTable)
					.setParameter("ColumnName", sColumn)
					.setParameter("DateFmt", sDateFmt)
					.setParameter("NoFmt", sNoFmt);
			ASResultSet rs = Sqlca.getASResultSet(objQuery);
			if (rs.next()) {
				String sMaxSerialNo = rs.getString(1);
				rs.close();

				iMaxNo = 0;
				if ((sMaxSerialNo != null) && (sMaxSerialNo.indexOf(sDate, 0) != -1)) {
					iMaxNo = Integer.valueOf(sMaxSerialNo.substring(iDateLen)) .intValue();
					sNewSerialNo = sDate + decimalformat.format(iMaxNo + 1);
				} else {
					sNewSerialNo = getSerialNoFromDB(sTable, sColumn, "", sDateFmt, sNoFmt, today, Sqlca);
				}

				SqlObject objUpdate = new SqlObject(sUpdateSql);
				objUpdate.setParameter("MaxSerialNo", sNewSerialNo)
						.setParameter("TableName", sTable)
						.setParameter("ColumnName", sColumn)
						.setParameter("DateFmt", sDateFmt)
						.setParameter("NoFmt", sNoFmt);
				Sqlca.executeSQL(objUpdate);
			} else {
				rs.close();

				sNewSerialNo = getSerialNoFromDB(sTable, sColumn, "", sDateFmt, sNoFmt, today, Sqlca);

				SqlObject objInsert = new SqlObject(sInsertSql);
				objInsert.setParameter("MaxSerialNo", sNewSerialNo)
						.setParameter("TableName", sTable)
						.setParameter("ColumnName", sColumn)
						.setParameter("DateFmt", sDateFmt)
						.setParameter("NoFmt", sNoFmt);
				Sqlca.executeSQL(objInsert);
			}

			Sqlca.commit();
		} catch (Exception e) {
			Sqlca.rollback();
			ARE.getLog().error("getSerialNo...失败[" + e.getMessage() + "]!", e);
		}
		return sNewSerialNo;
	}

	public static String getSerialNoXD(String sTable, String sColumn, String sDateFmt, String sNoFmt, Date today, Transaction Sqlca)
			throws Exception {
		return getSerialNoByCon(sTable, sColumn, sDateFmt, sNoFmt, today, Sqlca);
	}

	public static String getSerialNoFromDB(String sTable, String sColumn, String sWhere, String sDateFmt, String sNoFmt, Date today, Transaction Sqlca)
			throws Exception {
		ARE.getLog().warn("****不建议的取流水号的方式(getSerialNoFromDB)****[" + sTable + "][" + sColumn + "]******");

		SimpleDateFormat sdfTemp = new SimpleDateFormat(sDateFmt);
		DecimalFormat dfTemp = new DecimalFormat(sNoFmt);

		String sPrefix = sdfTemp.format(today);
		int iDateLen = sPrefix.length();

		String sSql = "select max(" + sColumn + ") from " + sTable + " where " + sColumn + " like '" + sPrefix + "%' ";
		if (sWhere.length() > 0) {
			sSql = sSql + " and " + sWhere;
		}
		ASResultSet rsTemp = Sqlca.getResultSet(sSql);
		int iMaxNo = 0;
		if (rsTemp.next()) {
			String sMaxSerialNo = rsTemp.getString(1);
			if (sMaxSerialNo != null)
				iMaxNo = Integer.valueOf(sMaxSerialNo.substring(iDateLen)).intValue();
		}
		rsTemp.getStatement().close();

		String sNewSerialNo = sPrefix + dfTemp.format(iMaxNo + 1);
		ARE.getLog().info("newSerialNo[" + sTable + "][" + sColumn + "]=[" + sNewSerialNo+ "]");
		return sNewSerialNo;
	}

	public static String getSerialNo_for_alarm(String sTable, String sColumn, String sWhere, String sDateFmt, String sNoFmt, Date today, Transaction Sqlca)
			throws Exception {
		return getSerialNo_for_alarm(sTable, sColumn, sDateFmt, sNoFmt, today, Sqlca);
	}

	public static String getSerialNo_for_alarm(String sTable, String sColumn, String sDateFmt, String sNoFmt, Date today, Transaction Sqlca)
			throws Exception {
		return getSerialNoByCon(sTable, sColumn, sDateFmt, sNoFmt, today, Sqlca);
	}

	public static String getSerialNo(String sTable, String sColumn, String sWhere, String sDateFmt, String sNoFmt, Date today, Transaction Sqlca)
			throws Exception {
		return getSerialNo(sTable, sColumn, sDateFmt, sNoFmt, today, Sqlca);
	}

	/**
	 * 获取流程序列号[此方法只提供“FLOW_TASK”表使用]
	 * 
	 * @return yyyyMMdd00000000
	 */
	public static String getWorkNo() throws Exception {
		Transaction Sqlca = null;
		ASResultSet rs = null;
		String sWorkNo = ""; //流程编号
		String strSeq = ""; //序列号
		String sDateNo = ""; //日期号
		try {
			Sqlca = new Transaction(sDataSource);
			SqlObject objQuery = new SqlObject(sQueryWorkNoSql);
			rs = Sqlca.getASResultSet(objQuery);
			if (rs.next()) {
				strSeq = rs.getString(1);
			}
			strSeq = df.format(Integer.parseInt(strSeq)); //序列号
			sDateNo = sdf.format(new Date()); //获取时间号
			sWorkNo = sDateNo + strSeq; //流程编号
		} catch (Exception e) {
			throw new Exception("getWorkNo...失败！" + e.getMessage());
		} finally {
			if (rs != null)
				rs.getStatement().close();
			if (Sqlca != null)
				Sqlca.disConnect();
		}
		return sWorkNo;
	}

	public static void main(String[] argv) {
		try {
			ARE.init("etc/are.xml");
			setDataSource("als");
			for (int i = 0; i < 10; i++) {
				String sSerialNo = getSerialNo("BUSINESS_APPLY", "SERIALNO");
				ARE.getLog().info("BASE1 SerialNo=" + sSerialNo);
				sSerialNo = getSerialNo("BUSINESS_APPLY", "SERIALNO");
				ARE.getLog().info("BASE2 SerialNo=" + sSerialNo);
				sSerialNo = getSerialNo("BUSINESS_APPLY", "SERIALNO", "BA");
				ARE.getLog().info("Prefix1 SerialNo=" + sSerialNo);
				sSerialNo = getSerialNo("BUSINESS_APPLY", "SERIALNO", "BA");
				ARE.getLog().info("Prefix2 SerialNo=" + sSerialNo);
				sSerialNo = getSerialNo("BUSINESS_APPLY", "SERIALNO", "yyyyMMdd", "000000", new Date());
				ARE.getLog().info("Free1 SerialNo=" + sSerialNo);
				sSerialNo = getWorkNo();
				ARE.getLog().info("getWorkNo WorkNo=" + sSerialNo);
			}
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error("main error!", e);
		}
	}
}