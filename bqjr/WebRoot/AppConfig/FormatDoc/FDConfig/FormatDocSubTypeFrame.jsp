<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �����������ҳ��
	 */
	String sTypeNo = CurPage.getParameter("TypeNo");
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocSubTypeList.jsp","ParentTypeNo=<%=sTypeNo%>","rightup","");
	//AsControl.OpenView("/Blank.jsp","TextToShow=�����Ϸ��б���ѡ��һ��","rightdown","");
</script>
<%@ include file="/IncludeEnd.jsp"%>