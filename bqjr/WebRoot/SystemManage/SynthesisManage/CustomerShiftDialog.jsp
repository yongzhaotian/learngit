<%/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
			 * This software is the proprietary information of Amarsoft, Inc.
			 * Use is subject to license terms.
			 * Author: zywei 2006-10-25
			 * Tester:
			 *
			 * Content: 获取客户转移更新信息类型
			 * Input Param:
			 *      	
			 * Output param:
			 *			
			 * History Log:wqchen 2010-03-24  获取配置文件参数ApproveNeed，判断是否显示客户信息转移更新信息中的最终审批意见
			 *
			 */%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>

</head>

<%
	//从配置文件中获取参数ApproveNeed的值
	String sApproveNeed = CurConfig.getConfigure("ApproveNeed");
%>
<body class="ListPage" leftmargin="0" topmargin="0" onload="" style="overflow: auto; overflow-y: auto;overflow-x: auto;" >
	<table align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
		    <td></td>
		</tr>
		<tr valign=top>
	    	<td>
				<form name="Condition">
					<table align="center">
				 		<tr align="center" bgcolor="#CCCCCC">
							<td align="center">选择</td>
							<td align="left">待更新内容</td>					
						</tr>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox1" checked value="true" class=changeColor onClick="javascript:setChecked1(this.checked)"></td>
							<td align="left" id="TDName1" class=changeColor onClick="javascript:setColor(1)"> 客户信息 </td>	
						</tr>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox2" checked value="true" class=changeColor onClick="javascript:setChecked2(this.checked)"></td>
							<td align="left" id="TDName2" class=changeColor onClick="javascript:setColor(1)"> 申请信息 </td>	
						</tr>

						<%if("true".equalsIgnoreCase(sApproveNeed)){ %>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox3" checked value="true" class=changeColor onClick="javascript:setChecked3(this.checked)"></td>
							<td align="left" id="TDName3" class=changeColor onClick="javascript:setColor(1)"> 最终审批意见信息 </td>	
						</tr>
						<%} %>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox4" checked value="true" class=changeColor onClick="javascript:setChecked4(this.checked)"></td>
							<td align="left" id="TDName4" class=changeColor onClick="javascript:setColor(1)"> 合同信息 </td>	
						</tr>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox5" checked value="true" class=changeColor onClick="javascript:setChecked5(this.checked)"></td>
							<td align="left" id="TDName5" class=changeColor onClick="javascript:setColor(1)"> 出帐信息 </td>	
						</tr>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox6"  checked value="true" class=changeColor onClick="javascript:setChecked6(this.checked)"></td>
							<td align="left" id="TDName6" class=changeColor onClick="javascript:setColor(1)"> 借据信息 </td>	
						</tr>	
						<tr align="center">      		
				      		<td align="center" colspan=2> 
				        		<input type="button" name="Confirm" value="确认" onClick="javascript:my_Confirm()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
				        		<input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
				      		</td>
				    	</tr>
					</table>
				</form>
    		</td>
		</tr>		
	</table>
</body>
</html>

<script type="text/javascript">
	
	//设置客户信息选择框的属性
	function setChecked1(check)
	{
		if(check)
			Condition.chkbox1.value = "true";
		else
			Condition.chkbox1.value = "false";
	}
	
	//设置申请信息选择框的属性
	function setChecked2(check)
	{
		if(check)
			Condition.chkbox2.value = "true";
		else
			Condition.chkbox2.value = "false";
	}
	
	//设置最终审批意见信息选择框的属性
	function setChecked3(check)
	{
		if(check)
			Condition.chkbox3.value = "true";
		else
			Condition.chkbox3.value = "false";
	}
	
	//设置合同信息选择框的属性
	function setChecked4(check)
	{
		if(check)
			Condition.chkbox4.value = "true";
		else
			Condition.chkbox4.value = "false";
	}
	
	//设置出帐信息选择框的属性
	function setChecked5(check)
	{
		if(check)
			Condition.chkbox5.value = "true";
		else
			Condition.chkbox5.value = "false";
	}
	
	//设置借据信息选择框的属性
	function setChecked6(check)
	{
		if(check)
			Condition.chkbox6.value = "true";
		else
			Condition.chkbox6.value = "false";
	}
	

	//判断是否有选中的记录
	function isSelected()
	{
  		var iCondition = document.forms["Condition"];		
		//循环判断checkbox每个元素element的checked属性是否为真,
		//以此来判断是否有复选框被选中；
		for (i=0;i<iCondition.elements.length;i++)
		{
			if (iCondition.elements[i].checked)
				return true;
		}
		return false;
	}

	//交易发送
	function my_Confirm()
	{
       	var sReturnValue = "";
       	if(!isSelected()) 
       	{
       		alert(getHtmlMessage('66'));//请至少选择一项！
       		return;
       	}
       	//如果客户信息选中，则返回Customer，否则返回None
       	if(Condition.chkbox1.value == "true")
       		sReturnValue = sReturnValue + "Customer|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//如果客户信息选中，则返回Customer，否则返回None
       	if(Condition.chkbox2.value == "true")
       		sReturnValue = sReturnValue + "Apply|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//如果最终审批意见信息选中，则返回Customer，否则返回None
       	if(Condition.chkbox3.value == "true")
       		sReturnValue = sReturnValue + "Approve|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//如果合同信息选中，则返回Customer，否则返回None
       	if(Condition.chkbox4.value == "true")
       		sReturnValue = sReturnValue + "Contract|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//如果出帐信息选中，则返回Customer，否则返回None
       	if(Condition.chkbox5.value == "true")
       		sReturnValue = sReturnValue + "PutOut|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//如果借据信息选中，则返回Customer，否则返回None
       	if(Condition.chkbox6.value == "true")
       		sReturnValue = sReturnValue + "DueBill|";
       	else
       		sReturnValue = sReturnValue + "None|";
       		
       	self.returnValue = sReturnValue;
		self.close();
	}
	
</script>

<%@ include file="/IncludeEnd.jsp"%>