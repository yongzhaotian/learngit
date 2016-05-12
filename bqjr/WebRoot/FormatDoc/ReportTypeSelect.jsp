<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Author:   xdhou  2005.02.17
		Content: 获取调查报告的种类
		Input Param:
			ObjectType：对象类型
			ObjectNo：对象编号
		Output param:
			DocID：调查报告种类
	 */
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//业务流水号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 	//对象类型
	
	String sSql = " select distinct DocID from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' ";
	String sDocID = Sqlca.getString(sSql);	
	if(sDocID == null) sDocID = "";
	out.print(sDocID); 
%><%@ include file="/IncludeEndAJAX.jsp"%>