<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwliu  2004.12.2
		Tester:
		Content: 客户主界面
		Input Param:			              
		Output param:
			FundSource:资金来源方式
		History Log: 
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>请选择资金来源方式</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义函数;]~*/%>
<script type="text/javascript">

	function newFundSource()
	{
		var sFundSource = document.getElementById("FundSource").value;
		//检查客户类型是否选择
		if (sFundSource == '')
		{
			alert("资金来源方式未选择！");
			return;
		}
		
		//返回变量：资金来源方式
		self.returnValue=sFundSource;
		self.close();
	}
	

</script>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=true;CodeAreaID=Main04;Describe=主体页面;]~*/%>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
  <table align="center" width="250" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择资金来源方式：</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select id="FundSource">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CapitalsourceStyle' and IsInUse = '1' ",1,2,"")%> 
        </select>
      </td>
    </tr>
   	<tr>
      <td nowarp bgcolor="#DCDCDC" height="30" colspan=2 align=center> 
        <input type="button" name="next" value="确认" onClick="javascript:newFundSource()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE; border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>    
  </table>
</body>
<%/*~END~*/%>

</html>
<%@ include file="/IncludeEnd.jsp"%>