<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bhxiao  2011.10.12
		Tester:
		Content: ������Ŀ��Ϣ¼�����
		Input Param:
		Output param:
		History Log: 
		 
	 */
	%>
<%/*~END~*/%>
 

<html>
<head> 
<title>�������µİ汾��</title>

<style>
.black9pt {font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#FFF0E8">
<br>
  <table align="center"  border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
     <tr>
	  	<td nowarp align="left" class="black9pt" bgcolor="#FFF0E8" ></font>�°汾��<font color="#ff0000">&nbsp;*</font></td>
	  	<td nowarp bgcolor="#FFF0E8">
	  		<input id="VersionID" type="text" name="VersionID" value="" style="width:60px">
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
		var termID = trim(document.getElementById("VersionID").value);
		if(termID == ""){
			alert("������汾�ţ�");
			return;
		}
		//���ر�����
		parent.returnValue = termID;
		parent.close();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>