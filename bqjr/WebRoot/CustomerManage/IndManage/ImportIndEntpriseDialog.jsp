<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jgao1
		Tester:
		Content: �ͻ���Ϣ����ҳ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>������ͻ���Ϣ</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������

	//����������	

	//���ҳ�����
	%>
<%/*~END~*/%>


<script type="text/javascript">

	function importCustomer()
	{
		var sCustomerName = document.all("CustomerName").value;
		var sCertType = document.all("CertType").value;
		var sCertID = document.all("CertID").value;
		
		//���֤�������Ƿ�ѡ��
		if (sCertType == '')
		{
			alert(getBusinessMessage('148'));//��ѡ��֤�����ͣ�
			document.all("CertType").focus();
			return;
		}
		//���֤�������Ƿ�����
		if (sCertID == '')
		{
			alert(getBusinessMessage('149'));//֤������δ���룡
			document.all("CertID").focus();
			return;
		}		
		//�ж���֯��������Ϸ���
		if(sCertType =='Ent01')
		{			
			if(!CheckORG(sCertID))
			{
				alert(getBusinessMessage('102'));//��֯������������
				document.all("CertID").focus();
				return;
			}			
		}		
		//���ͻ������Ƿ�����
		if (sCustomerName == '')
		{
			alert(getBusinessMessage('104'));//�ͻ����Ʋ���Ϊ�գ�
			document.all("CustomerName").focus();
			return;
		}
		
		//���ر�����ϸ���Ŀͻ����͡��ͻ����ơ��ͻ�֤�����͡�֤����
		self.returnValue=sCustomerName+"@"+sCertType+"@"+sCertID;
		self.close();
	}
	

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
     <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >ѡ��֤������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select name="CertType"">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and SortNo like 'Ent%' order by SortNo ",1,2,"")%> 
        </select>
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >֤������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="CertID" value="">
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC"  >�ͻ�����&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="CustomerName" value="" style="width:200px;">
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:importCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>