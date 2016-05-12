<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: slliua 2004.12.28
 * Tester:
 *
 * Content:      将不良资产移交保全部门
 * Input Param:
 *			    
 * Output param:
 *	
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>将不良资产移交保全部门</title>

<script type="text/javascript">

	function newShiftRM()
	{
		var sTraceOrgID ;  //保全机构编号
		var sShiftType ;   //移交类型
		var sTraceOrgName ;   //保全机构名称
		
		//sShiftType = document.all("ShiftType").value;
		sShiftType = '02';//默认移交类型为客户移交
		sTraceOrgID = document.buff.TraceOrgID.value;
		sTraceOrgName = document.buff.TraceOrgName.value;
		
		if(sShiftType=="")
		{
			alert("请选择移交类型！");
			return;
		}
		
		if(sTraceOrgName=="")
		{
			alert("请选择保全机构！");
			return;
		}
		
		self.returnValue=sShiftType+"@"+sTraceOrgID+"@"+sTraceOrgName;//返回参数
		
		self.close();
	}
	
	function selectOrg()
	{
		var sParaString = "BelongOrgID,"+"<%=CurOrg.getRelativeOrgID()%>";
		//将选择机构设置为所有机构
		var sReturn= selectObjectValue("SelectAllOrg",sParaString,0,0,"");	
		
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sTraceOrgID=sReturn[0];
		
			document.all("TraceOrgID").value=sReturn[0];
			document.all("TraceOrgName").value=sReturn[1];
			
		}
		else if (sReturn=='_CLEAR_')
		{
			sTraceOrgID="";
		
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
   	 <!-- 
   	 <tr>
    	<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" ></td>
		<td nowarp bgcolor="#F0F1DE" >选择移交类型： 
			<select name="ShiftType" >
				<%=HTMLControls.generateDropDownSelect(Sqlca,"ShiftType","")%> 
			</select>
		</td>
   	 </tr>
     -->
	 <tr> 
		<td nowarp align="left" class="black9pt" bgcolor="#F0F1DE" ></td>  
		<td nowarp bgcolor="#F0F1DE" >保全机构:
			<input type='text' name="TraceOrgName" value="" ReadOnly=true>
	        <input type=button value="" onclick=parent.selectOrg()>
	        <input type=hidden name="TraceOrgID" value="" >
		</td>
	</tr>
	
	
    </table>
   <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("确认","","javascript:newShiftRM()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>