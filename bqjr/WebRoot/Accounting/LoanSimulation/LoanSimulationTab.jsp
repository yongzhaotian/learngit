<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content:示例tab页面
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "示例tab页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sReal = CurPage.getAttribute( "Real" );
	if( sReal == null ) sReal = "";

	//获得页面参数	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	if(simulationObject==null){
		simulationObject=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_putout);
		session.setAttribute("SimulationObject_BusinessPutOut",simulationObject);
		simulationObject.setAttributeValue("SerialNo","0000001");
		simulationObject.setAttributeValue("OperateOrgID",CurOrg.getOrgID());
		simulationObject.setAttributeValue("ZxFlag","1");
	}
	//贷款比较所需条件
	String simulationSchemeCount=(String)session.getValue("SimulationSchemeCount");
	if(simulationSchemeCount==null){
		session.putValue("SimulationSchemeCount","1");
		simulationSchemeCount="1";
	}
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
		//依次为：
			//0.是否显示
			//1.注册目标组件号(为空则自动取当前组件)
			//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.按钮文字
			//4.说明文字
			//5.事件
			//6.资源图片路径  

		String sButtons[][] = new String[7+Integer.valueOf(simulationSchemeCount)][7];
		String s1[]={"false","","Button","方案另存为","方案另存为","saveScheme('save')",sResourcesPath};
		String s2[]={"false","","Button","清空方案列表","清空方案","saveScheme('clear')",sResourcesPath};
		for(int i=1;i<DataConvert.toInt(simulationSchemeCount);i++){
			String s3[]={"true","","Button","方案"+i,"方案另存为","saveScheme('"+i+"')",sResourcesPath};
			sButtons[i+2]=s3;
		}
		String s4[]={"false","","Button","方案比较","方案比较","genReport()",sResourcesPath};
		String s5[]={"false","","Button","存量咨询","存量咨询","realLoanSimulation()",sResourcesPath};
		String s6[]={"true","","Button","重置数据","重置数据","saveScheme('reset')",sResourcesPath};
		String s7[]={"false","","Button","贷款咨询","贷款咨询","",sResourcesPath};
		String s8[]={"true","","Button","咨询按揭金额","咨询按揭金额","LoanTimePlan()",sResourcesPath};
		if(simulationObject!=null&&BUSINESSOBJECT_CONSTATNTS.business_putout.equals(simulationObject.getObjectType())){//说明已放款，隐藏此按钮
			s7[0]="true";
			s7[5]="runTransaction2('0020','"+simulationObject.getObjectType()+"','"+simulationObject.getObjectNo()+"','"+simulationObject.getString("PutoutDate")+"')";
		}
		sButtons[0]=s1;
		sButtons[1]=s2;
		sButtons[DataConvert.toInt(simulationSchemeCount)+2]=s4;	
		sButtons[Integer.valueOf(simulationSchemeCount)+3]=s5;	
		sButtons[Integer.valueOf(simulationSchemeCount)+4]=s6;
		sButtons[Integer.valueOf(simulationSchemeCount)+5]=s7;
		sButtons[Integer.valueOf(simulationSchemeCount)+6]=s8;
		
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script type="text/javascript">
	var putOutDate = "";
	var tabstrip = new Array();
  	<%
  	String sIframeName = "TabContentFrame";
  	String bSubAccount = sReal.equals( "yes" ) ? "true" :"false";
	String sTabStrip[][] = {
		{"","贷款方案信息","doTabAction(\'Loan\')"},
		{"","还款计划","doTabAction(\'PaymentSchedule\')"},
		{bSubAccount,"分户帐信息","doTabAction(\'"+BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger+"@SubsidiaryledgerList\')"},
		// {"","交易信息","doTabAction(\'TransactionList')"}
	
	};
	
	out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

	String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
	String sTabHeadStyle = "";
	String sTabHeadText = "<br>";
	String sTopRight = "";
	String sTabID = "tabtd";
	
	String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
	String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";

	%>

	function doTabAction(tabaction){
		if(tabaction=="Loan"){
			OpenComp("ACCT_LoanSimulationBasicInfo","/Accounting/LoanSimulation/LoanBasicInfo.jsp","","<%=sIframeName%>");
		}
		else if(tabaction=="PaymentSchedule"){
			OpenComp("ACCT_LoanSimulationCashFlowTab","/Accounting/LoanSimulation/CashFlowTab.jsp","","<%=sIframeName%>");
		}
		else if(tabaction=="TransactionList"){
			OpenComp("ACCT_LoanSimulationTransList","/Accounting/LoanSimulation/TransactionList.jsp","","<%=sIframeName%>");
		}
		else{
			var objectType = tabaction.split("@")[0];
			var templeteNo = tabaction.split("@")[1];
			OpenComp("BusinessObjectList","/Accounting/LoanSimulation/BusinessObjectList.jsp","ObjectType="+objectType+"&TempleteNo="+templeteNo,"<%=sIframeName%>");
		}
		
	}
	
	function saveScheme(schemeIndicator){
		returnValue=PopPage("/Accounting/LoanSimulation/SimulationSchemeAction.jsp?SchemeIndicator="+schemeIndicator,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
		if(typeof(returnValue) == "undefined" || returnValue == "" )return;
		if(returnValue=="true"){
			OpenComp("ACCT_LoanSimulationTab","/Accounting/LoanSimulation/LoanSimulationTab.jsp","Real=no","_self");
			//reloadSelf();
		}
		else{
			alert(returnValue);
			return;
		}
	}
	
	function genReport(){
		OpenComp("ACCT_LoanSimulationReport","/Accounting/LoanSimulation/LoanSimulationReport.jsp","","_blank","");
	}
	
	// 存量咨询
	function realLoanSimulation(){
		var loanInfo = setObjectValue("SelectPayableLoan","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(loanInfo) == "undefined" || loanInfo == "_CANCEL_" || loanInfo == "_NONE_" || loanInfo == "_CLEAR_" ) return;
		var loanSerialNo = loanInfo.split("@")[0];
		PopPage("/Accounting/LoanSimulation/LoadLoan.jsp?SerialNo="+loanSerialNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
		//reloadSelf();
		OpenComp("ACCT_LoanSimulationTab","/Accounting/LoanSimulation/LoanSimulationTab.jsp","Real=yes","_self");
	}

	function runTransaction2(transcode,documenttype,documentno,transDate){		
		if("<%=simulationObject.getString("BusinessType")%>"=="null"){
			alert("请先录入贷款方案信息并保存,再点贷款咨询！");
			return;
		}
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction.jsp?TransDate="+transDate+"&TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("交易执行成功！");
		reloadSelf();
	}
	
	function LoanTimePlan(){
		PopPage("/Accounting/LoanSimulation/LoanTimePlan.jsp","","resizable=yes;dialogWidth=24;dialogHeight=16;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
	}
	function tt(){
		reloadSelf();
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" id=InfoTable>
	<tr id="ButtonTR" height="1">
		<td id="InfoButtonArea" class="InfoButtonArea">
			<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
	    </td>
	</tr>
	<tr>
		<td>
			<%@include file="/Resources/CodeParts/Tab04.jsp"%>
		</td>
	</tr>
</table>
	<script type="text/javascript">
		sButtonAreaHTML = document.getElementById("InfoButtonArea").innerHTML;
		if(sButtonAreaHTML.indexOf("hc_drawButtonWithTip")<0){
			document.getElementById("ButtonTR").style.display="none";
		}
	</script>
</body>
</html>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
	doTabAction("Loan");
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
