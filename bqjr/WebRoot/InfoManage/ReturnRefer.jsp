<%
/* Author: 
 * Tester:
 *
 * Content: ����ƻ�
 * Input Param:
 *
 * Output param:
 *             
 * History Log: 1�� modified by zllin ��������ƻ������е�ָ���ڴβ�ѯ���״ηſ�����ۿ��ղ�ͬʱ���״οۿ�ʱ����Ϣ�ۼ�
 				2��modifed by xhgao ����������򣬷ŵ�ALS6��Ʒ
 *              
 */
 %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%!
	/**�ж�s�Ƿ�δ��
	 */
	public String isNull(String s, String s1){
		if(s == null || s.length() == 0){
			return s1;
		}
		return s;
	}
%>
<head>
<title>����ƻ�</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onBeforeUnload="reloadOpener();" onKeyUp="javascript:consult()">

<%
	String sReturnType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReturnType"));	//���ʽ
	String sReleaseDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReleaseDate"));	//��������
	String sFirstDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FirstDate"));		//�״οۿ�����
	String sLoanBJ = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanBJ"));			//�����
	String sLoanYL = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanYL"));			//������
	String sLoanQX = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanQX"));			//��������
	String sLoanQS1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanQS1"));			//��ѯ����
	String sLoanQS2 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanQS2"));			//��ѯ����
	String sURL = "ReturnRefer.jsp?rand="+java.lang.Math.random();

	sReturnType	 = isNull(sReturnType,"1");
	sReleaseDate = isNull(sReleaseDate,"");
	sFirstDate   = isNull(sFirstDate,"");
	sLoanBJ      = isNull(sLoanBJ,"0");
	sLoanYL      = isNull(sLoanYL,"0");
	sLoanQX      = isNull(sLoanQX,"0");
	sLoanQS1     = isNull(sLoanQS1,"0");
	sLoanQS2     = isNull(sLoanQS2,"0");
	String sReturnTypeName = sReturnType.equals("2")?"�ȶ��":"�ȶϢ";

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
				<tr><td>���ʽ��</td>
					<td><select name="ReturnType" style='FONT-SIZE: 9pt;border-style:groove;text-align:left;width:80pt;height:13pt'>
							<option value="1" <%=sReturnType.equals("1")?"selected":""%>>�ȶϢ</option>
							<option value="2" <%=sReturnType.equals("2")?"selected":""%> >�ȶ��</option>
						</select>
					</td>
				</tr>
				<tr><td>�������ڣ�</td>
					<td><input readonly="true" value="<%=sReleaseDate%>" type=text name="ReleaseDate" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:left;width:90pt;height:13pt;cursor:pointer;background:#EEEEff' 
							onclick="selectReleaseDate();" size=1>
					</td>
				</tr>
				<tr><td>�״οۿ��գ�</td>
					<td><input readonly="true" value="<%=sFirstDate%>" type=text name="FirstDate" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:left;width:90pt;height:13pt;cursor:pointer;background:#EEEEff' 
							onclick="selectFirstDate();" size=1>
					</td>
				</tr>
				<tr><td>�����</td>
					<td><input  type=text value="<%=sLoanBJ%>" name="LoanBJ" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt' size=1>��Ԫ
					</td>
				</tr>
				<tr><td>�����ʣ�</td>
					<td><input  type=text value="<%=sLoanYL%>" name="LoanYL" 
						style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt' size=1>��
					</td>
				</tr>
				<tr><td>�������ޣ�</td>
					<td><input  type=text value="<%=sLoanQX%>" name="LoanQX" 
						style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt' size=1>��
					</td>
				</tr>
				<tr><td>��ѯ������</td>
					<td><input  type=text value="<%=sLoanQS1%>" name="LoanQS1" 
							style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:38pt;height:13pt' size=1>��
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
						bordercolordark='#FFFFFF' height='22'  title='���д�����ѯ'>��ѯ
					</td>
					<td> &nbsp;&nbsp;</td>
					<!-- <td onclick="spreadsheetPrintout(document.all('Spreadsheet1').HTMLData)"
						bordercolorlight='#999999' bordercolordark='#FFFFFF' height='22'  title='��ӡ��ѯ�ƻ�'>��ӡ
					</td> -->
					<!-- ��Ϊ����excel��ӡ�ķ�ʽ add by xhgao --> 
					<td onclick="javascript:exportExcel()" 
						bordercolorlight='#999999' bordercolordark='#FFFFFF' height='22'  title='������ѯ�ƻ�'>������excel
					</td>
					<td> &nbsp;&nbsp;</td>
					<td onclick="javascript:goback()" 
						bordercolorlight='#999999' bordercolordark='#FFFFFF' height='22'  title='���ع���̨'>����
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
			alert("��Ĵ������ޱ���������");
		}else if (!reg_Num(sLoanBJ)){
			alert("��Ĵ�������������");
		}else if (!reg_Num(sLoanYL)){
			alert("��������ʱ���������");
		}else
		{
			if(sLoanBJ=="")
				alert("��Ĵ������Ϊ��");
			else if (sLoanYL=="")
               	alert("��Ĵ��������ʲ���Ϊ��");
			else if (sLoanQX.value=="")
				alert("��Ĵ������޲���Ϊ��");
			else if (!Judge_Int(sLoanQS1,sLoanQS2))
				alert("����ĵ�һ��ֵ���ܹ����ڵڶ���ֵ"+"�������������ѡ����Ĭ��Ϊȫ����ѯ");
			else
			{
				//frm.Txt_Query.value="Commit";
       			//frm.submit();
       			document.frm.submit();
			}
		}
	}
}

//��һ�����ֱ�����ڵڶ�������
function Judge_Int(iVar1,iVar2)
{
	if(reg_Int(iVar1)&& reg_Int(iVar2))
	{
		if(iVar1>iVar2)
		{	
			//alert("����ĵ�һ��ֵ���ܹ����ڵڶ���ֵ");
			return false;
		}
		else
			return true;
	}
	/*
	if ((reg_Int(iVar1)!=1 && reg_Int(iVar2)==1) || (reg_Int(iVar1)==1 && reg_Int(iVar2)!=1))
	{
		//alert("�������������ѡ����Ĭ��Ϊȫ����ѯ");
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

function reg_Int(str)//������,����true.
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

function reg_Num(str)//������,����true.
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

function judge_Date()//�ж��״οۿ����Ƿ����
{
	var sFirstDate=document.frm.FirstDate.value;
	var sReleaseDate=document.frm.ReleaseDate.value;
	if (sReleaseDate=="")
	{
	 	alert("�����÷������ڣ�");
	 	return false;
 	}
	if (sFirstDate=="")
	{
	 	alert("�������״οۿ����ڣ�");
	 	return false;
 	}
	if (sFirstDate < sReleaseDate)
 	{
	 	alert("�����״οۿ��ձ������ڷ����գ�");
	 	return false;
 	}
	/*
	var sFirstDateTime = sFirstDate.substring(0,4)+sFirstDate.substring(5,7)+sFirstDate.substring(8,10);
	var sReleaseDateTime = sReleaseDate.substring(0,4)+(parseInt(sReleaseDate.substring(5,7))+1)+sReleaseDate.substring(8,10);
	var fFirstDateTime = parseFloat(sFirstDateTime);
	var fReleaseDateTime = parseFloat(sReleaseDateTime);
	if(fFirstDateTime-fReleaseDateTime>20){		//��������һ����
		alert("����״οۿ��ղ��ô��ڷſ�����һ����");
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
        //Sheet1.ActiveSheet.Export("����ƻ���.xls",c.ssExportActionNone);//owc9~10
        //save it off to the filesystem...
        //Export(Filename, Action, Format)
        //Filename  ��ѡ��ָ�������ļ����ļ����������ָ���ò����������û���ʱ�ļ����д�����ʱ�ļ�����ʱ�ļ��е�λ�������ϵͳ���죩��
                //��� Action ��������Ϊ ssExportActionNone�������ָ���ò�����
        //Action    SheetExportActionEnum ���ͣ���ѡ��ָ���Ƿ񽫹�������Ϊ�ļ��������ָ���ò��������� Microsoft Excel �д򿪹�����
                //����û��������û�а�װ Excel������ʾ���档
        //Format SheetExportFormat ���ͣ���ѡ��ָ���������ӱ��ʱ���õĸ�ʽ
        Spreadsheet1.Export("����ƻ���.xls",c.ssExportActionOpenInExcel,c.ssExportXMLSpreadsheet);        //owc11
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

'������ʱ�ļ�
function createTemporaryFile(fileName,data)
	set objFS=CreateObject("Scripting.FileSystemObject")
	set f = objFS.CreateTextFile(fileName, True, True)
	f.write(data)
	f.close
end function

'��ӡ
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
double dLoanYHBJ = 0.0000;//Ӧ������
double dLoanYHLX = 0.0000;//Ӧ����Ϣ
double dLoanYHBJ1 = 0.0000;//�ѻ�����
double  dTemp = 0.0000;//Ӧ����Ϣ
double dLoanBXHJ = 0.0000 ;//Ӧ����Ϣ
String sFirstDate1 = "";
if(sReturnType.compareTo("") != 0)
{
//�����dLoanBJ
//�������ʣ�dLoanYL
//����������dLoanQX
//�״οۿ����ڣ�sFirstDate
//�����ڴΣ�i
//Ӧ������dLoanYHBJ
//�ѻ�����dLoanYHBJ1
//Ӧ����Ϣ��dLoanYHLX
//��Ϣ�ϼƣ�dLoanBXHJ
//Ӧ�������ڣ�sDateYHRQ

	for(int j = 0; j < iQueryMax; j++){
		//���㻹���ڣ�
		sFirstDate1 = StringFunction.getRelativeAccountMonth(sFirstDate.substring(0,7),"Month",j)+sFirstDate.substring(7,10);

		if(sReturnType.equals("1")){		//�ȶϢ��
			//����ֵ1���»����,���㹫ʽ���»����=�����*������*(1-(1/((1+������)��������(�η�))-1))
			dLoanBXHJ = dLoanBJ*10000 * (dLoanYL/1000/(1-(1/(java.lang.Math.pow((1+dLoanYL/1000),dLoanQX)))));
			//����ֵ2���»���Ϣ������ʽ���������*������
			dLoanYHBJ1 = dLoanYHBJ1+dLoanYHBJ;				//�ѻ������ۼ�
			dLoanYHLX = (dLoanBJ*10000-dLoanYHBJ1)*dLoanYL/1000;	//Ӧ����Ϣ
			if(bFirstReturn==false) {
				//��ֹ��һ��Ӧ������Ϊ����	
				//�ſ������״οۿ��ղ�ͬ���ң�������-�״οۿ��գ�>30�����Ϣ�ۼ�
			  if (iDiffDate > 30.0){
			  	dTemp = dLoanYHLX * (iDiffDate/30.0 - 1.0);
			  	dLoanBXHJ = dLoanBXHJ + dTemp ;
			  }
			  	dLoanYHLX = dLoanYHLX * (iDiffDate/30.0);
				bFirstReturn = true;
			}
			//����ֵ2���»�����������ʽ��ÿ�±�Ϣ�ϼ���-�������*������
			dLoanYHBJ = dLoanBXHJ - dLoanYHLX;	
			if (j == iQueryMax-1)
			{
			 dLoanYHBJ = dLoanBJ*10000-dLoanYHBJ1;
			 dLoanBXHJ = dLoanYHBJ+dLoanYHLX;	
			}
		}else{		//�ȶ��
			//����ֵ1���»�����̶�
			//dLoanYHBJ = dLoanBJ*10000/dLoanQX;
			//����ֵ2���»���Ϣ���
			//dLoanYHLX = (dLoanBJ*10000-i*dLoanYHBJ)*dLoanYL/1000;
			if(bFirstReturn==false) {
			//�޸ĵȶ�� �����������һ�ڻ�������
				//dLoanYHBJ = dLoanBJ*10000/dLoanQX*(iDiffDate/30.0);
				//dLoanYHLX = (dLoanBJ*10000-dLoanYHBJ)*dLoanYL/1000*(iDiffDate/30.0);
				dLoanYHBJ = dLoanBJ*10000/dLoanQX;
				dLoanYHLX = (dLoanBJ*10000)*dLoanYL/1000*(iDiffDate/30.0);
				bFirstReturn = true;
			}else{
				dLoanYHBJ = dLoanBJ*10000/dLoanQX;
				//����ֵ2���»���Ϣ���,��ʽ: �»���Ϣ = (�����-�ѻ�����)*����������  ���� �»���Ϣ = (�����-�����*�ڴ�/����)*����������
				dLoanYHLX = (dLoanBJ*10000-j*dLoanYHBJ)*dLoanYL/1000;
				//dLoanYHLX=(dLoanBJ*10000-dLoanBJ*10000*j/dLoanQX)*dLoanYL/1000;
			}
			//����ֵ3�����Ϣ�ϼ�
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
		Spreadsheet1.Cells(2,3)="<%=sReturnTypeName%>";	//���ʽ
		Spreadsheet1.Cells(4,3)="'<%=sReleaseDate%>";	//��������
		Spreadsheet1.Cells(4,5)="'<%=sFirstDate%>";		//�״οۿ���
		Spreadsheet1.Cells(3,3)="<%=sLoanBJ%>"+"��Ԫ";	//����
		Spreadsheet1.Cells(3,5)="<%=sLoanYL%>��";		//������
		Spreadsheet1.Cells(2,5)="<%=sLoanQX%>";			//��������
		
<%
	if(iQueryMax-iQueryMin>2){
	//(iQueryMax-iQueryMin+1)-2 : �������-(���ڵ�����)
%>
		//Spreadsheet1.Range("a8").InsertRows(<%=(iQueryMax-iQueryMin+1)-2%>);
		Spreadsheet1.Rows("8:<%=(iQueryMax-iQueryMin+1)-2+7%>").Insert(Spreadsheet1.Constants.xlShiftDown); //for owc11
<%
	}
	for(int k = 0; k <= (iQueryMax-iQueryMin); k++){
		//k+iQueryMin-1  : ����ָ���Ƶ�ָ������
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
