<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	String sObjectType = "";
	sObjectType = CurPage.getParameter("ObjectType");
%>
<html>
<head> 
<title>��ѡ��Ȩ������ </title>
</head>

<body class="pagebackground">
<center>
<form  name="buff">

<table width="90%" border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr> 
      <td nowrap align="right" width="50%">��</td>
      <td nowrap width="50%">
	<select name="ViewID" class="right">
		<%=HTMLControls.generateDropDownSelect(Sqlca,"select ViewCode,ViewName from VIEW_LIBRARY where ViewType = (select ViewType from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"')",1,2,"")%>
	</select>
      </td>
</tr> 
<tr> 
      <td nowrap align="right" width="50%">�����һ��</td>
      <td nowrap width="50%">
      <input TYPE="RADIO" name="Obt" value="1"    >����
      <BR>
      <input TYPE="RADIO" name="Obt" value="2"    >����
      </td>
</tr> 
<tr>
      <td nowarp  colspan="2" height="25" align=center  height="1"> 
        <input type="button"  name="ok" value="ȷ��" onClick="javascript:goBack()" style="font-size:9pt;padding-left:5;padding-right:5;background-image:url(<%=sResourcesPath%>/button/button_back_hover.gif); ">
        <input type="button"  name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='';self.close()" style="font-size:9pt;padding-left:5;padding-right:5;background-image:url(<%=sResourcesPath%>/button/button_back_hover.gif); ">
      </td>
</tr>
</table>
</form>
</center>
</body>
</html> 
<script type="text/javascript">
	function goBack(){
		var sViewID = buff.ViewID.value;
		
		if( buff.Obt[0].checked){
			self.returnValue = sViewID+"@1";
			self.close();
		}else if( buff.Obt[1].checked){	
			self.returnValue = sViewID+"@2";
			self.close();
		}else {
			alert("��ѡ��һ�");	
		}
	}		
</script>
<%@ include file="/IncludeEnd.jsp"%>