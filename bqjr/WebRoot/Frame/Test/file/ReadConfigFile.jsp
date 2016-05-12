<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%@
 page import="java.util.ResourceBundle"%><%
	/*
  		读取配置文件信息
	*/
	//配置文件SysConfig.properties存放在WEB-INF\classes目录下
	ResourceBundle resourcebundle = ResourceBundle.getBundle("SysConfig",java.util.Locale.CHINA);
	String sASRoleSetClass = resourcebundle.getString("ASRoleSet");
	out.println("ASRoleSetClass---------------"+sASRoleSetClass);
	//配置文件cfg.properties存放在WEB-INF\etc目录下
	//ResourceBundle resourcebundle = ResourceBundle.getBundle("SysConfig",java.util.Locale.CHINA);
	//String sReportUrl = resourcebundle.getString("ASRoleSet");
	//out.println("---------------"+sReportUrl);
%><%@ include file="/IncludeEnd.jsp"%>