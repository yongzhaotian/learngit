<%@ page contentType="text/html; charset=GBK"%>
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
	String sReal = CurPage.getAttribute( "Real" );
	if( sReal == null ) sReal = "";

	//���ҳ�����	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	if(simulationObject==null){
		simulationObject=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_putout);
		session.setAttribute("SimulationObject_BusinessPutOut",simulationObject);
		simulationObject.setAttributeValue("SerialNo","0000001");
		simulationObject.setAttributeValue("OperateOrgID",CurOrg.getOrgID());
		simulationObject.setAttributeValue("ZxFlag","1");
	}
	//����Ƚ���������
	String simulationSchemeCount=(String)session.getValue("SimulationSchemeCount");
	if(simulationSchemeCount==null){
		session.putValue("SimulationSchemeCount","1");
		simulationSchemeCount="1";
	}
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
		//����Ϊ��
			//0.�Ƿ���ʾ
			//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
			//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.��ť����
			//4.˵������
			//5.�¼�
			//6.��ԴͼƬ·��  

		String sButtons[][] = new String[7+Integer.valueOf(simulationSchemeCount)][7];
		String s1[]={"false","","Button","�������Ϊ","�������Ϊ","saveScheme('save')",sResourcesPath};
		String s2[]={"false","","Button","��շ����б�","��շ���","saveScheme('clear')",sResourcesPath};
		for(int i=1;i<DataConvert.toInt(simulationSchemeCount);i++){
			String s3[]={"true","","Button","����"+i,"�������Ϊ","saveScheme('"+i+"')",sResourcesPath};
			sButtons[i+2]=s3;
		}
		String s4[]={"false","","Button","�����Ƚ�","�����Ƚ�","genReport()",sResourcesPath};
		String s5[]={"false","","Button","������ѯ","������ѯ","realLoanSimulation()",sResourcesPath};
		String s6[]={"true","","Button","��������","��������","saveScheme('reset')",sResourcesPath};
		String s7[]={"false","","Button","������ѯ","������ѯ","",sResourcesPath};
		String s8[]={"true","","Button","��ѯ���ҽ��","��ѯ���ҽ��","LoanTimePlan()",sResourcesPath};
		if(simulationObject!=null&&BUSINESSOBJECT_CONSTATNTS.business_putout.equals(simulationObject.getObjectType())){//˵���ѷſ���ش˰�ť
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


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script type="text/javascript">
	var putOutDate = "";
	var tabstrip = new Array();
  	<%
  	String sIframeName = "TabContentFrame";
  	String bSubAccount = sReal.equals( "yes" ) ? "true" :"false";
	String sTabStrip[][] = {
		{"","�������Ϣ","doTabAction(\'Loan\')"},
		{"","����ƻ�","doTabAction(\'PaymentSchedule\')"},
		{bSubAccount,"�ֻ�����Ϣ","doTabAction(\'"+BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger+"@SubsidiaryledgerList\')"},
		// {"","������Ϣ","doTabAction(\'TransactionList')"}
	
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
	
	// ������ѯ
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
			alert("����¼��������Ϣ������,�ٵ������ѯ��");
			return;
		}
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction.jsp?TransDate="+transDate+"&TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("����ִ�гɹ���");
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

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
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



<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript">
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
	doTabAction("Loan");
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
