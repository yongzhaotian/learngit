<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XWu 2004.12.04
 * Tester:
 *
 * Content:      选择不良资产移交类型
 * Input Param:
 *			    
 * Output param:
 *	ShiftType： 移交类型
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>选择不良资产移交类型</title>
<%
	String sShiftType="";
%>
<script type="text/javascript">

	function newShiftType()
	{
		var sShiftType ;
		
		sShiftType = document.all("ShiftType").value;
		self.returnValue=sShiftType;//返回参数
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
	<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >选择不良资产移交类型</td>
	<td nowarp bgcolor="#F0F1DE" > 
		<select name="ShiftType" >
			<%=HTMLControls.generateDropDownSelect(Sqlca,"Select ItemNo,ItemName From CODE_LIBRARY Where CodeNo = 'ShiftType'",1,2,"")%>
		</select>
	</td>
	</tr>
    </table>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr>
     <td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("确认","","javascript:newShiftType()",sResourcesPath)%></td>
     <td nowrap bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>