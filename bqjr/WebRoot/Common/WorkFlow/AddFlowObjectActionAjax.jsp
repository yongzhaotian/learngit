<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: �������̶���
		Input Param:
			ObjectType�� ��������
			sObjectNo���������
			sDescribe������
		Output Param:
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%> 

<%	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sApplyType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ApplyType"));
	String sDescribe = DataConvert.toRealString(iPostChange,(String)request.getParameter("Describe"));
	String sInitFlowNo = "",sInitPhaseNo = "",sReturnValue="";

	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	try{
		
		//�������̶���ӳ��
				 		
		sSql="select Attribute2 from CODE_LIBRARY where CodeNo='ApplyType' and ItemNo=:ItemNo";
		so = new SqlObject(sSql).setParameter("ItemNo",sApplyType);
		rs = Sqlca.getASResultSet(so);
		while(rs.next()){
			sInitFlowNo = rs.getString(1);
		}
		rs.getStatement().close();

		sSql="select InitPhase from FLOW_CATALOG where FlowNo=:FlowNo";
		so = new SqlObject(sSql).setParameter("FlowNo",sInitFlowNo);
		rs = Sqlca.getASResultSet(so);
		while(rs.next()){
			sInitPhaseNo = rs.getString(1);
		}
		rs.getStatement().close();

		//�޸Ľ׶�		
		FlowObject foTemp = new FlowObject(sObjectType,sObjectNo,Sqlca);
		FlowPhase fpTemp = new FlowPhase(sInitFlowNo,sInitPhaseNo,Sqlca);
		foTemp.changePhase(fpTemp,CurUser);
		sReturnValue= "succeeded";
	}catch(Exception ex){
		//out.println(ex.toString());
		sReturnValue= "failed";
	}finally{
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	  out.println(sReturnValue);
	}
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>