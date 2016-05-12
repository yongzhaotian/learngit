package com.amarsoft.app.accounting.web.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class SelectCalendar extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		/**
		 * Modify by hlhaung 2013/05/08
		 * content:得到展示月份的节假日维护情况
		 */
		//定义变量
		String sSql = "";
		String sReturn = "";
		boolean flag = false;
		
		String sCurDate = (String) this.getAttribute("CurDate");
		String sArea = (String) this.getAttribute("Area");
		if(sCurDate.split("/")[1].length()==1){
			sCurDate = sCurDate.split("/")[0]+"/0"+sCurDate.split("/")[1];
		}
		
		//将空值转化为空字符串
		if(sCurDate == null) sCurDate = "";
	   	if(sArea==null) sArea="";
	   	
	   	Sqlca.getConnection().setAutoCommit(false);
	   	try{
	   		sSql = "select CurDate,WorkFlag from system_calendar where CurDate like ? and CalendarType=?";
	   		PreparedStatement pre = Sqlca.getConnection().prepareStatement(sSql);
	   		pre.setString(1, sCurDate+"%");
	   		pre.setString(2, sArea);
	   		ResultSet rs = pre.executeQuery();
	   		
	   		while(rs.next()){
	   			if(!flag){
	   				flag=true;
	   			}
	   			sReturn += rs.getString("CurDate")+","+rs.getString("WorkFlag")+"@";
	   		}
	   		if(flag){
	   			sReturn = sReturn.substring(0, sReturn.length()-1);
	   		}
	   		rs.close();
	   		pre.close();
	   		return sReturn;
	   	}catch (Exception e) {
			e.printStackTrace();
			Sqlca.getConnection().rollback();
			return sReturn;
		}
	}

}
