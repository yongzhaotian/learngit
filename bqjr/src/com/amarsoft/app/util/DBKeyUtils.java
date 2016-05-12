package com.amarsoft.app.util;

import java.util.Date;
import java.util.UUID;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class DBKeyUtils {
	private static long iCount = 100000L;

	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
	private static SimpleDateFormat sdf2 = new SimpleDateFormat("yyMMddHHmmssSSS");
	private static SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd"); //获取日期号
	private static DecimalFormat df = new DecimalFormat("00000000");//格式化数字

	private static String sQueryWorkNoSql = "select workNo_Seq.nextVal workno from dual"; //取序列
	
	/**
	 * 获取序列号
	 * 
	 * @return yyyyMMddHHmmssSSSxxxxxxx000000
	 */
	public static synchronized String getSerialNo() {
		if (iCount > 999998L) {
			iCount = 100000L;
		}
		
		String sTime = sdf.format(new Date()); //获取时间
		
		String sRandom = getMathRandom(); //获取7位随机数
		
		return sTime + sRandom + iCount++;
	}

	/**
	 * 获取以“sPrefix”开头的序列号
	 * 
	 * @param sPrefix [sPrefix字符建议长度两位以内字符,超过两位去前两位]
	 * @return **MMddHHmmssSSSxxxxxxx000000
	 */
	public static synchronized String getSerialNo(String sPrefix) {
		if(sPrefix != null && !"".equals(sPrefix)){
			sPrefix = sPrefix.trim();
			if(sPrefix.length()>2)
				sPrefix = sPrefix.substring(2).toUpperCase();
			else
				sPrefix = sPrefix.toUpperCase();
		}
		
		if (iCount > 999999L) 
			iCount = 100000L;
		
		String sTime = sdf2.format(new Date()); //获取时间
		
		String sRandom = getMathRandom(); //获取7位随机数
		
		return sPrefix + sTime + sRandom + iCount++;
	}
	

	/**
	 * 获取时间序号
	 * 
	 * @return yyyyMMdd0000000000000**
	 */
	public static synchronized String getTimeNo() {
		String sTime = sdf3.format(new Date()); //获取时间
		
		String millis = String.valueOf(System.currentTimeMillis()); //获取但前时间的毫秒
		
		//获取2位随机数
		String sRandom = Double.toString(Math.random()).substring(2);
		if (sRandom.length() > 3) 
			sRandom = sRandom.substring(0, 2);
		else
			sRandom = (sRandom + "0").substring(0, 2);
		
		return sTime + millis + sRandom;
	}
	
	/**
	 * 获取流程序列号[此方法只提供“FLOW_TASK”表使用]
	 * 
	 * @param Sqlca 
	 * @return yyyyMMdd00000000
	 * @throws Exception
	 */
	public static synchronized String getWorkNo(Transaction Sqlca) throws Exception {
		ASResultSet rs = null;
		String sWorkNo = ""; //流程编号
		String strSeq = ""; //序列号
		String sDateNo = ""; //日期号
		try {
			SqlObject objQuery = new SqlObject(sQueryWorkNoSql);
			rs = Sqlca.getASResultSet(objQuery);
			if (rs.next()) {
				strSeq = rs.getString(1);
			}
			strSeq = df.format(Integer.parseInt(strSeq)); //序列号
			sDateNo = sdf3.format(new Date()); //获取时间号
			sWorkNo = sDateNo + strSeq; //流程编号
		} catch (Exception e) {
			throw new Exception("getWorkNo...失败！" + e.getMessage());
		} finally {
			if (rs != null)
				rs.getStatement().close();
		}
		return sWorkNo;
	}

	/**
	 * 获取去掉“-”的UUID
	 * 
	 * @return
	 */
	public static synchronized String getUUID() {
		String uuid = UUID.randomUUID().toString();
		return uuid.replace("-", "");
	}

	/**
	 * 
	 * 获取随7位机数（为避免重复，分别获取4位和3位两组随机数）
	 * Math.random()产生一个[0，1)之间的随机double数值，是Java、js等语言常用代码。 
	 * 例如：var a = Math.random() * 2 + 1，设置一个随机1到3(取不到3)的变量。
	 * 
	 * @return
	 */
	public static String getMathRandom() {
		//获取4位随机数
		String r1 = Double.toString(Math.random()).substring(2);
		if (r1.length() > 4) 
			r1 = r1.substring(0, 4);
		else
			r1 = (r1 + "000").substring(0, 4);
		
		//获取3位随机数
		String r2 = Double.toString(Math.random()).substring(2);
		if (r2.length() > 3) 
			r2 = r2.substring(0, 3);
		else
			r2 = (r2 + "00").substring(0, 3);
		return r1 + r2;
	}
	
	public static void main(String[] args) {
		for (int i = 0; i < 10; i++) {
			System.out.println("getSerialNo(T)=" + getSerialNo("DK"));
		}
	}
}

