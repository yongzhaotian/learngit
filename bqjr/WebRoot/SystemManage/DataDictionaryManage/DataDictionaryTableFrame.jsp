<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 表与对应字段上下框架页面
	author: yzheng
	date: 2013-6-8
 */
 
	//获得页面参数
// 	String tableType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TableType"));
 
// 	if(tableType==null) tableType="";
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableList.jsp","","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
