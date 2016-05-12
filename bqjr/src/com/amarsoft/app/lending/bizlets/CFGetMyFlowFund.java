
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * Author: --qfang 2011-06-03
 * Tester:
 * Describe: --获取本行流动资金贷款
            本类方法中本行流动资金贷款定义为该客户：未结清业务的余额总和。
 * Input Param:
        ObjectType: 对象类型(申请、审批、合同)
		ObjectNo: 申请、批复、合同流水号
 * Output Param:
		dTotalBalance：本行流动资金贷款额
 * HistoryLog:
*/

public class CFGetMyFlowFund extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//获得对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//获得对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//定义变量：SQL语句
		String sSql = "";
		//定义变量：查询结果集
		ASResultSet rs = null;
		//本行流动资金贷款额
		double dTotalBalance = 0.0;
		
		//取合同余额总和
		sSql = 	"select nvl(sum(Balance),0) as TotalBalance from BUSINESS_CONTRACT where BusinessType like '1010%' and CustomerID=:CustomerID";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sObjectNo));
		if(rs.next())
		{			
			dTotalBalance = rs.getDouble("TotalBalance");
		}
		rs.getStatement().close();	   	
		return dTotalBalance+"";
	}
	
}
