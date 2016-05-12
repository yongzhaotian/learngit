package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class UpdateGroupType extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值	    
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sUserID   = (String)this.getAttribute("UserID");
		String sChangeFlag   = (String)this.getAttribute("ChangeFlag");
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		if(sChangeFlag == null) sChangeFlag = "";
		
		//定义变量		
		ASResultSet rs = null;
		String sSql = "";//Sql语句
		SqlObject so;
		String sCustomerType = "";//客户类型
		String sGroupType = "";//集团客户类型
		String sChangeType = "";//变更类型
		String sSerialNo = "";//变更流水号
		
		//实例化用户对象
	    ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		if(sChangeFlag.equals("1To2"))//将一类集团客户转换为二类集团客户
		{
			sCustomerType = "0202";
			sGroupType = "2";
			sChangeType = "050";
		}
		if(sChangeFlag.equals("2To1"))//将二类集团客户转换为一类集团客户
		{
			sCustomerType = "0201";
			sGroupType = "1";
			sChangeType = "040";
		}
		
		//将集团客户的客户类型由一类集团客户更新为二类集团客户
		sSql =  " update CUSTOMER_INFO "+
				" set CustomerType =:CustomerType "+
				" where CustomerID =:CustomerID ";
		//执行更新语句
		so = new SqlObject(sSql).setParameter("CustomerType", sCustomerType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	    
	    //将集团客户概况信息的机构性质由一类集团客户更新为二类集团客户
		sSql =  " update ENT_INFO "+
				" set OrgNature =:OrgNature , "+
				" GroupFlag =:GroupFlag "+
				" where CustomerID =:CustomerID ";
		//执行更新语句
		so = new SqlObject(sSql).setParameter("OrgNature", sCustomerType)
		.setParameter("GroupFlag", sGroupType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	    	    	    
	    //将集团成员概况信息的机构性质、集团客户标志由一类集团客户更新为二类集团客户
		sSql =  " update ENT_INFO "+
				" set GroupFlag =:GroupFlag "+
				" where CustomerID in "+
				" (select RelativeID "+
				" from CUSTOMER_RELATIVE "+
				" where CustomerID =:CustomerID "+
				" and RelationShip like '04%' "+
				" and length(RelationShip)>2) "; 
		//执行更新语句
		so = new SqlObject(sSql).setParameter("GroupFlag", sGroupType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	    
	   //将集团成员的集团分类由一类集团客户更新为二类集团客户
		sSql =  " update CUSTOMER_RELATIVE "+
				" set Describe =:Describe "+
				" where CustomerID =:CustomerID "+
				" and RelationShip like '04%' "+
				" and length(RelationShip)>2 ";
		//执行更新语句
		so = new SqlObject(sSql).setParameter("Describe", sGroupType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so); 
		
		//登记集团成员变更记录
	    //获取集团成员的客户编号、客户名称、证件类型、组织机构代码
		sSql = 	" select RelativeID,CustomerName,CertType,CertID "+
				" from CUSTOMER_RELATIVE "+
				" where CustomerID =:CustomerID "+
				" and RelationShip like '04%' "+
				" and length(RelationShip)>2 ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);
	    while(rs.next())
	    {
	    	String sRelativeID = rs.getString("RelativeID");
	    	String sRelativeName = rs.getString("CustomerName");
	    	String sCertType = rs.getString("CertType");
	    	String sCertID = rs.getString("CertID");
	    	if(sCertType.equals("Ent01"))
	    	{
	    		//变更流水号，集团代码，客户代码，变动类型，原客户名称，变动日期，操作机构，操作人员，客户名称，组织机构代码
	    		//变动标志：010：新增；020：删除；030：更名； 040：二类转一类；050：一类转二类
	    		sSerialNo = DBKeyHelp.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
	    		sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
		 			   " values(:SerialNo,:GroupNo,:CustomerID,:ChangeType,:OldName,:UpdateDate,:UpdateOrgid, "+
		 			   " :UpdateUserid,:CustomerName,:Corp)";
	    		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sCustomerID).setParameter("CustomerID", sRelativeID)
	    		.setParameter("ChangeType", sChangeType).setParameter("OldName", sRelativeName).setParameter("UpdateDate", StringFunction.getToday())
	    		.setParameter("UpdateOrgid", CurUser.getOrgID()).setParameter("UpdateUserid", sUserID).setParameter("CustomerName", sRelativeName).setParameter("Corp", sCertID);
	    		Sqlca.executeSQL(so);	
	    	}else
	    	{
	    		//变更流水号，集团代码，客户代码，变动类型，原客户名称，变动日期，操作机构，操作人员，客户名称，组织机构代码
	    		//变动标志：010：新增；020：删除；030：更名； 040：二类转一类；050：一类转二类
	    		sSerialNo = DBKeyHelp.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
	    		sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
		 			   " values(:SerialNo,:GroupNo,:CustomerID,:ChangeType,:OldName,:UpdateDate,:UpdateOrgid, "+
		 			   " :UpdateUserid,:CustomerName,'')";
	    		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sCustomerID).setParameter("CustomerID", sRelativeID)
	    		.setParameter("ChangeType", sChangeType).setParameter("OldName", sRelativeName).setParameter("UpdateDate", StringFunction.getToday())
	    		.setParameter("UpdateOrgid", CurUser.getOrgID()).setParameter("UpdateUserid", sUserID).setParameter("CustomerName", sRelativeName);
	    		Sqlca.executeSQL(so);
	    	}
	    }
	    rs.getStatement().close();
	    
	    return "1";
	    
	 }

}
