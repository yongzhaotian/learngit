<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	//  获取页面参数
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplySerialNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sMobilePosNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MOBLIEPOSNO"));
	
	if(sStatus == null) sStatus="";
	if(sSSerialNo == null) sSSerialNo="";
	if(sMobilePosNo == null) sMobilePosNo="";

	/* 
	页面说明： 通过数组定义生成Tab框架页面示例
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
			
		{"true", "移动Pos点详情", "/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosApplyInfoManager.jsp", "SSerialNo="+sSSerialNo+"&Status="+sStatus},
		{"true", "关联产品", "/BusinessManage/PosManage/MobilePosApplyFlow/ProductList.jsp", "MOBLIEPOSNO="+sMobilePosNo},
		{"true", "关联销售人员", "/BusinessManage/PosManage/MobilePosApplyFlow/SalesManListForMobilePos.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&MOBLIEPOSNO"+sMobilePosNo},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
