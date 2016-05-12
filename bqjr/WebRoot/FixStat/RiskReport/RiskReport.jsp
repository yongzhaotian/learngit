<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 风险报告
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险报告"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<html>
<head>
<title></title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div id="CoverTipDiv" style="position:absolute; left:1px; top:1px; width:100%; height:35px; z-index:2; display:none"> 
 <table width="100%" height="100%" align=center border="0" cellspacing="0" cellpadding="1" bgcolor="#333333">
    <tr> 
      <td>
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
		<tr> 
		  <td width=1><img class=clockimg src=<%=sResourcesPath%>/1x1.gif width="1" height="1"></td>
		  <td id="CoverTipTD" style="background-color: #FFFFFF;"></td>
		</tr>
		</table>
	</td>
	</tr>
</table>
</div>
<table border="0" width="100%" cellspacing="0" cellpadding="4">
	<tr>
	    <td>
		内部信用评级
	    </td>
	    <td>
		<input type=text name=CreditRating1>
	    </td>
	    <td>
		<input type=button value="测算">
	    </td>
	    <td>
		违约概率 (PD)
	    </td>
	    <td>
		<input type=text name=PD>
	    </td>
	    <td>
		<input type=button value="测算">
	    </td>
	</tr>
	<tr>
	    <td colspan=6 height=1 bgcolor=#FFFFFF>
	    </td>
	</tr>
	<tr>
	    <td>
		给定违约损失率 (LGD)
	    </td>
	    <td>
		<input type=text name=LGD>
	    </td>
	    <td>
		<input type=button value="测算">
	    </td>
	    <td>
		违约风险敞口
	    </td>
	    <td>
		<input type=text name=EAD>
	    </td>
	    <td>
		<input type=button value="测算">
	    </td>
	</tr>
	<tr>
	    <td colspan=6 height=1 bgcolor=#FFFFFF>
	    </td>
	</tr>
	<tr>
	    <td>
		期限
	    </td>
	    <td>
		<input type=text name=TERM>
	    </td>
	    <td>
	    </td>
	    <td>
		预期损失 (EL)
	    </td>
	    <td>
		<input type=text name=EL>
	    </td>
	    <td>
		<input type=button value="测算">
	    </td>
	</tr>
	<tr>
	    <td colspan=6 height=1 bgcolor=#FFFFFF>
	    </td>
	</tr>
</table>
</body>
</html>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function showCoverTip(sTipText){
		oDiv = document.getElementById("CoverTipDiv");
		oTD = document.getElementById("CoverTipTD");
		oDiv.style.display="";
		oTD.innerHTML=sTipText;
	}
	function hideCoverTip(){
		oDiv = document.getElementById("CoverTipDiv");
		oTD = document.getElementById("CoverTipTD");
		oDiv.style.display="none";
		oTD.innerHTML="";
	}

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
