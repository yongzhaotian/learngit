<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "页面访问时间日志"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String sToday=StringFunction.getToday();
	String sTempletNo="AuditUserPageList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1 = 2 "; //数据量过大，屏蔽进入页面的时候自动查询
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(40); 	//服务器分页

	Vector vTemp = dwTemp.genHTMLDataWindow(sToday);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	String sButtons[][] = {
		{"true","","PlainText","由于本页面数据量过大，请通过查询条件查询","由于本页面数据量过大，请通过查询条件查询","style={color:red}",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%@include file="/IncludeEnd.jsp"%>