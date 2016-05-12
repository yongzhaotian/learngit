/*
 		Author: --魏治毅 2005-11-23
		Tester:
		Describe: --新增授信额度申请记录时，需同时在额度信息表CL_INFO中新增一笔记录
		Input Param:
				ObjectNo：申请编号
				BusinessType：业务品种
				CustomerID: 客户代码
				CustomerName: 客户名称				
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeCLInfo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		//业务品种
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//客户编号
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//客户名称		
		String sCustomerName = (String)this.getAttribute("CustomerName");		
		//登记人
		String sInputUser = (String)this.getAttribute("InputUser");
		//登记机构
		String sInputOrg = (String)this.getAttribute("InputOrg");
		
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sCustomerID == null) sCustomerID = "";
	    if(sCustomerName == null) sCustomerName = "";
	    if(sInputUser == null) sInputUser = "";
	    if(sInputOrg == null) sInputOrg = "";
	   	SqlObject so ;
	    //获得当前时间
	    String sCurDate = StringFunction.getToday();
	    String sSerialNo="",sClTypeName="",sSql="";
	    
	    
        sSql =  " insert into Business_Apply(Serialno) "+
        " values (:sSerialNo)";
        so = new SqlObject(sSql);
        so.setParameter("sSerialNo", sObjectNo);
	    //执行插入语句
	    Sqlca.executeSQL(so);
	    
	    
	    
	    //如果业务品种是额度，则必须在额度信息表CL_INFO中插入一笔信息
	    if(sBusinessType.startsWith("3"))
	    {
	        sSerialNo = DBKeyHelp.getSerialNo("CL_INFO","LineID",Sqlca);
	        
	         sSql = "select TypeName from Business_Type where typeno=:typeno";
	         so = new SqlObject(sSql).setParameter("typeno", sBusinessType);
	         sClTypeName = Sqlca.getString(so);

	         sSql =  " insert into CL_INFO(LineID,CLTypeID,ClTypeName,ApplySerialNo,CustomerID,CustomerName, "+
     		" FreezeFlag,InputUser,InputOrg,InputTime,UpdateTime) "+
             " values (:LineID,'001',:ClTypeName,:ApplySerialNo,:CustomerID, " + 
      	    " :CustomerName,'1',:InputUser,:InputOrg,:InputTime,:UpdateTime)"; 
	         so = new SqlObject(sSql);
	         so.setParameter("LineID", sSerialNo).setParameter("ClTypeName", sClTypeName).setParameter("ApplySerialNo", sObjectNo)
	         .setParameter("CustomerID", sCustomerID).setParameter("InputUser", sInputUser).setParameter("InputOrg", sInputOrg)
	         .setParameter("InputTime", sCurDate).setParameter("UpdateTime", sCurDate).setParameter("CustomerName", sCustomerName);
		     //执行插入语句
		     Sqlca.executeSQL(so);
	    }	    
		return "1";
	 }
}
