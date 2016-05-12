<%@ page language="java" import="com.amarsoft.awe.dw.ui.util.Const,java.util.*,com.amarsoft.are.jbo.*,com.amarsoft.awe.dw.ui.util.Request" pageEncoding="GBK"%>
<%
String sTableId = Request.GBKSingleRequest("tableId",request);
String sTableIndex = "0";
if(sTableId.length()>8)
	sTableIndex = sTableId.substring(8);
String sTableRow = Request.GBKSingleRequest("tableRow",request);
String sTableCol = Request.GBKSingleRequest("tableCol",request);
String sDZCol = Request.GBKSingleRequest("dzCol",request);
System.out.println("sTableIndex = " + sTableIndex);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
<title>修改</title>
<script>
var iDZColIndex = <%=sDZCol%>;
var sColName = window.dialogArguments.DZ[<%=sTableIndex%>][1][iDZColIndex][15];

function initValue(){
	var sValue = window.dialogArguments.tableDatas["<%=sTableId%>"][<%=sTableRow %>][<%=sTableCol%>];
	document.getElementById("detail").value = sValue;
}
function return_value(){
	window.dialogArguments.setItemValue(<%=sTableIndex%>,<%=sTableRow%>,sColName,document.getElementById('detail').value);
	//alert(<%=sTableIndex%> + "|" + <%=sTableRow%> + "|" + sColName + "|" + document.getElementById('detail').value);
	window.close();
}
</script>
</head>
<body onload="initValue()">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="90%" align="center">
	<textarea id="detail" style="width:100%;height:100%">test</textarea>
	</td>
  </tr>
  <tr>
    <td height="10%" align="center">
		<input type="button" name="ok" id="ok" value="确定" onclick="return_value()">&nbsp;
		<input type="button" name="cancel" id="cancel" value="取消" onclick="window.close()">
	</td>
  </tr>
</table>
</body>
</html>