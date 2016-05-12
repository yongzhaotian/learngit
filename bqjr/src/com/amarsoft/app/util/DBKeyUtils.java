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
	private static SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd"); //��ȡ���ں�
	private static DecimalFormat df = new DecimalFormat("00000000");//��ʽ������

	private static String sQueryWorkNoSql = "select workNo_Seq.nextVal workno from dual"; //ȡ����
	
	/**
	 * ��ȡ���к�
	 * 
	 * @return yyyyMMddHHmmssSSSxxxxxxx000000
	 */
	public static synchronized String getSerialNo() {
		if (iCount > 999998L) {
			iCount = 100000L;
		}
		
		String sTime = sdf.format(new Date()); //��ȡʱ��
		
		String sRandom = getMathRandom(); //��ȡ7λ�����
		
		return sTime + sRandom + iCount++;
	}

	/**
	 * ��ȡ�ԡ�sPrefix����ͷ�����к�
	 * 
	 * @param sPrefix [sPrefix�ַ����鳤����λ�����ַ�,������λȥǰ��λ]
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
		
		String sTime = sdf2.format(new Date()); //��ȡʱ��
		
		String sRandom = getMathRandom(); //��ȡ7λ�����
		
		return sPrefix + sTime + sRandom + iCount++;
	}
	

	/**
	 * ��ȡʱ�����
	 * 
	 * @return yyyyMMdd0000000000000**
	 */
	public static synchronized String getTimeNo() {
		String sTime = sdf3.format(new Date()); //��ȡʱ��
		
		String millis = String.valueOf(System.currentTimeMillis()); //��ȡ��ǰʱ��ĺ���
		
		//��ȡ2λ�����
		String sRandom = Double.toString(Math.random()).substring(2);
		if (sRandom.length() > 3) 
			sRandom = sRandom.substring(0, 2);
		else
			sRandom = (sRandom + "0").substring(0, 2);
		
		return sTime + millis + sRandom;
	}
	
	/**
	 * ��ȡ�������к�[�˷���ֻ�ṩ��FLOW_TASK����ʹ��]
	 * 
	 * @param Sqlca 
	 * @return yyyyMMdd00000000
	 * @throws Exception
	 */
	public static synchronized String getWorkNo(Transaction Sqlca) throws Exception {
		ASResultSet rs = null;
		String sWorkNo = ""; //���̱��
		String strSeq = ""; //���к�
		String sDateNo = ""; //���ں�
		try {
			SqlObject objQuery = new SqlObject(sQueryWorkNoSql);
			rs = Sqlca.getASResultSet(objQuery);
			if (rs.next()) {
				strSeq = rs.getString(1);
			}
			strSeq = df.format(Integer.parseInt(strSeq)); //���к�
			sDateNo = sdf3.format(new Date()); //��ȡʱ���
			sWorkNo = sDateNo + strSeq; //���̱��
		} catch (Exception e) {
			throw new Exception("getWorkNo...ʧ�ܣ�" + e.getMessage());
		} finally {
			if (rs != null)
				rs.getStatement().close();
		}
		return sWorkNo;
	}

	/**
	 * ��ȡȥ����-����UUID
	 * 
	 * @return
	 */
	public static synchronized String getUUID() {
		String uuid = UUID.randomUUID().toString();
		return uuid.replace("-", "");
	}

	/**
	 * 
	 * ��ȡ��7λ������Ϊ�����ظ����ֱ��ȡ4λ��3λ�����������
	 * Math.random()����һ��[0��1)֮������double��ֵ����Java��js�����Գ��ô��롣 
	 * ���磺var a = Math.random() * 2 + 1������һ�����1��3(ȡ����3)�ı�����
	 * 
	 * @return
	 */
	public static String getMathRandom() {
		//��ȡ4λ�����
		String r1 = Double.toString(Math.random()).substring(2);
		if (r1.length() > 4) 
			r1 = r1.substring(0, 4);
		else
			r1 = (r1 + "000").substring(0, 4);
		
		//��ȡ3λ�����
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

