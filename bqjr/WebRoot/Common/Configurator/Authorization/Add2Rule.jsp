<%@page import="com.amarsoft.sadre.rules.aco.Dimension"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.sadre.cache.*"%>
<%@page import="com.amarsoft.sadre.rules.aco.RuleScene" %>
<%@page import="com.amarsoft.sadre.rules.op.Operator"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zllin 2011-01-06
		Tester: 
		Content: 
		Input Param:
			ThreadID	�������µĹ����б�
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������	
	String sCurrentDMS = DataConvert.toString(CurPage.getParameter("currentDMS"));
	String sPrivouseDMS = DataConvert.toString(CurPage.getParameter("privouseDMS"));
	
	//Thread.currentThread().sleep(2000);
	
	String[] current = sCurrentDMS.split(",");
	String[] privouse = sPrivouseDMS.split(",");
	StringBuffer dmsScript = new StringBuffer("<table class=\"styletc\">");
	//StringBuffer dmsScript = new StringBuffer("");
	//--------------���˳�����ӵ���Ȩά��
	for(int i=0; i<current.length; i++){
		boolean exists = false;
		for(int j=0; j<privouse.length; j++){
			if(current[i].equals(privouse[j])){
				exists = true;
				break;
			}
		}
		if(!exists){
			Dimension dms = Dimensions.getDimension(current[i]);
			if(dms==null){
				continue;
			}
			dmsScript.append(dms.getHTMLScript(Sqlca));
		}
		
	}
	dmsScript.append("</table>");
	
	out.println(dmsScript);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
