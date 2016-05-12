<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XWu 2004.12.04
 * Tester:
 *
 * Content:      选择不良资产管理人
 * Input Param:
 *			    
 * Output param:
 *		RecoveryUserID： 保全部管理人员ID
 *		RecoveryUserName：保全部管理人员名称
 *		RecoveryOrgID：保全部管理人员所属机构ID
 * History Log: 
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>选择不良资产管理人</title>

<script type="text/javascript">

	function newTraceUser()
	{		
		sTraceUserID = document.all("TraceUserID").value;
		sTraceOrgID = document.buff.TraceOrgID.value;
		sTraceUserName = document.all("TraceUserName").value;
		if(sTraceUserID=="")
		{
			alert(getBusinessMessage('764'));//请选择不良资产管理人！
			return;
		}
		
		self.returnValue=sTraceUserID+"@"+sTraceUserName+"@"+sTraceOrgID;//返回参数
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
		<td nowarp bgcolor="#F0F1DE" >请选择管理人:&nbsp;&nbsp;
			<input type='text' name="TraceUserName" value="" ReadOnly=true>
			<input type=button value="" onclick=parent.selectUser()>
			<input type=hidden name="TraceUserID" value="" >
			<input type=hidden name="TraceOrgID" value="" >
		</td>
	</tr>
	<tr>
		<td nowarp align="left" class="black9pt" bgcolor="#F0F1DE" ></td> 
		<td nowarp bgcolor="#F0F1DE" >管理人所属机构:	
			<input type='text' name="TraceOrgName" value="" ReadOnly=true>
    	</td>
	</tr>	
  </table>
  
  <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("确认","","javascript:newTraceUser()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>