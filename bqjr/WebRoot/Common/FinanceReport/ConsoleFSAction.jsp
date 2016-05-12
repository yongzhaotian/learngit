<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: ������²���
		Input Param:
             ObjectNo ��   ������ ĿǰĬ��Ϊ�ͻ����
             ObjectType �� �������� ĿǰĬ��CustomerFS
             ReportDate �� �����ֹ����    
		Output param:
		History Log: 
			���ø��������һ����������ɾ��һ�ױ���
			�Զ��������������� zywei 2007/10/10
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>������²���</title>
<%
	String sObjectType = "",sObjectNo = "",sWhere = "",sReportDate = "",sOrgID = "",sUserID = "",sActionType = "";
	String sReportScope = "",sSql = "",sSql1 = "",sSql2 = "",sNewReportDate = "";
	SqlObject so = null;
	String sNewSql = "";
	//zywei 2007/10/10 �����������־
	String sDealFlag = "";
	String sReturnValue="";
	//������ ��ʱΪ�ͻ���
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//�������� ��ʱ��ΪCustomerFS
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	sReportScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	sWhere = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Where"));
	sNewReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NewReportDate"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null)	sObjectType = "";
	if(sReportDate == null)	sReportDate = "";
	if(sReportScope == null) sReportScope = "";
	if(sWhere == null)	sWhere = "";
	if(sNewReportDate == null)	sNewReportDate = "";
	sWhere = StringFunction.replace(sWhere,"^","=");
	
	//�����������
	sActionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));
	if(sActionType==null)	sActionType = "";	
	
	sOrgID = CurOrg.getOrgID();
	sUserID = CurUser.getUserID();
	
    try{
		if(sActionType.equals("AddNew")){
			// ����ָ��MODEL_CATALOG��where��������һ���±���		
			Report.newReports(sObjectType,sObjectNo,sReportScope,sWhere,sReportDate,sOrgID,sUserID,Sqlca);
		}else if(sActionType.equals("Delete")){
			// ɾ��ָ��������������ڵ�һ������ 
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
			// ����ָ������Ļ���·� 
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
			
			// ����ָ������Ļ���·�
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
        throw new Exception("������ʧ�ܣ�"+e.getMessage());
    }
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sDealFlag);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>


<%@ include file="/IncludeEndAJAX.jsp"%>