<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMD.jsp"%><%
	String sScriptText = DataConvert.toRealString(iPostChange,CurComp.getParameter("ScriptText",10));
	if (sScriptText==null) sScriptText="";
	sScriptText = StringFunction.replace(sScriptText,"$[wave]","~");
%>
<HTML>
<html>
<head>
<title></title>
</head>

<body leftmargin="0" topmargin="0" class="windowbackground" onload="loadSourceScript()">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr height=1>
	    <td>
            <table>
                <tr>
                    <td >
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","确定","确定","getHTMLScript()",sResourcesPath)%>
                    </td>
                    <td>
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","取消","取消","cancel()",sResourcesPath)%>
                    </td>
                </tr>
            </table>
	    </td>
	</tr>
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
                                <tr width="100%"> 
									<td> 
										<div name="tt" class="groupboxmaxcontent" style="position:absolute; width: 100%;" id="window1"> 
                                        <iframe name="right" disabled=false  src="<%=sWebRootPath%>/Blank.jsp?TextToShow=请稍候..." width=100% height=100% frameborder=0 scrolling=no ></iframe>
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

<script type="text/javascript">
	function getHTMLScript(){
        sReturnValue=right.returnHTMLScript();
        top.returnValue = sReturnValue;
        top.close();
    }
	
    function cancel(){
    	top.close();
	}
    
    function loadSourceScript(){
        right.setHTMLScript('<%=sScriptText%>');
    }
</script>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Tree06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	right.designMode="On";
	OpenPage("/Common/HtmlEditor/editor.jsp","right","");
    </script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>