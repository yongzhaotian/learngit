<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.sadre.cache.*"%>
<%@page import="com.amarsoft.sadre.rules.aco.RuleScene" %>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zllin 2011-07-14
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
	String sCurScene = DataConvert.toString(CurPage.getParameter("CurScene"));
	String sRuleId = DataConvert.toString(CurPage.getParameter("RuleId"));
	//Thread.currentThread().sleep(5000);
	RuleScene ruleScene = RuleScenes.getRuleScene(sCurScene);
	if(ruleScene==null){
		out.println("<img src=\"ico/error.png\"><font color=\"red\">��Ȩ����["+sSceneId+"]������!</font>");
	}else{
		int sveFlg = ruleScene.importRule(sRuleId, sSceneId, Sqlca);
		switch(sveFlg){
			case RuleScene.������_�ɹ�:
				out.println("<img src=\"ico/tick.png\"><font color=\"green\">��Ȩ���򱣴�ɹ�!</font>&nbsp;&nbsp;<img src=\"ico/reload.png\"><label style=\"background:#FF0\">�������������������Ч!</label>");
				break;
			case RuleScene.��Ȩ����_������:
				out.println("<img src=\"ico/warn.gif\"><font color=\"red\">����Ч����Ȩ����,��ȷ��!</font>");
				break;
			default:		//���򱣴�_ʧ��
				out.println("<img src=\"ico/warn.gif\"><font color=\"red\">��Ȩ���򱣴�ʧ��!</font>");
		}
		
	}
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
