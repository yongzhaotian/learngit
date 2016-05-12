<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: fmwu 2008.1.4
 * Tester:
 *
 * Content: 生成电子文档条件检查
 * Input Param:
 *		　合同流水号:	ObjectNo
 * Output param:
 *		 结果:	ok 或者　nodef 或者 nodoc
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>获取电子文档流水号</title>
<%
	String sReturn = "ok";
    String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sEDocNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocNo"));
	String sSerialNo = null;
	System.out.println(sObjectNo+"==============="+sObjectType+"===================="+sEDocNo);

	//假如业务品种没有定义，则提示没有定义模板
	if (sEDocNo == null ) {
		sReturn = "nodef";		
	}
	else {
		sEDocNo = Sqlca.getString("select EDocNo from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
	}

	if (sEDocNo == null) {
		sReturn = "nodef";
	}
	else {
		 sSerialNo = Sqlca.getString("Select SerialNo from EDOC_PRINT where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' and EDocNo='"+sEDocNo+"'");
	}

	if (sSerialNo == null) {
		sReturn = "nodoc";
	} else {
		String sFullPath = Sqlca.getString("Select FullPath from EDOC_PRINT where SerialNo='"+sSerialNo+"'");
		java.io.File dFile = new java.io.File(sFullPath);
		if(!dFile.exists())	
			sReturn = "nodoc";
	}

	//假如没有生成好的文档，看看是否有文档模板定义
	if ("nodoc".equals(sReturn)) {
		String sFullPathFmt = Sqlca.getString("select FullPathFmt from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
		String sFullPathDef = Sqlca.getString("select FullPathDef from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
		
		if (sFullPathFmt == null || sFullPathDef == null) {
			sReturn = "nodef";
		}
		else  {
			java.io.File dFile = new java.io.File(sFullPathFmt);
			System.out.println("sFullPathFmt:"+sFullPathFmt);
			System.out.println("dFile.exists():"+dFile.exists());
			
			if(!dFile.exists()){
				sReturn = "nodef";
			}
			dFile = new java.io.File(sFullPathDef);
			if(!dFile.exists())	{
				System.out.println("sFullPathDef:"+dFile.getAbsolutePath());
				sReturn = "nodef";
			}
		}
	}
	
	if ("ok".equals(sReturn)) {
		sReturn = sSerialNo;
	}
%>

<script language=javascript>
	self.returnValue = "<%=sReturn%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
