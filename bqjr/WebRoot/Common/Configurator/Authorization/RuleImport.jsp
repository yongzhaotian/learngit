<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.sadre.cache.*"%>
<%@page import="com.amarsoft.sadre.rules.aco.RuleScene" %>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zllin 2011-07-14
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
	//String sSql; 
	
	//获得组件参数	
	String sSceneId = DataConvert.toString(CurPage.getParameter("SceneId"));
	String sCurScene = DataConvert.toString(CurPage.getParameter("CurScene"));
	String sRuleId = DataConvert.toString(CurPage.getParameter("RuleId"));
	//Thread.currentThread().sleep(5000);
	RuleScene ruleScene = RuleScenes.getRuleScene(sCurScene);
	if(ruleScene==null){
		out.println("<img src=\"ico/error.png\"><font color=\"red\">授权场景["+sSceneId+"]不存在!</font>");
	}else{
		int sveFlg = ruleScene.importRule(sRuleId, sSceneId, Sqlca);
		switch(sveFlg){
			case RuleScene.规则处理_成功:
				out.println("<img src=\"ico/tick.png\"><font color=\"green\">授权规则保存成功!</font>&nbsp;&nbsp;<img src=\"ico/reload.png\"><label style=\"background:#FF0\">规则需在重新载入后生效!</label>");
				break;
			case RuleScene.授权规则_不存在:
				out.println("<img src=\"ico/warn.gif\"><font color=\"red\">无有效的授权规则,请确认!</font>");
				break;
			default:		//规则保存_失败
				out.println("<img src=\"ico/warn.gif\"><font color=\"red\">授权规则保存失败!</font>");
		}
		
	}
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
