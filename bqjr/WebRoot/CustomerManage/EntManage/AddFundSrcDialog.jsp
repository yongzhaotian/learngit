<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwliu  2004.12.2
		Tester:
		Content: �ͻ�������
		Input Param:			              
		Output param:
			FundSource:�ʽ���Դ��ʽ
		History Log: 
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>��ѡ���ʽ���Դ��ʽ</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=���庯��;]~*/%>
<script type="text/javascript">

	function newFundSource()
	{
		var sFundSource = document.getElementById("FundSource").value;
		//���ͻ������Ƿ�ѡ��
		if (sFundSource == '')
		{
			alert("�ʽ���Դ��ʽδѡ��");
			return;
		}
		
		//���ر������ʽ���Դ��ʽ
		self.returnValue=sFundSource;
		self.close();
	}
	

</script>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=true;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
  <table align="center" width="250" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >ѡ���ʽ���Դ��ʽ��</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select id="FundSource">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CapitalsourceStyle' and IsInUse = '1' ",1,2,"")%> 
        </select>
      </td>
    </tr>
   	<tr>
      <td nowarp bgcolor="#DCDCDC" height="30" colspan=2 align=center> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newFundSource()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE; border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>    
  </table>
</body>
<%/*~END~*/%>

</html>
<%@ include file="/IncludeEnd.jsp"%>