<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: ��ʾ�ͻ���ص��ֽ���Ԥ��
		Input Param:
	           
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    �µİ汾�ĸ�д
	 */
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ֽ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	int i0;
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=��ҳ���д;]~*/%>

<html>
<head>
<title>�����ֽ���Ԥ���¼</title>
<script type="text/javascript">

	function checkTerm()
	{
		var vYear,vCount,vReportScope;
		
		vYear = document.forms["RecordTerm"].BaseYear.value;
		vCount = document.forms["RecordTerm"].YearCount.value;
		
		for(var i=0; i<document.forms["RecordTerm"].ReportScope.length;i++ )
		{
			if (document.forms["RecordTerm"].ReportScope[i].checked)
			{
				vReportScope = document.forms["RecordTerm"].ReportScope[i].value;
				break;
			}
		}

		if(vYear == "")
		{
			alert(getBusinessMessage('182'));//��ѡ���׼��ݣ�
			return;
		}

		if(vCount == "")
		{
			alert(getBusinessMessage('183'));//��ѡ��Ԥ��������
			return;
		}

		self.returnValue = "BaseYear=" + vYear + "&YearCount=" + vCount + "&ReportScope=" + vReportScope;
		self.close();
	}
	
	function myCancel()
	{
		self.returnValue='_none_';
		self.close()	
	}

</script>

</head>
<body bgcolor="#DCDCDC">
<table width="70%" align="center" height="80%">
	<tr><td heignt="20">&nbsp;</td></tr>
  <tr align="center">
    <td width="3%">&nbsp;</td>
    <td width="97%">
      <form name="RecordTerm">
			<table >
				<tr>
					<td>
						��׼��ݣ�
					</td>
					<td>
				  		<select name="BaseYear">
				        <%
							java.util.Date today = new java.util.Date();
							int sYear = today.getYear() + 1900 - 1;
							for(i0=0;i0<5;i0++)
							{
						 %>
				            <option value='<%=sYear%>'><%=sYear--%></option>
						 <%
							}
						 %>
				          </select>	
				          ��				
					</td>
				</tr>
				<!--
				<tr>
					<td>
						Ԥ��������
					</td>
					<td>
				        <select name="YearCount">
				        <%
				        	for(i0=1;i0<=20;i0++)
				        	{
				        %>
				        		<option value='<%=i0%>'><%=i0%></option>
				        <%
				        	}
				        %>
				        </select>					
					</td>
				</tr>
				-->
				<tr>
					<td>
						����ھ���
					</td>
					<td>
						<input type=hidden name="YearCount" value=1>
						<input type='radio' name='ReportScope' value="01" checked  >�ϲ�</input>	<br>				
						<input type='radio' name='ReportScope' value="03" 		   >����</input>	<br>				
						<input type='radio' name='ReportScope' value="02" 		   >������ĸ��˾��</input>					
					</td>
				</tr>	
			</table>

      </form>
    </td>
  </tr>
  <tr align="center">
    <td height="26" width="3%">&nbsp;</td>
    <td height="26" width="97%">&nbsp;
      <input type="button" style="width:50px"  name="ok" value="��һ��" onclick="javascipt:checkTerm()">
      &nbsp;&nbsp;
      <input type="button" style="width:50px"  name="Cancel" value="ȡ��" onclick="javascript:myCancel()">
    </td>
  </tr>
</table>
</body>
</html>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
