<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<html>
<head> 
<title>�������µ������ź�����</title>

<style>
.black9pt {font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#FFF0E8">
<br>
  <table align="center"  border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
     <tr>
	  	<td nowarp align="left" class="black9pt" bgcolor="#FFF0E8" ></font>��������<font color="#ff0000">&nbsp;*</font></td>
	  	<td nowarp bgcolor="#FFF0E8">
	  		<input id="TermID" type="text" name="TermID" value="" style="width:60px">
	  	</td>
    </tr>
    <tr>
	  	<td nowarp align="left" class="black9pt" bgcolor="#FFF0E8" ></font>���������<font color="#ff0000">&nbsp;*</font></td>
	  	<td nowarp bgcolor="#FFF0E8">
	  		<input id="TermName" type="text" name="TermName" value="" style="width:120px">
	  	</td>
    </tr>
    <tr>
     	<td nowarp bgcolor="#FFF0E8" height="25" colspan="2" align="center"> 
	        <input type="button" name="next" value="ȷ��" onClick="javascript:newCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
	        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      	</td>
    </tr>
  </table>
</body>
</html>
<script language=javascript>
	function newCustomer(){
		var termID = trim(document.getElementById("TermID").value);
		var termName = trim(document.getElementById("TermName").value);
		if(termID == ""||termName==""){
			alert("�����������ż����ƣ�");
			return;
		}
		//���ر�����
		self.returnValue = termID+"@"+termName+"@";
		self.close();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>