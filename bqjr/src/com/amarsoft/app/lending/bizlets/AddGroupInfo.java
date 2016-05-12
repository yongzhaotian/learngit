package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddGroupInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值：集团客户编号，集团编号，操作人
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sRelativeID = (String)this.getAttribute("RelativeID");
		String sUserID  = (String)this.getAttribute("UserID");
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeID == null) sRelativeID = "";		
		if(sUserID == null) sUserID = "";
		
		//定义变量
		ASResultSet rs = null;
		String sSql = "";
		//声明对象
		SqlObject so = null;
		//客户类型
		String sCustomerType = "";
		//集团标志
		String sGroupFlag = "";
		//客户名称
		String sCustomerName = "";
		//证件类型
		String sCertType = "";
		//证件编号
		String sCertID = "";
				
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		
		//根据集团客户代码获取集团客户类型
		so = new SqlObject("select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID").setParameter("CustomerID", sRelativeID);
		sCustomerType = Sqlca.getString(so);
		if(sCustomerType == null) sCustomerType = "";
		
		//根据集团成员代码获取集团成员名称、证件类型、证件编号
		sSql = 	" select CustomerName,CertType,CertID "+
		" from CUSTOMER_INFO "+
		" where CustomerID =:CustomerID ";
		so = new SqlObject(sSql);
		so.setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);	
		if (rs.next()) 
		{					
			sCustomerName = rs.getString("CustomerName");	
			sCertType = rs.getString("CertType");
			sCertID = rs.getString("CertID");
			if(sCustomerName == null) sCustomerName = "";
			if(sCertType == null) sCertType = "";
			if(sCertID == null) sCertID = "";
		}
		rs.getStatement().close();
		
		//更新集团成员的所属集团
		sSql =  " update CUSTOMER_INFO set BelongGroupID =:BelongGroupID where CustomerID =:CustomerID ";
		so = new SqlObject(sSql).setParameter("BelongGroupID", sRelativeID).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		//更新集团成员的集团标志	
		if(sCustomerType.equals("0210")) sGroupFlag = "1";
		if(sCustomerType.equals("0220")) sGroupFlag = "2";
		sSql = 	" update ENT_INFO set GroupFlag =:GroupFlag where CustomerID =:CustomerID ";
		so = new SqlObject(sSql).setParameter("GroupFlag", sGroupFlag).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		
		//新增集团成员变更记录
		//变更流水号，集团代码，客户代码，变动类型，原客户名称，变动日期，操作机构，操作人员，客户名称，组织机构代码
		//变动标志：010：新增；020：删除
		String sSerialNo = DBKeyHelp.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
		if(sCertType.equals("Ent01"))
		{
			//只有证件类型为组织机构代码证时，才记录组织机构代码
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
			   " values(:SerialNo,:GroupNo,:CustomerID,'010',:OldName,:UpdateDate,:UpdateOrgid, "+
			   " :UpdateUserid,:CustomerName,:Corp)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sRelativeID).setParameter("CustomerID", sCustomerID)
			.setParameter("OldName", sCustomerName).setParameter("UpdateDate", StringFunction.getToday()).setParameter("UpdateOrgid", CurUser.getOrgID())
			.setParameter("UpdateUserid", CurUser.getUserID()).setParameter("CustomerName", sCustomerName).setParameter("Corp", sCertID);
			Sqlca.executeSQL(so);			
		}else
		{
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
			   " values(:SerialNo,:GroupNo,:CustomerID,'010',:OldName,:UpdateDate,:UpdateOrgid, "+
			   " :UpdateUserid,:CustomerName,'')";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sRelativeID).setParameter("CustomerID", sCustomerID)
			.setParameter("OldName", sCustomerName).setParameter("UpdateDate", StringFunction.getToday()).setParameter("UpdateOrgid", CurUser.getOrgID())
			.setParameter("UpdateUserid", CurUser.getUserID()).setParameter("CustomerName", sCustomerName);
			Sqlca.executeSQL(so);			
		}
				
		return "1";
	}		
}
