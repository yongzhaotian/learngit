<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "费用还款记录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	String templetFilter="1=1";
	String templetNo;
	//获得组件参数
	
	//获得页面参数
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String objectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//借据编号
	if(objectType==null) objectType="";
	if(objectNo == null) objectNo="";

	String sTemplete = "FeeRecordList";
    ASDataObject doTemp = new ASDataObject(sTemplete,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Freeform风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//将模版应用于Datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectType+","+objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	};
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>
