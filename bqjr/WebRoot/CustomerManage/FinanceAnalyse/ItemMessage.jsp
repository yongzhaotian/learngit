<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  
		Tester:	
		Content:  --�ͻ����񱨱����
		Input Param:
	                 --CustomerID���ͻ���
	
		Output param:        
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	�°汾�ĸ�д
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ָ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
   //�������
   
   //���ҳ��������ͻ�����
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
		�����������
	</td>
	<td colspan="3">
		<select multiple name="reportList">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select AccountMonth || '@' || Scope,AccountMonth || ' ' || getItemName('ReportScope',Scope) from Finance_Desc where CustomerID = '" + sCustomerID + "' order by AccountMonth",1,2,"")%>
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
		var iLength  = document.forms["SelectReport"].reportList.length;
		var iCount = 1;
		var vTemp, vTemp1, vTemp2, vReturn = "";
		
		if(iLength < 3)
		{
			for(i=0;i<=iLength-1;i++)
			{
				vTemp = document.forms["SelectReport"].reportList.item(i).value.split("@");
				vTemp1 = vTemp[0];
				vTemp2 = vTemp[1];
				vReturn += "&AccountMonth" + iCount + "=" + vTemp1 + "&Scope" + iCount + "=" + vTemp2;
				iCount++;
				if(iCount > 3)
					break;
			}
			while(iCount <= 3)
			{
				vReturn += "&AccountMonth" + iCount + "=" + vTemp1 + "&Scope" + iCount + "=" + vTemp2;
				iCount++;
			}
		}
		else
		{
			for(i=0;i<=iLength-1;i++)
			{	
				if(document.forms["SelectReport"].reportList.item(i).selected)
				{
					vTemp = document.forms["SelectReport"].reportList.item(i).value.split("@");
					vTemp1 = vTemp[0];
					vTemp2 = vTemp[1];
					vReturn += "&AccountMonth" + iCount + "=" + vTemp1 + "&Scope" + iCount + "=" + vTemp2;
					iCount++;
				}
			}
			
			if(iCount <= 3)
			{
				alert(getBusinessMessage('177'));//��ѡ���������ڱ���
				return;
			}
		}
		
		self.returnValue = vReturn;
		self.close();
	}
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
