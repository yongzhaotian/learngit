<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ndeng  2005.05.23
		Tester:
		Content: 最终审批意见查询页面
		Input Param:

		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>请输入查询信息</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量

	
	//获得组件参数	

	//获得页面参数	

	%>
<%/*~END~*/%>


<script type="text/javascript">

	function newCustomer()
	{
		var sApproveType = document.all("ApproveType").value;
		var sApplyTime = document.all("ApplyTime").value;
		var sApplyTime2 = document.all("ApplyTime2").value;
		var sApproveTime = document.all("ApproveTime").value;
		var sApproveTime2 = document.all("ApproveTime2").value;
		var sCustomerID = document.all("CustomerID").value;
		var sCustomerName = document.all("CustomerName").value;
		var sType = document.all("Type").value;
		var sCurrency = document.all("Currency").value;
		var sSum = document.all("Sum").value;
		var sSum2 = document.all("Sum2").value;
		var sApplySerialNo = document.all("ApplySerialNo").value;
		var sApproveSerialNo = document.all("ApproveSerialNo").value;
		var sIsFirst = document.all("IsFirst").value;
		
		if(sApproveType =="" && sApplyTime =="" && sApplyTime2 =="" && sApproveTime == "" && sApproveTime2 == "" && sCustomerID == "" && sCustomerName =="" && sType =="" && sCurrency == "" && sSum == "" && sSum2 == "" && sApplySerialNo =="" && sApproveSerialNo =="" && sIsFirst =="")
		    return;
		if(sSum != "")
		{
		    if(checkSum(sSum))
		    {
    		    alert("金额应该输入数字！");
    		    return;
		    } 
		}
		if(sSum2 != "")
		{
		    if(checkSum(sSum2))
		    {
    		    alert("金额应该输入数字！");
    		    return;
		    } 
		}
		if(sApplyTime != "")
		{
		      if(!isdate_YYYYMMDD(sApplyTime))
		      {
		          alert("审查日期格式输入不正确，请按YYYY/MM/DD的格式输入！");
		          return;
		      }  
		}
		if(sApplyTime2 != "")
		{
		      if(!isdate_YYYYMMDD(sApplyTime2))
		      {
		          alert("审查日期格式输入不正确，请按YYYY/MM/DD的格式输入！");
		          return;
		      }  
		}
		if(sApproveTime != "")
		{
		      if(!isdate_YYYYMMDD(sApproveTime))
		      {
		          alert("审批日期格式输入不正确，请按YYYY/MM/DD的格式输入！");
		          return;
		      }  
		}
		if(sApproveTime2 != "")
		{
		      if(!isdate_YYYYMMDD(sApproveTime2))
		      {
		          alert("审批日期格式输入不正确，请按YYYY/MM/DD的格式输入！");
		          return;
		      }  
		}
		self.returnValue=sApproveType+"@"+sApplyTime+"@"+sApplyTime2+"@"+sApproveTime+"@"+sApproveTime2+"@"+sCustomerID+"@"+sCustomerName+"@"+sType+"@"+sCurrency+"@"+sSum+"@"+sSum2+"@"+sApplySerialNo+"@"+sApproveSerialNo+"@"+sIsFirst;
		self.close();
	}
	//效验金额是否是数字 返回true－传入参数包含字符
	function checkSum(sSum)
	{
		var bhavechar = false;	//输入字段是否包含字符
		for(var i=0;i<=sSum.length-1;i++)
		{
			s_tmp = sSum.substring(i,i+1);
			if(s_tmp>"9" || s_tmp<"0")
			{
				bhavechar=true;		//包含字符		
			}
		}
		return 	bhavechar;	
	}
    function isdate_YYYYMMDD(strDate){
	   var intYear;
	   var intMonth;
	   var intDay;
	  
	   if(strDate.length!=10) return false;
	   if(strDate.charAt(4) != '/' || strDate.charAt(7) != '/') return false;
	   intYear = strDate.substring(0,4);
	   intMonth = strDate.substring(5,7);
	   intDay = strDate.substring(8,10);	   
	   if(isNaN(intYear)||isNaN(intMonth)||isNaN(intDay)) return false;
	   	   
	   if(intYear>9999||intYear<0) return false;
	   
	   if(intMonth>11||intMonth<0) return false;
	   
	   if (intDay>30||intDay<0) return false;
	   
	   return true;
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="350" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >最终审批意见类型：</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="ApproveType">	   
			<option value=''></option>
			<option value='1'>同意最终审批意见</option> 
			<option value='2'>否决最终审批意见</option>   
        </select>
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >审查时间(YYYY/MM/DD)：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="ApplyTime" value="" style='width:80px'> 到 <input type='text' name="ApplyTime2" value="" style='width:80px'>
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >审批时间(YYYY/MM/DD)：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="ApproveTime" value="" style='width:80px'> 到 <input type='text' name="ApproveTime2" value="" style='width:80px'>
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >客户号：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CustomerID" value="" >
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >客户名称：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CustomerName" value="" style='width:200px'>
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >业务品种：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="Type" value="">
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >币种：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <select name="Currency">	
            <option value=''></option>   
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'Currency'",1,2,"")%>
        </select>
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >金额(元)：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="Sum" value="" style='width:80px'> 到 <input type='text' name="Sum2" value="" style='width:80px'>
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >申请流水号：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="ApplySerialNo" value="">
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >最终审批意见流水号：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="ApproveSerialNo" value="">
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >是否首笔：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <select name="IsFirst">	
            <option value=''></option>
            <%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesOrNo'",1,2,"")%>
        </select>
      </td>
   </tr>
   <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:newCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
   </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>