<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@ page import = "com.amarsoft.are.lang.StringX" %>
<%@ page import = "com.amarsoft.are.security.MessageDigest" %>
<%
	/*
		Describe: ��ü��ܺ����ˮ��
		Input Param:
			EncryptionType����������
			SerialNo����ˮ�ţ�����ǰ��
		Output Param:
			SerialNo����ˮ�ţ����ܺ�
	 */
	//���ҳ�����
	String sEncryptionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EncryptionType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//����ֵת������ַ���
	if(sEncryptionType == null) sEncryptionType = "";
	if(sSerialNo == null) sSerialNo = "";
	
	//ʹ��MD5���ܼ������м���
	if(sEncryptionType.equals("MD5")){
   		//sSerialNo = StringX.bytesToHexString(MessageDigest.getDigest("MD5", sSerialNo), true);
   		sSerialNo = MessageDigest.getDigestAsUpperHexString("MD5", sSerialNo);
	}
	out.println(sSerialNo);
%>
<%@	include file="/IncludeEndAJAX.jsp"%>