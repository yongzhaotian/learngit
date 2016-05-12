<!--
<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: nccb 2004.2.10
 * Tester:
 *
 * Content: 本页面用于选择报表统计年份
 * Input Param:			Date,		统计月份
 						OrgID,		机构代码
 * Output param:
 *
 * History Log: 2004-5-9 10:29 yliu
 *                          
 */
%>
-->
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>请选择统计年份</title>
</head>
<BODY bgcolor="#FFFFFF" leftmargin="0" topmargin="0">

<script>
var dDate = new Date();
var dCurMonth = dDate.getMonth();
var dCurYear = dDate.getFullYear();
var dCurDayOfMonth = dDate.getDate();

function fToggleColor(myElement){
	var toggleColor = "#ff0000";
	if (myElement.id == "calDateText") {
		if (myElement.color == toggleColor) {
			myElement.color = "";
		} else {
			myElement.color = toggleColor;
	   	}
	} else {
		if (myElement.id == "calCell") {
			for (var i in myElement.children) {
				if (myElement.children[i].id == "calDateText") {
					if (myElement.children[i].color == toggleColor) {
						myElement.children[i].color = "";
					} else {
						myElement.children[i].color = toggleColor;
            		}
         		}
      		}
   		}
   	}
}

function doCancel(){
	top.returnValue="";
	top.close();
}

function doClose(){
	top.returnValue=document.all.Year.value;
	top.close();
}

</script>
<div align=center>
<form name="item">
<table>
<tr><td align="right">
<select name="Year">
<script>
document.write("<option selected value='"+dCurYear+"'>"+dCurYear+"</option>");
for(i=dCurYear-1;i>dCurYear-50;i--){
	document.write("<option value='"+i+"'>"+i+"</option>");
}
</script>
</select>年
</td>
</tr>
<tr>
<td align='right'>
     <img border='0' src='<%=sResourcesPath%>/close.gif' onclick="javascript:doClose();" style='cursor:pointer;'>
     <img border='0' src='<%=sResourcesPath%>/zero.gif'  onclick="javascript:doCancel();" style='cursor:pointer;'>
</td>
</tr>
</table>
</form>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>