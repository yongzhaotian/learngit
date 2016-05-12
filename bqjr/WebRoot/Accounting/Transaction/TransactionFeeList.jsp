<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "交易收取费用列表界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>

<%
	//获得页面参数,父交易流水号
	String parentTransSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentTransSerialNo"));
	if(parentTransSerialNo == null) parentTransSerialNo = "";
%>

<%
	//生成DW对象
	String sTempletNo = "Transaction_Fee";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	//增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//设置页面显示的列数
	dwTemp.setPageSize(10);
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(parentTransSerialNo);
	for(int i=0;i<vTemp.size();i++)out.print((String)vTemp.get(i));

%>


<%
	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()",sResourcesPath}
	};
%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>

	/*~[Describe=数据保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
		as_save("myiframe0",sPostEvents);
	}
</script>
	
	<script language=javascript>	
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	</script>	


<%@ include file="/IncludeEnd.jsp"%>
