<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.8.9
		Tester:
		Content:  ������Ա�Ի���
		Input Param:			              
		Output param:
			RelativeID�������ͻ����
			RelativeType����������
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>������Ա</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=���庯��;]~*/%>
<script type="text/javascript">
	//ѡ������ͻ�
	function SelectCustomer()
	{
		sCustomerInfo = setObjectValue("SelectInvest","","",0,0,"");
		if(typeof(sCustomerInfo) != "undefined" && sCustomerInfo != "") 
		{
			sCustomerInfo = sCustomerInfo.split("@");
			buff.CustomerID.value = sCustomerInfo[0];
			buff.CustomerName.value = sCustomerInfo[1];
		}
	}
	
	//ȷ�ϰ�ť
	function confirmInfo()
	{
		var sCustomerID = buff.CustomerID.value;
		var sCustomerName = buff.CustomerName.value;
		var sRelativeType = buff.RelativeType.value;
		//���ͻ������Ƿ�ѡ��
		if (sCustomerName == '')
		{
			alert("��ѡ��ͻ���");
			return;
		}
		
		//���ر����������ͻ���ź͹�������
		self.returnValue=sCustomerID+"@"+sRelativeType;
		self.close();
	}
	

</script>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=true;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
<form name="buff">
  <table align="center"  border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >�ͻ����ƣ�</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <input name="CustomerName" value="" readonly  style="background-color:#D8D8D8">
        <input type="hidden" name="CustomerID" value="" readonly style="background-color:#D8D8D8" readonly>
        <input type="button"  class="inputDate" value=".." name="button" onClick="SelectCustomer()">
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >������ϵ��</td>
      <td nowarp bgcolor="#F0F1DE" >        
        <select name="RelativeType">	   
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelativeType' and IsInUse = '1' ",1,2,"")%> 
        </select>               
      </td>
    </tr>
   	<tr>
      <td nowarp bgcolor="#F0F1DE" height="30" colspan=2 align=center> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:confirmInfo()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>    
  </table>
</form>
</body>
<%/*~END~*/%>

</html>
<%@ include file="/IncludeEnd.jsp"%>