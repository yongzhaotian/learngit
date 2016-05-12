
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,com.amarsoft.biz.bizlet.Bizlet" %>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sReturnValue = "";
		
	//获得页面参数		
	String sPolicyID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PolicyID"));
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	String sUserID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	
	Bizlet bzCheckCreditApplyAuthorization = new CheckCreditApplyAuthorization();
	bzCheckCreditApplyAuthorization.setAttribute("FlowNo",sFlowNo); 
	bzCheckCreditApplyAuthorization.setAttribute("PhaseNo",sPhaseNo);	
	bzCheckCreditApplyAuthorization.setAttribute("ObjectType",sObjectType);		
	bzCheckCreditApplyAuthorization.setAttribute("ObjectNo",sObjectNo);
	bzCheckCreditApplyAuthorization.setAttribute("PolicyID",sPolicyID);
	bzCheckCreditApplyAuthorization.setAttribute("OrgID",sOrgID);
	bzCheckCreditApplyAuthorization.setAttribute("UserID",sUserID);
	
	sReturnValue = (String)bzCheckCreditApplyAuthorization.run(Sqlca);
	if(sReturnValue.equals("Pass")) //审批权限通过
		out.println("该审批人员对当前业务具有终审权"+"<br>");
	else
		out.println(sReturnValue+"<br>");	
%>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
