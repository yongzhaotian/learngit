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
			if (sDataSheetTerm.equalsIgnoreCase("Year")) {//年报
				sCtrlSlt = QUERY_TERM_YEAR;
				sCtrlQry = QUERY_TERM_YEAR;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getRelativeMonth(com.amarsoft.ars.utils.DateUtils.getToday(),0,0,"yyyy"):sInputDate;
			} else if (sDataSheetTerm.equalsIgnoreCase("HalfYear")) {//半年报
				sCtrlSlt = QUERY_TERM_HALF_YEAR;
				sCtrlQry = QUERY_TERM_HALF_YEAR;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getYearInfo(com.amarsoft.ars.utils.DateUtils.getToday(),-1):sInputDate;
			} else if (sDataSheetTerm.equalsIgnoreCase("Quarter")) {//季报
				sCtrlSlt = QUERY_TERM_QUARTER;
				sCtrlQry = QUERY_TERM_QUARTER;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getQuaterInfo(com.amarsoft.ars.utils.DateUtils.getToday(),-1):sInputDate;
			} else if (sDataSheetTerm.equalsIgnoreCase("Day")) {//日报
				sCtrlSlt = QUERY_TERM_DAY;
				sCtrlQry = QUERY_TERM_DAY;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getRelativeDate(com.amarsoft.ars.utils.DateUtils.getToday(),0,0,-1):sInputDate;
			}else{//月报
				//sCtrlSlt = QUERY_TERM_MONTH;
				sNowTerm = sInputDate.length()==0?com.amarsoft.ars.utils.DateUtils.getRelativeMonth(com.amarsoft.ars.utils.DateUtils.getToday(),0,-1,"yyyy/MM"):sInputDate;
			}
%>
		<td align="right">日期:</td>
		<td align="left">
			<input type="text" readonly size="10" name="InputDate" value="<%=SpecialTools.real2Amarsoft(sNowTerm)%>" onclick="javascript:selectQueryTerm()" style="cursor: pointer;">
		</td>
<%
		}

		if (bShowOrgID) {
%>
		<td align="right">范围:</td>
		<td align="left">
		<input type="hidden" name = "OrgID" value = "<%=SpecialTools.real2Amarsoft(sOrgID.equals("")?CurOrg.getOrgID():sOrgID)%>">
		<input type="text" readonly size="18" name="OrgName" value="<%=sOrgName.equals("")?CurOrg.getOrgName():sOrgName%>" onclick="javascript:selectOrgID();" style="cursor: pointer;">
		</td>
<%
		}

		if (bShowCurrency) {
			String sCurrencyCode = "select ItemNo||','||ItemName,'  '||ItemName from CODE_LIBRARY where CodeNo = 'Currency' and (IsInUse is null or IsInUse <> '2') order by SortNo,ItemNo";
%>
		<td align="right">币种:</td>
		<td align="left">
			<select name="Currency" class="right">
				<OPTION value="C1,外币折美元">外币折美元</OPTION>
				<OPTION value="C2,本外币折人民币">本外币折人民币</OPTION>
				<%=HTMLControls.generateDropDownSelect(Sqlca,sCurrencyCode,1,2,"01,人民币")%>
			</select>
		</td>
<%
		}

		if (bShowUnit) {
%>
		<td align="right">单位:</td>
		<td align="left">
			<select name="Unit" class="right">
				<OPTION value="1">元</OPTION>
				<OPTION value="1000">千元</OPTION>
				<OPTION value="10000" selected>万元</OPTION>
				<OPTION value="1000000" >百万元</OPTION>
				<OPTION value="100000000">亿元</OPTION>
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
			}else{//默认为与报表频度一致sCtrlSlt
				//selected[0]="selected";
				selected[Integer.parseInt(sQueryTerm)]="selected";
				//sCtrlSlt = sQueryTerm;
				sCtrlQry = sQueryTerm;
			}
%>
		<td align="right" colspan="3">类型:</td>
		<td align="left" colspan="3">
			<select name="QueryTerm" class="right" onchange="javascript:changeQureyTerm()">
				<OPTION value="<%=QUERY_TERM_MONTH%>"     <%=selected[1]%> >月报</OPTION>
				<OPTION value="<%=QUERY_TERM_QUARTER%>"   <%=selected[2]%> >季报</OPTION>
				<OPTION value="<%=QUERY_TERM_HALF_YEAR%>" <%=selected[3]%> >半年报</OPTION>
				<OPTION value="<%=QUERY_TERM_YEAR%>"      <%=selected[4]%> >年报</OPTION>
			</select>
		</td>
<%
		}
%>
		<td>
			<input type="button" value="查看" onclick="javascript:doSubmit()">&nbsp;
			<input type="button" name="Export" value="导出当前" onclick="javascript:exportExcel()">&nbsp;
<%	
		//if(dataSheet.hasAdminRole()){
%>
			<input type="button" value="重新统计" onclick="javascript:setRegenerateFlag()">
<%
		//}
%>
		</td>
<%
	//ars3 新增部分--分页操作按钮控制生成
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
		<%/*1、改变查询时间
		    2、改变触发月份选择
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
	   * 比较两个上报频度的时间大小
	   * 4[3|2|1|0] 报表为年报但选了比年小的上报频度
	   * 3[2|1|0]   报表为半年报但选了比年小的上报频度
	   * 2[1|0]		报表为季报但选了比年小的上报频度
	   * 1[0]		报表为月报但选了比年小的上报频度
	   */%>
	function compareQueryTerm(ctrlslt,ctrlqry){
		var errcode="000";
		if(ctrlslt==<%=QUERY_TERM_YEAR%>	 && ctrlqry<ctrlslt) {
			alert("报表为年报但选择了年以下的上报频度.");
			errcode="100";
		}
		if(ctrlslt==<%=QUERY_TERM_HALF_YEAR%>&& ctrlqry<ctrlslt) {
			alert("报表为半年报但选择了半年以下的上报频度.");
			errcode="011";
		}
		if(ctrlslt==<%=QUERY_TERM_QUARTER%>	 && ctrlqry<ctrlslt) {
			alert("报表为季报但选择了季以下的上报频度.");
			errcode="010";
		}
		if(ctrlslt==<%=QUERY_TERM_MONTH%>	 && ctrlqry<ctrlslt) {
			alert("报表为月报但选择了月以下的上报频度.");
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
			alert("没有选择相应的查询机构。");
			return;
		}
		if(typeof(sDateValue) == "undefined" || sDateValue.length == 0){
			alert("您没有选统计日期!!");
			return false;
		}else{
/*可见控制区*/
			div_owc.style.display="none";
			div_param.style.display="none";
			div_process.style.display="block";
/*可见控制区*/
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
            //Filename  可选。指定保存文件的文件名。如果不指定该参数，将在用户临时文件夹中创建临时文件（临时文件夹的位置因操作系统而异）。
                    //如果 Action 参数设置为 ssExportActionNone，则必须指定该参数。
            //Action    SheetExportActionEnum 类型，可选。指定是否将工作表保存为文件。如果不指定该参数，则在 Microsoft Excel 中打开工作表。
                    //如果用户计算机上没有安装 Excel，则显示警告。
            //Format SheetExportFormat 类型，可选。指定导出电子表格时所用的格式
            Sheet1.Export("<%=sSheetTitle%>.xls",c.ssExportActionOpenInExcel,c.ssExportXMLSpreadsheet);        //owc11
        }catch(exception){
            //alert(exception);
        }
	}
</script>
<%
	}
%>
