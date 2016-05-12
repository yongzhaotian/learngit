/*
		Author: --CYHui 2005-12-13
		Tester:
		Describe: --取得当前客户经理管护有未结清单项交易或者有效授信批复的客户数量
		Input Param:
				UserID：用户代码
		Output Param:
				iCustomerAmount：户数
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCustomerAmount extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//获取当前用户
		String sUserID = (String)this.getAttribute("UserID");
		
		//将空值转化成空字符串
		if(sUserID == null) sUserID = "";
		
		//定义变量：SQL语句
		String sSql = "";
		int iCustomerAmount = 0;
				
		sSql =  "select nvl(count(distinct CustomerID),0) from BUSINESS_CONTRACT where OperateUserID =:sUserID ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sUserID", sUserID));
		if(rs.next())
			iCustomerAmount = rs.getInt(1);
		rs.getStatement().close();
		
		sSql = "select nvl(count(distinct CustomerID),0) from BUSINESS_APPROVE where OperateUserID =:sUserID1 and CustomerID not in(select CustomerID from BUSINESS_CONTRACT where OperateUserID =:sUserID2)";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sUserID1", sUserID).setParameter("sUserID2", sUserID));
		if(rs.next())
			iCustomerAmount = iCustomerAmount + rs.getInt(1);
		rs.getStatement().close();
				
		return String.valueOf(iCustomerAmount);
	}
}