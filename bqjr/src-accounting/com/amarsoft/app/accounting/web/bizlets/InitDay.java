package com.amarsoft.app.accounting.web.bizlets;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitDay extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String aArea = (String) this.getAttribute("Area");
		String sDateArr = (String) this.getAttribute("DateArr");
		int star = 0,totalDay = 0;
		Connection conn = Sqlca.getConnection();
		conn.setAutoCommit(false);
		PreparedStatement pre = null;
		ResultSet rs = null;
		try
		{
			String sBeginDate = sDateArr.split("@")[0];
			String sEndDate = sDateArr.split("@")[1];
			String date = sBeginDate;
			//求出总共的天数
			totalDay = DateFunctions.getDays(sBeginDate, sEndDate)+1;
			
			boolean flag = false;
			for(int i=0;i<totalDay;i++)
			{
				//获取开始日是星期几
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
				Date d = sdf.parse(date);
				Calendar c = Calendar.getInstance();
				c.setTime(d);
				star = c.get(Calendar.DAY_OF_WEEK)-1;
				pre = conn.prepareStatement("select CurDate from system_calendar where CurDate = ? and CalendarType = ?");
				pre.setString(1, date);
				pre.setString(2,aArea);
				rs = pre.executeQuery();
				if(rs.next())
				{
					c.setTime(d);
					c.add(Calendar.DATE, +1);
					date = sdf.format(c.getTime());
					flag = true;
				}
				rs.close();
				pre.close();
				if(flag)
				{
					flag = false;
					continue;
				}
				
				//添加记录
				pre = conn.prepareStatement("insert into system_calendar(CurDate,WorkFlag,CalendarType) values (?,?,?)");
				pre.setString(1, date);
				if(star<=5 && star!=0)
				{
					pre.setString(2, "1");//工作日
				}else
				{
					pre.setString(2, "2");//节假日
				}
				pre.setString(3,aArea);
				pre.executeUpdate();
				pre.close();
				
				c.setTime(d);
				c.add(Calendar.DATE, +1);
				date = sdf.format(c.getTime());
			}
			return "true";
		}catch(Exception e)
		{
			e.printStackTrace();
			conn.rollback();
			return "false";
		}
	}
}
