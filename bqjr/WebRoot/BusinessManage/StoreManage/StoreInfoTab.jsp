<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	//  获取页面参数
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));
	String sModify= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	
	if(sStatus == null) sStatus="";
	if(sSSerialNo == null) sSSerialNo="";
	if(sSNo == null) sSNo = ""; 
	if(sFlag == null) sFlag = ""; 
	if(sModify==null) sModify="";


	/* 
	页面说明： 通过数组定义生成Tab框架页面示例
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
			{"true", "门店详情", "/BusinessManage/StoreManage/StoreInfo.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&Status="+sStatus+"&sFlag="+sFlag+"&Modify="+sModify},
			{"true", "关联产品", "/BusinessManage/StoreManage/ProductList.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&sFlag="+sFlag},
			{"true", "关联销售人员", "/BusinessManage/StoreManage/SalesManList.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&sFlag="+sFlag},
			{"true", "关联邮寄门店", "/BusinessManage/StoreManage/PostStoreList.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&sFlag="+sFlag},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
