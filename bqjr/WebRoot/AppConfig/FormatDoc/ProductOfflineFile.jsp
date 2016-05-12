<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String sFileName="";
	String result = "";
	try{
		String sObjectType = CurPage.getParameter("ObjectType");    	
		String sObjectNo = CurPage.getParameter("ObjectNo");    	
		String sDocID = CurPage.getParameter("DocID");
		sDocID = FormatToolManager.getTrueDocId(sObjectType,sObjectNo,sDocID);//找到合适版本的DOCID
		String sExcludeDirIds =CurPage.getParameter("ExcludeDirIds"); 		//排除的节点
		if(sExcludeDirIds == null) sExcludeDirIds = "";
		
		IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,sExcludeDirIds);
		
		//不存在目录则创建
		String sBasePath = CurConfig.getConfigure("WorkDocOfflineSavePath");
		if(sBasePath == null) sBasePath = "";
		java.io.File fileSS = new java.io.File(sBasePath);
		if(fileSS.exists()==false)fileSS.mkdirs();
		sFileName = formatTool.exportOfflineDocument(new FormatDocConfig(request),sBasePath,CurUser,sObjectType,sObjectNo,sDocID);
		result = sFileName;
	}catch(Exception e){
		ARE.getLog().error(e.toString());
		result = "FAILED";
	}
	out.print(result);
%><%@ include file="/IncludeEndAJAX.jsp"%>