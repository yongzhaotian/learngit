<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		Author: zq 2016-01-12
		Tester:
		Describe: 新增债权转让main文件
		Jira:PRM-658
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		Output Param:
		HistoryLog:
	 */
	%>
<%
	String PG_TITLE = "债权转让查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;债权转让查询&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请稍后";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
	
	//产品类型
	String sProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));	
	if(null == sProductType) sProductType = "";
%>

<%@include file="/Resources/CodeParts/Main04.jsp"%>

<script type="text/javascript">
		myleft.width=1;
		AsControl.OpenView("/CustomService/BusinessConsult/AssignmentClaimsQueryList.jsp","ProductType=<%=sProductType%>","right",""); 
</script>
<%@ include file="/IncludeEnd.jsp"%>
	