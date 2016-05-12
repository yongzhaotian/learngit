<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: cyyu 2009.02.06
 * Tester:
 *
 * Content: 获取电子文档编号
 * Input Param:
 *		　业务类型:	ObjectType
 * Output param:
 *		 结果:	EDocNo
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>获取电子文档流水号</title>
<%
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sEDocNo = Sqlca.getString("Select EDocNo from EDOC_RELATIVE where TypeNo='"+sObjectType+"'");
%>

<script language=javascript>
	self.returnValue = "<%=sEDocNo%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
