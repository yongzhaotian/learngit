<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content:ʾ��tabҳ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ʾ��tabҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	
	String LoanType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanType")));

	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");
	String rightType = "ReadOnly";//��ҳ��Ȩ�� 
	List<BusinessObject> boList = simulationObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
	if(boList!=null&&boList.size() == 1 && "01".equals(boList.get(0).getString("PaymentMethod"))) rightType = "";//�ȶϢʱ�����޸�
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
  	String sIframeName = "TabContentFrameArr";
	String sTabStrip[][] = {
		{"","����ƻ�","viewPaymentSchedule()"},
		//{"","���üƻ�","doTabAction(\'"+BUSINESSOBJECT_CONSTATNTS.fee_schedule+"@PaymentScheduleAcctFeeList\')"},
	
	};

	out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

	String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
	String sTabHeadStyle = "";
	String sTabHeadText = "<br>";
	String sTopRight = "";
	String sTabID = "tabtd";
	
	String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
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

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript">
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
	viewPaymentSchedule();
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>