<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>��ѡ��ͳ������</title>
</head>
<BODY bgcolor="#FFFFFF" leftmargin="0" topmargin="0">

<script>
var dDate = new Date();
var dCurMonth = dDate.getMonth();
var dCurYear = dDate.getFullYear();
var dCurDayOfMonth = dDate.getDate();

function fToggleColor(myElement) {
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

function fSetSelectedMonth(month){
	top.returnValue=document.getElementById("Year").value+"/"+month;
	top.close();
}

function doCancel(){
	top.returnValue="";
	top.close();
}

function doClose(){
	top.close();
}

/*~[Describe=֧��ESC�ر�ҳ��;InputParam=��;OutPutParam=��;]~*/
document.onkeydown = function(){
	if(event.keyCode==27){
		top.close();
	}
};

</script>
<div align=center>
<form name="item">
<table>
<tr><td align="right">
<select id="Year" name="Year">
<script>
document.write("<option selected value='"+dCurYear+"'>"+dCurYear+"</option>");
for(i=dCurYear-1;i>dCurYear-50;i--){
	document.write("<option value='"+i+"'>"+i+"</option>");
}
</script>
</select>��
</td>
</tr>
<tr>
<td>
<table align='right' border='1' bordercolor='#EEEEEE' cellpadding='0' cellspacing='1'>
<tr>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('01')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('01')>һ��</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('02')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('02')>����</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('03')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('03')>����</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('04')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('04')>����</font>
</td>
</tr>
<tr>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('05')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('05')>����</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('06')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('06')>����</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('07')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('07')>����</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('08')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('08')>����</font>
</td>
</tr>
<tr>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('09')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('09')>����</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('10')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('10')>ʮ��</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('11')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('11')>ʮһ��</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('12')>
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedMonth('12')>ʮ����</font>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td align='right'>
     <img border='0' src='<%=sResourcesPath%>/close.gif' onclick="javascript:doClose();" style='cursor: pointer;'>
     <img border='0' src='<%=sResourcesPath%>/zero.gif'  onclick="javascript:doCancel();" style='cursor: pointer;'>
</td>
</tr>
</table>
</form>
</div>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>