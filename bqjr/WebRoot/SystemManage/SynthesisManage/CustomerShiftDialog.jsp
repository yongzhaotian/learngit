<%/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
			 * This software is the proprietary information of Amarsoft, Inc.
			 * Use is subject to license terms.
			 * Author: zywei 2006-10-25
			 * Tester:
			 *
			 * Content: ��ȡ�ͻ�ת�Ƹ�����Ϣ����
			 * Input Param:
			 *      	
			 * Output param:
			 *			
			 * History Log:wqchen 2010-03-24  ��ȡ�����ļ�����ApproveNeed���ж��Ƿ���ʾ�ͻ���Ϣת�Ƹ�����Ϣ�е������������
			 *
			 */%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>

</head>

<%
	//�������ļ��л�ȡ����ApproveNeed��ֵ
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
							<td align="center">ѡ��</td>
							<td align="left">����������</td>					
						</tr>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox1" checked value="true" class=changeColor onClick="javascript:setChecked1(this.checked)"></td>
							<td align="left" id="TDName1" class=changeColor onClick="javascript:setColor(1)"> �ͻ���Ϣ </td>	
						</tr>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox2" checked value="true" class=changeColor onClick="javascript:setChecked2(this.checked)"></td>
							<td align="left" id="TDName2" class=changeColor onClick="javascript:setColor(1)"> ������Ϣ </td>	
						</tr>

						<%if("true".equalsIgnoreCase(sApproveNeed)){ %>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox3" checked value="true" class=changeColor onClick="javascript:setChecked3(this.checked)"></td>
							<td align="left" id="TDName3" class=changeColor onClick="javascript:setColor(1)"> �������������Ϣ </td>	
						</tr>
						<%} %>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox4" checked value="true" class=changeColor onClick="javascript:setChecked4(this.checked)"></td>
							<td align="left" id="TDName4" class=changeColor onClick="javascript:setColor(1)"> ��ͬ��Ϣ </td>	
						</tr>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox5" checked value="true" class=changeColor onClick="javascript:setChecked5(this.checked)"></td>
							<td align="left" id="TDName5" class=changeColor onClick="javascript:setColor(1)"> ������Ϣ </td>	
						</tr>
						<tr align="center">
							<td align="center"><input type=checkbox name ="chkbox6"  checked value="true" class=changeColor onClick="javascript:setChecked6(this.checked)"></td>
							<td align="left" id="TDName6" class=changeColor onClick="javascript:setColor(1)"> �����Ϣ </td>	
						</tr>	
						<tr align="center">      		
				      		<td align="center" colspan=2> 
				        		<input type="button" name="Confirm" value="ȷ��" onClick="javascript:my_Confirm()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
				        		<input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
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
	
	//���ÿͻ���Ϣѡ��������
	function setChecked1(check)
	{
		if(check)
			Condition.chkbox1.value = "true";
		else
			Condition.chkbox1.value = "false";
	}
	
	//����������Ϣѡ��������
	function setChecked2(check)
	{
		if(check)
			Condition.chkbox2.value = "true";
		else
			Condition.chkbox2.value = "false";
	}
	
	//�����������������Ϣѡ��������
	function setChecked3(check)
	{
		if(check)
			Condition.chkbox3.value = "true";
		else
			Condition.chkbox3.value = "false";
	}
	
	//���ú�ͬ��Ϣѡ��������
	function setChecked4(check)
	{
		if(check)
			Condition.chkbox4.value = "true";
		else
			Condition.chkbox4.value = "false";
	}
	
	//���ó�����Ϣѡ��������
	function setChecked5(check)
	{
		if(check)
			Condition.chkbox5.value = "true";
		else
			Condition.chkbox5.value = "false";
	}
	
	//���ý����Ϣѡ��������
	function setChecked6(check)
	{
		if(check)
			Condition.chkbox6.value = "true";
		else
			Condition.chkbox6.value = "false";
	}
	

	//�ж��Ƿ���ѡ�еļ�¼
	function isSelected()
	{
  		var iCondition = document.forms["Condition"];		
		//ѭ���ж�checkboxÿ��Ԫ��element��checked�����Ƿ�Ϊ��,
		//�Դ����ж��Ƿ��и�ѡ��ѡ�У�
		for (i=0;i<iCondition.elements.length;i++)
		{
			if (iCondition.elements[i].checked)
				return true;
		}
		return false;
	}

	//���׷���
	function my_Confirm()
	{
       	var sReturnValue = "";
       	if(!isSelected()) 
       	{
       		alert(getHtmlMessage('66'));//������ѡ��һ�
       		return;
       	}
       	//����ͻ���Ϣѡ�У��򷵻�Customer�����򷵻�None
       	if(Condition.chkbox1.value == "true")
       		sReturnValue = sReturnValue + "Customer|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//����ͻ���Ϣѡ�У��򷵻�Customer�����򷵻�None
       	if(Condition.chkbox2.value == "true")
       		sReturnValue = sReturnValue + "Apply|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//����������������Ϣѡ�У��򷵻�Customer�����򷵻�None
       	if(Condition.chkbox3.value == "true")
       		sReturnValue = sReturnValue + "Approve|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//�����ͬ��Ϣѡ�У��򷵻�Customer�����򷵻�None
       	if(Condition.chkbox4.value == "true")
       		sReturnValue = sReturnValue + "Contract|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//���������Ϣѡ�У��򷵻�Customer�����򷵻�None
       	if(Condition.chkbox5.value == "true")
       		sReturnValue = sReturnValue + "PutOut|";
       	else
       		sReturnValue = sReturnValue + "None|";
       	
       	//��������Ϣѡ�У��򷵻�Customer�����򷵻�None
       	if(Condition.chkbox6.value == "true")
       		sReturnValue = sReturnValue + "DueBill|";
       	else
       		sReturnValue = sReturnValue + "None|";
       		
       	self.returnValue = sReturnValue;
		self.close();
	}
	
</script>

<%@ include file="/IncludeEnd.jsp"%>