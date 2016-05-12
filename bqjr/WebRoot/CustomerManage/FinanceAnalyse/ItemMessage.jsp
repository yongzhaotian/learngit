<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  
		Tester:	
		Content:  --客户财务报表分析
		Input Param:
	                 --CustomerID：客户号
	
		Output param:        
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	新版本的改写
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "指标分析"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
   //定义变量
   
   //获得页面参数，客户代码
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
		报表截至日期
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
				alert(getBusinessMessage('177'));//请选择至少三期报表！
				return;
			}
		}
		
		self.returnValue = vReturn;
		self.close();
	}
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
