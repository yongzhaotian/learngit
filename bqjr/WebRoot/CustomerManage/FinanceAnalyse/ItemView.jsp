<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  --
		Tester:	
		Content: --客户财务报表分析
		Input Param:
	                 --CustomerID：客户号
	                 --Term 参数包括以下参数内容：
	                      --ReportCount ：报表期数
	                      --AccountMonth1：报表的年月
	                      --Scope：报表范围
	                      --EntityCount：客户数
		Output param:
	                --CustomerID：客户号
	                --ReportNo:报表号
			               
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
    
    //获得页面参数,客户代码、Term变量（报表期数、报表的年月、报表范围、客户数）
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sTerm       = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Term"));
	sTerm = sTerm.replace('@','&');
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=主页面的编写;]~*/%>
<html>
<head>
	<title>指标分析</title>
</head>
<body class="ListPage" leftmargin="0" topmargin="0" style="overflow: auto;overflow-x:visible;overflow-y:visible" onload="" oncontextmenu="return false">
<table align='center' cellspacing=0 cellpadding=0 border=0 width=100% height="100%">
  <tr> 
       <td class='tabcontent' align='center' valign='top'>  
			<table cellspacing=0 cellpadding=4 border=0 width='100%' height='100%'>
				<tr> 
				<td valign="top" id="TabBodyTable" class="TabBodyTable">
					<iframe name="DeskTopInfo" src="" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 ></iframe>
				</td>
				</tr>
			</table> 
      </td>
  </tr>
</table>
</body>
</html>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List03;Describe=打开一个窗口;]~*/%>
<script type="text/javascript">
	OpenPage("/CustomerManage/FinanceAnalyse/ItemDetail.jsp?CustomerID=<%=sCustomerID%><%=sTerm%>","DeskTopInfo");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
