<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "费用计划信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	String sSql = "";
	//获得页面参数
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));
	
	// 贷款台账列表
	ASDataObject doTemp = new ASDataObject("PaymentScheduleAcctFeeList",Sqlca);
	
	// 设置查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
		};
	%>


<%@include file="/Resources/CodeParts/List05.jsp"%>

	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	
	function exportAll()
	{
		amarExport("myiframe0");
	}

	</script>


<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>


<%@	include file="/IncludeEnd.jsp"%>