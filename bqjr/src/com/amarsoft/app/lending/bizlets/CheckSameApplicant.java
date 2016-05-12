package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckSameApplicant extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		
		//获取参数：流水号，对象类型，对象编号，和共同申请人ID
		String sSerialNo = (String)this.getAttribute("SerialNo");		//无用参数 by yzheng
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sApplicantID = (String)this.getAttribute("ApplicantID");						
		
		//将空值转化成空字符串
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sApplicantID == null) sApplicantID = "";
		
		SqlObject so ;//声明对象
		//定义变量：SQL语句、返回结果、业务申请人
		String sSql = "";
		String sReturn = "";
		String sCustomerID = "";
		boolean sFlag = false;
		//定义变量：查询结果集
		ASResultSet rs = null;
		//判断是否存在共同申请人
		sSql = " select SerialNo,ApplicantID  from BUSINESS_APPLICANT where ObjectNo=:ObjectNo and ObjectType=:ObjectType ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
	    rs = Sqlca.getResultSet(so);
		
		while(rs.next()) 
		{
			//取数据库中存在的共同申请人ID
			String sApplicantID1 = rs.getString("ApplicantID");
			if(sApplicantID1 ==null) sApplicantID1 = "";
			//如果该共同申请人已经存在则退出循环
			if(sApplicantID.equals(sApplicantID1))
			{
				sFlag = true;	
				break;		
			}			
		}
		rs.getStatement().close();
			
		//判断共同申请人是否和申请人相同  
		if(!sFlag)
		{	
			String sTableName="";
			//不同阶段在不同表中查询CustomerID
			if(sObjectType.equalsIgnoreCase("BusinessContract"))
			{
				sTableName = "BUSINESS_CONTRACT";
			}else if(sObjectType.equalsIgnoreCase("ApproveApply"))
			{
				sTableName = "BUSINESS_APPROVE";
			}else if(sObjectType.equalsIgnoreCase("CreditApply"))
			{
				sTableName = "BUSINESS_APPLY";
			}
			//如果取得表明则执行sql
			if(!sTableName.equals(""))
			{
				sSql = "select CustomerID from " + sTableName + " where SerialNo=:SerialNo  ";	
				so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				sCustomerID = Sqlca.getString(so);
			}
			
			if(sCustomerID == null) sCustomerID="";
		}
		//判断返回信息
		if(sFlag)
			sReturn = "对不起，该申请人已经存在！";
		else if(sApplicantID.equals(sCustomerID))
			sReturn = "对不起，共同申请人和业务申请人不能相同！";
		else
			sReturn = "SUCCESS";
		//返回值
		return sReturn;
	}

}
