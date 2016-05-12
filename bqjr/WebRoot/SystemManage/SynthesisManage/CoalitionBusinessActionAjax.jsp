<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:mfhu  2005-3-17
 * Tester:
 *
 * Content:   	业务合并
 * Input Param:
 *				
 * Output param:
 *			
 * 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%	
	//获取变量：合并前客户编号、合并前客户名称、合并后的客户编号、合并后客户名称、合并后证件类型、合并后证件编号、合并后贷款卡编号
	String sFromCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromCustomerID"));	    
	String sFromCustomerName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromCustomerName"));
	String sToCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCustomerID"));	
	String sToCustomerName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCustomerName"));	
	String sToCertType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCertType"));	
	String sToCertID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCertID"));	
	String sToLoanCardNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToLoanCardNo"));	
	//将空值转化为空字符串
	if(sFromCustomerID == null) sFromCustomerID = "";
	if(sFromCustomerName == null) sFromCustomerName = "";
	if(sToCustomerID == null) sToCustomerID = "";
	if(sToCustomerName == null) sToCustomerName = "";
	if(sToCertType == null) sToCertType = "";
	if(sToCertID == null) sToCertID = "";
	if(sToLoanCardNo == null) sToLoanCardNo = "";
		
	//定义变量
	String sFlag = "";	
	String sSql = "";	
	SqlObject so = null;
	String sNewSql = "";
	//转移日志信息
	String sChangeReason = "业务合并操作人员代码:"+CurUser.getUserID()+"   姓名："+CurUser.getUserName()+"   机构代码："+CurOrg.getOrgID()+"   机构名称："+CurOrg.getOrgName();
	String sInputDate   = StringFunction.getToday();

	try
	{
		//更新申请表
		//Sqlca.executeSQL("update BUSINESS_APPLY set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		sNewSql = "update BUSINESS_APPLY set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//更新批复表
		sNewSql = "update BUSINESS_APPROVE set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//更新合同表
		sNewSql = "update BUSINESS_CONTRACT set CustomerID = :CustomerID,CustomerName = :CustomerName where CustomerID = :CustomerID ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//更新授信额度表
		sNewSql = "update CL_INFO set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//更新出帐表
		sNewSql = "update BUSINESS_PUTOUT set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
				
		//更新借据表
		sNewSql = "update BUSINESS_DUEBILL set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//更新流水表
		sNewSql = "update BUSINESS_WASTEBOOK set CustomerID1 = :CustomerID,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//更新担保合同和担保信息
		sNewSql = "update GUARANTY_CONTRACT set GuarantorID = :GuarantorID1,GuarantorName = :GuarantorName,CertType = :CertType,CertID = :CertID,LoanCardNo = :LoanCardNo where GuarantorID = :GuarantorID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("GuarantorID1",sToCustomerID);
		so.setParameter("GuarantorName",sToCustomerName);
		so.setParameter("CertType",sToCertType);
		so.setParameter("CertID",sToCertID);
		so.setParameter("LoanCardNo",sToLoanCardNo);
		so.setParameter("GuarantorID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		sNewSql = "update GUARANTY_INFO set OwnerID=:OwnerID1,OwnerName=:OwnerName,CertType = :CertType,CertID = :CertID,LoanCardNo = :LoanCardNo where OwnerID = :OwnerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("OwnerID1",sToCustomerID);
		so.setParameter("OwnerName",sToCustomerName);
		so.setParameter("CertType",sToCertType);
		so.setParameter("CertID",sToCertID);
		so.setParameter("LoanCardNo",sToLoanCardNo);
		so.setParameter("OwnerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//如果还要合并其他数据表中的客户请在下边区域中自行增加
		
		
		//在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
        String sSerialNo1 =  DBKeyHelp.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
				" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
		        " VALUES('UniteBusiness',:ObjectNo,:SerialNo,:OldOrgID,:OldOrgName,:NewOrgID, "+
		        " :NewOrgName,'','','','',:ChangeReason,:ChangeOrgID,:ChangeUserID,:ChangeTime)";
    	so = new SqlObject(sNewSql);
		so.setParameter("ObjectNo",sFromCustomerID);
		so.setParameter("SerialNo",sSerialNo1);
		so.setParameter("OldOrgID",sFromCustomerID);
		so.setParameter("OldOrgName",sFromCustomerName);
		so.setParameter("NewOrgID",sToCustomerID);
		so.setParameter("NewOrgName",sToCustomerName);
		so.setParameter("ChangeReason",sChangeReason);
		so.setParameter("ChangeOrgID",CurOrg.getOrgID());
		so.setParameter("ChangeUserID",CurUser.getUserID());
		so.setParameter("ChangeTime",sInputDate);
		Sqlca.executeSQL(so);
		sFlag = "TRUE";
	}
	catch(Exception e)
	{
		sFlag="FALSE";
		throw new Exception("事务处理失败！"+e.getMessage());
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sFlag);
	sFlag = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sFlag);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>