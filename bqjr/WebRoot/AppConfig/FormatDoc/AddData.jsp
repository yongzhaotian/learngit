<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String result = "";
	String sDocID="";
	String sObjectNo="";
	String sObjectType="";
	String sMethod="";
	//String sOrgID="";
	try{
		sDocID    = CurPage.getParameter("DocID");    		//���鱨���ĵ����
		sObjectNo = CurPage.getParameter("ObjectNo"); 		//ҵ����ˮ��
		sObjectType = CurPage.getParameter("ObjectType"); 	//��������
		sMethod = CurPage.getParameter("Method");
		//sOrgID = FormatDocHelp.getBranchOrgID(CurUser.getOrgID());
		sDocID = FormatToolManager.getTrueDocId(sObjectType,sObjectNo,sDocID);//�ҵ����ʰ汾��DOCID
		String sExcludeDirIds =CurPage.getParameter("ExcludeDirIds"); 		//�ų��Ľڵ�
		//System.out.println("sExcludeDirIds=" + sExcludeDirIds);
		IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,sExcludeDirIds);
		if(!formatTool.existDocument(CurUser,sObjectType,sObjectNo,sDocID)){ //�״����ɸ�ʽ������
			formatTool.newDocument(CurUser,sObjectType,sObjectNo,sDocID);
		}else{ //�ٴν����ʽ�����棬Ҫ������������ˢ��Ŀ¼
			formatTool.refreshDocument(CurUser,sObjectType,sObjectNo,sDocID);
		}
		result="SUCCESS";
	}catch(Exception e){
		ARE.getLog().error(e.toString());
		result="FAILED";
	}
	out.print(result);
%><%@ include file="/IncludeEndAJAX.jsp"%>