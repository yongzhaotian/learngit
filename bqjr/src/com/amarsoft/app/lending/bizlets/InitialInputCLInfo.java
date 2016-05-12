/*
		Author: --jschen 2010-03-17
		Tester:
		Describe: --补登新增授信额度时，需同时在额度信息表CL_INFO中新增一笔记录
		Input Param:
				BCSerialNo：额度协议号	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitialInputCLInfo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//对象编号
		String sObjectNo = (String)this.getAttribute("BCSerialNo");	
		//业务品种
		String sBusinessType = "";
		//客户编号
		String sCustomerID = "";
		//客户名称		
		String sCustomerName = "";		
		//登记人
		String sInputUser = "";
		//登记机构
		String sInputOrg = "";
		//冻结标志
		String sFreezeFlag = "";
		 
		SqlObject so=null;
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
	   	
	    //获得当前时间
	    String sCurDate = StringFunction.getToday();
	    String sSerialNo="",sClTypeName="",sSql="";
	    
	    //获取额度相关信息，插入到CL_INFO表中
	    sSql = "select BusinessType,CustomerID,CustomerName,InputUserID,InputOrgID,FreezeFlag from BUSINESS_CONTRACT where SerialNo =:SerialNo";
	    so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
	    ASResultSet rs = Sqlca.getASResultSet(so);
        if(rs.next()){
        	sBusinessType = rs.getString("BusinessType");
        	sCustomerID = rs.getString("CustomerID");
        	sCustomerName = rs.getString("CustomerName");
        	sInputUser = rs.getString("InputUserID");
        	sInputOrg = rs.getString("InputOrgID");
        	sFreezeFlag = rs.getString("FreezeFlag");
        }
	    rs.getStatement().close();
        
	    sSerialNo = DBKeyHelp.getSerialNo("CL_INFO","LineID",Sqlca);
	    so = new SqlObject("select TypeName from Business_Type where typeno=:typeno").setParameter("typeno", sBusinessType);
	    sClTypeName = Sqlca.getString(so);
	    sSql =  " insert into CL_INFO(LineID,CLTypeID,ClTypeName,BCSerialNo,CustomerID,CustomerName, "+
		" FreezeFlag,InputUser,InputOrg,InputTime,UpdateTime) "+
        " values (:LineID,'001',:ClTypeName,:BCSerialNo,:CustomerID, " + 
 	    " :CustomerName,:FreezeFlag,:InputUser,:InputOrg,:InputTime,:UpdateTime)";        
		//执行插入语句
	    so = new SqlObject(sSql);
	    so.setParameter("LineID", sSerialNo).setParameter("ClTypeName", sClTypeName).setParameter("BCSerialNo", sObjectNo)
	    .setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("FreezeFlag", sFreezeFlag)
	    .setParameter("InputUser", sInputUser).setParameter("InputTime", sCurDate).setParameter("UpdateTime", sCurDate).setParameter("InputOrg", sInputOrg);
		Sqlca.executeSQL(so);	
		//插入关联额度信息
		
		return "1";
	 }
}
