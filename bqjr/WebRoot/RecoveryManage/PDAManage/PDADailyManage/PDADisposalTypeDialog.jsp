<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: FSGong 2004.12.08
 * Tester:
 *
 * Content:      ѡ���ծ�ʲ����÷�ʽ
 * Input Param:
 *			    
 * Output param:
 *	DispositionType���ʲ����÷�ʽ
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>ѡ���ծ�ʲ����÷�ʽ</title>
<%
	String sDispositionType="";
%>
<script type="text/javascript">

	function Get_DispositionType()
	{
		var sDispositionType ;
		
		
		sDispositionType = document.all("DispositionType").value;
		
		if(sDispositionType=="")
		{
			alert(getBusinessMessage(158));//ѡ���ծ�ʲ����÷�ʽ��
			return;
		}
		
		self.returnValue=sDispositionType;
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
  <table align="center" width="240" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr id="ListTitle" class="ListTitle">
	    <td>
	    </td>
    </tr>
	<tr> 
	<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >ѡ���ծ�ʲ����÷�ʽ��</td>
	<td nowarp bgcolor="#F0F1DE" > 
		<select name="DispositionType" >
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'DispositionType' and ItemNo<>'01' ",1,2,"")%> 
		</select>
	</td>
	</tr>
    </table>
  <table align="center" width="240" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr>
	<td> </td>
	</tr>
    <tr>
     <td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("ȷ��","","javascript:Get_DispositionType()",sResourcesPath)%></td>
     <td nowrap bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("ȡ��","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>