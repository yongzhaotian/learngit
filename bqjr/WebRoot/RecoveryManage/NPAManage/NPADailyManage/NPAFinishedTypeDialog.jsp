<%
/* Copyright 2003-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XWu 2004.11.25
 * Tester:
 *
 * Content:      ѡ���ս����ͶԻ���
 * Input Param:
 *			    
 * Output param:
 *	self.returnValue �� �ս����͡�����	
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>ѡ���ս����ͶԻ���</title>
<%
	String sFinishedType="";
%>
<script type="text/javascript">

	function newFinishedType()
	{

		sFinishedType = buff.FinishedType.value ;
		sFinishedDate = buff.FinishedDate.value ;

		if(typeof(sFinishedType) == "undefined" || sFinishedType.length == 0)
		{
			alert(getBusinessMessage("781"));//��ѡ���ս����ͣ�
			return;
		}		
		if(typeof(sFinishedDate) == "undefined" || sFinishedDate.length == 0)
		{
			alert(getBusinessMessage("782"));//��ѡ���ս����ڣ�
			return;
		}

		self.returnValue = sFinishedType+"@"+sFinishedDate;  //���ز����ս����͡�����
		self.close();
	}
	
	//ѡ���ս�����
	function openFinishedType()
	{
		sParaString = "CodeNo"+",FinishType";		
		sFinishedTypeInfo = setObjectValue("SelectCode",sParaString,"",0,0,"");
		if(typeof(sFinishedTypeInfo) != "undefined")
		{
	        sFinishedTypeInfo = sFinishedTypeInfo.split('@');			
	        buff.FinishedType.value = sFinishedTypeInfo[0];
	        buff.FinishedTypeName.value = sFinishedTypeInfo[1];
		}
	}	   

	//ѡ������
	function openFinishedDate()
	{
		sFinishedDate=PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth=20;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sFinishedDate) != "undefined")
		{
	        buff.FinishedDate.value = sFinishedDate;
		}
	}
	
</script>

<style TYPE="text/css">
.changeColor{ background-color: #F0F1DE  }
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
<form name="buff">
  <table align="center" width="160" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr id="ListTitle" class="ListTitle">
	    <td>
	    </td>
    </tr>
	<tr> 
	<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >�ս����ͣ�</td>
	<td nowarp bgcolor="#F0F1DE" > 
		<input name="FinishedTypeName" value="" readonly  style="background-color:#D8D8D8">
		<input name="FinishedType" type="hidden" value="">
        <input type=button class=inputDate  value=... name=button onClick="openFinishedType()">
	</td>
	</tr>

	<tr> 
	<td nowrap align="center" class="black9pt" bgcolor="#F0F1DE" >�ս����ڣ�</td>
	<td nowrap bgcolor="#F0F1DE" > 
          <input name="FinishedDate" value="" readonly  style="background-color:#D8D8D8">
          <input name="" type="hidden" value="">
          <input type=button class=inputDate  value=... name=button onClick="openFinishedDate()">
	</td>
	</tr> 

    </table>
  <table align="center" width="160" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr>
     <td nowrap align="right" class="black9pt" bgcolor="#F0F1DE"><%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:newFinishedType()",sResourcesPath)%></td>
     <td nowrap bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("ȡ��","ȡ��","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>