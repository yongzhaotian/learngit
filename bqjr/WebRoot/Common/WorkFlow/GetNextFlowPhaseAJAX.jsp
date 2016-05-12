<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%@
 page import="com.amarsoft.biz.workflow.*" %><%
	/* 
	 * Content: 提示下一阶段信息 
	 * Input Param:
	 * 				SerialNo：	当前任务的流水号
	 *				PhaseAction：	所选的下一步动作
	 * Output param:
	 *				PhaseInfo：	下阶段信息
	 */
	String sSerialNo = CurPage.getParameter("SerialNo");//从上个页面得到传入的任务流水号
	String sPhaseAction = CurPage.getParameter("PhaseAction");//从上个页面得到传入的动作信息
	String sPhaseOpinion1 = CurPage.getParameter("PhaseOpinion1");//从上个页面得到传入的意见信息	
	if(sSerialNo == null) sSerialNo = "";
	if(sPhaseAction == null) sPhaseAction = "";
	if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
	
	String sPhaseInfo="",sNextPhaseName="",sNextPhaseNameStr="";//返回阶段信息、阶段名称
	//初始化任务对象
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	
	FlowPhase[] sFlowPhase = ftBusiness.getNextFlowPhase(sPhaseAction,sPhaseOpinion1);
	for(int i=0;i<sFlowPhase.length;i++)
	{
		FlowPhase flowPhase = sFlowPhase[i];
		sNextPhaseName = flowPhase.PhaseName;
		sNextPhaseNameStr += sNextPhaseName+";";
		//获得下一阶段的阶段名称
		//sNextPhaseName = ftBusiness.getNextFlowPhase(sPhaseAction,sPhaseOpinion1).PhaseName;
	}
	sPhaseInfo="下一阶段:";
	sPhaseInfo = sPhaseInfo+" " + sNextPhaseNameStr;//拼出提示信息

	out.print(sPhaseInfo);
%><%@ include file="/IncludeEndAJAX.jsp"%>