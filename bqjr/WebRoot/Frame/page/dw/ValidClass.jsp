<%@ page language="java" import="java.util.*" pageEncoding="GBK"%><%@
page import="java.sql.*"%><%@
page import="com.amarsoft.are.ARE"%><%@
page import="com.amarsoft.awe.dw.ui.validator.ICustomerRule"%><%
	String sClass = request.getParameter("ClassName");
	String sValue = java.net.URLDecoder.decode(request.getParameter("Value"),"UTF-8").replaceAll("�ѡա�","&");
	//ƴ�Ӳ���
	Hashtable params = new Hashtable();
	for(java.util.Enumeration enum1 = request.getParameterNames(); enum1.hasMoreElements();){
		String sKey = (String)enum1.nextElement();
		//System.out.println("sKey=" + sKey);
		if(sKey.equals("ClassName"))continue;
		if(sKey.equals("Value"))continue;
		if(request.getParameter(sKey)!=null){
			String sParamValue = java.net.URLDecoder.decode(request.getParameter(sKey).toString(),"UTF-8");
			params.put(sKey,sParamValue.replaceAll("�ѡա�","&"));
			//System.out.println("������" + sParamValue);
		}
	}
	ARE.getLog().trace("��ʼClass��֤�����ղ�����sClass=" + sClass + "|value=" + sValue);
	try{
		if(sClass!=null){
			ICustomerRule rule = (ICustomerRule)Class.forName(sClass).newInstance();
			String sResult = rule.valid(sValue,params);
			if(sResult.equals("")){
				out.print("true");
				//ARE.getLog().info("true");
			}else{
				out.print(sResult);
				//ARE.getLog().info(sResult);
			}
		}else{
			out.print("δ����У����");
			//ARE.getLog().info("false");
		}
	}catch(Exception e){
		ARE.getLog().error("classУ������ˣ�"+e.toString());
		out.print("�����ˣ�"+e.toString());
	}
%>