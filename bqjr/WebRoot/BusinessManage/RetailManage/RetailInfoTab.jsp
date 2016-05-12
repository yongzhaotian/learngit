<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	//  获取页面参数
	String sRSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RSerialNo"));
	String sModify =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	if(sModify == null) sModify = "";
	if(sRSerialNo == null) sRSerialNo = "";

	/* 
	页面说明： 通过数组定义生成Tab框架页面示例
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		//{"false", "List", "/BusinessManage/RetailManage/RetailList.jsp", ""},
		{"true", "零售商详情", "/BusinessManage/ChannelManage/RetailApplyInfo.jsp", "RSerialNo="+sRSerialNo+"&Modify="+sModify},
		{"true", "关联的门店信息", "/BusinessManage/RetailManage/RetailStoreList.jsp", "RSerialNo="+sRSerialNo},
		{"false", "Blank", "/Blank.jsp", ""},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
