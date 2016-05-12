<%
	if (!sDisplayCriteria.equalsIgnoreCase("False")) {
%>
<div id=div_param style="display:none">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<form method="post" name="item" action="" >
<input type="hidden" name="Rand" value=randomNumber()>
<input type="hidden" name="DisplayCriteria" value="">
<input type="hidden" name="RedoFlag" value="0">
	<tr>
<%
		if (bShowInputDate) {
			String sReportTerm,sNowTerm = "";
			if (sDataSheetTerm.equalsIgnoreCase("Year")) {//�걨
				sCtrlSlt = QUERY_TERM_YEAR;
				sCtrlQry = QUERY_TERM_YEAR;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getRelativeMonth(com.amarsoft.ars.utils.DateUtils.getToday(),0,0,"yyyy"):sInputDate;
			} else if (sDataSheetTerm.equalsIgnoreCase("HalfYear")) {//���걨
				sCtrlSlt = QUERY_TERM_HALF_YEAR;
				sCtrlQry = QUERY_TERM_HALF_YEAR;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getYearInfo(com.amarsoft.ars.utils.DateUtils.getToday(),-1):sInputDate;
			} else if (sDataSheetTerm.equalsIgnoreCase("Quarter")) {//����
				sCtrlSlt = QUERY_TERM_QUARTER;
				sCtrlQry = QUERY_TERM_QUARTER;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getQuaterInfo(com.amarsoft.ars.utils.DateUtils.getToday(),-1):sInputDate;
			} else if (sDataSheetTerm.equalsIgnoreCase("Day")) {//�ձ�
				sCtrlSlt = QUERY_TERM_DAY;
				sCtrlQry = QUERY_TERM_DAY;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getRelativeDate(com.amarsoft.ars.utils.DateUtils.getToday(),0,0,-1):sInputDate;
			}else{//�±�
				//sCtrlSlt = QUERY_TERM_MONTH;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getRelativeMonth(com.amarsoft.ars.utils.DateUtils.getToday(),0,-1,"yyyy/MM"):sInputDate;
			}
%>
		<td align="right">����:</td>
		<td align="left">
			<input type="text" readonly size="10" name="InputDate" value="<%=SpecialTools.real2Amarsoft(sNowTerm)%>" onclick="javascript:selectQueryTerm()" style="cursor: pointer;">
		</td>
<%
		}

		if (bShowOrgID) {
%>
		<td align="right">��Χ:</td>
		<td align="left">
		<input type="hidden" name = "OrgID" value = "<%=SpecialTools.real2Amarsoft(sOrgID.equals("")?CurOrg.getOrgID():sOrgID)%>">
		<input type="text" readonly size="18" name="OrgName" value="<%=sOrgName.equals("")?CurOrg.getOrgName():sOrgName%>" onclick="javascript:selectOrgID();" style="cursor: pointer;">
		</td>
<%
		}

		if (bShowCurrency) {
			String sCurrencyCode = "select ItemNo||','||ItemName,'  '||ItemName from CODE_LIBRARY where CodeNo = 'Currency' and (IsInUse is null or IsInUse <> '2') order by SortNo,ItemNo";
%>
		<td align="right">����:</td>
		<td align="left">
			<select name="Currency" class="right">
				<OPTION value="C1,�������Ԫ">�������Ԫ</OPTION>
				<OPTION value="C2,������������">������������</OPTION>
				<%=HTMLControls.generateDropDownSelect(Sqlca,sCurrencyCode,1,2,"01,�����")%>
			</select>
		</td>
<%
		}

		if (bShowUnit) {
%>
		<td align="right">��λ:</td>
		<td align="left">
			<select name="Unit" class="right">
				<OPTION value="1">Ԫ</OPTION>
				<OPTION value="1000">ǧԪ</OPTION>
				<OPTION value="10000" selected>��Ԫ</OPTION>
				<OPTION value="1000000" >����Ԫ</OPTION>
				<OPTION value="100000000">��Ԫ</OPTION>
			</select>
		</td>
<%
		}

		if (bShowQueryTerm) {
			String[] selected = new String[5];
			selected[0]="";
			selected[1]="";
			selected[2]="";
			selected[3]="";
			selected[4]="";
			if(sQueryTerm == null || sQueryTerm.equals("")){
				selected[1]="selected";
				//sCtrlQry = sQueryTerm;
			}else{//Ĭ��Ϊ�뱨��Ƶ��һ��sCtrlSlt
				//selected[0]="selected";
				selected[Integer.parseInt(sQueryTerm)]="selected";
				//sCtrlSlt = sQueryTerm;
				sCtrlQry = sQueryTerm;
			}
%>
		<td align="right" colspan="3">����:</td>
		<td align="left" colspan="3">
			<select name="QueryTerm" class="right" onchange="javascript:changeQureyTerm()">
				<OPTION value="<%=QUERY_TERM_MONTH%>"     <%=selected[1]%> >�±�</OPTION>
				<OPTION value="<%=QUERY_TERM_QUARTER%>"   <%=selected[2]%> >����</OPTION>
				<OPTION value="<%=QUERY_TERM_HALF_YEAR%>" <%=selected[3]%> >���걨</OPTION>
				<OPTION value="<%=QUERY_TERM_YEAR%>"      <%=selected[4]%> >�걨</OPTION>
			</select>
		</td>
<%
		}
%>
		<td>
			<input type="button" value="�鿴" onclick="javascript:doSubmit()">&nbsp;
			<input type="button" name="Export" value="������ǰ" onclick="javascript:exportExcel()">&nbsp;
<%	
		//if(dataSheet.hasAdminRole()){
%>
			<input type="button" value="����ͳ��" onclick="javascript:setRegenerateFlag()">
<%
		//}
%>
		</td>
<%
	//ars3 ��������--��ҳ������ť��������
	if(sInputDate.length()!=0 && dataSheet.sheetProperty().pageOutput()){
		out.println(dataSheet.genPageButtonScript());
		}
%>
	</tr>
</form>
</table>
</div>
<script type="text/javascript" src="eventfuns.js"></script>
<script type="text/javascript">
	var sCtrlSlt = "<%=sCtrlSlt%>";
	function changeQureyTerm(){
		<%/*1���ı��ѯʱ��
		    2���ı䴥���·�ѡ��
		  */%>
		document.item.InputDate.value="";
		var sCtrlQry = document.item.QueryTerm.value;
		//sCtrlSlt = sQueryTerm;
		if(compareQueryTerm("<%=sCtrlSlt%>",sCtrlQry)!="000"){
			return;
		}
		sCtrlSlt = sCtrlQry;
		
	}
	<%/* 
	   * �Ƚ������ϱ�Ƶ�ȵ�ʱ���С
	   * 4[3|2|1|0] ����Ϊ�걨��ѡ�˱���С���ϱ�Ƶ��
	   * 3[2|1|0]   ����Ϊ���걨��ѡ�˱���С���ϱ�Ƶ��
	   * 2[1|0]		����Ϊ������ѡ�˱���С���ϱ�Ƶ��
	   * 1[0]		����Ϊ�±���ѡ�˱���С���ϱ�Ƶ��
	   */%>
	function compareQueryTerm(ctrlslt,ctrlqry){
		var errcode="000";
		if(ctrlslt==<%=QUERY_TERM_YEAR%>	 && ctrlqry<ctrlslt) {
			alert("����Ϊ�걨��ѡ���������µ��ϱ�Ƶ��.");
			errcode="100";
		}
		if(ctrlslt==<%=QUERY_TERM_HALF_YEAR%>&& ctrlqry<ctrlslt) {
			alert("����Ϊ���걨��ѡ���˰������µ��ϱ�Ƶ��.");
			errcode="011";
		}
		if(ctrlslt==<%=QUERY_TERM_QUARTER%>	 && ctrlqry<ctrlslt) {
			alert("����Ϊ������ѡ���˼����µ��ϱ�Ƶ��.");
			errcode="010";
		}
		if(ctrlslt==<%=QUERY_TERM_MONTH%>	 && ctrlqry<ctrlslt) {
			alert("����Ϊ�±���ѡ���������µ��ϱ�Ƶ��.");
			errcode="001";
		}
		return errcode;
	}

	function selectQueryTerm(){
		//alert(sCtrlSlt);
		if (sCtrlSlt=="<%=QUERY_TERM_MONTH%>"){
			selectMonth();
		}else if (sCtrlSlt=="<%=QUERY_TERM_QUARTER%>"){
			selectQuarter();
		}else if (sCtrlSlt=="<%=QUERY_TERM_HALF_YEAR%>"){
			SelectHalfYear();
		}else if (sCtrlSlt=="<%=QUERY_TERM_YEAR%>"){
			selectYear();
		}else if (sCtrlSlt=="<%=QUERY_TERM_DAY%>"){
			selectDate();
		}
	}

	function doSubmit(){
		var sDateValue = document.item.InputDate.value;
		var sOrgValue = document.item.OrgID.value;
		if(sOrgValue=="") {
			alert("û��ѡ����Ӧ�Ĳ�ѯ������");
			return;
		}
		if(typeof(sDateValue) == "undefined" || sDateValue.length == 0){
			alert("��û��ѡͳ������!!");
			return false;
		}else{
/*�ɼ�������*/
			div_owc.style.display="none";
			div_param.style.display="none";
			div_process.style.display="block";
/*�ɼ�������*/
			document.forms["item"].submit();
		}
	}
	function setRegenerateFlag(){
		document.item.RedoFlag.value = "1";
		doSubmit();
	}

	function exportExcel(){
        try{
            var c = Sheet1.Constants;
            //Sheet1.ActiveSheet.Export("<%//=sSheetTitle%>.xls",c.ssExportActionNone);//owc9~10
            //save it off to the filesystem...
            //Export(Filename, Action, Format)
            //Filename  ��ѡ��ָ�������ļ����ļ����������ָ���ò����������û���ʱ�ļ����д�����ʱ�ļ�����ʱ�ļ��е�λ�������ϵͳ���죩��
                    //��� Action ��������Ϊ ssExportActionNone�������ָ���ò�����
            //Action    SheetExportActionEnum ���ͣ���ѡ��ָ���Ƿ񽫹�������Ϊ�ļ��������ָ���ò��������� Microsoft Excel �д򿪹�����
                    //����û��������û�а�װ Excel������ʾ���档
            //Format SheetExportFormat ���ͣ���ѡ��ָ���������ӱ��ʱ���õĸ�ʽ
            Sheet1.Export("<%=sSheetTitle%>.xls",c.ssExportActionOpenInExcel,c.ssExportXMLSpreadsheet);        //owc11
        }catch(exception){
            //alert(exception);
        }
	}
</script>
<%
	}
%>
