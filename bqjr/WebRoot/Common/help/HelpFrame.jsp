<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sComponentURL = "/Common/help/QuestionList.jsp?a=b";
	String sCommentItemID = CurPage.getParameter("CommentItemID");
	
	if(sObjectType!=null && !sObjectType.equals("")){
		%>
		<script>
			OpenPage("<%=sComponentURL%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
		</script>
		<%
			//response.sendRedirect(sComponentURL);
	}
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>帮助</title>
<script type="text/javascript">
	window.moveTo(0,0);
 
	if (document.all) 
	{ 
  		top.window.resizeTo(screen.availWidth,screen.availHeight); 
	} 
 
	else if (document.layers||document.getElementById) 
	{ 
  		if (top.window.outerHeight<screen.availHeight||top.window.outerWidth<screen.availWidth) 
  		{ 
    		top.window.outerHeight = screen.availHeight; 
    		top.window.outerWidth = screen.availWidth; 
  		} 
	}
</script>
</head>

<frameset rows="*" cols="190,*" framespacing="0" frameborder="yes" border="1" >
  <frameset rows="47,30,*" cols="*" frameborder="no" border="1">
    <frame src="HelpSearch.jsp?CompClientID=<%=CurComp.getClientID()%>" name="topFrame" scrolling="no" >
    <frame src="HelpFunctions.jsp?CompClientID=<%=CurComp.getClientID()%>" name="functionFrame" scrolling="no">
    <frame src="HelpIndex.jsp?CompClientID=<%=CurComp.getClientID()%>&CommentItemID=<%=sCommentItemID%>" name="leftFrame" scrolling="no">
  </frameset>
  <frame src="<%=sWebRootPath%>/Blank.jsp?TextToShow=请点击左侧分类目录" name="mainFrame" scrolling="auto">
</frameset>
<noframes><body>

</body></noframes>
</html>
<%@ include file="/IncludeEnd.jsp"%>