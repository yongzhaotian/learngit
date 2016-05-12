<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  kfb 2005.03.08
 * Tester:
 *
 * Content: 交接用户动作 Ajax方式调用获取信息
 * Input Param:
 *
 * Output param:
 *
 *
 * History Log:
 *			
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%
	//获取参数：转移前用户编号、转移前机构代码、转移前机构名称、转移后机构代码、转移后机构名称
    String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));	
	String sToOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgID"));
	String sToOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgName"));
	SqlObject so = null;
	//转移日志信息
	String sChangeReason = "用户转移操作人员代码:"+CurUser.getUserID()+"   姓名："+CurUser.getUserName()+"   机构代码："+CurOrg.getOrgID()+"   机构名称："+CurOrg.getOrgName();
	//SQL语句，是否成功标志
	String sSql = "";
	String sReturnValue = "";
	String sInputDate   = StringFunction.getToday();
	try
	{
		 //将当前用户对应该客户和的所有业务（的相关内容）改为目标机构；
		sSql =  " update AGENCY_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID).setParameter("UpdateDate",StringFunction.getToday()).setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update AGENT_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID).setParameter("UpdateDate",StringFunction.getToday()).setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ASSET_CONTRACT set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ASSET_INFO set OperateOrgID = :OperateOrgID,UpdateDate=:UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ASSET_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update BILL_INFO set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
			
		sSql =  " update BUG_REPORT set OrgID = :OrgID where USERID = :USERID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("USERID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_APPLICANT set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update BUSINESS_APPLY set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_APPLY set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update BUSINESS_APPROVE set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_APPROVE set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update BUSINESS_CONTRACT set RecoveryOrgID = :RecoveryOrgID,UpdateDate = :UpdateDate where RecoveryUserID = :RecoveryUserID ";
		so = new SqlObject(sSql);
		so.setParameter("RecoveryOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("RecoveryUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_CONTRACT set RecoveryCognOrgID = :RecoveryCognOrgID,UpdateDate = :UpdateDate where RecoveryCognUserID = :RecoveryCognUserID ";
		so = new SqlObject(sSql);
		so.setParameter("RecoveryCognOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("RecoveryCognUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_CONTRACT set ManageOrgID = :ManageOrgID,UpdateDate = :UpdateDate where ManageUserID = :ManageUserID ";
		so = new SqlObject(sSql);
		so.setParameter("ManageOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("ManageUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_CONTRACT set StatOrgID = :StatOrgID,UpdateDate = :UpdateDate where StatUserID =:StatUserID ";
		so = new SqlObject(sSql);
		so.setParameter("StatOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("StatUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_CONTRACT set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_CONTRACT set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update BUSINESS_DUEBILL set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_DUEBILL set InputOrgID = :OperateOrgID,UpdateDate = :UpdateDate where InputUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_EXTENSION set OrgID = :OrgID where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		
		sSql =  " update BUSINESS_PUTOUT set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_PUTOUT set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_TYPE set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update BUSINESS_WASTEBOOK set OrgID = :OrgID where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update BUSINESS_WASTEBOOK set MFOrgID = :MFOrgID where MFUserID = :MFUserID ";
		so = new SqlObject(sSql);
		so.setParameter("MFOrgID",sToOrgID);
		so.setParameter("MFUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CASHFLOW_RECORD set OrgID = :OrgID where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CLASS_CATALOG set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CLASS_METHOD set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CLASSIFY_RECORD set OrgID = :OrgID where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);		
		
		sSql =  " update CODE_CATALOG set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);	
		

		
		sSql =  " update CODE_LIBRARY set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update CONTRACT_INFO set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update COST_INFO set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update COST_INFO set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CREDIT_PROVE set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);		
		
		sSql =  " update CUSTOMER_ANARECORD set OrgID = :OrgID,UpdateDate = :UpdateDate where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CUSTOMER_ANARECORD set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update CUSTOMER_BELONG set OrgID = :OrgID where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CUSTOMER_BELONG set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update CUSTOMER_BOND set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update CUSTOMER_FSRECORD set OrgID = :OrgID where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CUSTOMER_IMASSET set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update CUSTOMER_INFO set InputOrgID = :InputOrgID where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CUSTOMER_MEMO set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update CUSTOMER_OACCOUNT set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CUSTOMER_OACTIVITY set InputOrgID = :InputOrgID,UpdateDate =:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update CUSTOMER_REALTY set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CUSTOMER_RELATIVE set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);		
		
		sSql =  " update CUSTOMER_SPECIAL set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID =:InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		//sSql =  " update CUSTOMER_STOCK set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		sSql =  " update CUSTOMER_STOCK set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);		     
		
		sSql =  " update CUSTOMER_TAXPAYING set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update CUSTOMER_VEHICLE set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update DOC_ATTACHMENT set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update DOC_LIBRARY set OrgID = :OrgID,OrgName = :OrgName where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("OrgName",sToOrgName);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update DOC_LIBRARY set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update DUN_INFO set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);		
		
		
		
		sSql =  " update ENT_AUTH set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		//sSql =  " update ENT_BONDISSUE set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		sSql =  " update ENT_BONDISSUE set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ENT_ENTRANCEAUTH set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ENT_FIXEDASSETS set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ENT_FOA set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update ENT_INFO set UpdateOrgID = :UpdateOrgID,UpdateDate = :UpdateDate where UpdateUserID = :UpdateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("UpdateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UpdateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ENT_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ENT_INVENTORY set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ENT_IPO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);		
		
		
		
		sSql =  " update ENT_REALTYAUTH set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		
		
		sSql =  " update EVALUATE_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update EVALUATE_RECORD set OrgID =:OrgID where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update EXAMPLE_INFO set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update EXAMPLE_INFO set AuditOrg = :AuditOrg,UpdateTime = :UpdateTime where AuditUser = :AuditUser ";
		so = new SqlObject(sSql);
		so.setParameter("AuditOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("AuditUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update FLOW_OBJECT set OrgID = :OrgID,OrgName = :OrgName where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("OrgName",sToOrgName);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update FLOW_TASK set OrgID = :OrgID,OrgName = :OrgName where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("OrgName",sToOrgName);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update FLOW_TASK_CLOSED set OrgID = :OrgID,OrgName =:OrgName where UserID = :UserID";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("OrgName",sToOrgName);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update FORMATDOC_CATALOG set OrgID = :OrgID,UpdateDate=:UpdateDate where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update FORMATDOC_DATA set OrgID = :OrgID,UpdateDate = :UpdateDate where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update FORMATDOC_DEF set OrgID = :OrgID,UpdateDate = :UpdateDate where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update GUARANTY_CONTRACT set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update GUARANTY_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update HRUSER_INFO set BelongOrg = :BelongOrg where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("BelongOrg",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update IND_BI set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
	    sSql =  " update IND_EDUCATION set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update IND_INFO set UpdateOrgID = :UpdateOrgID,UpdateDate = :UpdateDate where UpdateUserID = :UpdateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("UpdateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UpdateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update IND_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update IND_OASSET set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update IND_ODEBT set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update IND_RESUME set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update IND_SI set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update INSPECT_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update INSPECT_INFO set InspectOrgID = :InspectOrgID,UpdateDate=:UpdateDate where InspectUserID = :InspectUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InspectOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InspectUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update INVOICE_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update LAWCASE_BOOK set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update LAWCASE_BOOK set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);		
		
		sSql =  "update LAWCASE_COGNIZANCE set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update LAWCASE_INFO set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update LAWCASE_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update LAWCASE_PERSONS set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update LC_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		
		
		sSql =  " update MANAGE_CHANGE set OldOrgID = :OldOrgID where OldUserID = :OldUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OldOrgID",sToOrgID);
		so.setParameter("OldUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update MANAGE_CHANGE set NewOrgID = :NewOrgID where NewUserID = :NewUserID ";
		so = new SqlObject(sSql);
		so.setParameter("NewOrgID",sToOrgID);
		so.setParameter("NewUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update MANAGE_CHANGE set ChangeOrgID = :ChangeOrgID where ChangeUserID = :ChangeUserID ";
		so = new SqlObject(sSql);
		so.setParameter("ChangeOrgID",sToOrgID);
		so.setParameter("ChangeUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update MESSAGE_INFO set SendOrgID = :SendOrgID where SendUserID = :SendUserID ";
		so = new SqlObject(sSql);
		so.setParameter("SendOrgID",sToOrgID);
		so.setParameter("SendUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update MESSAGE_INFO set ReceiveOrgID = :ReceiveOrgID where ReceiveUserID = :ReceiveUserID ";
		so = new SqlObject(sSql);
		so.setParameter("ReceiveOrgID",sToOrgID);
		so.setParameter("ReceiveUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update OBJECT_ATTRIBUTE set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update OBJECTTYPE_CATALOG set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ORG_INFO set InputOrg = :InputOrg,UpdateTime = :UpdateTime,UpdateDate = :UpdateDate where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update OTHERCHANGE_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		
		
		sSql =  " update PROJECT_BUDGET set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update PROJECT_FUNDS set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update PROJECT_INFO set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update PROJECT_PROGRESS set InputOrgID = :InputOrgID,UpdateDate=:UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		
		
		sSql =  " update RECLAIM_INFO set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update RECLAIM_INFO set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		/* sSql =  " update REG_COMMENT_ITEM set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);  */
		
		/* sSql =  " update REG_COMP_DEF set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);  */
		
		sSql =  " update REG_FUNCTION_DEF set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		/* sSql =  " update REG_PAGE_DEF set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);  */
		
		sSql =  " update REPORT_RECORD set OrgID = :OrgID,UpdateTime = :UpdateTime where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so); 
		
		sSql =  " update RIGHT_INFO set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so); 
		
		sSql =  " update RISK_SIGNAL set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ROLE_INFO set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update ROLE_RIGHT set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		
		
		sSql =  " update SEPERATOR_CATALOG set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update SYSTEM_LOG set OrgID = :OrgID,OrgName = :OrgName where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("OrgName",sToOrgName);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update TEAM_INFO set InputOrg = :InputOrg,UpdateTime = :UpdateTime,UpdateDate = :UpdateDate where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update TRACER_MANAGE set TraceOrgID = :TraceOrgID where TraceUserID = :TraceUserID ";
		so = new SqlObject(sSql);
		so.setParameter("TraceOrgID",sToOrgID);
		so.setParameter("TraceUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update TRACER_MANAGE set InputOrgID = :InputOrgID where InputUserID =:InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);	
		
		sSql =  " update TRADE_LOG set OperateOrgID = :OperateOrgID where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update USER_CHANGEINFO set OrgID = :OrgID where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update USER_INFO set InputOrg = :InputOrg,UpdateTime = :UpdateTime,UpdateDate = :UpdateDate where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update USER_INFO set BelongOrg = :BelongOrg,UpdateTime = :UpdateTime,UpdateDate = :UpdateDate where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("BelongOrg",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update USER_LIST set OrgID = :OrgID,OrgName = :OrgName where UserID = :UserID ";
		so = new SqlObject(sSql);
		so.setParameter("OrgID",sToOrgID);
		so.setParameter("OrgName",StringFunction.getToday());
		so.setParameter("UserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update USER_RELATIVE set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update USER_RIGHT set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update USER_ROLE set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update VIEW_CATALOG set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update VIEW_LIBRARY set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update WORK_RECORD set OperateOrgID = :OperateOrgID,UpdateDate = :UpdateDate where OperateUserID = :OperateUserID ";
		so = new SqlObject(sSql);
		so.setParameter("OperateOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("OperateUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update WORK_RECORD set InputOrgID = :InputOrgID,UpdateDate = :UpdateDate where InputUserID = :InputUserID ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrgID",sToOrgID);
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("InputUserID",sFromUserID);
		Sqlca.executeSQL(so);
		
		sSql =  " update WZD_MISSION set InputOrg = :InputOrg,UpdateTime = :UpdateTime where InputUser = :InputUser ";
		so = new SqlObject(sSql);
		so.setParameter("InputOrg",sToOrgID);
		so.setParameter("UpdateTime",StringFunction.getToday());
		so.setParameter("InputUser",sFromUserID);
		Sqlca.executeSQL(so);
		
		//在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
        String sSerialNo1 =  DBKeyHelp.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
				" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
		        " VALUES('User',:ObjectNo,:SerialNo,:OldOrgID,:OldOrgName,:NewOrgID, "+
		        " :NewOrgName,'','','','',:ChangeReason,:ChangeOrgID,:ChangeUserID,:ChangeTime)";
    	so = new SqlObject(sSql);
		so.setParameter("ObjectNo",sFromUserID);
		so.setParameter("SerialNo",sSerialNo1);
		so.setParameter("OldOrgID",sFromOrgID);
		so.setParameter("OldOrgName",sFromOrgName);
		so.setParameter("NewOrgID",sToOrgID);
		so.setParameter("NewOrgName",sToOrgName);
		so.setParameter("ChangeReason",sChangeReason);
		so.setParameter("ChangeOrgID",CurOrg.getOrgID());
		so.setParameter("ChangeUserID",CurUser.getUserID());
		so.setParameter("ChangeTime",sInputDate);
		Sqlca.executeSQL(so);
		
        sReturnValue = "TRUE";
	}
	catch(Exception e)
	{
		sReturnValue = "FALSE";
	}

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>