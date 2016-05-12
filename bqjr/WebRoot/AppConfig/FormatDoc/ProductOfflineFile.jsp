<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String sFileName="";
	String result = "";
	try{
		String sObjectType = CurPage.getParameter("ObjectType");    	
		String sObjectNo = CurPage.getParameter("ObjectNo");    	
		String sDocID = CurPage.getParameter("DocID");
		sDocID = FormatToolManager.getTrueDocId(sObjectType,sObjectNo,sDocID);//�ҵ����ʰ汾��DOCID
		String sExcludeDirIds =CurPage.getParameter("ExcludeDirIds"); 		//�ų��Ľڵ�
		if(sExcludeDirIds == null) sExcludeDirIds = "";
		
		IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,sExcludeDirIds);
		
		//������Ŀ¼�򴴽�
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