package com.amarsoft.app.accounting.config;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.Configure;

public class SystemConfig{
	private static String businessDate;

	/*
	 * ֱ�Ӵ�ϵͳ��̬�����л�ȡϵͳӪҵ����
	 */
	public static String getBusinessDate() throws Exception{
	       if(businessDate==null||"".equals(businessDate) || businessDate.length() != 10)
	           return loadBusinessDate();
	       else return businessDate;
	}
	
	/*
	 * ֱ�Ӷ�ϵͳ��̬��������ϵͳӪҵ����
	 */
	public static void setBusinessDate(String BusinessDate) throws Exception{
		businessDate = BusinessDate;
	}
	
	/*
	 * ֱ�Ӵ����ݿ��л�ȡϵͳӪҵ����
	 */
	public static String loadBusinessDate() throws Exception{
		Configure CurConfig = null;
		String sDataSource = null;
		Connection conn = null;
		
		try
		{
			//����ϵͳ����������Ϣ��ȡ���ݿ�����
			CurConfig =  Configure.getInstance();
			sDataSource = (String)CurConfig.getConfigure("DataSource");
			conn = ARE.getDBConnection(sDataSource);
			businessDate = loadBusinessDate(conn);
			conn.close();
			conn = null;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}finally
		{
			if(conn != null)  conn.close();
		}
		return businessDate;
	}
	
	/*
	 * ���ݴ�������ݿ����ӣ�ֱ�Ӵ����ݿ��еõ�ϵͳӪҵ����
	 */
    public static String loadBusinessDate(Connection connection) throws Exception{
       PreparedStatement ps=connection.prepareStatement("select BusinessDate from SYSTEM_SETUP");
       ResultSet rs=ps.executeQuery();
       if(rs.next()){
          businessDate=rs.getString("BusinessDate");
          rs.close();
          ps.close();
       }else{
          rs.close();
          ps.close();
          throw new Exception("ϵͳ����δ���壬����ϵϵͳ����Ա���ã�");
       }
    	return businessDate;
    } 
	
	public static String getBusinessTime() throws Exception{
		return getBusinessDate()+" "+StringFunction.getNow();
	}
	
	public static String getSystemDate() throws Exception{
		return DateX.format(new Date());
	}
}
