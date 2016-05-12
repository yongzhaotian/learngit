<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
/*
	Author:   xdhou  2005.02.18
	Tester:
	Content: 选择需要调用的JSP
	Input Param:
		SerialNo:	报告流水号
		ObjectNo：	业务流水号
	Output param:
	History Log: 
 */
%>
<% 	
	//获得参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); 	//对象类型
	String sSql = "",sJspName="",sDocID="";
	ASResultSet rsData = null;

	sSql = " select JspFileName,A.DocID " +
			" from FORMATDOC_DATA A,FORMATDOC_DEF B "+
			" where A.SerialNo = '"+sSerialNo+"' "+
			" and A.ObjectNo = '"+sObjectNo+"' "+
			" and A.ObjectType = '"+sObjectType+"'"+
			" and B.DocID = A.DocID "+
			" and B.DirID = A.DirID ";
	rsData = Sqlca.getResultSet(sSql);
	if(rsData.next()){
		sJspName = rsData.getString(1);
		sDocID = rsData.getString(2);
	}
	rsData.getStatement().close();
	
	String sReturn = sJspName+"?DocID="+sDocID+"&";
	out.println(sReturn);
%>
<%@ include file="/IncludeEndAJAX.jsp"%>