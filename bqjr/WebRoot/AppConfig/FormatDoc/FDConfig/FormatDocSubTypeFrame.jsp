<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 上下联动框架页面
	 */
	String sTypeNo = CurPage.getParameter("TypeNo");
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocSubTypeList.jsp","ParentTypeNo=<%=sTypeNo%>","rightup","");
	//AsControl.OpenView("/Blank.jsp","TextToShow=请在上方列表中选择一项","rightdown","");
</script>
<%@ include file="/IncludeEnd.jsp"%>