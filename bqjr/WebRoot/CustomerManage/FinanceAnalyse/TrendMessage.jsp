<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  
		Tester:	
		Content: 客户财务报表分析
		Input Param:
	                 CustomerID：客户号
	
		Output param:        
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	新版本的改写
			
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "趋势分析"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
   //定义变量
   
   //获得页面参数
	String sCustomerID = DataConvert.toRealString((String)CurPage.getParameter("CustomerID"));
	//获得组件参数
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=主页面编写;]~*/%>

<html>
<head> 
<title>趋势分析条件</title>
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
		基期报表截至日期
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
		二期报表截至日期
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
		三期报表截至日期
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
		近期报表截至日期
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
		分析方式
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
      <input type="button" style="width:50px"  name="ok" value="确认" onclick="javascipt:newReport()">
      &nbsp;&nbsp; 
      <input type="button" style="width:50px"  name="Cancel" value="取消" onclick="javascript:self.returnValue='_none_';self.close()">
    </td>
  </tr>
</table>
</body>
</html>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List04;Describe=自定义函数;]~*/%>
<script>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=确定;InputParam=无;OutPutParam=无;]~*/		
	function newReport()
	{
		var v1  = document.forms["SelectReport"].AccountMonth1.value;
		if(typeof(v1)=="undefined" || v1.length==0)
		{
			alert(getBusinessMessage('178'));//请选择基期截至日期！
			return;
		}
		var v2  = document.forms["SelectReport"].AccountMonth2.value;
		if(typeof(v2)=="undefined" || v2.length==0)
		{
			alert(getBusinessMessage('179'));//请选择二期截至日期！
			return;
		}
		var v3  = document.forms["SelectReport"].AccountMonth3.value;
		if(typeof(v3)=="undefined" || v3.length==0)
		{
			alert(getBusinessMessage('180'));//请选择三期截至日期！
			return;
		}
		var v4  = document.forms["SelectReport"].AccountMonth4.value;
		if(typeof(v4)=="undefined" || v4.length==0)
		{
			alert(getBusinessMessage('181'));//请选择近期截至日期！
			return;
		}
		
		self.returnValue = v1 + v2 + v3 + v4 + "&AnalyseType=" + document.forms["SelectReport"].AnalyseType.value;
		self.close();
	}
	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
