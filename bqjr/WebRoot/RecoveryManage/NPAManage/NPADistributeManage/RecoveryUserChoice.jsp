<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XWu 2004.12.04
 * Tester:
 *
 * Content:      ѡ�����ʲ�������
 * Input Param:
 *			    
 * Output param:
 *		RecoveryUserID�� ��ȫ��������ԱID
 *		RecoveryUserName����ȫ��������Ա����
 *		RecoveryOrgID����ȫ��������Ա��������ID
 * History Log: 
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>ѡ�����ʲ�������</title>

<script type="text/javascript">

	function newTraceUser()
	{		
		sTraceUserID = document.all("TraceUserID").value;
		sTraceOrgID = document.buff.TraceOrgID.value;
		sTraceUserName = document.all("TraceUserName").value;
		if(sTraceUserID=="")
		{
			alert(getBusinessMessage('764'));//��ѡ�����ʲ������ˣ�
			return;
		}
		
		self.returnValue=sTraceUserID+"@"+sTraceUserName+"@"+sTraceOrgID;//���ز���
		self.close();
	}
	
	function selectUser()
	{
		var sParaString = "BelongOrg,"+"<%=CurOrg.getOrgID()%>";
		var sReturn= selectObjectValue("SelectUser",sParaString,"");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			
			document.all("TraceUserID").value=sReturn[0];
			document.all("TraceUserName").value=sReturn[1];
			document.all("TraceOrgID").value=sReturn[2];
			document.all("TraceOrgName").value=sReturn[3];
			
		}
		else if (sReturn=='_CLEAR_')
		{
			document.all("TraceUserID").value="";
			document.all("TraceUserName").value="";
			document.all("TraceOrgID").value="";
			document.all("TraceOrgName").value="";
		}
		else 
		{
			return;
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
  <table align="center" width="280" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr> 
		<td nowarp align="left" class="black9pt" bgcolor="#F0F1DE" ></td>  
		<td nowarp bgcolor="#F0F1DE" >��ѡ�������:&nbsp;&nbsp;
			<input type='text' name="TraceUserName" value="" ReadOnly=true>
			<input type=button value="" onclick=parent.selectUser()>
			<input type=hidden name="TraceUserID" value="" >
			<input type=hidden name="TraceOrgID" value="" >
		</td>
	</tr>
	<tr>
		<td nowarp align="left" class="black9pt" bgcolor="#F0F1DE" ></td> 
		<td nowarp bgcolor="#F0F1DE" >��������������:	
			<input type='text' name="TraceOrgName" value="" ReadOnly=true>
    	</td>
	</tr>	
  </table>
  
  <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("ȷ��","","javascript:newTraceUser()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("ȡ��","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>