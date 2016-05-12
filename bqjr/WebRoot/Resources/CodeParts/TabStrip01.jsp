<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Resources/1/css/strip.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Resources/1/css/tabs.css">
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Resources/1/js/plugins/tabstrip-1.0.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:auto;overflow-x:visible;overflow-y:visible;">
<div  valign=middle style="padding:0;border:0px solid #F00;position:absolute; height:100%;width: 100%; overflow:hidden" id="window1">
</div>
</body>
<script type="text/javascript">
var tabCompent = new TabStrip("T01", "µ¥¸öTabStrip×é", "<%=_sView%>", "#window1");
<%int _i = 0; for(; _i < sTabStrip.length; _i++){
	if(!"true".equals(sTabStrip[_i][0])) continue;
	out.println("tabCompent.addDataItem(\"TS"+_i+"\", \""+sTabStrip[_i][1]+"\", \""+(sTabStrip[_i].length < 3 || sTabStrip[_i][2].equals("") ? "" : sTabStrip[_i].length < 4 ? "AsControl.OpenComp('"+sTabStrip[_i][2]+"', '', 'TabContentFrame')" : "AsControl.OpenComp('"+sTabStrip[_i][2]+"', '"+sTabStrip[_i][3]+"', 'TabContentFrame')")+"\", true, false);");
}%>
tabCompent.setSelectedItem("TS0");
tabCompent.init();
function addTabStripItem(sTitle, sUrl, sParas){
	var script = !sUrl ? "" : "AsControl.OpenView('"+sUrl+"', '"+sParas+"', 'TabContentFrame')";
	tabCompent.addItem("TS"+escape(sTitle).replace(/\%/g, ""), sTitle, script, true, true, true);
}
</script>
</html>