<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String result = "";
	String sDocID="";
	String sObjectNo="";
	String sObjectType="";
	String sMethod="";
	//String sOrgID="";
	try{
		sDocID    = CurPage.getParameter("DocID");    		//调查报告文档类别
		sObjectNo = CurPage.getParameter("ObjectNo"); 		//业务流水号
		sObjectType = CurPage.getParameter("ObjectType"); 	//对象类型
		sMethod = CurPage.getParameter("Method");
		//sOrgID = FormatDocHelp.getBranchOrgID(CurUser.getOrgID());
		sDocID = FormatToolManager.getTrueDocId(sObjectType,sObjectNo,sDocID);//找到合适版本的DOCID
		String sExcludeDirIds =CurPage.getParameter("ExcludeDirIds"); 		//排除的节点
		//System.out.println("sExcludeDirIds=" + sExcludeDirIds);
		IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,sExcludeDirIds);
		if(!formatTool.existDocument(CurUser,sObjectType,sObjectNo,sDocID)){ //首次生成格式化报告
			formatTool.newDocument(CurUser,sObjectType,sObjectNo,sDocID);
		}else{ //再次进入格式化报告，要按担保变更情况刷新目录
			formatTool.refreshDocument(CurUser,sObjectType,sObjectNo,sDocID);
		}
		result="SUCCESS";
	}catch(Exception e){
		ARE.getLog().error(e.toString());
		result="FAILED";
	}
	out.print(result);
%><%@ include file="/IncludeEndAJAX.jsp"%>