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
	//String sSql; 
	
	//����������	
	String sSceneId = DataConvert.toString(CurPage.getParameter("SceneId"));
	String sRuleId = DataConvert.toString(CurPage.getParameter("RuleId"));
	//ARE.getLog().debug("SceneId="+sSceneId);
	//ARE.getLog().debug("RuleId="+sRuleId);
	//ARE.getLog().debug("RuleId-node="+request.getAttribute("note"));
	//Thread.currentThread().sleep(5000);
	RuleScene ruleScene = RuleScenes.getRuleScene(sSceneId);
	if(ruleScene==null){
		out.println("<img src=\"ico/error.png\"><font color=\"red\">��Ȩ����["+sSceneId+"]������!</font>");
	}else{
		int sveFlg = ruleScene.saveRule(CurPage, CurUser, Sqlca);
		switch(sveFlg){
			case RuleScene.������_�ɹ�:
				try{
					RuleScenes.reloadRuleScene(sSceneId);
				}catch(Exception e){
					ARE.getLog().error("������Ȩ����ʧ��!",e);
					throw e;
				}
				out.println("<img src=\""+sWebRootPath+"/Common/Configurator/Authorization/ico/tick.png\"><font color=\"green\">��Ȩ���򱣴�ɹ�!</font>&nbsp;&nbsp;<img src=\"ico/reload.png\"><label style=\"background:#FF0\">�������������������Ч!</label>");
				break;
			case RuleScene.��������_Ϊ��:
				out.println("<img src=\""+sWebRootPath+"/Common/Configurator/Authorization/ico/warn.gif\"><font color=\"red\">����Ч����Ȩ����,��ȷ��!</font>");
				break;
			default:		//���򱣴�_ʧ��
				out.println("<img src=\""+sWebRootPath+"/Common/Configurator/Authorization/ico/warn.gif\"><font color=\"red\">��Ȩ���򱣴�ʧ��!</font>");
		}
		
	}
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
