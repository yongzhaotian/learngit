<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	// 获得页面组件参数
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sTemp==null) sTemp="";
	if(sCustomerID==null) sCustomerID="";
	if(sObjectNo==null) sObjectNo="";

	/* 
	--页面说明： 通过数组定义生成Tab框架页面示例--
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		{"true", "合同信息", "/Common/WorkFlow/PutOutApply/PutOutCreditInfo.jsp", "ObjectNo="+sObjectNo+"&temp="+sTemp},
		{"true", "客户信息", "/Common/WorkFlow/PutOutApply/PutOutCustomerInfo.jsp", "CustomerID="+sCustomerID},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
