<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: slliu 2004.11.22
 * Tester:
 *
 * Content:      选择案件类型
 * Input Param:
 *			    
 * Output param:
 *	sLawCaseType：案件类型	
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>选择案件类型</title>
<%
	//案件类型
	String sLawCaseType = "";	
%>
<script type="text/javascript">

	function newLawCaseType()
	{
		var sLawCaseType;		
		//案件类型
		sLawCaseType = document.all("LawCaseType").value;	
		if(sLawCaseType == "")
		{
			alert(getBusinessMessage("780"));//请选择案件类型！
			return;
		}		
		self.returnValue=sLawCaseType;	//返回所选的案件类型
		self.close();	
	}
	
</script>

<style TYPE="text/css">
.changeColor{ background-color: #F0F1DE  }
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
<form name="buff">
<table align="center" width="250" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr id="ListTitle" class="ListTitle">
		<td>
		</td>
	</tr>
	<tr> 
		<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >选择案件类型：</td>
		<td nowarp bgcolor="#F0F1DE" > 
			<select name="LawCaseType" >
				<%=HTMLControls.generateDropDownSelect(Sqlca,"LawCaseType",sLawCaseType)%> 
			</select>
		</td>
	</tr>
	
</table>
<table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("确认","","javascript:newLawCaseType()",sResourcesPath)%></td>
		<td nowrap bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
	</tr>
</table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>