<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String sDocID    = CurPage.getParameter("DocID");    		//���鱨���ĵ�ID
	String sObjectNo = CurPage.getParameter("ObjectNo"); 		//ҵ����ˮ��
	String sObjectType = CurPage.getParameter("ObjectType"); 	//��������
	String sTypeNo = CurPage.getParameter("TypeNo"); 	//���鱨���ĵ����
	if(sTypeNo!=null && sTypeNo.length()>0)
		sDocID = FormatToolManager.getTrueDocId(sObjectType,sObjectNo,sDocID);//�ҵ����ʰ汾��DOCID
	String result = "true";
	IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,null);
	if(!formatTool.existDocument(CurUser,sObjectType,sObjectNo,sDocID)){ //�״����ɸ�ʽ������
		formatTool.newDocument(CurUser,sObjectType,sObjectNo,sDocID);
	}else{ //�ٴν����ʽ�����棬Ҫ������������ˢ��Ŀ¼
		FormatDocConfig fconfig = new FormatDocConfig(request);
		formatTool.refreshDocument(CurUser,sObjectType,sObjectNo,sDocID);
		if(formatTool.refreshDocumentData(sObjectType,sObjectNo,sDocID,fconfig)==false)
			result = "false";
	}
	out.print(result); 
%><%@ include file="/IncludeEndAJAX.jsp"%>