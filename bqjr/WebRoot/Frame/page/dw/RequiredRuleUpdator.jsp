<%@ page language="java" import="java.util.*,com.amarsoft.awe.dw.*,com.amarsoft.awe.util.*,com.amarsoft.awe.dw.ui.validator.*" pageEncoding="GBK"%><%@page import="java.sql.*"%><%@page import="com.amarsoft.are.ARE"%><%
/*
�������ڸ��±�������֤
*/
String sDataObject = request.getParameter("DataObject");
String sColName = request.getParameter("ColName");
String sRequired = request.getParameter("Required");
boolean bRequired = "1".equals(sRequired);
try{
	ASDataObject asObj = (ASDataObject)ObjectConverts.getObject(sDataObject);	
	asObj.setRequired(sColName, bRequired);
	//ˢ����֤����
	IValidateRulesFactory factory = new DefaultValidateRulesFactory(asObj);
	asObj.validateRules = factory.getValidateRules();
	
	sDataObject = ObjectConverts.getString(asObj);
	out.print(sDataObject);
}
catch(Exception e){
	e.printStackTrace();
	out.print("fail:"+ e.toString());
}
%>