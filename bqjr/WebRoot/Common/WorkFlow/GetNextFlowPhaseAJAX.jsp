<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%@
 page import="com.amarsoft.biz.workflow.*" %><%
	/* 
	 * Content: ��ʾ��һ�׶���Ϣ 
	 * Input Param:
	 * 				SerialNo��	��ǰ�������ˮ��
	 *				PhaseAction��	��ѡ����һ������
	 * Output param:
	 *				PhaseInfo��	�½׶���Ϣ
	 */
	String sSerialNo = CurPage.getParameter("SerialNo");//���ϸ�ҳ��õ������������ˮ��
	String sPhaseAction = CurPage.getParameter("PhaseAction");//���ϸ�ҳ��õ�����Ķ�����Ϣ
	String sPhaseOpinion1 = CurPage.getParameter("PhaseOpinion1");//���ϸ�ҳ��õ�����������Ϣ	
	if(sSerialNo == null) sSerialNo = "";
	if(sPhaseAction == null) sPhaseAction = "";
	if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
	
	String sPhaseInfo="",sNextPhaseName="",sNextPhaseNameStr="";//���ؽ׶���Ϣ���׶�����
	//��ʼ���������
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	
	FlowPhase[] sFlowPhase = ftBusiness.getNextFlowPhase(sPhaseAction,sPhaseOpinion1);
	for(int i=0;i<sFlowPhase.length;i++)
	{
		FlowPhase flowPhase = sFlowPhase[i];
		sNextPhaseName = flowPhase.PhaseName;
		sNextPhaseNameStr += sNextPhaseName+";";
		//�����һ�׶εĽ׶�����
		//sNextPhaseName = ftBusiness.getNextFlowPhase(sPhaseAction,sPhaseOpinion1).PhaseName;
	}
	sPhaseInfo="��һ�׶�:";
	sPhaseInfo = sPhaseInfo+" " + sNextPhaseNameStr;//ƴ����ʾ��Ϣ

	out.print(sPhaseInfo);
%><%@ include file="/IncludeEndAJAX.jsp"%>