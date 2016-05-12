<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	//  获取页面参数
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SSerialNo"));
	String sRelaSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplySerialNo"));
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransferType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));

	if(sSSerialNo == null) sSSerialNo="";
	if(sRelaSerialNo == null) sRelaSerialNo = ""; 
	if(sTransferType == null) sTransferType = ""; 
	if(sApplyType == null) sApplyType = ""; 

	/* 
	页面说明： 通过数组定义生成Tab框架页面示例
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
			{"false", "协议详情", "/BusinessManage/CollectionManage/TransferAutoDealList.jsp", "TransferType="+sTransferType+"&SerialNo="+sSSerialNo+"&RelaSerialNo="+sRelaSerialNo},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<script type="text/javascript">
AsControl.OpenView("/BusinessManage/CollectionManage/TransferAutoDealList.jsp","TransferType="+"<%=sTransferType%>"+"&SerialNo="+"<%=sSSerialNo%>"+"&RelaSerialNo="+"<%=sRelaSerialNo%>"+"&ApplyType="+"<%=sApplyType%>","_self","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
