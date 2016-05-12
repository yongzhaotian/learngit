package com.amarsoft.app.billions;

import java.sql.ResultSetMetaData;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CommonUtils {
	
	/**
	 * 取出非法字符（包括两端空格）
	 * @param s
	 * @return
	 */
	public static String replaceIllegalChar(String s) {
	
		String sRet = s;
		if (s ==  null) {
			sRet = "";
		}
		sRet = s.replaceAll("[\\\\|'|\"]+", "");
		return sRet.trim();
	}
	
	/**
	 * 复制记录
	 * @param Sqlca
	 * @param tableName
	 * @param colName
	 * @param colValue
	 * @throws Exception
	 */
	public static void copyRecord(Transaction Sqlca, String tableName, String colName, String colValue)  throws Exception{
		
		SqlObject sqlObj = null;
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("Select * from "+tableName + " where "+colName+"='"+colValue+"'"));
		ResultSetMetaData rsmd = rs.getMetaData();
		StringBuffer sbColums = new StringBuffer();
		StringBuffer sbValues = new StringBuffer();
		//String types = "";
				
		for (int i=1; i<=rsmd.getColumnCount(); i++) {
			String sColName = rsmd.getColumnName(i);
			sbColums.append(sColName).append(",");
			sbValues.append(":").append(sColName).append(",");
			//types += rsmd.getColumnTypeName(i) + ",";
		}
		// 得到插入sql
		StringBuffer sbInsert = new StringBuffer();
		if (sbColums.length()>0 && sbValues.length()>0) {
			sbInsert.append("INSERT INTO ").append(tableName).append("(").append(sbColums.deleteCharAt(sbColums.length()-1)).append(")")
				.append(" VALUES (").append(sbValues.deleteCharAt(sbValues.length()-1)).append(")");
			sqlObj = new SqlObject(sbInsert.toString());
		}
		
		// 注册设置值
		if(rs.next()) {
			for (int i=1; i<=rsmd.getColumnCount(); i++) {
				String sCol  = rsmd.getColumnName(i);
				if (sCol.equalsIgnoreCase(colName)) {
					sqlObj.setParameter(sCol, DBKeyHelp.getSerialNo(tableName, colName,"S"));
					continue;
				}
				// fixme 判定类型 只判断浮点和字符串类型
				String sColType = rsmd.getColumnTypeName(i);
				if ("VARCHAR2".equals(sColType)) {
					sqlObj.setParameter(sCol, rs.getString(sCol));
				} else if ("NUMBER".equals(sColType)) {
					sqlObj.setParameter(sCol, rs.getDouble(sCol));
				}
			}
		}
		
		Sqlca.executeSQL(sqlObj);
		System.out.println("Insert Sql : " + sbInsert.toString());
		rs.getStatement().close();
		//System.out.println("Types: " + types);
	}
	
	public static void main(String[] args) {
		
		String s = "xxxx \\\"\\\\ '''";
		System.out.println(s);
		System.out.println(CommonUtils.replaceIllegalChar(s));
	}
}
