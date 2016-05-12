<%
	String sPageHead = "";
	String sPageHeadPlacement = "";

	if(PG_TITLE.indexOf("@")>=0){
		sPageHead = StringFunction.getSeparate(PG_TITLE,"@",1);
		sPageHeadPlacement = StringFunction.getSeparate(PG_TITLE,"@",2);
	}
%>
<html>
<head>
<%@ include file="/Resources/CodeParts/progressSet.jsp"%>
<title><%=(sPageHeadPlacement.equals("WindowTitle")?sPageHead:"")%></title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<%@ include file="/Resources/CodeParts/CoverTip.jsp"%>
<table id="ListTable" border="0" width="100%" height="99%" cellspacing="0" cellpadding="0" >
<tr width="100%" height="99%" >
<td width="37%" height="99%" >
<table width="100%" height="99%" >
	<%if(sPageHeadPlacement.equals("PageTitle")){%>
	<tr height=1>
	    <td id="ListTitle" class="ListTitle"><%=sPageHead%></td>
	</tr>
	<%}%>
	<%@ include file="/Resources/CodeParts/FilterArea.jsp"%>
	<tr height=1  id="ButtonTR">
		<td valign=top id="InfoButtonArea" class="infodw_buttonarea_td" align="left" >
			<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
	    </td>
	</tr>
	<tr id="DWTR">
	    <td id="ListDWArea" class="ListDWArea">
			<iframe name="myiframe0" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe>			 
	    </td>
	</tr>
	</table>
	</td>
	<td width="70%" height="99%" >
	<table width="100%" height="99%" >
<%
String ShowDetailArea = (String)CurPage.getAttribute("ShowDetailArea");
if(ShowDetailArea!=null && ShowDetailArea.equalsIgnoreCase("true")){
%>
	<tr>
	    <td id="ListHorizontalBar" class="ListHorizontalBar">
		<div id="divDrag" class="divDrag" title="可拖拽改变窗口大小" style="height:1px;width:100%;font-size:0;z-index:0;cursor:n-resize;"></div>
	    </td>
	</tr>
	<tr>
	    <td id="ListDetailAreaTD" class="ListDetailAreaTD" >
		<table height=100% width=100% cellpadding=5>
		<tr>
		<td>
		<div class="groupboxmaxcontent">
			<iframe name="DetailFrame" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,CurPage.getAttribute("DetailFrameInitialText"))%>" width=100% height=100% frameborder=0></iframe>
		</div>
		</td>
		</tr>
		</table>
		</td>
	</tr>
<script type="text/javascript">
<%
String DetailAreaHeight = (String)CurPage.getAttribute("DetailAreaHeight");
if(DetailAreaHeight!=null && !DetailAreaHeight.equals("")){
	%>
	ListDWArea.height=<%=DetailAreaHeight%>;
	<%
}else{
	%>
	ListDWArea.height=232;	
	<%
}
%>
$(function(){
	$("#divDrag").bind("mousedown", function(e){
		var myboard = $("#myboard").show();
		var mybody = $("body").addClass("no_select");
		$(document).bind("mousemove", dragmove).bind("mouseup", dragup);
		var y = e.clientY;
		var width = window.parseInt(ListDWArea.width, 10);
		function dragmove(e){
			ListDWArea.width = width + e.clientY - y;
		}
		function dragup(){
			$(document).unbind("mousemove", dragmove).unbind("mouseup", dragup);
			myboard.hide();
			mybody.removeClass("no_select");
		}
	});
});
</script>
<%
}
%>
</table>
</td>
</tr>
</table>
<div id="myboard" style="position: absolute; left: 0; top: 0; width: 100%; height: 100%; cursor: n-resize; display: none;"></div>
</body>
</html>