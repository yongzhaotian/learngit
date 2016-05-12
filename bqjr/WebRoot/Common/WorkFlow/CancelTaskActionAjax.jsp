<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: CChang 2003.8.28
 * Tester:
 *
 * Content: 提示下一阶段信息 
 * Input Param:
 * 				SerialNo：	当前任务的流水号
 * Output param:
 *				sReturnValue:	返回值Commit表示完成操作
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<%@page import="com.amarsoft.biz.workflow.action.*" %>
<% 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));//从上个页面得到传入的任务流水号
	String sReturnMessage = "";//执行后返回的信息
	String sReturnValue="";
	
	FlowAction flowAction = new FlowAction();
	flowAction.setSerialNo(sSerialNo);
	flowAction.preCancel(Sqlca);
	
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//初始化任务对象
	//ftBusiness.cancel(CurUser);//执行退回操作
	sReturnMessage = ftBusiness.cancel(CurUser).ReturnMessage;	
	if("退回完成".equals(sReturnMessage)){
		sReturnValue = "Commit";
	}else{
		sReturnValue=sReturnMessage;
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>