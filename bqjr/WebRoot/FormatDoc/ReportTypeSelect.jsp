<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Author:   xdhou  2005.02.17
		Content: ��ȡ���鱨�������
		Input Param:
			ObjectType����������
			ObjectNo��������
		Output param:
			DocID�����鱨������
	 */
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//ҵ����ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 	//��������
	
	String sSql = " select distinct DocID from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' ";
	String sDocID = Sqlca.getString(sSql);	
	if(sDocID == null) sDocID = "";
	out.print(sDocID); 
%><%@ include file="/IncludeEndAJAX.jsp"%>