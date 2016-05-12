<html>
<head>
<title>untitled</title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
  <tr id=mytop> 
    <td id="mytoptd">
		<iframe name="rightup" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
  <tr id=mydown> 
    <td>
		<div id="divDrag" class="divDrag" title="可拖拽改变窗口大小" style="height:1px;width:100%;font-size:0;z-index:0;cursor:n-resize;"></div>
		<iframe name="rightdown" scrolling="no"  src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"请在上方列表中选择一项")%>"  width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
</table>
</body>
<div id="myboard" style="position: absolute; left: 0; top: 0; width: 100%; height: 100%; cursor: n-resize; display: none;"></div>
</html>
<script type="text/javascript">
mytoptd.height=232;
$(function(){
	$("#divDrag").bind("mousedown", function(e){
		var myboard = $("#myboard").show();
		var mybody = $("body").addClass("no_select");
		$(document).bind("mousemove", dragmove).bind("mouseup", dragup);
		var y = e.clientY;
		var height = window.parseInt(mytoptd.height, 10);
		function dragmove(e){
			mytoptd.height = height + e.clientY - y;
		}
		function dragup(){
			$(document).unbind("mousemove", dragmove).unbind("mouseup", dragup);
			myboard.hide();
			mybody.removeClass("no_select");
		}
	});
});
</script>