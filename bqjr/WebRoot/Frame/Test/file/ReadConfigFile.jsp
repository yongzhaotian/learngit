<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%@
 page import="java.util.ResourceBundle"%><%
	/*
  		��ȡ�����ļ���Ϣ
	*/
	//�����ļ�SysConfig.properties�����WEB-INF\classesĿ¼��
	ResourceBundle resourcebundle = ResourceBundle.getBundle("SysConfig",java.util.Locale.CHINA);
	String sASRoleSetClass = resourcebundle.getString("ASRoleSet");
	out.println("ASRoleSetClass---------------"+sASRoleSetClass);
	//�����ļ�cfg.properties�����WEB-INF\etcĿ¼��
	//ResourceBundle resourcebundle = ResourceBundle.getBundle("SysConfig",java.util.Locale.CHINA);
	//String sReportUrl = resourcebundle.getString("ASRoleSet");
	//out.println("---------------"+sReportUrl);
%><%@ include file="/IncludeEnd.jsp"%>