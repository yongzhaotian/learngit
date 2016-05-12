<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<HEAD>
<title>日历选择器</title>
<%
	String d ="'123'";  
	if((request.getParameter("d")!=null)&&(request.getParameter("d").trim().length()!=0)){
		d= "'"+request.getParameter("d")+"'";
	}
%>
</HEAD>
<%
	String sSql;
	ASResultSet rs;
	String sMyCurrentJob[][] = new String[100][5];
	int iJobs=0;
	String sToday = StringFunction.getToday();
	
	sSql ="select SerialNo,GetItemName('WorkType',WorkType)  as WorkType,WorkBrief,PlanFinishDate,PromptBeginDate,ActualFinishDate,WorkContent,"
			+"getOrgName(InputOrgID) as OrgName,getUserName(InputUserID) as UserName "
			+"from WORK_RECORD  "
			+"where  (ActualFinishDate is null or ActualFinishDate=' ') and InputUserID = '"+CurUser.getUserID()+"'"; 
	rs = SqlcaRepository.getResultSet(sSql);
	while(rs.next()){
		sMyCurrentJob[iJobs][0] = rs.getString("SerialNo");
		sMyCurrentJob[iJobs][1] = rs.getString("WorkType");
		sMyCurrentJob[iJobs][2] = SpecialTools.real2Amarsoft(rs.getString("WorkBrief"));
		sMyCurrentJob[iJobs][3] = SpecialTools.real2Amarsoft(rs.getString("WorkContent"));
		sMyCurrentJob[iJobs][4] = rs.getString("PlanFinishDate");
		if(sMyCurrentJob[iJobs][4]==null) sMyCurrentJob[iJobs][4]="";
		iJobs++;
	}
	rs.getStatement().close();
%>


<script type="text/javascript">
var sCurJob = new Array();
<%
String sCurYear,sCurMonth,sDate;
int iCurYear,iCurMonth,iDate;
for(int i=0;i<iJobs;i++){
	if(sMyCurrentJob[i]==null) break;
	if(sMyCurrentJob[i][0]!=null){
		%>
		sCurJob[<%=i%>] = new Array(7);
		sCurJob[<%=i%>][0] = "<%=sMyCurrentJob[i][0]%>";
		sCurJob[<%=i%>][1] = "<%=sMyCurrentJob[i][1]%>";
		sCurJob[<%=i%>][2] = "<%=sMyCurrentJob[i][2]%>";
		sCurJob[<%=i%>][3] = "<%=sMyCurrentJob[i][3]%>";
		<%
		sCurYear = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",1);
		sCurMonth = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",2);
		sDate = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",3);
		
		if(sCurYear==null || sCurYear.equals("")) iCurYear=0;
		else iCurYear=Integer.parseInt(sCurYear);
		if(sCurMonth==null || sCurMonth.equals("")) iCurMonth=0;
		else iCurMonth=Integer.parseInt(sCurMonth);
		if(sDate==null || sDate.equals("")) iDate=0;
		else iDate=Integer.parseInt(sDate);
		%>
		sCurJob[<%=i%>][4] = <%=iCurYear%>;
		sCurJob[<%=i%>][5] = <%=iCurMonth%>;
		sCurJob[<%=i%>][6] = <%=iDate%>;
		<%
	}else{
		break;
	}
}
%>

function getTodayJobCount(iYear,iMonth,iDay){
	var iCountWorks=0;
	for(var i=0;i<sCurJob.length;i++){
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDay){
			iCountWorks++;
		}
	}
	return iCountWorks;
}

function getTodayTip(iYear,iMonth,iDay){
	var sTips="",sTmp="",j=1;
	for(var i=0;i<sCurJob.length;i++){
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDay){
			//alert(iYear+iMonth+iDay);
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

function fSetSelectedDay(myElement){
	if (myElement.id == "calCell") {
		if (!isNaN(parseInt(myElement.children["calDateText"].innerText))) {
			myElement.bgColor = "#c0c0c0";
			objPrevElement.bgColor = "";
			document.getElementById("calSelectedDate").value = parseInt(myElement.children["calDateText"].innerText);
			objPrevElement = myElement;
			self.returnValue=document.getElementById("tbSelYear").value+"/"+document.getElementById("tbSelMonth").value+"/"+myElement.children["calDateText"].innerText;
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
	sReturn += ("<table align='right' border='0' cellpadding='0' cellspacing='0'>");
	sReturn += ("<tr>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][0] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][1] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][2] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][3] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][4] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][5] + "</td>");
	sReturn += ("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][6] + "</td>");
	sReturn += ("</tr>");
	for (var w = 1; w < 7; w++) {
		sReturn += ("<tr>");
		for (var d = 0; d < 7; d++){
			if (!isNaN(myMonth[w][d])){
				if(iYear==dCurDate.getFullYear() && iMonth==(dCurDate.getMonth()+1) && myMonth[w][d]==document.getElementById("calSelectedDate").value){
					if(getTodayJobCount(iYear,iMonth,parseInt(myMonth[w][d],10))>0){
						sReturn += ("<td align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='cursor:pointer;background-color:#c0c0c0;' onMouseOver=showTipOfToday(1,this,\'"+getTodayTip(iYear,iMonth,parseInt(myMonth[w][d],10))+"\') >");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += ("<b>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</b>");
						sReturn += ("</font>");
					}else{
						sReturn += ("<td align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='cursor:pointer;background-color:#c0c0c0;'  onMouseOver='showlayer(0,this)'>");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+") >");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</font>");
					}
				}else{
					if(getTodayJobCount(iYear,iMonth,parseInt(myMonth[w][d],10))>0){
						sReturn += ("<td align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='cursor:pointer' onMouseOver=showTipOfToday(1,this,\'"+getTodayTip(iYear,iMonth,parseInt(myMonth[w][d],10))+"\')>");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)'  onClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += ("<b>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ("</b>");
						sReturn += ( "</font>");
					}else{
						sReturn += ("<td align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='cursor:pointer' onMouseOver='showlayer(0,this)'");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)'  onClick=newTask("+iYear+","+iMonth+","+myMonth[w][d]+")>");
						sReturn += (""+ myMonth[w][d] +"");
						sReturn += ( "</font>");
					}
				}
			}else{
				sReturn += ("<td align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='cursor:pointer' onMouseOver='showlayer(0,this)' onclick=fSetSelectedDay(this)>");
				sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>&nbsp;</font>");
			}
			sReturn += ("</td>");
		}
		sReturn += ("</tr>");
	}
	sReturn += ("</table>");
	return sReturn;
}

function fUpdateCal(iYear, iMonth) {
	myMonth = fBuildCal(iYear, iMonth);
	objPrevElement.bgColor = "";
	document.getElementById("calSelectedDate").value = "";
	for (var w = 1; w < 7; w++) {
		for (var d = 0; d < 7; d++) {
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


function showTipOfToday(id,e,sText){
    sHtmlTmp = "";
    sHtmlTmp += "<table   border=1 cellspacing=0 cellpadding=3 bordercolorlight=#99999 bordercolordark=#FFFFFF width=110 ><tr><td class=SubMenuTd2>";
    sHtmlTmp += sText;
    sHtmlTmp += "</td></tr></table>";
    while(sHtmlTmp.indexOf("~p")>=0) sHtmlTmp = sHtmlTmp.replace("~p","<br>");
    //alert(sText);
    document.getElementById('subMenu'+id).innerHTML = sHtmlTmp;
    showlayer(id,e);
}

function newTask(iYear,iMonth,iDate){
	var sSerialNo="";
	for(var i=0;i<sCurJob.length;i++){
		//alert(sCurJob[i][4]+"/"+sCurJob[i][5]+"/"+sCurJob[i][6]);
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDate){
			//alert("in");
			sSerialNo=sCurJob[i][0];
			//OpenPage("/DeskTop/WorkRecordInfo.jsp?SerialNo="+sSerialNo,"","");
			editWork(sSerialNo);
			return;
		}
	}
	editWork("");
}

function editWork(sSerialNo){
	popComp("WorkRecordInfo","/DeskTop/WorkRecordInfo.jsp","SerialNo="+sSerialNo, "","");
	reloadSelf();
}
function showlayer(id,e){
	document.getElementById('subMenu'+id).style.left=getRealLeft(e);
    document.getElementById('subMenu'+id).style.top=getRealTop(e)+e.offsetHeight;
    //document.getElementById('subMenu'+id).style.width=e.offsetWidth;

    if(getRealLeft(e)+ e.offsetWidth + document.getElementById('subMenu'+id).offsetWidth >document.body.offsetWidth)
    	document.getElementById('subMenu'+id).style.left = getRealLeft(e) - document.getElementById('subMenu'+id).offsetWidth;
    
    if(getRealTop(e)+ e.offsetHeight + document.getElementById('subMenu'+id).offsetHeight >document.body.offsetHeight)
    	document.getElementById('subMenu'+id).style.top = getRealTop(e) - document.getElementById('subMenu'+id).offsetHeight;
    
    document.getElementById('subMenu'+id).style.visibility="visible";
    for(var i=0;i<2;i++) //modify by xdhou in 2003/09/23 old:for(var i=0;i<8;i++) 注意：随着subMenu的length而定
    {
        if(i!=id)
            document.getElementById('subMenu'+i).style.visibility="hidden";
    }
}

function getRealTop(imgElem) {
    yPos = eval(imgElem).offsetTop;
    tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) {
        yPos += tempEl.offsetTop;
        tempEl = tempEl.offsetParent;
    }
    return yPos;
}
function getRealLeft(imgElem){
    xPos = eval(imgElem).offsetLeft;
    tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) {
        xPos += tempEl.offsetLeft;
        tempEl = tempEl.offsetParent;
    }
    return xPos;
}
</script>

<script type="text/javascript">
var dDate = new Date();
var dCurMonth = dDate.getMonth();
var dCurDayOfMonth = dDate.getDate();
var dCurYear = dDate.getFullYear();
var objPrevElement = new Object();
</script>


<BODY class="pagebackground" leftmargin="0" topmargin="0">
<table border="0" align='center' width='100%' >
<form name="frmCalendarSample" method="post" action="">
<tr>
<td align='right' onMouseOver="showlayer(0,this)" height=28>
<input type="hidden" id="calSelectedDate" name="calSelectedDate" value="">
<select id="tbSelYear" name="tbSelYear" onchange='drawHtmlToObject(document.getElementById("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, "11px", "", 1))'>
<%
	int i;
	for(i=2000;i<=2015;i++){
%>	
		<option value="<%=i%>"><%=i%></option>
<%
	}
%>
</select>

<select id="tbSelMonth" name="tbSelMonth" onchange='drawHtmlToObject(document.getElementById("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, "11px", "", 1))'>
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
</form>
</table>

<div id="subMenu0" style="position:absolute; left:0px; top:0px; visibility:hidden">
</div>
<div id="subMenu1" style="position:absolute; left:0px; top:0px; width:80px; visibility:hidden" onMouseOver='showlayer(0,this)'>
</div>
<script type="text/javascript">

var dCurDate = new Date();


frmCalendarSample.tbSelMonth.options[dCurDate.getMonth()].selected = true;

for (var i = 0; i < frmCalendarSample.tbSelYear.length; i++)
if (frmCalendarSample.tbSelYear.options[i].value == dCurDate.getFullYear())
frmCalendarSample.tbSelYear.options[i].selected = true;

if(dCurDate.getDate()<10)
	document.getElementById("calSelectedDate").value = "0"+dCurDate.getDate();
else
	document.getElementById("calSelectedDate").value = dCurDate.getDate();


drawHtmlToObject(document.getElementById("MyCalendar"),amarsoft2Real(fDrawCal(dCurDate.getFullYear(), dCurDate.getMonth()+1, 30, 20, "11px", "", 1)));
</script>

<%@ include file="/IncludeEnd.jsp"%>