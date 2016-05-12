<%@ page language="java" import="com.amarsoft.are.*,com.amarsoft.awe.dw.ui.util.PublicFuns,com.amarsoft.awe.dw.ui.util.Request,com.amarsoft.awe.dw.ASDataObject,com.amarsoft.awe.dw.ui.util.ConvertXmlAndJava,com.amarsoft.awe.dw.ui.value.*,java.util.*,com.amarsoft.awe.dw.ui.util.*,com.amarsoft.awe.dw.ui.htmlfactory.*,com.amarsoft.are.jbo.*,com.amarsoft.are.jbo.impl.*" pageEncoding="GBK"%><%
/*
检查导出是否完成
*/
if(session.getAttribute("CheckExportPage"+request.getParameter("rand"))==null){
	out.print("false");
}
else{
	session.removeAttribute("CheckExportPage"+request.getParameter("rand"));
	System.out.println("clear session:" + "CheckExportPage"+request.getParameter("rand"));
	out.print("true");
}
%>