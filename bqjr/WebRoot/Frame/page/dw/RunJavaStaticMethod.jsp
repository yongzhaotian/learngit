<%@page import="java.net.URLDecoder"%>
<%@ page language="java" import="java.util.*,java.lang.reflect.*,com.amarsoft.dict.als.cache.*,com.amarsoft.awe.dw.datamodel.TagMap" pageEncoding="GBK"%><%@page import="com.amarsoft.are.ARE"%><%
String sClassName = request.getParameter("className");
String sMethodName = request.getParameter("methodName");
String sParamValues = request.getParameter("paramValues");
if(sParamValues!=null){
	sParamValues = URLDecoder.decode(sParamValues, "UTF-8");
	sParamValues = java.net.URLDecoder.decode(sParamValues,"UTF-8"); 
	sParamValues = java.net.URLDecoder.decode(sParamValues,"UTF-8"); 
}

try{
	
	Class c = Class.forName(sClassName);
	Method m = null;
	String[] params = null;
	if(sParamValues!=null){
		params = sParamValues.split("\\,");
		Class methodArgTypes[] = new Class[params.length];
		for(int i=0;i<params.length;i++)methodArgTypes[i]= String.class;
		m = c.getMethod(sMethodName,methodArgTypes);
	}
	else
		m = c.getMethod(sMethodName,null);
	String result = (String)m.invoke(c, params);
	out.print(result);
}
catch(Exception e){
	e.printStackTrace();
	out.print("undefined");
}
%>
