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
  <tr> 
    <td id=myleft width="50%">
	<iframe name="frameleft" scrolling="yes"  src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe> 
    </td>
    <td id="mycenter" class="mycenter">
		<div id="divDrag" class="divDrag" title="可拖拽改变窗口大小 Drag to resize" style="height:100%;width:1px;z-index:0;cursor:w-resize;">
		</div>
	</td>
    <td id=myright width="50%"> 
	<iframe name="frameright" scrolling="yes"  src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"请在左侧选择一项")%>" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
  <tr>
	<td nowarp bgcolor="#f6fbfe" height="25" align=center valign="middle" colspan="3" style="border-top:1px solid #6c8aa2"> 
		<input type="button" name="ok" value="确认" onClick="javascript:returnSelection()"  border='1'>
		<input type="button" name="Cancel" value="取消" onClick="javascript:doCancel();" border='1'>
	</td>
  </tr>
</table>
<div id="myboard" style="position: absolute; left: 0; top: 0; width: 100%; height: 100%; cursor: w-resize; display: none;"></div>
</body>
</html>
<script type="text/javascript">

function doCancel() {
	self.returnValue = "";
	self.close();
}

function returnSelection(){
	var sRet ="";
	sRet = sRet + self.frameleft.test();
	sRet = sRet + "~"+ self.frameright.test();
	self.returnValue = sRet;
	self.close();
}

myleft.width=480;
$(function(){
	$("#divDrag").bind("mousedown", function(e){
		var myboard = $("#myboard").show();
		var mybody = $("body").addClass("no_select");
		$(document).bind("mousemove", dragmove).bind("mouseup", dragup);
		var x = e.clientX;
		var width = window.parseInt(myleft.width, 10);
		function dragmove(e){
			myleft.width = width + e.clientX - x;
		}
		function dragup(){
			$(document).unbind("mousemove", dragmove).unbind("mouseup", dragup);
			myboard.hide();
			mybody.removeClass("no_select");
		}
	});
});
</script>