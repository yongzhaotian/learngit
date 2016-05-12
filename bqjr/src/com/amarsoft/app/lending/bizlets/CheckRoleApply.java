/*
		Author: --fwang 2009-06-12
		Tester:
		Describe: --判断客户经理之间的关系
		Input Param:
				CustomerID:客户ID
				UserID：当前用户ID
				OrgID：当前机构ID
		Output Param:
				"1":客户经理在同一机构
				"2":客户经理在同一上级机构
				"3":客户经理不在同一上级机构
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckRoleApply extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//获得客户ID
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//获得当前用户ID
		String sUserID = (String)this.getAttribute("UserID");
		//机构代码
		String sOrgID = (String)this.getAttribute("OrgID");
		
		//将空值转换为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		
		//定义变量	
		String  sSql = "";//存放sql语句	
		String  sSuperiorOrgID = "";//存放上级金融机构代码
		String  sOldOrgID = "";//该用户以前所属客户经理机构ID
		String  sOldRelativeOrgID = "";//该用户以前所属客户经理上级机构ID
		String	sApplyType ="";
		ASResultSet rs = null;//存放结果集
		SqlObject so ;//声明对象
		
		//获取该用户原所属客户经理机构ID
		sSql = "select OrgID from CUSTOMER_BELONG where CustomerID=:CustomerID and BelongAttribute='1'";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);
		
		if(rs.next())
		{
			sOldOrgID = rs.getString("OrgID");
		}
		rs.getStatement().close();
		
		//获取该用户原所属客户经理机构上级机构
		sSql = 	" select RelativeOrgID from ORG_INFO where OrgID =:OrgID ";
		so = new SqlObject(sSql).setParameter("OrgID", sOldOrgID);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sOldRelativeOrgID = rs.getString("RelativeOrgID");	
		}
		rs.getStatement().close();
		
		//获取当前机构的上级机构
		sSql = 	" select OI.RelativeOrgID as SuperiorOrgID"+
		" from ORG_INFO OI"+
		" where OI.OrgID =:OrgID ";
		so = new SqlObject(sSql).setParameter("OrgID", sOrgID);
        rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sSuperiorOrgID = rs.getString("SuperiorOrgID");	
		}
		rs.getStatement().close();
		
		//判断是否属于同一机构
		if(sOldOrgID.equals(sOrgID)){
			sApplyType = "1" ;
		//判断是否属于同一上级机构
		}else if(sOldRelativeOrgID.equals(sSuperiorOrgID)){
			sApplyType = "2" ;
		//判断是否属于不同上级机构
		}else {
			sApplyType = "3" ;
		}
		sSql = " update CUSTOMER_BELONG set ApplyType =:ApplyType where CustomerID =:CustomerID " ;
		so = new SqlObject(sSql).setParameter("ApplyType", sApplyType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		
		return "1";
	}
}


