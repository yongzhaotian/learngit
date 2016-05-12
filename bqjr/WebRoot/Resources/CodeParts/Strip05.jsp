<html>
<body class=pagebackground leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='98%'  cellspacing="4" cellpadding="0">
  <tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
			<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
	    </td>
	</tr>
	<script type="text/javascript">
		sButtonAreaHTML = document.getElementById("ListButtonArea").innerHTML;
		if(sButtonAreaHTML.indexOf("hc_drawButtonWithTip")<0){
			document.getElementById("ButtonTR").style.display="none";
		}
	</script>
<%for(int i=0;i<sStrips.length;i++){
	if(sStrips[i][0]==null || !sStrips[i][0].equals("true")) continue;
%>
  <tr > 
    <td colspan="4"> 
      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 style='cursor: pointer;' width='100%'>
			<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
			  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent(event,'ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='cursor: pointer;' width='15' height='15'> 
			  </td>
			  <td align=left width='85%' valign='middle' onClick="javascript:document.getElementById('ConditonMap<%=i%>Tab3').click();"> 
				<table>
				  <tr> 
					<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 ><%=sStrips[i][1]%></font> </td>
				  </tr>
				</table>
			  </td>
			  <td align="right" valign="middle"> 
				<a href="javascript:refreshCompInStrip(<%=i%>)">&nbsp;&nbsp;刷新&nbsp;&nbsp;|</a>
			  	<a href="javascript:newCompInStrip(<%=i%>)">&nbsp;&nbsp;新窗口&nbsp;&nbsp;</a>
			  </td>
			</tr>
		  </table>
		</td>
	  	</tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id=ConditonMap<%=i%>Content style=' WIDTH: 100%;display:none'> 
		<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
		<tr>
			<td>
				<iframe name="StripFrame<%=i%>" scrolling="no" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"正在打开页面，请稍候...")%>" width=100% height=<%=sStrips[i][2]%> frameborder=0></iframe>
			</td>
		</tr>
		</table>
      </div>
    </td>
  </tr>
<%}%>
</table>
</div>
</body>
</html>
<script type="text/javascript">
	var sStripsCondition =  new Array(<%=sStrips.length%>);

	function showHideContent(event,id,iStrip){
		var bMO = false;
		var bOn = false;
		var oTab    = document.getElementById(id+"Tab");
		var oTab2   = document.getElementById(id+"Tab2");
		var oImage   = document.getElementById(id+"Tab3");
		var oContent = document.getElementById(id+"Content");
		var oEmptyTag = document.getElementById(id+"EmptyTag");

		if (!oTab || !oTab2 || !oImage || !oContent) 	return;
	
		var obj = event.srcElement || event.target;
		if (obj){
			bMO = (obj.src.toLowerCase().indexOf("_mo.gif") != -1);
			bOn = (oContent.style.display.toLowerCase() == "none");
		}

		if (bOn == false){
			oTab.bgColor = "#EEEEEE";
			oTab2.color  = "#000000";
			oContent.style.display = "none";
			if(oEmptyTag){
				oEmptyTag.style.display = "";
			}
			oImage.src = "<%=sResourcesPath%>/expand" + (bMO? ".gif" : ".gif");
		}else{
			oTab2.color  = "#ffffff";
			oTab.bgColor = "#00659C";
			oContent.style.display = "";
			if(oEmptyTag){
				oEmptyTag.style.display = "none";
			}
			oImage.src = "<%=sResourcesPath%>/collapse" + (bMO? "_mo.gif" : "_mo.gif");
			openCompInStrip(iStrip);
		}
	}
	
	function openCompInStrip(iStrip){
	<%	for(int i=0;i<sStrips.length;i++){	%>
			if(iStrip==<%=i%>){
				if("<%=sStrips[i][3]%>"!="" && sStripsCondition[<%=i%>]!="opened"){
					OpenComp("<%=sStrips[i][3]%>","<%=sStrips[i][4]%>","<%=sStrips[i][5]%>","StripFrame<%=i%>","");
					sStripsCondition[<%=i%>]="opened";
				}
				try{
					<%=sStrips[i][6]%>
				}catch(e){
					alert("执行代码出错！\n"+e);
				}
			}
	<%	}	%>
	}
	
	function refreshCompInStrip(iStrip){
	<%	for(int i=0;i<sStrips.length;i++){	%>
			if(iStrip==<%=i%>){
				OpenComp("<%=sStrips[i][3]%>","<%=sStrips[i][4]%>","<%=sStrips[i][5]%>","StripFrame<%=i%>","");
			}
	<%	}	%>
	}
	
	function newCompInStrip(iStrip){
	<%	for(int i=0;i<sStrips.length;i++){	%>
			if(iStrip==<%=i%>){
				OpenComp("<%=sStrips[i][3]%>","<%=sStrips[i][4]%>","<%=sStrips[i][5]%>","_blank","");
				refreshCompInStrip(iStrip);
			}
	<%	}	%>
	}
</script>