<%
/* Author: byhu 2004.12.07
 * Tester:
 *
 * Content: ��ʾ��һ�׶���Ϣ 
 * Input Param:
 * 				SerialNo��	��ǰ�������ˮ��
 *				PhaseAction��	��ѡ����һ������
 * Output param:
 *				PhaseInfo��	�½׶���Ϣ
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>

<% 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//���ϸ�ҳ��õ������������ˮ��
	String sPhaseAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseAction"));//���ϸ�ҳ��õ�����Ķ�����Ϣ
	String sPhaseOpinion1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));//���ϸ�ҳ��õ�����������Ϣ	
	String sReturnValue="";
	
	//����ֵת���ɿ��ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sPhaseAction == null) sPhaseAction = "";
	if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
	
	String sPhaseInfo="",sNextPhaseName="";//���ؽ׶���Ϣ���׶�����
	
	//��ʼ���������
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	//�����һ�׶εĽ׶�����
	sNextPhaseName = ftBusiness.getNextFlowPhase(sPhaseAction,sPhaseOpinion1).PhaseName;
	
	sPhaseInfo="��һ�׶�:";
	sPhaseInfo = sPhaseInfo+" " + sNextPhaseName;//ƴ����ʾ��Ϣ
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sPhaseInfo);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>