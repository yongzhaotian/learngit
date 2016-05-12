<%@ include file="/IncludeBeginMD.jsp"%>
<html>
<HEAD>
	<title></title>
	<STYLE>
		.table1 {  border: solid; border-width: 1px 1px 2px 2px; border-color: #000000 black #000000 #000000} 
		.td1 {  border-color: #000000 #000000 black black; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 10pt; color: #000000}
	</STYLE>	
	<style>
		@media print{ INPUT {display:none} }
	</style>	
</HEAD>
<body style='word-break:break-all' >
<div id=div1 style="display:block" >
<object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style="display:none" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object>
<input type=button value='打印设置' onclick="WebBrowser1.ExecWB(8,1)">
<input type=button value='打印预览' onclick="WebBrowser1.ExecWB(7,1)">
<input type=button value='打印' onclick="WebBrowser1.ExecWB(6,1)">
<!-- 
<input type=button value='另存为' onclick="WebBrowser1.ExecWB(4,1)">
<input type=button value='导出到word' onclick="ExportToWord()">
 -->
<input type=button value='关闭' onclick="WebBrowser1.ExecWB(45,1)">
<p>
</div>
<%
	String sid = CurPage.getParameter("sid");
	out.println(SpecialTools.amarsoft2Real((String)session.getAttribute(sid)));
	session.removeAttribute(sid);
%>
</body>
<script type="text/javascript">
	function ExportToWord(){
		var oWD = new ActiveXObject('word.Application'); 
		oWD.Application.Visible = true;
		var oDC =oWD.Documents.Add('',0,1); 
		var oRange =oDC.Range(0,1);
		var sel=parent.document.body.createTextRange();
		oTblExport = parent.document.getElementById('reporttable'); 
		if (oTblExport != null) {
			sel.moveToElementText(oTblExport); 
			sel.execCommand('Copy');
			parent.document.body.blur(); 
			oRange.Paste(); 
		}
	}
	
	function mykd(){
		//F3:F5,F11:FullScreen
		if(event.keyCode==114 || event.keyCode==116 || event.keyCode==122 || (event.keyCode==78 && event.ctrlKey)){
			event.keyCode=0;
			event.returnValue=false;
			return false;
		}
	}
	try {	document.body.onkeydown=mykd; } catch(e) {var a=1;}
	try {	document.onkeydown=mykd; } catch(e) {var a=1;}
	try {	/*document.oncontextmenu=Function("return false;");*/ } catch(e) {var a=1;}
</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>