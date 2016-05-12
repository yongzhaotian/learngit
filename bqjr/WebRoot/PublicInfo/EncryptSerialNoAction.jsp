<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@ page import = "com.amarsoft.are.lang.StringX" %>
<%@ page import = "com.amarsoft.are.security.MessageDigest" %>
<%
	/*
		Describe: 获得加密后的流水号
		Input Param:
			EncryptionType：加密类型
			SerialNo：流水号（加密前）
		Output Param:
			SerialNo：流水号（加密后）
	 */
	//获得页面参数
	String sEncryptionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EncryptionType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//将空值转化后空字符串
	if(sEncryptionType == null) sEncryptionType = "";
	if(sSerialNo == null) sSerialNo = "";
	
	//使用MD5加密技术进行加密
	if(sEncryptionType.equals("MD5")){
   		//sSerialNo = StringX.bytesToHexString(MessageDigest.getDigest("MD5", sSerialNo), true);
   		sSerialNo = MessageDigest.getDigestAsUpperHexString("MD5", sSerialNo);
	}
	out.println(sSerialNo);
%>
<%@	include file="/IncludeEndAJAX.jsp"%>