<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  
		Tester:	
		Content: �ͻ����񱨱����
		Input Param:
	                 CustomerID���ͻ���
	
		Output param:        
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	�°汾�ĸ�д
			
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ʒ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
   //�������
   
   //���ҳ�����
	String sCustomerID = DataConvert.toRealString((String)CurPage.getParameter("CustomerID"));
	//����������
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ҳ���д;]~*/%>

<html>
<head> 
<title>���Ʒ�������</title>
</head>
<body bgcolor="#FAF4DE">
<table width="75%" align="center" height="255">
	<tr>
		<td height="1">&nbsp;</td>
	</tr>
  <tr align="center">
    <td width="97%"> 
      <form name="SelectReport">
      <table>
	<tr>
	<td align="right">
		���ڱ����������
	</td>
	<td colspan="3">
		<select name="AccountMonth1">
			<option></option>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select '&AccountMonth1=' || AccountMonth || '&Scope1=' || Scope,AccountMonth || ' ' || getItemName('ReportScope',Scope) from Finance_Desc where CustomerID = '" + sCustomerID + "' order by AccountMonth",1,2,"")%>
		</select>
	</td>
	</tr>
   <tr>
     <td height="1">&nbsp;</td>
   </tr>
   <td align="right">
		���ڱ����������
	</td>
	<td colspan="3">
		<select name="AccountMonth2">
			<option></option>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select '&AccountMonth2=' || AccountMonth || '&Scope2=' || Scope,AccountMonth || ' ' || getItemName('ReportScope',Scope) from Finance_Desc where CustomerID = '" + sCustomerID + "' order by AccountMonth",1,2,"")%>
		</select>
	</td>
	</tr>
	<tr>
     <td height="1">&nbsp;</td>
   </tr>
   <td align="right">
		���ڱ����������
	</td>
	<td colspan="3">
		<select name="AccountMonth3">
			<option></option>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select '&AccountMonth3=' || AccountMonth || '&Scope3=' || Scope,AccountMonth || ' ' || getItemName('ReportScope',Scope) from Finance_Desc where CustomerID = '" + sCustomerID + "' order by AccountMonth",1,2,"")%>
		</select>
	</td>
	</tr>
	<tr>
     <td height="1">&nbsp;</td>
   </tr>
   <td align="right">
		���ڱ����������
	</td>
	<td colspan="3">
		<select name="AccountMonth4">
			<option></option>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select '&AccountMonth4=' || AccountMonth || '&Scope4=' || Scope,AccountMonth || ' ' || getItemName('ReportScope',Scope) from Finance_Desc where CustomerID = '" + sCustomerID + "' order by AccountMonth",1,2,"")%>
		</select>
	</td>
	</tr>
	<tr>
     <td height="1">&nbsp;</td>
   </tr>
   <td align="right">
		������ʽ
	</td>
	<td colspan="3">
		<select name="AnalyseType">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"FinanceTrendAnalyse","")%>
		</select>
	</td>
	</tr>
	</table>
      </form>
    </td>
  </tr>
  <tr align="center">
    <td width="97%">&nbsp; 
      <input type="button" style="width:50px"  name="ok" value="ȷ��" onclick="javascipt:newReport()">
      &nbsp;&nbsp; 
      <input type="button" style="width:50px"  name="Cancel" value="ȡ��" onclick="javascript:self.returnValue='_none_';self.close()">
    </td>
  </tr>
</table>
</body>
</html>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List04;Describe=�Զ��庯��;]~*/%>
<script>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=��;]~*/		
	function newReport()
	{
		var v1  = document.forms["SelectReport"].AccountMonth1.value;
		if(typeof(v1)=="undefined" || v1.length==0)
		{
			alert(getBusinessMessage('178'));//��ѡ����ڽ������ڣ�
			return;
		}
		var v2  = document.forms["SelectReport"].AccountMonth2.value;
		if(typeof(v2)=="undefined" || v2.length==0)
		{
			alert(getBusinessMessage('179'));//��ѡ����ڽ������ڣ�
			return;
		}
		var v3  = document.forms["SelectReport"].AccountMonth3.value;
		if(typeof(v3)=="undefined" || v3.length==0)
		{
			alert(getBusinessMessage('180'));//��ѡ�����ڽ������ڣ�
			return;
		}
		var v4  = document.forms["SelectReport"].AccountMonth4.value;
		if(typeof(v4)=="undefined" || v4.length==0)
		{
			alert(getBusinessMessage('181'));//��ѡ����ڽ������ڣ�
			return;
		}
		
		self.returnValue = v1 + v2 + v3 + v4 + "&AnalyseType=" + document.forms["SelectReport"].AnalyseType.value;
		self.close();
	}
	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
