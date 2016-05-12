/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --将已批准的预警信息复制到预警信息解除中
		Input Param:
				ObjectNo: 批准的预警信息编号				
		Output Param:
				SerialNo：流水号
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class AddRiskSignalFreeInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{		
		//获得已批准预警信息流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获取当前用户
		String sUserID = (String)this.getAttribute("UserID");
		
		//将空值转化成空字符串		
		if(sObjectNo == null) sObjectNo = "";		
		if(sUserID == null) sUserID = "";
		
		//获得流水号
		String sSerialNo = DBKeyHelp.getSerialNo("RISK_SIGNAL","SerialNo","",Sqlca);
		//定义变量：SQL语句
		String sSql = "";		
						
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		
		//将已批准的信息复制到预警信息解除中
		sSql =  "insert into RISK_SIGNAL ( "+
					"ObjectType, "+          
					"ObjectNo, "+
					"SerialNo, "+
					"RelativeSerialNo, "+ 
					"SignalType, "+
					"SignalStatus, "+
					"InputOrgID, "+
					"InputUserID, "+
					"InputDate, "+
					"UpdateDate, "+
					"Remark, "+
					"SignalNo, "+
					"SignalName, "+
					"MessageOrigin, "+ 
					"MessageContent, "+
					"ActionFlag, "+
					"ActionType, "+											
					"FreeReason, "+
					"SignalChannel) "+					
					"select "+ 
					"ObjectType, "+          
					"ObjectNo, "+
					"'"+sSerialNo+"', "+
					"'"+sObjectNo+"', "+ 
					"'02', "+
					"'10', "+
					"'"+CurUser.getOrgID()+"', " + 
					"'"+CurUser.getUserID()+"', " +
					"'"+StringFunction.getToday()+"', " + 
					"'"+StringFunction.getToday()+"', " + 
					"'', "+
					"SignalNo, "+
					"SignalName, "+
					"MessageOrigin, "+ 
					"MessageContent, "+
					"ActionFlag, "+
					"ActionType, "+		
					"FreeReason, "+
					"SignalChannel "+					
					"from RISK_SIGNAL " +
					"where SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);		
				
		return sSerialNo;
	}	
}
