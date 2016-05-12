<%@page import="java.net.URLDecoder"%>
<%@ page language="java" import="java.util.*,java.lang.reflect.*,com.amarsoft.awe.util.json.*,com.amarsoft.dict.als.cache.*,com.amarsoft.awe.dw.datamodel.TagMap" pageEncoding="GBK"%><%@page import="com.amarsoft.are.ARE"%><%
String sClassName = request.getParameter("className");
String sMethodName = request.getParameter("methodName");
String sParamValues = request.getParameter("paramValues");
JSONObject jsonobject=null;
if(sParamValues!=null){
	sParamValues = URLDecoder.decode(sParamValues, "UTF-8");
	sParamValues = java.net.URLDecoder.decode(sParamValues,"UTF-8"); 
	sParamValues = java.net.URLDecoder.decode(sParamValues,"UTF-8"); 
	jsonobject = (JSONObject)JSONValue.parse(sParamValues);
}

try{
	
	Class c = Class.forName(sClassName);
	Object obj = c.newInstance();
	Method m = c.getMethod(sMethodName,null);
	//设置参数值
	if(jsonobject!=null){
		Iterator it = jsonobject.keySet().iterator();
		while(it.hasNext()){
			String sKey = it.next().toString();
			String sMethod = "set"  +sKey.substring(0, 1).toUpperCase() + sKey.substring(1);
			try{
				Method m2 = c.getMethod(sMethod,String.class);
				ARE.getLog().debug("run Method=" + sMethod + ",value=" + jsonobject.get(sKey).toString());
				m2.invoke(obj, jsonobject.get(sKey).toString());
			}
			catch(Exception e){
				e.printStackTrace();
				ARE.getLog().warn(sClassName + "的"+sMethod+"方法调用失败");
			}
		}
	}
	
	String result = (String)m.invoke(obj, null);
	out.print(result);
}
catch(Exception e){
	e.printStackTrace();
	out.print("undefined");
}
%>
