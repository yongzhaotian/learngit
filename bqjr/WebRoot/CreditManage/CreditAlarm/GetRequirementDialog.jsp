<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<html>
<head>
<title>�����봦��Ҫ��</title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="4">
	<tr>
		<td class="buttonback">
		<input type=button value="ȷ��" onclick="returnText()">
		</td>
	</tr>
	
	<tr>
	    <td class="ListDWArea">
			<textarea id="MyTextArea" style={width:100%;height:100%}></textarea>
	    </td>
	</tr>
</table>
</body>
</html>
<script>
function returnText(){
	sText = document.getElementById("MyTextArea").value;
	top.returnValue=sText;
	self.close();
}
</script>
<%@ include file="/IncludeEnd.jsp"%>
