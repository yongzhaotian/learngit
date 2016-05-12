<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:RCZhu 2003.7.18
 * Tester:
 *
 * Content: 日历选择器
 * Input Param:
 * Output param:
 *
 * 
 *
 */
%>


<script language="javascript">


	<%
	//参数定义
	String OthArea = "";
	String sCurdate = "";//日期
	String sSql;
	ASResultSet rs;
	
	//获得组件参数
	//地区：Land，HK，MC
	String sArea = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Area"));
	if(sArea == null) sArea = "";
	
	if(sArea.equals("Land"))OthArea = "WORKFLAG";//是否工作日（大陆）
	if(sArea.equals("HK")) OthArea = "WORKFLAGHK";//是否工作日（香港）
	if(sArea.equals("MC")) OthArea = "WORKFLAGMC";//是否工作日（澳门）
	
	
	%> 

var sCurJob = new Array();


function getTodayJobCount(iYear,iMonth,iDay){
	var iCountWorks=0;
	for(i=0;i<sCurJob.length;i++)
	{
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDay)
		{
			iCountWorks++;
		}
	}
	return iCountWorks;
}

function getTodayTip(iYear,iMonth,iDay)
{
	var sTips="",sTmp="",j=1;
	
	for(i=0;i<sCurJob.length;i++)
	{
		
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDay)
		{
			sTmp = j+"."+sCurJob[i][2];
			if(sTmp==null) sTmp="";
			if(sTmp.length>10) sTmp = sTmp.substring(0,10)+"...";
			sTips += sTmp+"~p";
			j++;
		}
	}
	sTips=""+sTips;
	return sTips;
}

function fSetSelectedDay(myElement)
{
	if (myElement.id == "calCell") 
	{
		if (!isNaN(parseInt(myElement.children["calDateText"].innerText))) 
		{
			myElement.bgColor = "#c0c0c0";
			objPrevElement.bgColor = "";
			document.all.calSelectedDate.value = parseInt(myElement.children["calDateText"].innerText);
			objPrevElement = myElement;
			//modify by hxd in 2001/08/27
			//self.returnValue=document.all.tbSelYear.value+"/"+document.all.tbSelMonth.value+"/"+document.all.calSelectedDate.value;
			self.returnValue=document.all.tbSelYear.value+"/"+document.all.tbSelMonth.value+"/"+myElement.children["calDateText"].innerText;
			window.close();
      }
   }
}

function fGetDaysInMonth(iMonth,iYear) 
{
	var dPrevDate = new Date(iYear, iMonth, 0);
	return dPrevDate.getDate();
}

function fBuildCal(iYear, iMonth, iDayStyle) 
{
	var aMonth = new Array();
	aMonth[0] = new Array(7);
	aMonth[1] = new Array(7);
	aMonth[2] = new Array(7);
	aMonth[3] = new Array(7);
	aMonth[4] = new Array(7);
	aMonth[5] = new Array(7);
	aMonth[6] = new Array(7);
	var dCalDate = new Date(iYear, iMonth-1, 1);
	var iDayOfFirst = dCalDate.getDay();
	var iDaysInMonth = fGetDaysInMonth(iMonth, iYear);
	var iVarDate = 1;
	var i, d, w;
	if (iDayStyle == 2) {
		aMonth[0][0] = "Sunday";
		aMonth[0][1] = "Monday";
		aMonth[0][2] = "Tuesday";
		aMonth[0][3] = "Wednesday";
		aMonth[0][4] = "Thursday";
		aMonth[0][5] = "Friday";
		aMonth[0][6] = "Saturday";
	} 
	else if (iDayStyle == 1) 
	{
		aMonth[0][0] = "日";
		aMonth[0][1] = "一";
		aMonth[0][2] = "二";
		aMonth[0][3] = "三";
		aMonth[0][4] = "四";
		aMonth[0][5] = "五";
		aMonth[0][6] = "六";
	} 
	else 
	{
		aMonth[0][0] = "Su";
		aMonth[0][1] = "Mo";
		aMonth[0][2] = "Tu";
		aMonth[0][3] = "We";
		aMonth[0][4] = "Th";
		aMonth[0][5] = "Fr";
		aMonth[0][6] = "Sa";
	}

	for (d = iDayOfFirst; d < 7; d++) 
	{
		if(iVarDate<10) 
			aMonth[1][d] = "0"+iVarDate;  //add by hxd in 2001/08/27
		else
			aMonth[1][d] = iVarDate;
		
		iVarDate++;
	}

	for (w = 2; w < 7; w++) 
	{
		for (d = 0; d < 7; d++) 
		{	
			if (iVarDate <= iDaysInMonth) 
			{
				if(iVarDate<10) 
					aMonth[w][d] = "0"+iVarDate;  //add by hxd in 2001/08/27
				else
					aMonth[w][d] = iVarDate;
				iVarDate++;
	      }
	   }
	}
	
	return aMonth;
}

function fDrawCal(iYear, iMonth, iCellWidth, iCellHeight, sDateTextSize, sDateTextWeight, iDayStyle) 
{
	var myMonth;
	var sReturn = "";
	myMonth = fBuildCal(iYear, iMonth, iDayStyle);
	sReturn += ("<table align='center' border='1' cellpadding='0' cellspacing='0'>");
	sReturn += ("<tr>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][0] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][1] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][2] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][3] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][4] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][5] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][6] + "</td>");
	sReturn += ("</tr>");
	//modify by zmxu
	var sHolidaySatuationForThisMonth = RunMethod("PublicMethod","HolidaySatuationForThisMonth",(iYear+"/"+iMonth)+",<%=sArea%>");
	var sArray = "";
	if(sHolidaySatuationForThisMonth!=""){
		sArray = sHolidaySatuationForThisMonth.split("@");
	}
	for (w = 1; w < 7; w++) 
	{
		sReturn += ("<tr>");
		for (d = 0; d < 7; d++) 
		{
			if (!isNaN(myMonth[w][d])) 
			{
				var color = "";
				sCurdate = iYear+"/"+iMonth+"/"+myMonth[w][d];
				var mySelfDefDate = "";
				mySelfDefDate += iYear+"/";
				mySelfDefDate += (iMonth+"").length==1?"0"+iMonth:iMonth;
				mySelfDefDate += "/"+myMonth[w][d];
				if(sHolidaySatuationForThisMonth!=""){
					for(var jj=0;jj<sArray.length;jj++){
						if(sArray[jj].split(",")[0]==mySelfDefDate){
							if(sArray[jj].split(",")[1]=="1"){
								color = "#ff0000";
							}
							if(sArray[jj].split(",")[1]=="2"){
								color = "#00e00d";
							}
							if(sArray[jj].split(",")[1]=="3"){
								color = "#008000";
							}
							break;
						}
					}
					mySelfDefDate="";
				}
				sReturn += ("<td  align='center' bgcolor='"+color+"' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand' onMouseOver='showlayer(0,this)'");
				sReturn += ("<font id=calDateText style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onClick=newTask(this,"+myMonth[w][d]+")>");
				sReturn += (""+ myMonth[w][d] +"");
				sReturn += ( "</font>");
			} 
			else 
			{
				sReturn += ("<td align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand' onMouseOver='showlayer(0,this)' onclick=fSetSelectedDay(this)>");
				sReturn += ("<font id=calDateText ' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "'>&nbsp;</font>");
			}
			sReturn += ("</td>");
		}
		sReturn += ("</tr>");
	}
	sReturn += ("</table>");
	return sReturn;
}

function fUpdateCal(iYear, iMonth) 
{
	myMonth = fBuildCal(iYear, iMonth);
	objPrevElement.bgColor = "";
	document.all.calSelectedDate.value = "";
	for (w = 1; w < 7; w++) 
	{
		for (d = 0; d < 7; d++) 
		{
			if (!isNaN(myMonth[w][d])) 
			{
				calDateText[((7*w)+d)-7].innerText = myMonth[w][d];
			} 
			else 
			{
				calDateText[((7*w)+d)-7].innerText = " ";
        	}
      	}
   	}
}

function isDate(value,separator) 
{
	var sItems = value.split(separator);
	if (sItems.length!=3) return false;
	if (isNaN(sItems[0])) return false; 
	if (isNaN(sItems[1])) return false;
	if (isNaN(sItems[2])) return false;
	if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2050) return false;
	if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
	if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;
	return true;
}


function showTipOfToday(id,e,sText)
{  
    sHtmlTmp = "";
    sHtmlTmp += "<table border=1 cellspacing=0 cellpadding=3 bordercolorlight=#99999 bordercolordark=#FFFFFF width=110 ><tr><td class=SubMenuTd2>";
    sHtmlTmp += sText;
    sHtmlTmp += "</td></tr></table>";
    while(sHtmlTmp.indexOf("~p")>=0) sHtmlTmp = sHtmlTmp.replace("~p","<br>");
    document.all('subMenu'+id).innerHTML = sHtmlTmp;
    showlayer(id,e);
}

function newTask(myElement,tbSeldate)//id,日期
{
	tbSeldate = tbSeldate + "";
	if(tbSeldate.length < 2) {
		tbSeldate = "0" + tbSeldate;
	}
	var toggleColor = "";
	var Tag = "";//标记：del删除，add增加
	var dateType = "";//工作类型：1为工作日，2为法假日，3为法定节假日
	if(document.all("forceradio")[0].checked){toggleColor="#ff0000" ;dataType = "1";}//工作日
	if(document.all("forceradio")[1].checked){toggleColor="#00e00d" ;dataType = "2";}//节假日
	if(document.all("forceradio")[2].checked){toggleColor="#008000" ;dataType = "3";}//法定节假日
	if(toggleColor==""){dataType = "0";};

	if (myElement.id == "calDateText") 
	{
		if (myElement.color == toggleColor) 
		{
			
			myElement.color = "";
		} 
		else 
		{
			myElement.color = toggleColor;
	   	}
	} 
	else 
	{	
		if(parseInt(document.all("tbSelYear").value)<parseInt(dCurYear)){
			if(!confirm("你现在维护的不是今年的节假日情况，你确定维护吗?")){
				return;
			}
		}
		if (myElement.id == "calCell") 
		{
			
			sCurdate = document.all("tbSelYear").value+"/"+document.all("tbSelMonth").value+"/"+tbSeldate;
			if (myElement.bgColor == toggleColor ||toggleColor == "") 
			{
				//删除一条数据
				sReturn = RunMethod("PublicMethod","DelOneCalendar",sCurdate+",<%=sArea%>");
				myElement.bgColor = "";
			} 
			else 
			{
				myElement.bgColor = toggleColor;
				RunMethod("PublicMethod","DelOneCalendar",sCurdate+",<%=sArea%>");
				//添加一条数据CURDATE：日期，AREATYPE区域编码，WORKFLAG：是大陆还是其他的工作日：1为工作日，2为节假日，3为法定节假日
				RunMethod("PublicMethod","AddOneCalendar",sCurdate+",<%=sArea%>,"+dataType);
			}
		}
		
         		
   	}
	}


function showlayer(id,e)
{  
	document.all('subMenu'+id).style.left=getRealLeft(e);
    document.all('subMenu'+id).style.top=getRealTop(e)+e.offsetHeight;

    if(getRealLeft(e)+ e.offsetWidth + document.all('subMenu'+id).offsetWidth >document.body.offsetWidth)
    	document.all('subMenu'+id).style.left = getRealLeft(e) - document.all('subMenu'+id).offsetWidth;
    
    if(getRealTop(e)+ e.offsetHeight + document.all('subMenu'+id).offsetHeight >document.body.offsetHeight)
    	document.all('subMenu'+id).style.top = getRealTop(e) - document.all('subMenu'+id).offsetHeight;
    
    document.all('subMenu'+id).style.visibility="visible";
    for(var i=0;i<2;i++) //modify by xdhou in 2003/09/23 old:for(var i=0;i<8;i++) 注意：随着subMenu的length而定
    {
        if(i!=id)
            document.all('subMenu'+i).style.visibility="hidden";
    }
}

function getRealTop(imgElem) 
{
    yPos = eval(imgElem).offsetTop;
    tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) 
    {
        yPos += tempEl.offsetTop;
        tempEl = tempEl.offsetParent;
    }
    return yPos;
}
function getRealLeft(imgElem) 
{
    xPos = eval(imgElem).offsetLeft;
    tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) 
    {
        xPos += tempEl.offsetLeft;
        tempEl = tempEl.offsetParent;
    }
    return xPos;
}
function initDay(){
	var sReturn = popComp("ChooseInitDate","/Accounting/SysCalendarManage/ChooseInitDate.jsp","","dialogWidth=20;dialogHeight=15;");
	if(typeof(sReturn)=="undefined"){
	}else{
		var sReturn = RunMethod("SystemManage","InitDay",sReturn+",<%=sArea%>");
		if(sReturn == "true"){
			alert("初始化成功。");
			self.reloadSelf();
		}else{
			alert("初始化失败。");
		}
	}
}


</script>

<SCRIPT LANGUAGE="JavaScript">
var dDate = new Date();
var dCurMonth = dDate.getMonth();
var dCurDayOfMonth = dDate.getDate();
var dCurYear = dDate.getFullYear();
var objPrevElement = new Object();
</script>



<BODY class="pagebackground" leftmargin="0" topmargin="0">
<h2 align="center">假日管理</h2>
<table border="0" align='center' width='100%' >
<form name="frmCalendarSample" method="post" action="">

<tr>
<td align='center' onMouseOver="showlayer(0,this)" height=28>
<input type="hidden" name="calSelectedDate" value="" >
<select name="tbSelYear" onchange='drawHtmlToObject(document.all("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 100, 30, "15px", "", 1))'>
<%
	int i;
	for(i=2000;i<=2020;i++)
	{
%>	
		<option value="<%=i%>"><%=i%></option>
<%
	}
%>
</select>

<select name="tbSelMonth" onchange='drawHtmlToObject(document.all("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 100, 30, "15px", "", 1))'>
<option value="01">一月</option>
<option value="02">二月</option>
<option value="03">三月</option>
<option value="04">四月</option>
<option value="05">五月</option>
<option value="06">六月</option>
<option value="07">七月</option>
<option value="08">八月</option>
<option value="09">九月</option>
<option value="10">十月</option>
<option value="11">十一月</option>
<option value="12">十二月</option>
</select>
 
</td>
</tr>
<tr>
<td id=MyCalendar>
</td>
</tr>
<tr>
<td align='right' >
<input type="button" value="初始化工作日" onclick="initDay()">
<input type="radio" name="forceradio" value="force1" id="forceradio">
<font color="#DA0000" size="+1">工作日</font>
<input type="radio" name="forceradio" value="force2" id="forceradio">
<font color="#00E00D" size="+1">节假日</font>
<input type="radio" name="forceradio" value="force3" id="forceradio">
<font color="#008000" size="+1">法定节假日</font>
 </td>
</tr>
</form>
</table>

<div id="subMenu0" style="position:absolute; left:0px; top:0px; visibility:hidden">
</div>
<div id="subMenu1" style="position:absolute; left:0px; top:0px; width:80px; visibility:hidden" onMouseOver='showlayer(0,this)'>
</div>
<script language="JavaScript">

var dCurDate = new Date();

frmCalendarSample.tbSelMonth.options[dCurDate.getMonth()].selected = true;

for (i = 0; i < frmCalendarSample.tbSelYear.length; i++)
if (frmCalendarSample.tbSelYear.options[i].value == dCurDate.getFullYear())
frmCalendarSample.tbSelYear.options[i].selected = true;

if(dCurDate.getDate()<10)
	document.all.calSelectedDate.value = "0"+dCurDate.getDate();
else
	document.all.calSelectedDate.value = dCurDate.getDate();

drawHtmlToObject(document.all("MyCalendar"),fDrawCal(dCurDate.getFullYear(), dCurDate.getMonth()+1, 100, 30, "15px", "", 1));//iYear, iMonth, iCellWidth, iCellHeight, sDateTextSize, sDateTextWeight, iDayStyle
</script>

<%@ include file="/IncludeEnd.jsp"%>