<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%
	/* 
	 * ͬ������
	 * ��ջ����е����ݣ����¶���ConfigFile
	 */
	String sReturn = "SUCCESS";
	try{
		CurConfig.reload(application);
	}catch(Exception er){
		out.println("��ջ���ʧ�ܣ�"+er);
		sReturn = "FAILED";
		throw er;
	}
	out.println(sReturn);
%><%@ include file="/IncludeEndAJAX.jsp"%>