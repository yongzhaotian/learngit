<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.TransactionConfig"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  	--spectre	2010.03
		Tester:
		Content: 业务基本信息
		Input Param:
		Output param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "交易详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数	
	String transactionSerialNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")));

	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	BusinessObject transaction = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transactionSerialNo);
	if(transaction==null){
		throw new Exception("未找打交易{"+transactionSerialNo+"}");
	}
	String transactionStatus = transaction.getString("TransStatus");
	String transactionCode=transaction.getString("TransCode");
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%	
	//从业务申请表中获得业务品种、申请类型、循环贷款类型、还款方式
	String templeteNo = TransactionConfig.getTransactionDef(transactionCode, "ViewTempletNo");
	if(templeteNo==null||templeteNo.length()==0){//没有配置模板的交易
		templeteNo="Acct_Transaction";
	}
	ASDataObject doTemp = new ASDataObject(templeteNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	
	if(transactionStatus==null||transactionStatus.equals("0")){
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	}
	else{
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","200");
	}
	if(templeteNo.equals("Acct_Transaction")){
		doTemp.setVisible("", false);
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","10");
	}
	
	//扩张datawindow功能
	ASValuePool valuePool=new ASValuePool(); 
	valuePool.setAttribute("ProductID", loan.getString("BusinessType"));
	valuePool.setAttribute("ProductVersion", loan.getString("ProductVersion"));
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	String dwValues=DWExtendedFunctions.setDataWindowValues(transaction,transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo")), dwTemp,Sqlca);
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("TT_1,TT_1,TT_1,TT_1,TT_1");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
	String sButtons[][] = {
			{"true","","Button","保存","保存","saveBusinessObjectToSession('"+transaction.getString("DocumentType")+"','"+BUSINESSOBJECT_CONSTATNTS.transaction+"','"+transactionSerialNo+"')",sResourcesPath},
			{"true","","Button","会计分录","会计分录","viewJournalList()",sResourcesPath},
	};
	
	if(transactionStatus==null||transactionStatus.equals("0")){
		sButtons[1][0]="false";
	}
	else{
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	
	<script language=javascript>
	//分录信息
	function viewJournalList(){
		OpenPage("/Accounting/LoanSimulation/BusinessObjectList.jsp?ObjectType=<%=BUSINESSOBJECT_CONSTATNTS.subledger_detail%>&TempleteNo=LoanDetailList&ParentObjectType=<%=BUSINESSOBJECT_CONSTATNTS.transaction%>&ParentObjectNo=<%=transactionSerialNo%>","DetailFrame","");
	}
</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<%
	String jsfile=com.amarsoft.app.accounting.config.loader.TransactionConfig.getTransactionDef(transactionCode, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
		String[] s=jsfile.split("@");
		for(String s1:s){
%>
<script type="text/javascript" src="<%=sWebRootPath+s1%>"> </script>
<%		}
	}
	else{
%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/transaction/transaction.js"> </script>
<%		
	}
	%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	<%= dwValues%>
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	
	var bCheckBeforeUnload = false;
	var businessDate = "<%=SystemConfig.getBusinessDate()%>";
	var systemDate = "<%=SystemConfig.getSystemDate()%>";
	var curUserID = "<%=CurUser.getUserID()%>";
	var curUserName = "<%=CurUser.getUserName()%>";
	var curOrgID = "<%=CurOrg.getOrgID()%>";
	var curOrgName = "<%=CurOrg.getOrgName()%>";
	var documentType = "<%=transaction.getString("DocumentType")%>";
	var documentSerialNo = "<%=transaction.getString("DocumentSerialNo")%>";
	var transactionSerialNo = "<%=transaction.getString("SerialNo")%>";
	var payPrincipalAmt = "";
	var payInteAmt = "";
	var relaObjectNo = "<%=transaction.getString("RelativeObjectNo")%>";
	var relaObjectType = "<%=transaction.getString("RelativeObjectType")%>";
	initRow();
<%	if(transactionStatus!=null&&!transactionStatus.equals("0")){
%>
		viewJournalList();
<%	}
%>
</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
