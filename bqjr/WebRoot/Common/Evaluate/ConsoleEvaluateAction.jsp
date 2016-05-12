<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:fhhao 2003.8.30
 * Tester:
 *
 * Content: 	新增信用等级评估动作
 * Input Param:
 *			ActionType：操作类型
 *			ObjectType：对象类型
 *		    ObjectNo：对象编号
 *			SerialNO：评级流水号
 *          AccountMonth：会计月份
 *          ModelNo：评估模型类型代码
 *			ModelType：评估模型类型
 * Output param:
 * History Log:   zbdeng 2004.02.09
 *                2003.02.11 FXie  修改权限判断
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.evaluate.*,com.amarsoft.app.lending.bizlets.InitializeFlow" %>
<% 
	//定义变量
	int iTCount = 0;
	
	//获取组件参数
	
	//获取页面参数
	String sActionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sSerialNo     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	String sModelNo      = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo"));
	String sModelType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelType"));
	String sReportScope    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	//将空值转化为空字符串
	if(sActionType == null) sActionType = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
	if(sModelNo == null) sModelNo = "";
	if(sModelType == null) sModelType = "";
	if(sReportScope == null) sReportScope = "";
	//采用标志位控制之后，这里新增的记录全都没有进行信用等级评估，所以不用查询该记录是否已评估。
	//原来这里的Evaluate.existEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,Sqlca)方法已经废除。
	if(sActionType.equals("add"))//新增
	{
		//实现多口径后，新增一条信用等级评估申请记录时，要带上相应的财务报表的口径参数。
		//这里修改了方法Evaluate.newEvaluate，在原来的基础上增加了口径参数。
		//sSerialNo = Evaluate.newEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),Sqlca); //原来的方法
		sSerialNo = Evaluate.newEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),sReportScope,Sqlca); //修改后的方法
		if(sObjectType.equals("Customer")){
			//信用等级没有系统评级，不置评估时间
		//	String sSql = " Update EVALUATE_RECORD Set EvaluateDate=''"+
		//	       " where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "'";
		//	Sqlca.executeSQL(sSql);
			InitializeFlow InitializeFlow_CustomerEvaluate = new InitializeFlow();
			InitializeFlow_CustomerEvaluate.setAttribute("ObjectType",sObjectType);
			InitializeFlow_CustomerEvaluate.setAttribute("ObjectNo",sSerialNo); 
			InitializeFlow_CustomerEvaluate.setAttribute("ApplyType","CreditCogApply");//信用等级评定模板编号
			InitializeFlow_CustomerEvaluate.setAttribute("FlowNo","EvaluateFlow");
			InitializeFlow_CustomerEvaluate.setAttribute("PhaseNo","0010");
			InitializeFlow_CustomerEvaluate.setAttribute("UserID",CurUser.getUserID());
			InitializeFlow_CustomerEvaluate.setAttribute("OrgID",CurUser.getOrgID());
			InitializeFlow_CustomerEvaluate.run(Sqlca);
		}
%>	
		<script type="text/javascript"> 
			self.returnValue="<%=sSerialNo%>";
			self.close();
		</script>		
<%
	}else if(sActionType.equals("delete"))//删除
	{
		Evaluate eEvaluate = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);
		eEvaluate.deleteEvaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);
%> 
		<script type="text/javascript">
			self.returnValue="success";//删除信用等级评估记录成功
			self.close();
		</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>