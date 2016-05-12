<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jgao1
		Tester:
		Content: 客户信息引入页面
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>请输入客户信息</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量

	//获得组件参数	

	//获得页面参数
	%>
<%/*~END~*/%>


<script type="text/javascript">

	function importCustomer()
	{
		var sCustomerName = document.all("CustomerName").value;
		var sCertType = document.all("CertType").value;
		var sCertID = document.all("CertID").value;
		
		//检查证件类型是否选择
		if (sCertType == '')
		{
			alert(getBusinessMessage('148'));//请选择证件类型！
			document.all("CertType").focus();
			return;
		}
		//检查证件号码是否输入
		if (sCertID == '')
		{
			alert(getBusinessMessage('149'));//证件号码未输入！
			document.all("CertID").focus();
			return;
		}		
		//判断组织机构代码合法性
		if(sCertType =='Ent01')
		{			
			if(!CheckORG(sCertID))
			{
				alert(getBusinessMessage('102'));//组织机构代码有误！
				document.all("CertID").focus();
				return;
			}			
		}		
		//检查客户名称是否输入
		if (sCustomerName == '')
		{
			alert(getBusinessMessage('104'));//客户名称不能为空！
			document.all("CustomerName").focus();
			return;
		}
		
		//返回变量：细化的客户类型、客户名称、客户证件类型、证件号
		self.returnValue=sCustomerName+"@"+sCertType+"@"+sCertID;
		self.close();
	}
	

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
     <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择证件类型&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select name="CertType"">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and SortNo like 'Ent%' order by SortNo ",1,2,"")%> 
        </select>
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >证件号码&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="CertID" value="">
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC"  >客户名称&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC"> 
        <input type='text' name="CustomerName" value="" style="width:200px;">
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:importCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>