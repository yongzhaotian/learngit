<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	// 获得页面组件参数
	String sLoanNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	if(sLoanNo==null) sLoanNo="";

	/* 
	--页面说明： 通过数组定义生成Tab框架页面示例--
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		{"true", "贷款人详情", "/BusinessManage/CollectionManage/LoanManInfo.jsp", "LoanNo="+sLoanNo},
		{"true", "还款渠道", "/BusinessManage/CollectionManage/RepaymentChannelList.jsp", "LoanNo="+sLoanNo},
		{"true", "关联城市", "/BusinessManage/CollectionManage/LoanManCityList.jsp", "LoanNo="+sLoanNo},
		{"true", "电子合同模板", "/BusinessManage/CollectionManage/LoanManEDocList.jsp", "LoanNo="+sLoanNo},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
