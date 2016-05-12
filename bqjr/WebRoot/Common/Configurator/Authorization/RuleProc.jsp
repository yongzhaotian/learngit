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
	//String sSql; 
	
	//获得组件参数	
	String sSceneId = DataConvert.toString(CurPage.getParameter("SceneId"));
	String sRuleId = DataConvert.toString(CurPage.getParameter("RuleId"));
	//ARE.getLog().debug("SceneId="+sSceneId);
	//ARE.getLog().debug("RuleId="+sRuleId);
	//ARE.getLog().debug("RuleId-node="+request.getAttribute("note"));
	//Thread.currentThread().sleep(5000);
	RuleScene ruleScene = RuleScenes.getRuleScene(sSceneId);
	if(ruleScene==null){
		out.println("<img src=\"ico/error.png\"><font color=\"red\">授权场景["+sSceneId+"]不存在!</font>");
	}else{
		int sveFlg = ruleScene.saveRule(CurPage, CurUser, Sqlca);
		switch(sveFlg){
			case RuleScene.规则处理_成功:
				try{
					RuleScenes.reloadRuleScene(sSceneId);
				}catch(Exception e){
					ARE.getLog().error("重载授权场景失败!",e);
					throw e;
				}
				out.println("<img src=\""+sWebRootPath+"/Common/Configurator/Authorization/ico/tick.png\"><font color=\"green\">授权规则保存成功!</font>&nbsp;&nbsp;<img src=\"ico/reload.png\"><label style=\"background:#FF0\">规则需在重新载入后生效!</label>");
				break;
			case RuleScene.规则配置_为空:
				out.println("<img src=\""+sWebRootPath+"/Common/Configurator/Authorization/ico/warn.gif\"><font color=\"red\">无有效的授权规则,请确认!</font>");
				break;
			default:		//规则保存_失败
				out.println("<img src=\""+sWebRootPath+"/Common/Configurator/Authorization/ico/warn.gif\"><font color=\"red\">授权规则保存失败!</font>");
		}
		
	}
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
