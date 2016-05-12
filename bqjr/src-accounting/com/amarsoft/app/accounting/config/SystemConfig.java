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
	 * 直接从系统静态变量中获取系统营业日期
	 */
	public static String getBusinessDate() throws Exception{
	       if(businessDate==null||"".equals(businessDate) || businessDate.length() != 10)
	           return loadBusinessDate();
	       else return businessDate;
	}
	
	/*
	 * 直接对系统静态变量设置系统营业日期
	 */
	public static void setBusinessDate(String BusinessDate) throws Exception{
		businessDate = BusinessDate;
	}
	
	/*
	 * 直接从数据库中获取系统营业日期
	 */
	public static String loadBusinessDate() throws Exception{
		Configure CurConfig = null;
		String sDataSource = null;
		Connection conn = null;
		
		try
		{
			//根据系统启动配置信息获取数据库连接
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
	 * 根据传入的数据库连接，直接从数据库中得到系统营业日期
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
          throw new Exception("系统日期未定义，请联系系统管理员设置！");
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
