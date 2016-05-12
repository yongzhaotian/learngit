<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: 显示客户相关的现金流预测
		Input Param:
	           
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    新的版本的改写
	 */
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户现金流测算"; // 浏览器窗口标题 <title> PG_TITLE </title>
	int i0;
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=主页面编写;]~*/%>

<html>
<head>
<title>新增现金流预测记录</title>
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
			alert(getBusinessMessage('182'));//请选择基准年份！
			return;
		}

		if(vCount == "")
		{
			alert(getBusinessMessage('183'));//请选择预测年数！
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
						基准年份：
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
				          年				
					</td>
				</tr>
				<!--
				<tr>
					<td>
						预测年数：
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
						报表口径：
					</td>
					<td>
						<input type=hidden name="YearCount" value=1>
						<input type='radio' name='ReportScope' value="01" checked  >合并</input>	<br>				
						<input type='radio' name='ReportScope' value="03" 		   >汇总</input>	<br>				
						<input type='radio' name='ReportScope' value="02" 		   >本部（母公司）</input>					
					</td>
				</tr>	
			</table>

      </form>
    </td>
  </tr>
  <tr align="center">
    <td height="26" width="3%">&nbsp;</td>
    <td height="26" width="97%">&nbsp;
      <input type="button" style="width:50px"  name="ok" value="下一步" onclick="javascipt:checkTerm()">
      &nbsp;&nbsp;
      <input type="button" style="width:50px"  name="Cancel" value="取消" onclick="javascript:myCancel()">
    </td>
  </tr>
</table>
</body>
</html>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
