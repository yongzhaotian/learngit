<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006.8.9
		Tester:
		Content:  新增成员对话框
		Input Param:			              
		Output param:
			RelativeID：关联客户编号
			RelativeType：关联类型
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>新增成员</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义函数;]~*/%>
<script type="text/javascript">
	//选择关联客户
	function SelectCustomer()
	{
		sCustomerInfo = setObjectValue("SelectInvest","","",0,0,"");
		if(typeof(sCustomerInfo) != "undefined" && sCustomerInfo != "") 
		{
			sCustomerInfo = sCustomerInfo.split("@");
			buff.CustomerID.value = sCustomerInfo[0];
			buff.CustomerName.value = sCustomerInfo[1];
		}
	}
	
	//确认按钮
	function confirmInfo()
	{
		var sCustomerID = buff.CustomerID.value;
		var sCustomerName = buff.CustomerName.value;
		var sRelativeType = buff.RelativeType.value;
		//检查客户名称是否选择
		if (sCustomerName == '')
		{
			alert("请选择客户！");
			return;
		}
		
		//返回变量：关联客户编号和关联类型
		self.returnValue=sCustomerID+"@"+sRelativeType;
		self.close();
	}
	

</script>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=true;CodeAreaID=Main04;Describe=主体页面;]~*/%>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
<form name="buff">
  <table align="center"  border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >客户名称：</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <input name="CustomerName" value="" readonly  style="background-color:#D8D8D8">
        <input type="hidden" name="CustomerID" value="" readonly style="background-color:#D8D8D8" readonly>
        <input type="button"  class="inputDate" value=".." name="button" onClick="SelectCustomer()">
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >关联关系：</td>
      <td nowarp bgcolor="#F0F1DE" >        
        <select name="RelativeType">	   
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelativeType' and IsInUse = '1' ",1,2,"")%> 
        </select>               
      </td>
    </tr>
   	<tr>
      <td nowarp bgcolor="#F0F1DE" height="30" colspan=2 align=center> 
        <input type="button" name="next" value="确认" onClick="javascript:confirmInfo()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>    
  </table>
</form>
</body>
<%/*~END~*/%>

</html>
<%@ include file="/IncludeEnd.jsp"%>