<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:		ygwu
		Tester:
		Describe: 	合同详情
		Input Param:
		Output Param:
		
		HistoryLog:
					2014/03/21查看合同信息
	 */
	%>
<%/*~END~*/%>

<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%>
<%
	/* 
	--页面说明： 通过数组定义生成Tab框架页面示例--*/
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		{"true", "合同详情", "/CreditManage/CreditApply/CreditView.jsp", "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&RightType=ReadOnly"},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
