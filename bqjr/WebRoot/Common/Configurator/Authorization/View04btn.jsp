
<html>
<head>
<title><%=PG_TITLE%></title>
</head>

<body leftmargin="0" topmargin="0" class="windowbackground" onload="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<!-----------------按扭区  add by byhu -------------------------->

<!--------------------------------------------------------------->

<!-- add by byhu: 用于刷新本页面 -->
<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
				<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
				<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
</form>
	<tr>
		<td valign="top">

			<table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
				<tr> 
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
					<td id="myleft" > 
						<table width="100%">
						  <tr height=1 id="ButtonTR">
							<td id="ListButtonArea" bgcolor="#E0ECFF" valign=middle>
								<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
						    </td>
						</tr>
						</table>
						<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=92% frameborder=0 scrolling=no ></iframe>
					</td>
					<td id="myleft_rightMargin" class="myleft_rightMargin"> </td>
					<td id="mycenter" class="mycenter">
						<div id=divDrag title='可拖拽改变窗口大小 Drag to resize' style="z-index:0; CURSOR: url('<%=sResourcesPath%>/ve_split.cur') "	ondrag="if(event.x>16 && event.x<400) {myleft_top.style.display='block';myleft.style.display='block';myleft_bottom.style.display='block';myleft.width=event.x-6;}if(event.x<=16 && event.y>=4) {myleft_top.style.display='none';myleft.style.display='none';myleft_bottom.style.display='none';}if(event.x<4) window.event.returnValue = false;">
							<!--img name=imgDrag title='可拖拉' height=100% width=3 src="<%=sResourcesPath%>/line.gif"-->
							<img class=imgDrag src=<%=sResourcesPath%>/1x1.gif width="1" height="1">
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
										<div  class="groupboxmaxcontent" style="position:absolute; width: 100%;overflow:hidden;" id="window1"> 
										<iframe name="right" scrolling="no" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=<%=PG_CONTNET_TEXT%>" width=100% height=100% frameborder=0></iframe>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td id="myright_rightMargin" class="myright_rightMargin"></td>
				</tr>
				<tr>
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
</body>
</html>
<script language="JavaScript">
	//设置标题
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	

	myleft.width=<%=PG_LEFT_WIDTH%>; 
</script>
