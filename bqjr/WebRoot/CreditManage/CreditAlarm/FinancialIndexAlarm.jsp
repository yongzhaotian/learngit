<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu 2005.01.21
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
					2005.7.28  hxli  设置过滤器，调整界面
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;
	String sAction; //排序编号
	ASResultSet rs;
	
	//获得组件参数	
	sAction =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Action"));
	if(sAction==null) sAction="";
	//获得页面参数	
	String sSqlFinancialItems = "select ModelNo,RowNo,RowName,RowSubject,RowAttribute from REPORT_MODEL where ModelNo='0009'";
	String sFSItems[][] = Sqlca.getStringMatrix(sSqlFinancialItems);
	String sFSDatas[][] = new String[sFSItems.length][5];
	String sWhere = " and ( 1=2 ";
	for(int i=0;i<sFSItems.length;i++)
	{
		sFSDatas[i][0] = DataConvert.toString(request.getParameter("ROW_"+sFSItems[i][1]+"_FROM"));
		sFSDatas[i][1] = DataConvert.toString(request.getParameter("ROW_"+sFSItems[i][1]+"_TO"));
		sFSDatas[i][2] = " select distinct ReportNo from REPORT_DATA where RowSubject='"+sFSItems[i][3]+"' ";
		if(sFSDatas[i][0]!=null && !sFSDatas[i][0].equals(""))
		{
			sFSDatas[i][3] = " and Col2Value>"+sFSDatas[i][0];
		}
		if(sFSDatas[i][1]!=null && !sFSDatas[i][1].equals(""))
		{
			sFSDatas[i][4] = " and Col2Value<"+sFSDatas[i][1];
		}
		if(!sFSDatas[i][0].equals("") || !sFSDatas[i][1].equals(""))
		{
			sWhere += " or ReportNo in (";
			sWhere += DataConvert.toString(sFSDatas[i][2]);
			sWhere += DataConvert.toString(sFSDatas[i][3]);
			sWhere += DataConvert.toString(sFSDatas[i][4]);
			sWhere += ")";
		}
	}
	sWhere += ")";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1";
	String sHeaders[][] = {
							{"CustomerID","客户编号"},
							{"EnterpriseName","客户名称"},
							{"ReportDate","报表日期"},
							{"IndustryType","行业"},
						  };

	sSql = "select distinct EI.CustomerID,EI.EnterpriseName,EI.IndustryType,RR.ReportDate from ENT_INFO EI,REPORT_RECORD RR where RR.ObjectType='CustomerFS' and  RR.ObjectNo=EI.CustomerID ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置不可见项
	doTemp.setVisible("IndustryType",false);
	//设置风格
	doTemp.setHTMLStyle("EnterpriseName","style={width:200px}");
	//设置下拉框
	doTemp.setDDDWCode("IndustryType","IndustryType");
	//设置过滤器  hxli 2005.7.28
	doTemp.setFilter(Sqlca,"1","ReportDate","HtmlTemplate=Date;DefaultOperator=BetweenString;DefaultValues=@"+StringFunction.getToday());
	doTemp.setFilter(Sqlca,"2","IndustryType","DefaultOperator=BeginsWith");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	doTemp.WhereClause += sWhere;

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","标记为预警信息","标记为预警信息","markAsAlert()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%
	String sPageHead = "";
	String sPageHeadPlacement = "";

if(PG_TITLE.indexOf("@")>=0){
	sPageHead = StringFunction.getSeparate(PG_TITLE,"@",1);
	sPageHeadPlacement = StringFunction.getSeparate(PG_TITLE,"@",2);
}
String sFilterHTML = (String)CurPage.getAttribute("FilterHTML");

%>
<html>
<head>
<title><%=(sPageHeadPlacement.equals("WindowTitle")?sPageHead:"")%></title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr height=1>
	    <td id="ListTitle" class="ListTitle"><%=(sPageHeadPlacement.equals("PageTitle")?sPageHead:"")%>
	    </td>
	</tr>
	<tr height=1>
		<td id="ListButtonArea" class="ListButtonArea">
			<table width=100% height=100%>
			<tr>
				<td class="FilterButtonTd" id="FilterButtonTd" width="1">
				<span id="ShowFilterButton"><img class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" name="Image1" onClick="showHideFilterArea()"></span>
				</td>
				<td class="buttonback">
				    	<table>
						<tr>
						<%
						for(int i=0;i<sButtons.length;i++){
							if(sButtons[i][0]==null || !sButtons[i][0].equals("true")) continue;
							%>
							<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,sButtons[i][1],sButtons[i][2],sButtons[i][3],sButtons[i][4],sButtons[i][5],sResourcesPath)%></td>
							<%
						}
						%>
						</tr>
				    	</table>
				</td>
			</tr>
			<tr>
				<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
				<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
				<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
				<input type=hidden name=Action value="">
				<input type=hidden name=WatcherID value="">
				<td colspan=2 id="ListCriteriaTd" class="ListCriteriaTd">
				<span id="FilterArea">
				<!--查询区-->
				<%
				if(sFilterHTML!=null && !sFilterHTML.equals(""))
				{
					%>
						<table border="1" bordercolorlight='#99999' bordercolordark='#FFFFFF' width="100%" height="100%" cellspacing="0" cellpadding="3">
						<tr>
						<td class="FilterHeaderTd">
						<a href="javascript:submitFilterForm('DOFilter')">[查询]</a>
						<a href="javascript:clearFilterForm('DOFilter')">[清空]</a>
						<a href="javascript:resetFilterForm('DOFilter')">[恢复]</a>
						<a href="javascript:hideFilterArea()">[取消]</a>
						<a href="javascript:importWatcher()">[载入]</a>
						<a href="javascript:exportWatcher()">[另存为]</a>
						&nbsp;&nbsp;&nbsp;&nbsp; <span class="DOFilterHint">请输入查询条件，并点击“查询”。</span>
						</td>
						</tr>
						<tr>
						<td>
							<table>
							<%=sFilterHTML%>
							</table>
						</td>
						</tr>
						<tr>
						<td height=150>
						<div style="overflow:auto;position:absolute;width:100%;height:100%">

							<table>
							<%
							for(int i=0;i<sFSItems.length;i++){
							%>

							<%if(sFSItems[i][4]!=null && sFSItems[i][4].toUpperCase().indexOf("READONLY")>=0){%>
								<tr bgcolor="#BBBBBB">
									<td><b><%=sFSItems[i][1]%></b></td>
									<td><b><%=sFSItems[i][2]%></b></td>
									<td colspan=4>&nbsp;</td>
								</tr>
							<%}else{%>
								<tr>
									<td><%=sFSItems[i][1]%></td>
									<td><%=sFSItems[i][2]%></td>
									
									<td>从</td>
									<td><input type=text name="ROW_<%=SpecialTools.real2Amarsoft(sFSItems[i][1])%>_FROM" value="<%=SpecialTools.real2Amarsoft(sFSDatas[i][0])%>"  <%=SpecialTools.amarsoft2Real(sFSItems[i][4])%>></td>
									<td <%=(sFSItems[i][4]!=null && sFSItems[i][4].toUpperCase().indexOf("READONLY")>=0)?"style={display:none}":""%>>到</td>
									<td <%=(sFSItems[i][4]!=null && sFSItems[i][4].toUpperCase().indexOf("READONLY")>=0)?"style={display:none}":""%>><input type=text name="ROW_<%=SpecialTools.real2Amarsoft(sFSItems[i][1])%>_TO" value="<%=SpecialTools.real2Amarsoft(sFSDatas[i][1])%>" <%=SpecialTools.amarsoft2Real(sFSItems[i][4])%> ></td>
								</tr>
							<%}%>
							<%
							}	
							%>
							</table>
						</div>

						</td>
						</tr>
						<tr>
						<td class="FilterSubmitTd">
						<input type=submit value="查询">
						<input type=button onclick="clearFilterForm('DOFilter')" value="清空">
						<input type=button onclick="resetFilterForm('DOFilter')" value="恢复">
						<input type=button onclick="hideFilterArea()" value="取消">
						<input type=button onclick="importWatcher()" value="载入">
						<input type=button onclick="exportWatcher()" value="另存为">
						</td>
						</tr>
						</table>
					<%
				}
				%>
				</span>
				</td>
				</form>
			</tr>
		</table>
	    </td>
	</tr>

	<tr>
	    <td class="ListDWArea">
			<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
	    </td>
	</tr>
	<tr>
	    <td id="ListBottomArea" class="ListBottomArea">
	    </td>
	</tr>
</table>
</body>
</html>
<script>
	var bFilterAreaShowStatus=false;
	<%
	if(sPageHeadPlacement.equals("")){
	%>
		document.getElementById("ListTitle").style.cssText += "display:none";
	<%
	}
	if(sFilterHTML==null || sFilterHTML.equals("")){
	%>
		showHideObjects("ShowFilterButton","hide");
		showHideObjects("FilterArea","hide");
		bFilterAreaShowStatus = false;
	<%
	}else{
		%>
		hideFilterArea();
		bFilterAreaShowStatus = false;	
		<%
	}
	%>
	
	function showHideFilterArea(){
		if(!bFilterAreaShowStatus){
			showFilterArea();
		}else{
			hideFilterArea();
		}
	}
	function showFilterArea()
	{
		//showHideObjects("ShowFilterButton","hide");
		showHideObjects("FilterArea","show");
		bFilterAreaShowStatus = true;
	}
	function hideFilterArea(){
		//showHideObjects("ShowFilterButton","show");
		showHideObjects("FilterArea","hide");
		bFilterAreaShowStatus = false;
	}

	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sExampleID = getItemValue(0,getRow(),"ExampleID");
		
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")) 
		{
			//as_del(myiframename);
			as_save(myiframe0);  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		openObject("Customer",sCustomerID,"001");
	}
	
	function importWatcher(){
		sReturn = popComp("WatcherSelection","/CreditManage/CreditAlarm/WatcherSelectionList.jsp","","");
	}
	
	function markAsAlert(){
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		popComp("AlertInfo","/CreditManage/CreditAlarm/AlertInfo.jsp","ObjectType=Customer&ObjectNo="+sCustomerID,"");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
