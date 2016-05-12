<style>
.imgsDrag{
	width:100%;
	height:3px;
	background-color:#9966BB;
	cursor: s-resize;
}
</style>
<table <%=sTableStyle%>>
	<tr>
		<td valign='top' colspan=2 class='tabhead' <%=sTabHeadStyle%>><%=sTabHeadText%></td>
	</tr>
	<tr>
		<td valign='top' align='left' id="<%=sTabID%>" class="tabtd"></td>
		<td valign='top' class="tabbar">
		<%=sTopRight%>
		</td>
	</tr>
	<tr>
		<td class='tabcontent' align='center' valign='top' colspan=2>
			<table border="1" cellspacing=0 cellpadding=0 border=0	width='100%' height='100%'>
				<tr id="mytop"> 
					<td>
					<iframe name="<%=sIframeName%>" src="<%=sDefaultPage%>" <%=sIframeStyle%> width=100% height=100% frameborder=1></iframe>
					</td>
				</tr>
				<tr id="mydown"> 
					<td>
					<div id=divDrag title='可拖拽改变窗口大小' ondrag="dragFrame(event);"><img class=imgsDrag src=<%=sResourcesPath%>/1x1.gif></div>
					<iframe name="EditBlock" <%=sIframeStyle%> width=100% height=100% frameborder=0>></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function dragFrame(event) {
	if(event.y>100 && event.y<800) { 
		mytop.height=event.y-20;
	}
	if(event.y<100) {
		window.event.returnValue = false;
	}
}
</script>