<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: slliua 2004.12.28
 * Tester:
 *
 * Content:      �������ʲ��ƽ���ȫ����
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
<title>�������ʲ��ƽ���ȫ����</title>

<script type="text/javascript">

	function newShiftRM()
	{
		var sTraceOrgID ;  //��ȫ�������
		var sShiftType ;   //�ƽ�����
		var sTraceOrgName ;   //��ȫ��������
		
		//sShiftType = document.all("ShiftType").value;
		sShiftType = '02';//Ĭ���ƽ�����Ϊ�ͻ��ƽ�
		sTraceOrgID = document.buff.TraceOrgID.value;
		sTraceOrgName = document.buff.TraceOrgName.value;
		
		if(sShiftType=="")
		{
			alert("��ѡ���ƽ����ͣ�");
			return;
		}
		
		if(sTraceOrgName=="")
		{
			alert("��ѡ��ȫ������");
			return;
		}
		
		self.returnValue=sShiftType+"@"+sTraceOrgID+"@"+sTraceOrgName;//���ز���
		
		self.close();
	}
	
	function selectOrg()
	{
		var sParaString = "BelongOrgID,"+"<%=CurOrg.getRelativeOrgID()%>";
		//��ѡ���������Ϊ���л���
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
		<td nowarp bgcolor="#F0F1DE" >ѡ���ƽ����ͣ� 
			<select name="ShiftType" >
				<%=HTMLControls.generateDropDownSelect(Sqlca,"ShiftType","")%> 
			</select>
		</td>
   	 </tr>
     -->
	 <tr> 
		<td nowarp align="left" class="black9pt" bgcolor="#F0F1DE" ></td>  
		<td nowarp bgcolor="#F0F1DE" >��ȫ����:
			<input type='text' name="TraceOrgName" value="" ReadOnly=true>
	        <input type=button value="" onclick=parent.selectOrg()>
	        <input type=hidden name="TraceOrgID" value="" >
		</td>
	</tr>
	
	
    </table>
   <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("ȷ��","","javascript:newShiftRM()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("ȡ��","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>