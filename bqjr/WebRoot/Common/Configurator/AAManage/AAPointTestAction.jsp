
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,com.amarsoft.biz.bizlet.Bizlet" %>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sReturnValue = "";
		
	//���ҳ�����		
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
	if(sReturnValue.equals("Pass")) //����Ȩ��ͨ��
		out.println("��������Ա�Ե�ǰҵ���������Ȩ"+"<br>");
	else
		out.println(sReturnValue+"<br>");	
%>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
