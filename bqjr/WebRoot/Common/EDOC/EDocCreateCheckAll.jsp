<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: fmwu 2008.1.4
 * Tester:
 *
 * Content: ���ɵ����ĵ��������
 * Input Param:
 *		����ͬ��ˮ��:	ObjectNo
 * Output param:
 *		 ���:	ok ���ߡ�nodef ���� nodoc
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>��ȡ�����ĵ���ˮ��</title>
<%
	String sReturn = "ok";
    String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sEDocNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocNo"));
	String sSerialNo = null;
	System.out.println(sObjectNo+"==============="+sObjectType+"===================="+sEDocNo);

	//����ҵ��Ʒ��û�ж��壬����ʾû�ж���ģ��
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

	//����û�����ɺõ��ĵ��������Ƿ����ĵ�ģ�嶨��
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
