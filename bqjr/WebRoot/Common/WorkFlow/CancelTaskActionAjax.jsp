<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: CChang 2003.8.28
 * Tester:
 *
 * Content: ��ʾ��һ�׶���Ϣ 
 * Input Param:
 * 				SerialNo��	��ǰ�������ˮ��
 * Output param:
 *				sReturnValue:	����ֵCommit��ʾ��ɲ���
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<%@page import="com.amarsoft.biz.workflow.action.*" %>
<% 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));//���ϸ�ҳ��õ������������ˮ��
	String sReturnMessage = "";//ִ�к󷵻ص���Ϣ
	String sReturnValue="";
	
	FlowAction flowAction = new FlowAction();
	flowAction.setSerialNo(sSerialNo);
	flowAction.preCancel(Sqlca);
	
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//��ʼ���������
	//ftBusiness.cancel(CurUser);//ִ���˻ز���
	sReturnMessage = ftBusiness.cancel(CurUser).ReturnMessage;	
	if("�˻����".equals(sReturnMessage)){
		sReturnValue = "Commit";
	}else{
		sReturnValue=sReturnMessage;
	}
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
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>