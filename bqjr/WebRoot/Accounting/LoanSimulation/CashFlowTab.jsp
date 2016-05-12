<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
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

	//获得页面参数	
	String LoanType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanType")));

	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");
	String rightType = "ReadOnly";//打开页面权限 
	List<BusinessObject> boList = simulationObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
	if(boList!=null&&boList.size() == 1 && "01".equals(boList.get(0).getString("PaymentMethod"))) rightType = "";//等额本息时可以修改
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
  	String sIframeName = "TabContentFrameArr";
	String sTabStrip[][] = {
		{"","还款计划","viewPaymentSchedule()"},
		//{"","费用计划","doTabAction(\'"+BUSINESSOBJECT_CONSTATNTS.fee_schedule+"@PaymentScheduleAcctFeeList\')"},
	
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
		var objectType = tabaction.split("@")[0];
		var templeteNo = tabaction.split("@")[1];
		OpenComp("BusinessObjectList","/Accounting/LoanSimulation/BusinessObjectList.jsp","ObjectType="+objectType+"&TempleteNo="+templeteNo,"<%=sIframeName%>");
	}
	
	function viewPaymentSchedule(){
		//OpenComp("PaymentScheduleList","/Accounting/LoanSimulation/PaymentScheduleList.jsp","ObjectType=<%=BUSINESSOBJECT_CONSTATNTS.payment_schedule%>&RightType=<%=rightType%>","<%=sIframeName%>");
		if("<%=LoanType%>"=="XFD"){
			OpenComp("PaymentScheduleList","/Accounting/LoanSimulation/PaymentScheduleList_XFD.jsp","ObjectType=<%=BUSINESSOBJECT_CONSTATNTS.payment_schedule%>&RightType=<%=rightType%>","_self");
		}else{
			OpenComp("PaymentScheduleList","/Accounting/LoanSimulation/PaymentScheduleList_HH.jsp","ObjectType=<%=BUSINESSOBJECT_CONSTATNTS.payment_schedule%>&RightType=<%=rightType%>","<%=sIframeName%>");
		}
		
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
	viewPaymentSchedule();
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>