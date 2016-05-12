<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sExecutorCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExecutorCode"));//行动代码大类
	if(sExecutorCode==null)sExecutorCode="";
	String sSql = "";
	
	sSql = "select itemno,itemname from ";
	
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	rs.getStatement().close();
	
%>
<html>
	<head></head>
	<body>
		<select id="subExecutorCode" name ="subExecutorCode">
			<option value=""></option>
		</select>
	</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>