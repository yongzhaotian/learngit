<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu 2005.01.21
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
					2005.7.28  hxli  ���ù���������������
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;
	String sAction; //������
	ASResultSet rs;
	
	//����������	
	sAction =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Action"));
	if(sAction==null) sAction="";
	//���ҳ�����	
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


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	String sHeaders[][] = {
							{"CustomerID","�ͻ����"},
							{"EnterpriseName","�ͻ�����"},
							{"ReportDate","��������"},
							{"IndustryType","��ҵ"},
						  };

	sSql = "select distinct EI.CustomerID,EI.EnterpriseName,EI.IndustryType,RR.ReportDate from ENT_INFO EI,REPORT_RECORD RR where RR.ObjectType='CustomerFS' and  RR.ObjectNo=EI.CustomerID ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ò��ɼ���
	doTemp.setVisible("IndustryType",false);
	//���÷��
	doTemp.setHTMLStyle("EnterpriseName","style={width:200px}");
	//����������
	doTemp.setDDDWCode("IndustryType","IndustryType");
	//���ù�����  hxli 2005.7.28
	doTemp.setFilter(Sqlca,"1","ReportDate","HtmlTemplate=Date;DefaultOperator=BetweenString;DefaultValues=@"+StringFunction.getToday());
	doTemp.setFilter(Sqlca,"2","IndustryType","DefaultOperator=BeginsWith");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	doTemp.WhereClause += sWhere;

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","���ΪԤ����Ϣ","���ΪԤ����Ϣ","markAsAlert()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
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
				<!--��ѯ��-->
				<%
				if(sFilterHTML!=null && !sFilterHTML.equals(""))
				{
					%>
						<table border="1" bordercolorlight='#99999' bordercolordark='#FFFFFF' width="100%" height="100%" cellspacing="0" cellpadding="3">
						<tr>
						<td class="FilterHeaderTd">
						<a href="javascript:submitFilterForm('DOFilter')">[��ѯ]</a>
						<a href="javascript:clearFilterForm('DOFilter')">[���]</a>
						<a href="javascript:resetFilterForm('DOFilter')">[�ָ�]</a>
						<a href="javascript:hideFilterArea()">[ȡ��]</a>
						<a href="javascript:importWatcher()">[����]</a>
						<a href="javascript:exportWatcher()">[���Ϊ]</a>
						&nbsp;&nbsp;&nbsp;&nbsp; <span class="DOFilterHint">�������ѯ���������������ѯ����</span>
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
									
									<td>��</td>
									<td><input type=text name="ROW_<%=SpecialTools.real2Amarsoft(sFSItems[i][1])%>_FROM" value="<%=SpecialTools.real2Amarsoft(sFSDatas[i][0])%>"  <%=SpecialTools.amarsoft2Real(sFSItems[i][4])%>></td>
									<td <%=(sFSItems[i][4]!=null && sFSItems[i][4].toUpperCase().indexOf("READONLY")>=0)?"style={display:none}":""%>>��</td>
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
						<input type=submit value="��ѯ">
						<input type=button onclick="clearFilterForm('DOFilter')" value="���">
						<input type=button onclick="resetFilterForm('DOFilter')" value="�ָ�">
						<input type=button onclick="hideFilterArea()" value="ȡ��">
						<input type=button onclick="importWatcher()" value="����">
						<input type=button onclick="exportWatcher()" value="���Ϊ">
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


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sExampleID = getItemValue(0,getRow(),"ExampleID");
		
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")) 
		{
			//as_del(myiframename);
			as_save(myiframe0);  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
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


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
