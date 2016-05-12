<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: 报表更新操作
		Input Param:
             ObjectNo ：   对象编号 目前默认为客户编号
             ObjectType ： 报表类型 目前默认CustomerFS
             ReportDate ： 报表截止日期    
		Output param:
		History Log: 
			利用改造过的类一次性新增或删除一套报表
			对多表操作增加事务处理 zywei 2007/10/10
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>报表更新操作</title>
<%
	String sObjectType = "",sObjectNo = "",sWhere = "",sReportDate = "",sOrgID = "",sUserID = "",sActionType = "";
	String sReportScope = "",sSql = "",sSql1 = "",sSql2 = "",sNewReportDate = "";
	SqlObject so = null;
	String sNewSql = "";
	//zywei 2007/10/10 增加事务处理标志
	String sDealFlag = "";
	String sReturnValue="";
	//对象编号 暂时为客户号
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//对象类型 暂时都为CustomerFS
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	sReportScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	sWhere = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Where"));
	sNewReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NewReportDate"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null)	sObjectType = "";
	if(sReportDate == null)	sReportDate = "";
	if(sReportScope == null) sReportScope = "";
	if(sWhere == null)	sWhere = "";
	if(sNewReportDate == null)	sNewReportDate = "";
	sWhere = StringFunction.replace(sWhere,"^","=");
	
	//报表操作类型
	sActionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));
	if(sActionType==null)	sActionType = "";	
	
	sOrgID = CurOrg.getOrgID();
	sUserID = CurUser.getUserID();
	
    try{
		if(sActionType.equals("AddNew")){
			// 根据指定MODEL_CATALOG的where条件增加一批新报表		
			Report.newReports(sObjectType,sObjectNo,sReportScope,sWhere,sReportDate,sOrgID,sUserID,Sqlca);
		}else if(sActionType.equals("Delete")){
			// 删除指定关联对象和日期的一批报表 
			Report.deleteReports(sObjectType,sObjectNo,sReportScope,sReportDate,Sqlca);	
			sNewSql = " delete from CUSTOMER_FSRECORD "+
					" where CustomerID = :CustomerID "+
					" and ReportDate = :ReportDate "+
					" and ReportScope = :ReportScope ";
			so = new SqlObject(sNewSql);
			so.setParameter("CustomerID",sObjectNo);
			so.setParameter("ReportDate",sReportDate);
			so.setParameter("ReportScope",sReportScope);
			Sqlca.executeSQL(so);
		}else if(sActionType.equals("ModifyReportDate")){
			// 更新指定报表的会计月份 
			sNewSql = " update CUSTOMER_FSRECORD "+
					" set ReportDate=:ReportDate "+
					" where CustomerID=:CustomerID "+
					" and ReportDate=:ReportDate "+
					" and ReportScope = :ReportScope ";
			so = new SqlObject(sNewSql);
			so.setParameter("ReportDate",sNewReportDate);
			so.setParameter("CustomerID",sObjectNo);
			so.setParameter("ReportDate",sReportDate);
			so.setParameter("ReportScope",sReportScope);
			Sqlca.executeSQL(so);
			
			// 更新指定报表的会计月份
			sNewSql = " update REPORT_RECORD "+
					" set ReportDate=:ReportDate "+
					" where ObjectNo=:ObjectNo "+
					" and ReportDate=:ReportDate"+
					" and ReportScope = :ReportScope ";
			so = new SqlObject(sNewSql);
			so.setParameter("ReportDate",sNewReportDate);
			so.setParameter("ObjectNo",sObjectNo);
			so.setParameter("ReportDate",sReportDate);
			so.setParameter("ReportScope",sReportScope);
	    	Sqlca.executeSQL(so);
		}
		
		sDealFlag = "ok";		
    }catch(Exception e){
        sDealFlag = "error";        
        throw new Exception("事务处理失败！"+e.getMessage());
    }
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sDealFlag);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>


<%@ include file="/IncludeEndAJAX.jsp"%>