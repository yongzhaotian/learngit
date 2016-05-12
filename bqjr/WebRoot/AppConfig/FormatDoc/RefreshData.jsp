<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String sDocID    = CurPage.getParameter("DocID");    		//调查报告文档ID
	String sObjectNo = CurPage.getParameter("ObjectNo"); 		//业务流水号
	String sObjectType = CurPage.getParameter("ObjectType"); 	//对象类型
	String sTypeNo = CurPage.getParameter("TypeNo"); 	//调查报告文档类别
	if(sTypeNo!=null && sTypeNo.length()>0)
		sDocID = FormatToolManager.getTrueDocId(sObjectType,sObjectNo,sDocID);//找到合适版本的DOCID
	String result = "true";
	IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,null);
	if(!formatTool.existDocument(CurUser,sObjectType,sObjectNo,sDocID)){ //首次生成格式化报告
		formatTool.newDocument(CurUser,sObjectType,sObjectNo,sDocID);
	}else{ //再次进入格式化报告，要按担保变更情况刷新目录
		FormatDocConfig fconfig = new FormatDocConfig(request);
		formatTool.refreshDocument(CurUser,sObjectType,sObjectNo,sDocID);
		if(formatTool.refreshDocumentData(sObjectType,sObjectNo,sDocID,fconfig)==false)
			result = "false";
	}
	out.print(result); 
%><%@ include file="/IncludeEndAJAX.jsp"%>