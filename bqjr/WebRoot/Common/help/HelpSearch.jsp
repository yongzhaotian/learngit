<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>无标题文档</title>
<script type="text/javascript">
function doSearch(){
	var sKeyWords = document.getElementById("KeyWords").value;
	if(sKeyWords=="GenChapterNo"){
		genChapterNo();
		return false;
	}
	if(sKeyWords.length<1)
	{
		alert("关键字过短，请重新输入查询关键字！");
		return false;
	}
	if(sKeyWords.indexOf("%")>0||sKeyWords.indexOf("and")>0||sKeyWords.indexOf("or")>0)
	{
		alert("请不要输入非法字符!");
		return false;
	}
	OpenComp("SearchResult","/Common/help/SearchResult.jsp","KeyWords="+sKeyWords,"mainFrame","");
	return false;
}
function genChapterNo(){
	OpenPage("/Common/help/HelpFunctions.jsp?Action=GenerateChapterNo&GenCriteria=","functionFrame","");
}
</script>
</head>

<body class="pagebackground">
<table>
	<form name="form1" method="post" action="" onSubmit="return doSearch()">
    	<tr>
		<td><input id="KeyWords" name="KeyWords" type="text" size="16"></td>
		<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","搜索","搜索","javascript:doSearch()",sResourcesPath)%></td>
	</tr>
	</form>
</table>
    </td>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>