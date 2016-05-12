<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author: syang 2009/10/15
		Tester:
		Describe: 根据意见，生成动作列表
		Input Param:
			SerialNo：任务流水号
			PhaseOpinion：意见
		Output Param:
		HistoryLog: 
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<% 
	//获取参数：任务流水号、意见
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sPhaseOpinion = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));
	
	//定义变量：流程编号、阶段编号、对象编号
	String sFlowNo = "",sPhaseNo = "",sObjectNo = "";
	//定义变量：动作、动作列表、阶段的类型、动作提示、阶段的属性
	String sPhaseAction = "",sActionList[],sSelectStyle = "",sActionDescribe = "",sPhaseAttribute = ""; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义业务逻辑主体;]~*/%>
<%
	//从任务流程表FLOW_TASK中查询出流程编号、阶段编号
	sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = :SerialNo ";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if (rsTemp.next()){
		sFlowNo  = DataConvert.toString(rsTemp.getString("FlowNo"));
		sPhaseNo  = DataConvert.toString(rsTemp.getString("PhaseNo"));
		
		//将空值转化成空字符串
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";				
	}
	rsTemp.getStatement().close();
	rsTemp = null;
	
	//初始化任务对象		 
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	//获取动作选择列表
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
	
	//生成JSON
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