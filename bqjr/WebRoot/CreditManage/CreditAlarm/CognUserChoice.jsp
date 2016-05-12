<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XWu 2004.12.04
 * Tester:
 *
 * Content:      选择认定人
 * Input Param:
 *		    
 * Output param:
 *		CognUserID： 认定人员用户ID
 *		CognUserName：认定人员名称
 *		CognOrgID：认定人员所属机构ID
 * History Log: 
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>选择认定人</title>

<script type="text/javascript">
	function newCognUser(){
		sCognUserID = document.all("CognUserID").value;
		sCognOrgID = document.buff.CognOrgID.value;
		sCognUserName = document.all("CognUserName").value;
		if(sCognUserID == ""){
			alert(getBusinessMessage('765'));//请选择认定人！
			return;
		}
		
		self.returnValue=sCognUserID+"@"+sCognOrgID;//返回参数
		self.close();
	}
	
	function selectUser(){
		var sParaString = "OrgSortNo,<%=CurOrg.getSortNo()%>,RoleID,84";
		var sReturn= selectObjectValue("SelectUserOrgAndRole",sParaString,"");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_')){
			sReturn=sReturn.split("@");
			document.all("CognUserID").value=sReturn[0];
			document.all("CognUserName").value=sReturn[1];
			document.all("CognOrgID").value=sReturn[2];
			document.all("CognOrgName").value=sReturn[3];
		}else if (sReturn=='_CLEAR_'){
			document.all("CognUserID").value="";
			document.all("CognUserName").value="";
			document.all("CognOrgID").value="";
			document.all("CognOrgName").value="";
		}else{
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
		<td nowarp bgcolor="#F0F1DE" >请选择认定人:&nbsp;&nbsp;
			<input type='text' name="CognUserName" value="" ReadOnly=true>
			<input type=button value="" onclick=parent.selectUser()>
			<input type=hidden name="CognUserID" value="" >
			<input type=hidden name="CognOrgID" value="" >
		</td>
	</tr>
	<tr>
		<td nowarp align="left" class="black9pt" bgcolor="#F0F1DE" ></td> 
		<td nowarp bgcolor="#F0F1DE" >认定人所属机构:	
			<input type='text' name="CognOrgName" value="" ReadOnly=true>
    	</td>
	</tr>	
  </table>
  <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("确认","","javascript:newCognUser()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>