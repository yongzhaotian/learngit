<%@ page language="java" import="java.util.*,com.amarsoft.awe.dw.ui.actions.IAmarRemoteFetch,com.amarsoft.awe.dw.ui.validator.ICustomerRule" pageEncoding="GBK"%><%@page import="java.sql.*"%><%@page import="com.amarsoft.are.ARE"%><%
//远程获取数据
String sClass = request.getParameter("ClassName");
//拼接参数
Hashtable params = new Hashtable();
for(java.util.Enumeration enum1 = request.getParameterNames(); enum1.hasMoreElements();){
	String sKey = (String)enum1.nextElement();
	if(sKey.equals("ClassName"))continue;
	if(request.getParameter(sKey)!=null){
		String sParamValue = java.net.URLDecoder.decode(request.getParameter(sKey).toString(),"UTF-8"); 
		params.put(sKey,sParamValue.replaceAll("⊙≌□","&"));
	}
}
System.out.println("开始远程获取数据，接收参数：sClass=" + sClass);
try{
	if(sClass!=null){
		IAmarRemoteFetch fetcher = (IAmarRemoteFetch)Class.forName(sClass).newInstance();
		String sResult = fetcher.getResult(params);
		out.print("success:" + sResult);
	}
	else{
		out.print("error:未定义获取类");
		ARE.getLog().info("false");
	}
}
catch(Exception e){
	ARE.getLog().error("出错了："+e.toString());
	out.print("error:"+e.toString());
}
%>