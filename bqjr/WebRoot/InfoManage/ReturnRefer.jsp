<%
/* Author: 
 * Tester:
 *
 * Content: 还款计划
 * Input Param:
 *
 * Output param:
 *             
 * History Log: 1、 modified by zllin 修正还款计划试算中的指定期次查询和首次放款日与扣款日不同时在首次扣款时的利息累计
 				2、modifed by xhgao 重新梳理程序，放到ALS6产品
 *              
 */
 %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%!
	/**判断s是否未空
	 */
	public String isNull(String s, String s1){
		if(s == null || s.length() == 0){
			return s1;
		}
		return s;
	}
%>
<head>
<title>还款计划</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onBeforeUnload="reloadOpener();" onKeyUp="javascript:consult()">

<%
	String sReturnType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReturnType"));	//还款方式
	String sReleaseDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReleaseDate"));	//发放日期
	String sFirstDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FirstDate"));		//首次扣款日期
	String sLoanBJ = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanBJ"));			//贷款本金
	String sLoanYL = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanYL"));			//月利率
	String sLoanQX = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanQX"));			//贷款期限
	String sLoanQS1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanQS1"));			//查询区间
	String sLoanQS2 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanQS2"));			//查询区间
	String sURL = "ReturnRefer.jsp?rand="+java.lang.Math.random();

	sReturnType	 = isNull(sReturnType,"1");
	sReleaseDate = isNull(sReleaseDate,"");
	sFirstDate   = isNull(sFirstDate,"");
	sLoanBJ      = isNull(sLoanBJ,"0");
	sLoanYL      = isNull(sLoanYL,"0");
	sLoanQX      = isNull(sLoanQX,"0");
	sLoanQS1     = isNull(sLoanQS1,"0");
	sLoanQS2     = isNull(sLoanQS2,"0");
	String sReturnTypeName = sReturnType.equals("2")?"等额本金":"等额本息";

	final String AS_DATE_FORMAT = "yyyy/MM/dd";
	int iDiffDate = 0;
	if(!(sReleaseDate.equals("")||sFirstDate.equals(""))){
		ASDate dReleaseDate = new ASDate(sReleaseDate);
		ASDate dFirstDate = new ASDate(sFirstDate);
		//iDiffDate = DateUtils.diffDate(sReleaseDate,sFirstDate,AS_DATE_FORMAT);
		iDiffDate = dFirstDate.getDifference(dReleaseDate);
	}
	boolean bFirstReturn = iDiffDate==0?true:false;

	double dLoanBJ = Double.parseDouble(sLoanBJ);
	double dLoanYL = Double.parseDouble(sLoanYL);
	int dLoanQX = Integer.parseInt(sLoanQX);
	int iLoanQS1 = Integer.parseInt(sLoanQS1);
	int iLoanQS2 = Integer.parseInt(sLoanQS2);
	int iQueryMax = iLoanQS2 > 0 ? iLoanQS2:dLoanQX;
	int iQueryMin = iLoanQS1 > 0 ? iLoanQS1:1;
	String[][] sQueryValue = new String[iQueryMax][5];
%>
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr height=1 valign=top id="buttonback">
    <td colpsan=3  rowspan=2 width=50%>
	<OBJECT classid="clsid:0002E559-0000-0000-C000-000000000046" height=100% id=Spreadsheet1 
		style="LEFT: 0px; TOP: 0px" width="100%" codebase="<%=sWebRootPath%>/FixStat/OWC11.DLL#version=0,0,0,0" VIEWASTEXT>
	<PARAM NAME="HTMLURL" VALUE="<%=sWebRootPath%>/InfoManage/ReturnPlan.htm">
	<PARAM NAME="DataType" VALUE="HTMLURL">
	<PARAM NAME="AutoFit" VALUE="0">
	<PARAM NAME="DisplayColHeaders" VALUE="-1">
	<PARAM NAME="DisplayGridlines" VALUE="0">
	<PARAM NAME="DisplayHorizontalScrollBar" VALUE="-1">
	<PARAM NAME="DisplayRowHeaders" VALUE="-1">
	<PARAM NAME="DisplayTitleBar" VALUE="0">
	<PARAM NAME="DisplayToolbar" VALUE="0">
	<PARAM NAME="DisplayVerticalScrollBar" VALUE="-1">
	<PARAM NAME="EnableAutoCalculate" VALUE="-1">
	<PARAM NAME="EnableEvents" VALUE="-1">
	<PARAM NAME="MoveAfterReturn" VALUE="-1">
	<PARAM NAME="MoveAfterReturnDirection" VALUE="0">
	<PARAM NAME="RightToLeft" VALUE="0">
	<PARAM NAME="ViewableRange" VALUE="1:65536">
	</OBJECT>
    </td>
    <td width="20%" height="70%" align="center">
		<form name="frm" method="post">
			<input value="" type=hidden name=Txt_Query  >
			<input value="" type=hidden name=ReturnPeriod  >
			<table>
				<tr><td>还款方式：</td>
					<td><select name="ReturnType" style='FONT-SIZE: 9pt;border-style:groove;text-align:left;width:80pt;height:13pt'>
							<option value="1" <%=sReturnType.equals("1")?"selected":""%>>等额本息</option>
							<option value="2" <%=sReturnType.equals("2")?"selected":""%> >等额本金</option>
						</select>
					</td>
				</tr>
				<tr><td>发放日期：</td>
					<td><input readonly="true" value="<%=sReleaseDate%>" type=text name="ReleaseDate" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:left;width:90pt;height:13pt;cursor:pointer;background:#EEEEff' 
							onclick="selectReleaseDate();" size=1>
					</td>
				</tr>
				<tr><td>首次扣款日：</td>
					<td><input readonly="true" value="<%=sFirstDate%>" type=text name="FirstDate" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:left;width:90pt;height:13pt;cursor:pointer;background:#EEEEff' 
							onclick="selectFirstDate();" size=1>
					</td>
				</tr>
				<tr><td>贷款本金：</td>
					<td><input  type=text value="<%=sLoanBJ%>" name="LoanBJ" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt' size=1>万元
					</td>
				</tr>
				<tr><td>月利率：</td>
					<td><input  type=text value="<%=sLoanYL%>" name="LoanYL" 
						style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt' size=1>‰
					</td>
				</tr>
				<tr><td>贷款期限：</td>
					<td><input  type=text value="<%=sLoanQX%>" name="LoanQX" 
						style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt' size=1>月
					</td>
				</tr>
				<tr><td>查询期数：</td>
					<td><input  type=text value="<%=sLoanQS1%>" name="LoanQS1" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:38pt;height:13pt' size=1>至
						<input  type=text value="<%=sLoanQS2%>" name="LoanQS2" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:38pt;height:13pt' size=1>
					</td>
				</tr>
			</table>
			<table>
			  <tr>
			  <td style="cursor: pointer;">
				<table border='1' cellspacing='0' cellpadding='3' height='100%'  background='/Resources/functionbg.gif' bordercolor='#DEDFCE'> 
				<tr align='center' background='/bank/Resources/functionbg.gif'> 
					<td onclick="javascript:loanQuery()" bordercolorlight='#999999' 
						bordercolordark='#FFFFFF' height='22'  title='进行贷款咨询'>咨询
					</td>
					<td> &nbsp;&nbsp;</td>
					<!-- <td onclick="spreadsheetPrintout(document.all('Spreadsheet1').HTMLData)"
						bordercolorlight='#999999' bordercolordark='#FFFFFF' height='22'  title='打印咨询计划'>打印
					</td> -->
					<!-- 改为导出excel打印的方式 add by xhgao --> 
					<td onclick="javascript:exportExcel()" 
						bordercolorlight='#999999' bordercolordark='#FFFFFF' height='22'  title='导出咨询计划'>导出到excel
					</td>
					<td> &nbsp;&nbsp;</td>
					<td onclick="javascript:goback()" 
						bordercolorlight='#999999' bordercolordark='#FFFFFF' height='22'  title='返回工作台'>返回
					</td>
				</tr>
				</table>
			  </tr>
			</table>
			</td>
		</form>
	  </td>
	</tr>
</table>
<iframe name=myform0 frameborder=0 width=1 height=1 style="display:none"> </iframe>

</body>
</html>

<script type="text/javascript">
var sReleaseDate,sFirstDate;
function goback(){
	window.open("<%=sWebRootPath%>/Redirector?ComponentID=Main&ComponentURL=/Main.jsp&ToDestroyAllComponent=Y","_top","");
	//self.close();
}
function selectReleaseDate()
{
	var temp="";
	sReleaseDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=235px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	if(typeof(sReleaseDate)!="undefined" && sReleaseDate!="")
	{
		document.frm.ReleaseDate.value = sReleaseDate;
	}
	//else
	//    document.frm.ReleaseDate.value = "";
}

function selectFirstDate()
{
	sFirstDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=235px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	if(typeof(sFirstDate)!="undefined" && document.frm.ReleaseDate.value!="")
	{
		document.frm.FirstDate.value = sFirstDate;
	}
	//else
	//    document.frm.FirstDate.value = "";
}

function consult()
{
	//alert(event.keyCode);
	if(event.keyCode==13) //Enter
	{
		loanQuery();
	}
}

function loanQuery()
{
	if (judge_Date())
	{
		var sLoanQX = document.frm.LoanQX.value;
		var sLoanBJ= document.frm.LoanBJ.value;
		var sLoanYL = document.frm.LoanYL.value;
		var sLoanQS1 = document.frm.LoanQS1.value;
		var sLoanQS2 = document.frm.LoanQS2.value;
		if (!reg_Int(sLoanQX)){
			alert("你的贷款期限必须是整数");
		}else if (!reg_Num(sLoanBJ)){
			alert("你的贷款本金必须是数字");
		}else if (!reg_Num(sLoanYL)){
			alert("你的月利率必须是数字");
		}else
		{
			if(sLoanBJ=="")
				alert("你的贷款本金不能为空");
			else if (sLoanYL=="")
               	alert("你的贷款月利率不能为空");
			else if (sLoanQX.value=="")
				alert("你的贷款期限不能为空");
			else if (!Judge_Int(sLoanQS1,sLoanQS2))
				alert("区间的第一个值不能够大于第二个值"+"如果不进行区间选择，则默认为全部查询");
			else
			{
				//frm.Txt_Query.value="Commit";
       			//frm.submit();
       			document.frm.submit();
			}
		}
	}
}

//第一个数字必须大于第二个数字
function Judge_Int(iVar1,iVar2)
{
	if(reg_Int(iVar1)&& reg_Int(iVar2))
	{
		if(iVar1>iVar2)
		{	
			//alert("区间的第一个值不能够大于第二个值");
			return false;
		}
		else
			return true;
	}
	/*
	if ((reg_Int(iVar1)!=1 && reg_Int(iVar2)==1) || (reg_Int(iVar1)==1 && reg_Int(iVar2)!=1))
	{
		//alert("如果不进行区间选择，则默认为全部查询");
		return false;
	}
	else
		return true;
	*/
	if(reg_Int(iVar1)&&reg_Int(iVar2)){
		return true;
	}else{
		return false;
	}
}	

function reg_Int(str)//是整数,返回true.
{
	var Letters = "1234567890";
	for (i=0;i<str.length;i++)
	{
		var CheckChar = str.charAt(i);
		if (Letters.indexOf(CheckChar) == -1)
		{
			return false;
		}
	}
	return true;
}

function reg_Num(str)//是数字,返回true.
{
	var Letters = "1234567890.";
	for (i=0;i<str.length;i++)
	{
		var CheckChar = str.charAt(i);
		if (Letters.indexOf(CheckChar) == -1)
		{
			return false;
		}
	}
	return true;
}

function judge_Date()//判断首次扣款日是否合理
{
	var sFirstDate=document.frm.FirstDate.value;
	var sReleaseDate=document.frm.ReleaseDate.value;
	if (sReleaseDate=="")
	{
	 	alert("请设置发放日期！");
	 	return false;
 	}
	if (sFirstDate=="")
	{
	 	alert("请设置首次扣款日期！");
	 	return false;
 	}
	if (sFirstDate < sReleaseDate)
 	{
	 	alert("您的首次扣款日必须晚于发放日！");
	 	return false;
 	}
	/*
	var sFirstDateTime = sFirstDate.substring(0,4)+sFirstDate.substring(5,7)+sFirstDate.substring(8,10);
	var sReleaseDateTime = sReleaseDate.substring(0,4)+(parseInt(sReleaseDate.substring(5,7))+1)+sReleaseDate.substring(8,10);
	var fFirstDateTime = parseFloat(sFirstDateTime);
	var fReleaseDateTime = parseFloat(sReleaseDateTime);
	if(fFirstDateTime-fReleaseDateTime>20){		//日期相差超过一个月
		alert("你的首次扣款日不得大于放款日期一个月");
		return false;
	}
	*/
	return true;
}

function reloadOpener(){
	try{
		top.opener.location.reload();
	}
	catch(e){
	}
}

function exportExcel(){
    try{
        var c = Spreadsheet1.Constants;
        //Sheet1.ActiveSheet.Export("还款计划表.xls",c.ssExportActionNone);//owc9~10
        //save it off to the filesystem...
        //Export(Filename, Action, Format)
        //Filename  可选。指定保存文件的文件名。如果不指定该参数，将在用户临时文件夹中创建临时文件（临时文件夹的位置因操作系统而异）。
                //如果 Action 参数设置为 ssExportActionNone，则必须指定该参数。
        //Action    SheetExportActionEnum 类型，可选。指定是否将工作表保存为文件。如果不指定该参数，则在 Microsoft Excel 中打开工作表。
                //如果用户计算机上没有安装 Excel，则显示警告。
        //Format SheetExportFormat 类型，可选。指定导出电子表格时所用的格式
        Spreadsheet1.Export("还款计划表.xls",c.ssExportActionOpenInExcel,c.ssExportXMLSpreadsheet);        //owc11
    }catch(exception){
        //alert(exception);
    }
}
</script>

<script language=vbscript>
sub DateChange(MyDate)
	dim tempDate,temp1,StringStart
	dim monthNum
	monthNum=1

	StringStart=1
	tempDate=DateAdd("m",monthNum,MyDate)
	StringStart=InStr(StringStart, tempDate, "-")
	temp1 = mid(tempDate,1,StringStart-1) + "/"
	if len(mid(tempDate,StringStart+1,InStr(StringStart+1, tempDate, "-")-StringStart-1))=1 then
		temp1=temp1+"0"
	end if
	temp1=temp1+  mid(tempDate,StringStart+1,InStr(StringStart+1, tempDate, "-")-StringStart-1)
	temp1=temp1+"/"
	if len(mid(tempDate,InStr(StringStart+1, tempDate, "-")+1))=1 then
		temp1=temp1+"0"
	end if
	temp1=temp1+mid(tempDate,InStr(StringStart+1, tempDate, "-")+1)

	document.frm.FirstDate.value = temp1
end sub

function dateplus(monthnum,dealdate)
	dim tempDate
	tempDate=DateAdd("m",monthnum,dealdate)
	StringStart=1
	StringStart=InStr(StringStart, tempDate, "-")
	temp1 = mid(tempDate,1,StringStart-1) + "/"
	if len(mid(tempDate,StringStart+1,InStr(StringStart+1, tempDate, "-")-StringStart-1))=1 then
		temp1=temp1+"0"
	end if
	temp1=temp1+  mid(tempDate,StringStart+1,InStr(StringStart+1, tempDate, "-")-StringStart-1)
	temp1=temp1+"/"
	if  len(mid(tempDate,InStr(StringStart+1, tempDate, "-")+1))=1 then
		temp1=temp1+"0"
	end if
	temp1=temp1+mid(tempDate,InStr(StringStart+1, tempDate, "-")+1)
	dateplus= temp1
end function

'创建临时文件
function createTemporaryFile(fileName,data)
	set objFS=CreateObject("Scripting.FileSystemObject")
	set f = objFS.CreateTextFile(fileName, True, True)
	f.write(data)
	f.close
end function

'打印
function spreadsheetPrintout(data)
	fileName= "c:\temporaryFile.htm"
	s = createTemporaryFile(fileName,data)

	Set xlApp = CreateObject("Excel.Application")
	Set xlBook = xlApp.Workbooks.open(fileName)

	xlBook.Sheets(1).PrintOut
	xlBook.Close
end function
</script>
<script>
<%
int i = 0;
double dLoanYHBJ = 0.0000;//应还本金
double dLoanYHLX = 0.0000;//应还利息
double dLoanYHBJ1 = 0.0000;//已还本金
double  dTemp = 0.0000;//应还本息
double dLoanBXHJ = 0.0000 ;//应还本息
String sFirstDate1 = "";
if(sReturnType.compareTo("") != 0)
{
//贷款本金：dLoanBJ
//贷款利率：dLoanYL
//贷款期数：dLoanQX
//首次扣款日期：sFirstDate
//贷款期次：i
//应还本金：dLoanYHBJ
//已还本金：dLoanYHBJ1
//应还利息：dLoanYHLX
//本息合计：dLoanBXHJ
//应还款日期：sDateYHRQ

	for(int j = 0; j < iQueryMax; j++){
		//计算还款期：
		sFirstDate1 = StringFunction.getRelativeAccountMonth(sFirstDate.substring(0,7),"Month",j)+sFirstDate.substring(7,10);

		if(sReturnType.equals("1")){		//等额本息法
			//计算值1：月还款额,计算公式：月还款额=贷款额*月利率*(1-(1/((1+月利率)还款期数(次方))-1))
			dLoanBXHJ = dLoanBJ*10000 * (dLoanYL/1000/(1-(1/(java.lang.Math.pow((1+dLoanYL/1000),dLoanQX)))));
			//计算值2：月还利息数；公式：贷款余额*月利率
			dLoanYHBJ1 = dLoanYHBJ1+dLoanYHBJ;				//已还本金累计
			dLoanYHLX = (dLoanBJ*10000-dLoanYHBJ1)*dLoanYL/1000;	//应还利息
			if(bFirstReturn==false) {
				//防止第一期应还本金为负数	
				//放款日与首次扣款日不同并且（发放日-首次扣款日）>30天的利息累计
			  if (iDiffDate > 30.0){
			  	dTemp = dLoanYHLX * (iDiffDate/30.0 - 1.0);
			  	dLoanBXHJ = dLoanBXHJ + dTemp ;
			  }
			  	dLoanYHLX = dLoanYHLX * (iDiffDate/30.0);
				bFirstReturn = true;
			}
			//计算值2：月还本金数；公式：每月本息合计数-贷款余额*月利率
			dLoanYHBJ = dLoanBXHJ - dLoanYHLX;	
			if (j == iQueryMax-1)
			{
			 dLoanYHBJ = dLoanBJ*10000-dLoanYHBJ1;
			 dLoanBXHJ = dLoanYHBJ+dLoanYHLX;	
			}
		}else{		//等额本金法
			//计算值1：月还本金固定
			//dLoanYHBJ = dLoanBJ*10000/dLoanQX;
			//计算值2：月还利息金额
			//dLoanYHLX = (dLoanBJ*10000-i*dLoanYHBJ)*dLoanYL/1000;
			if(bFirstReturn==false) {
			//修改等额本金 还款计算器第一期还款总数
				//dLoanYHBJ = dLoanBJ*10000/dLoanQX*(iDiffDate/30.0);
				//dLoanYHLX = (dLoanBJ*10000-dLoanYHBJ)*dLoanYL/1000*(iDiffDate/30.0);
				dLoanYHBJ = dLoanBJ*10000/dLoanQX;
				dLoanYHLX = (dLoanBJ*10000)*dLoanYL/1000*(iDiffDate/30.0);
				bFirstReturn = true;
			}else{
				dLoanYHBJ = dLoanBJ*10000/dLoanQX;
				//计算值2：月还利息金额,公式: 月还利息 = (贷款本金-已还本金)*贷款月利率  或者 月还利息 = (贷款本金-贷款本金*期次/期限)*贷款月利率
				dLoanYHLX = (dLoanBJ*10000-j*dLoanYHBJ)*dLoanYL/1000;
				//dLoanYHLX=(dLoanBJ*10000-dLoanBJ*10000*j/dLoanQX)*dLoanYL/1000;
			}
			//计算值3：贷款本息合计
			dLoanBXHJ = dLoanYHBJ+dLoanYHLX;
		}
		sQueryValue[j][0] = String.valueOf(j+1);
		sQueryValue[j][1] = "'" + sFirstDate1;
		//sQueryValue[j][2] = String.valueOf(dLoanBXHJ);
		//sQueryValue[j][3] = String.valueOf(dLoanYHBJ);
		//sQueryValue[j][4] = String.valueOf(dLoanYHLX);
		sQueryValue[j][2] = DataConvert.toMoney(dLoanBXHJ);
		sQueryValue[j][3] = DataConvert.toMoney(dLoanYHBJ);
		sQueryValue[j][4] = DataConvert.toMoney(dLoanYHLX);
	}

	//int iInsertRows = iQueryMax-iQueryMin>2?
%>
		Spreadsheet1.Cells(2,3)="<%=sReturnTypeName%>";	//还款方式
		Spreadsheet1.Cells(4,3)="'<%=sReleaseDate%>";	//发放日期
		Spreadsheet1.Cells(4,5)="'<%=sFirstDate%>";		//首次扣款日
		Spreadsheet1.Cells(3,3)="<%=sLoanBJ%>"+"万元";	//本金
		Spreadsheet1.Cells(3,5)="<%=sLoanYL%>‰";		//月利率
		Spreadsheet1.Cells(2,5)="<%=sLoanQX%>";			//贷款期限
		
<%
	if(iQueryMax-iQueryMin>2){
	//(iQueryMax-iQueryMin+1)-2 : 期数差额-(存在的两行)
%>
		//Spreadsheet1.Range("a8").InsertRows(<%=(iQueryMax-iQueryMin+1)-2%>);
		Spreadsheet1.Rows("8:<%=(iQueryMax-iQueryMin+1)-2+7%>").Insert(Spreadsheet1.Constants.xlShiftDown); //for owc11
<%
	}
	for(int k = 0; k <= (iQueryMax-iQueryMin); k++){
		//k+iQueryMin-1  : 数组指针移到指定期数
%>
		Spreadsheet1.Cells(<%=7 + k %>,1)="<%=sQueryValue[k+iQueryMin-1][0]%>";
		Spreadsheet1.Cells(<%=7 + k %>,2)="<%=sQueryValue[k+iQueryMin-1][1]%>";
		Spreadsheet1.Cells(<%=7 + k %>,3)="<%=sQueryValue[k+iQueryMin-1][2]%>";
		Spreadsheet1.Cells(<%=7 + k %>,4)="<%=sQueryValue[k+iQueryMin-1][3]%>";
		Spreadsheet1.Cells(<%=7 + k %>,5)="<%=sQueryValue[k+iQueryMin-1][4]%>";
<%
	}
}
%>
</script>
<%@ include file="/IncludeEnd.jsp"%>
