<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "交易信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("Acct_Transaction",Sqlca);
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(20); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
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
		//6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","新增交易","新增交易","newTransaction()",sResourcesPath},
			{"true","","Button","记账","记账交易","runTransaction()",sResourcesPath},
			{"true","","Button","冲账","冲账交易","reverseTransaction()",sResourcesPath},
			{"true","","Button","交易详情","交易详情","viewTransaction()",sResourcesPath},
			{"true","","Button","删除","删除","deleteTransaction()",sResourcesPath},
			{"true","","Button","凭证打印","凭证打印","printDocument()",sResourcesPath},
		};

	if(loan==null){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
	}
		
	%>
<%/*~END~*/%>

<%
	String businessDate = "";
	if(null!=loan){
		businessDate = loan.getString("BusinessDate");
	}
	if(!"".equals(businessDate)){
%>	
		
		<table>
		 	 <tr align="right">
		 	 	<td align="right"> 
		 	 		<font color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 	 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 	 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 	 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 	 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当前日期：<%=businessDate%></font>
		 		</td>
		 	  </tr>
		</table>
<%
	}
%>	


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<script language=javascript>
	//更多交易列表 
	function newTransaction(){
		var returnValue = setObjectValue("SelectLoanSimulationTransCode","","",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "_CANCEL_" || returnValue == "_NONE_" || returnValue == "_CLEAR_" ) return;
		returnValue=returnValue.split("@");
		var transCode=returnValue[0];
		var transDate = "<%=businessDate%>";
		if(transCode=="9090"){
			transDate = PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth=20;dialogheight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(transDate)=="undefined" || transDate.length==0) return;
		}
		var returnValue = PopPage("/Accounting/LoanSimulation/CreateTransaction.jsp?TransDate="+transDate+"&TransCode="+transCode,"","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		returnValue=returnValue.split("@");
		if(returnValue[0]=="true"){
			OpenComp("ACCT_LoanSimulationTransInfo","/Accounting/LoanSimulation/TransactionInfo.jsp","SerialNo="+returnValue[1],"_blank",OpenStyle);
			reloadSelf();
		}
	}
	
	function runTransaction2(transcode,documenttype,documentno,transDate){
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction.jsp?TransDate="+transDate+"&TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("交易执行成功！");
		reloadSelf();
	}
	
	function runTransaction1(transSerialNo){
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction.jsp?TransactionSerialNo="+transSerialNo,"","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("交易执行成功！");
		reloadSelf();
	}
	
	// 记账
	function runTransaction(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var status = getItemValue(0,getRow(),"TransStatus");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(status!="0"){
			alert("交易状态不正确，请选择未记账的交易！");
			return;
		}
		runTransaction1(serialNo);
	}

	//详情
	function viewTransaction(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenComp("ACCT_LoanSimulationTransInfo","/Accounting/LoanSimulation/TransactionInfo.jsp","SerialNo="+serialNo,"_blank",OpenStyle);
	}

	function deleteTransaction(){
		var status = getItemValue(0,getRow(),"TransStatus");
		if (typeof(status) == "undefined" || status.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (status!="0"){
			alert("交易不是未记账状态，不允许删除！");
			return;
		}
		deleteBusinessObjectFromSession('<%=BUSINESSOBJECT_CONSTATNTS.transaction%>','SerialNo');
	}

	// 冲账
	function reverseTransaction(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var status = getItemValue(0,getRow(),"TransStatus");
		if(status!="1"){
			alert("请选择生效的交易进行冲帐！");
			return;
		}
		var value = PopPage("/CreditManage/CreditConsult/SetoffTransaction.jsp?SerialNo="+serialNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:yes;status:no;statusbar:no");
		if(value=="true"){ 
			alert("冲帐成功！");
			reloadSelf();
		}
		else  alert("冲帐失败！");
	}

	
	function printDocument(){
		alert("自行开发功能，如不需要可屏蔽！");
	}
</script>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/businessobject.js"> </script>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	<%
		out.print(DWExtendedFunctions.setDataWindowValues(loan,loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.transaction), dwTemp,Sqlca) );
	%>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>