<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	// 获得页面组件参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	if(sSerialNo==null) sSerialNo="";

	/* 
	--页面说明： 通过数组定义生成Tab框架页面示例--
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		{"true", "贷款人详情", "/CustomerManage/CooperationCustomerManage/LoanManInfo1.jsp", "serialNo="+sSerialNo+"&temp=modify"},
		{"true", "还款渠道", "/CustomerManage/CooperationCustomerManage/RepaymentChannelList1.jsp", "serialNo="+sSerialNo},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
