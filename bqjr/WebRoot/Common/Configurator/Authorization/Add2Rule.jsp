<%@page import="com.amarsoft.sadre.rules.aco.Dimension"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.sadre.cache.*"%>
<%@page import="com.amarsoft.sadre.rules.aco.RuleScene" %>
<%@page import="com.amarsoft.sadre.rules.op.Operator"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zllin 2011-01-06
		Tester: 
		Content: 
		Input Param:
			ThreadID	场景项下的规则列表
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数	
	String sCurrentDMS = DataConvert.toString(CurPage.getParameter("currentDMS"));
	String sPrivouseDMS = DataConvert.toString(CurPage.getParameter("privouseDMS"));
	
	//Thread.currentThread().sleep(2000);
	
	String[] current = sCurrentDMS.split(",");
	String[] privouse = sPrivouseDMS.split(",");
	StringBuffer dmsScript = new StringBuffer("<table class=\"styletc\">");
	//StringBuffer dmsScript = new StringBuffer("");
	//--------------过滤出新添加的授权维度
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
