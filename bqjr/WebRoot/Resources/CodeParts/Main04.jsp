<%
	/**
	 *judge whether from MainMenu
	 */
	String sMainMenuFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("_SYSTEM_MENU_FALG"));
	if(sMainMenuFlag == null) sMainMenuFlag = "1";
	boolean bFormMainMenu = sMainMenuFlag.equals("1");
%>
<html>
<head>
<title><%=PG_TITLE%></title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground" onLoad="">
<!-- for refresh this page -->
<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
	<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
	<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
</form>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">

	<% if(bFormMainMenu){ %>
		<tr>
			<td id=mytop class="mytop"  valign="bottom" >
			<%@include file="/MainTop.jsp"%>
			</td>
		</tr>
		<!--<tr>
			<td valign="top" id="mymiddle" class="mymiddle"></td>
		</tr>
		<tr>
			<td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
		</tr>-->
	<%} %>
	<tr>
<td valign="top">
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
				<tr style="display:none;"> 
					<td id="myleft_left_top_corner" class="myleft_left_top_corner"></td>
					<td id="myleft_top" class="myleft_top"></td>
					<td id="myleft_right_top_corner" class="myleft_right_top_corner"></td>
					<td id="mycenter_top" class="mycenter_top"></td>
					<td id="myright_left_top_corner" class="myright_left_top_corner"></td>
					<td id="myright_top" class="myright_top"></td>
					<td id="myright_right_top_corner" class="myright_right_top_corner"></td>
				</tr>
				<tr> 
					<td id="myleft_leftMargin" class="myleft_leftMargin"></td>
					<td width="2" id="myleft" <%=(Integer.parseInt(PG_LEFT_WIDTH)<10?"style=\"display:none;\"":"")%>>
						<table style="height:100%;width:100%;" cellspacing="0" cellpadding="0">
						<tr height="1"><td class="left_content_title"><span><%=PG_TITLE%></span></td></tr>
						<tr height="100%"><td><iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no></iframe></td></tr>
						</table>
					</td>
				  <td id="myleft_rightMargin" class="myleft_rightMargin"> </td>
					<td id="mycenter" class="mycenter">
						<div id="divDrag" class="divDrag" title="可拖拽改变窗口大小 Drag to resize" style="height: 100%; width: 1px; z-index:0; cursor: w-resize;">
						</div>
					</td>
					<td id="myright_leftMargin" class="myright_leftMargin"></td>
					<td id="myright" class="myright">
						<div  class="RightContentDiv" id="RightContentDiv"> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
								<tr> 
									<td height="1"> 
										<table id=table0 cols=3 border=0 cellpadding=0 cellspacing=0>
											<tr> 
												<td nowrap class="groupboxheader"><%=PG_CONTENT_TITLE%></td>
												<td nowrap><img class=groupboxcornerimg src=<%=sResourcesPath%>/1x1.gif width="1" height="1" name="Image1"></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr> 
									<td colspan=2> 
										<div  class="groupboxmaxcontent" style="width: 100%;overflow:hidden;" id="window1"> 
										<iframe name="right" scrolling="auto" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,PG_CONTNET_TEXT)%>" width=100% height=100% frameborder=0></iframe>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td id="myright_rightMargin" class="myright_rightMargin"></td>
				</tr>
				<tr style="display:none;">
					<td id="myleft_left_bottom_corner" class="myleft_left_bottom_corner"></td>
					<td id="myleft_bottom" class="myleft_bottom"></td>
					<td id="myleft_right_bottom_corner" class="myleft_right_bottom_corner"></td>
					<td id="mycenter_bottom" class="mycenter_bottom"></td>
					<td id="myright_left_bottom_corner" class="myright_left_bottom_corner"></td>
					<td id="myright_bottom" class="myright_bottom"></td>
					<td id="myright_right_bottom_corner" class="myright_right_bottom_corner"></td>
				</tr>
		  </table>
		</td>
	</tr>
</table>
<div id="myboard" style="position: absolute; left: 0; top: 0; width: 100%; height: 100%; cursor: w-resize; display: none;"></div>
</body>
</html>
<script type="text/javascript">
	function setTitle(sTitle){
		document.getElementById("table0").rows[0].cells[0].innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	

	$(function(){
		$("#divDrag").bind("mousedown", function(e){
			document.body.onselectstart = function(){return false;};
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
				document.body.onselectstart = "";
			}
		});
	});
	
	myleft.width=<%=PG_LEFT_WIDTH%>; 
	<%
	String sDefaultCompID = CurPage.getParameter("DefaultCompID");
	String sDefaultCompParas = CurPage.getParameter("DefaultCompParas");
	if(sDefaultCompParas!=null) sDefaultCompParas = StringFunction.replace(sDefaultCompParas,"~","&");
	else sDefaultCompParas="";
	if(sDefaultCompID!=null && !sDefaultCompID.equals("")){
	%>
	OpenComp("<%=sDefaultCompID%>","","<%=sDefaultCompParas%>","right","");
	<%}%>
	setTimeout(function(){
		if(myleft.width<10){
			myleft.style.display = "none";
			mycenter.style.display = "none";
		}
	}, 100);
</script>