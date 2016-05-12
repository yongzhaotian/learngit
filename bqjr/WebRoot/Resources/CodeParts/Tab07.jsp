<script type="text/javascript">
<%
	String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
	String sTabHeadStyle = "";
	String sTabHeadText = "<br>";
	String sTopRight = "";
	String sTabViewId = "tab_DeskTopInfo";
	String sTabID = "tabtd";
	String sIframeName = "TabContentFrame";
	String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";
	String sDefaultPage = sWebRootPath+"/Blank.jsp";
	int defaultTab = 1;
	
	String sReturn="var tabstrip = new Array();\n";
  	for(int i=0,j=0;j<sTabStrip.length;i++,j++){
  		if(sTabStrip[j][0]==null) break;
  		else if(sTabStrip[j][0].equals("false")) {
  			i--;
  		}else{
	  		sReturn += "tabstrip["+i+"] = new Array(\"block_"+(i+1)+"\",\""+sTabStrip[j][1]+"\",\""+sTabStrip[j][2]+"\",\""+sTabStrip[j][3]+"\");\n";
	  	}
  	}
  	out.println(sReturn);
%>
</script>
<table <%=sTableStyle%>>
	<tr>
		<td valign='top' colspan=2 class='tabhead' <%=sTabHeadStyle%>><%=sTabHeadText%></td>
	</tr>
	<tr>
		<td valign='top' align='left' id="<%=sTabID%>" class="tabtd"></td>
		<td valign='top' class="tabbar"><%=sTopRight%></td>
	</tr>
	<tr>
		<td class='tabcontent' align='center' valign='top' colspan=2>
			<table cellspacing=0 cellpadding=4 border=0	width='100%' height='100%'>
				<tr> 
					<td valign="top">
					<iframe name="<%=sIframeName%>" src="<%=sDefaultPage%>" <%=sIframeStyle%>></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	function hc_drawTabToTable(tabViewId, tabStrip,selectedStrip,sObject){
		sObject.innerHTML="";
		var sInnerHTML = "<table id='"+tabViewId+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom'><tr>"+"\r";
		var rowspan="3";
		for(var i=0; i<tabStrip.length; i++){
			var a1="";
			var a2="";
			if(i==(selectedStrip-1)){
				a2="on";
			}else{
				a2="off";
			}
			if(i==(selectedStrip)){
				a1="on";
			}else{
				a1="off";
			}
			if(i==0){
				a1="fr";
				rowspan="2";
			}
			
			sInnerHTML += "<td rowspan="+rowspan+"><img class='tab"+a1+a2+"' src='"+sResourcesPath+"/1x1.gif'></td>"+"\r";
			sInnerHTML += "<td class='tabline'><img src='"+sResourcesPath+"/1x1.gif'></td>"+"\r";
			
			if(i==(tabStrip.length-1)){
				sInnerHTML += "<td rowspan=2 ><img class='tab"+a2+"bk' src='"+sResourcesPath+"/1x1.gif'></td>"+"\r";
			}
		}
		sInnerHTML += "</tr><tr>"+"\r";
		
		for(var i=0; i<tabStrip.length; i++){
			var selected="";
			if(i==(selectedStrip-1)){
				selected="sel";
			}else{
				selected="desel";
			}
			sInnerHTML += "<td  class='tab"+selected+"' nowrap>"+
					"<span class='tabtext' onclick=\"doTabAction(this,"+i+");\">"+tabStrip[i][1]+"</span></td>"+"\r";
		}
	
		sInnerHTML += "</tr><tr>"+"\r";
		
		for(var i=0; i<tabStrip.length; i++){
			if(i==0 || i==(tabStrip.length-1)){
				if(i==(selectedStrip-1)){
					sInnerHTML += "<td class='tabline1'><img src='"+sResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML += "<td class='tabline'><img src='"+sResourcesPath+"/1x1.gif'></td>"+"\r";
				}
			}
			if(i==(selectedStrip-1)){
				sInnerHTML += "<td class='tabline1'><img src='"+sResourcesPath+"/1x1.gif'></td>"+"\r";
			}else{
				sInnerHTML += "<td class='tabline'><img src='"+sResourcesPath+"/1x1.gif'></td>"+"\r";
			}
		}
		sInnerHTML +="</tr></table>"+"\r";
		sObject.innerHTML = sInnerHTML;
	}
	
	function doTabAction(obj,i){
		$(".tabsel").removeClass().addClass("tabdesel");
		$(obj).parent().removeClass().addClass("tabsel");
		AsControl.OpenView(tabstrip[i][2],tabstrip[i][3],'<%=sIframeName%>','');
	}
	hc_drawTabToTable("<%=sTabViewId%>",tabstrip,<%=defaultTab%>, document.getElementById('<%=sTabID%>'));
	$(".tabsel span").click();
</script>