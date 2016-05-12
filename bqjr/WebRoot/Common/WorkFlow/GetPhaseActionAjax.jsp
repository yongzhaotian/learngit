<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author: syang 2009/10/15
		Tester:
		Describe: ������������ɶ����б�
		Input Param:
			SerialNo��������ˮ��
			PhaseOpinion�����
		Output Param:
		HistoryLog: 
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<% 
	//��ȡ������������ˮ�š����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sPhaseOpinion = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));
	
	//������������̱�š��׶α�š�������
	String sFlowNo = "",sPhaseNo = "",sObjectNo = "";
	//��������������������б��׶ε����͡�������ʾ���׶ε�����
	String sPhaseAction = "",sActionList[],sSelectStyle = "",sActionDescribe = "",sPhaseAttribute = ""; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=����ҵ���߼�����;]~*/%>
<%
	//���������̱�FLOW_TASK�в�ѯ�����̱�š��׶α��
	sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = :SerialNo ";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if (rsTemp.next()){
		sFlowNo  = DataConvert.toString(rsTemp.getString("FlowNo"));
		sPhaseNo  = DataConvert.toString(rsTemp.getString("PhaseNo"));
		
		//����ֵת���ɿ��ַ���
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";				
	}
	rsTemp.getStatement().close();
	rsTemp = null;
	
	//��ʼ���������		 
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	//��ȡ����ѡ���б�
	sActionList = ftBusiness.getActionList(sPhaseOpinion);
	if(sActionList == null) { 
		sActionList = new String[1];
		sActionList[0] = "";
	}	
	
	String sActionValue[];
	int iCount=sActionList.length;
	sActionValue = new String[iCount];

	for(int i=0;i<iCount;i++){
		if(sActionList[i] != null && sActionList[i].split(" ").length >= 1){
			sSql ="select UI.UserID||' '||UI.UserName||' '||UR.RoleID||' '||RI.RoleName from "
			+" USER_INFO UI,USER_ROLE UR,ROLE_INFO RI "
			+" where UI.UserID = UR.UserID "
			+" and UR.RoleID = RI.RoleID "
			+" and UI.UserID=:UserID";
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",sActionList[i].split(" ")[0]));
			if(rsTemp.next()){
				sActionValue[i] = rsTemp.getString(1);
			}
			rsTemp.getStatement().close();
			rsTemp = null;
		}
	}
	
	if(sActionValue[0] == null){
		sActionValue = sActionList;
	}
	
	//����JSON
	String sReturn = "";
	for(int i=0;i<sActionValue.length;i++){
		sReturn += ("[\""+sActionValue[i]+"\"],");
	}
	if(sReturn.length() > 0){
		sReturn = sReturn.substring(0,sReturn.length()-1);
	}
	out.println(sReturn);
%>
<%@ include file="/IncludeEndAJAX.jsp"%>