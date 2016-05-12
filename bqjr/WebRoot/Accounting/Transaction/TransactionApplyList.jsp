<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.accounting.config.loader.*" %>

	<%
	String PG_TITLE = "核算交易定义列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	
	%> 
	<%@include file="/Common/WorkFlow/ApplyList.jsp"%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	<script language=javascript>

	/*~[Describe=新增交易申请;InputParam=无;OutPutParam=无;]~*/
	
	var tempTransCode = "";
	function createTask(){
		var transactionDate="";
		<%
		if(transactionFilter.indexOf("@")<0&&transactionFilter.trim().length()>0&&!transactionFilter.equalsIgnoreCase("All"))
		{
		%>
			var transactionCode = "<%=transactionFilter%>";
			var transObjectSelector = "<%=TransactionConfig.getTransactionDef(transactionFilter).getString("ObjectSelector")%>";
		<%
		}
		else{
		%>
			if("<%=transactionFilter%>"=="3530"){
				var transactionCode ="<%=transactionFilter%>";
				tempTransCode = transactionCode;
			}else{
				var paraString = "TransactionFilter,<%=transactionFilter%>,UserID,<%=CurUser.getUserID()%>";
				var returnValue = setObjectValue("SelectTransactionCode",paraString,"",0,0,"");
				if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
				{
					return;
				}
				returnValue = returnValue.split("@");
				var transactionCode = returnValue[0];
				tempTransCode = transactionCode;
			}
			
		<%
		}
		%>
		
		
		var relativeObjectType = "";
		var relativeObjectNo = "";
			
		var transObjectSelector = RunMethod("PublicMethod","GetColValue","Attribute5,CODE_LIBRARY,String@CodeNo@T_Transaction_Def@String@ItemNo@"+transactionCode);

		if(typeof(transObjectSelector) == "undefined" || transObjectSelector.length == 0){
			relativeObjectType = "";
			relativeObjectNo = "";
			return;
		}
		else{
			try{
				var returnValue = eval(transObjectSelector.split("@")[1]);
				if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_"){
					return;
				}
				relativeObjectType = returnValue.split("@")[0];
				relativeObjectNo = returnValue.split("@")[1];
			}
			catch(e){
				//alert("交易{"+transactionCode+"}定义的对象选择器调用失败，请检查Code_Library的Attribute5!");
				return;
			}
		}
		//CCS-953 提前还款、退货、费用减免相互判断是否有交易进行中
		var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+relativeObjectNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			return;
		}//CCS-953 END
		var objectType="<%=sApplyType%>";
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
		if(returnValue.substring(0,5) != "true@") {
			alert("创建交易失败！错误原因-"+returnValue);
			return;
		}
		returnValue = returnValue.split("@");
		var transactionSerialNo = returnValue[1];
		if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
			alert("创建交易失败！错误原因-"+returnValue);
			return;
		}
			
		 if(transactionCode=="0090" || transactionCode=="2012" || transactionCode=="0110" || transactionCode=="2011" || transactionCode=="3530" || transactionCode=="0052" ){
			 var sContractSerialNo = "";
			 if(transactionCode=="3530"){
				 var sLoanSerialNo = RunMethod("公用方法", "GetColValue", "acct_fee,objectno,serialno='"+relativeObjectNo+"'");
				sContractSerialNo = RunMethod("公用方法", "GetColValue", "acct_loan,putoutno,serialno='"+sLoanSerialNo+"'");//通过费用流水获取合同号码
			 }else{
				sContractSerialNo = RunMethod("公用方法", "GetColValue", "acct_loan,putoutno,serialno='"+relativeObjectNo+"'");//通过借据获取合同号码
			 }
			 sCompID = "CreditTab";
			sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
			sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&Flag=010&ContractSerialNo="+sContractSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}else{ 
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		reloadSelf();
		
	}

	/*~[Describe=交易详情;InputParam=无;OutPutParam=无;]~*/
	function viewTask(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sTransCode = getItemValue(0,getRow(),"TransCode");
		var BCSerialno = getItemValue(0,getRow(),"BCSerialno");
		var sLoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		 if(sTransCode=="0090" || sTransCode=="2012" || sTransCode=="0110" || sTransCode=="3530" || sTransCode=="2011" || sTransCode=="0052"){
			 if(sTransCode!="3530"){
				 BCSerialno =  RunMethod("公用方法", "GetColValue", "acct_loan,putoutno,serialno='"+sLoanSerialNo+"'");
			 }
			 sCompID = "CreditTab";
			sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
			sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo+"&ContractSerialNo="+BCSerialno+"&Flag=<%=sPhaseType%>";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}else{ 
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		reloadSelf();
	}

	/*~[Describe=取消任务;InputParam=无;OutPutParam=无;]~*/
	function cancelApply(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		var sTransCode = getItemValue(0,getRow(),"TransCode");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('70'))){ //您真的想取消该信息吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
		
		if(sTransCode=="3530"){
			RunMethod("BusinessManage","DeleteFeeWaiveApply",sObjectNo);
		}
		reloadSelf();//解决连续多次取消时报错
	}
	
	//交易执行
	function runTransaction(){
		var transactionSerialNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(transactionSerialNo)=="undefined"||transactionSerialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		var sTransStatus = getItemValue(0,getRow(),"TransStatus");
		if(sTransStatus =="1"){
			alert("已经记账成功!");
			return;
		}
		var sReturn = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,Y");
		if(typeof(sReturn)=="undefined"||sReturn.length==0){
			alert("系统处理异常！");
			return;
		}
		alert(sReturn.split("@")[1]);
		reloadSelf();
	}
	
	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit(){
		//add by hwang,新增获取参数sApplyType1申请类型
		//获得申请类型、申请流水号、流程编号、阶段编号、申请类型
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		var sTransCode = getItemValue(0,getRow(),"TransCode");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);		
		if(sNewPhaseNo != sPhaseNo) {
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}

		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		} 
		
		//进行风险智能探测
		
		<%-- var sReturn = autoRiskScan("017","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ApplyType1="+sApplyType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo+"&TransCode="+sTransCode);
		if(sReturn != true){
			return;
		} --%>

		if (sFlowNo == "TransactionFlow" && sApplyType1=="TransactionApply") {	// 利息减免校验
			var sPsSerialNo = RunMethod("公用方法", "GetColValue", "ACCT_PAYMENT_LOG,PSSERIALNO, SERIALNO IN(SELECT DOCUMENTSERIALNO FROM ACCT_TRANSACTION WHERE SERIALNO='"+sObjectNo+"' AND RELATIVEOBJECTTYPE='jbo.app.ACCT_LOAN' AND DOCUMENTTYPE='jbo.app.ACCT_PAYMENT_LOG')");
			if (sPsSerialNo=="Null" || sPsSerialNo.length==0) {
				alert("请选择还款计划流水！");
				return;
			}
		} else if (sFlowNo == "TransFeeFlow" && sApplyType1=="TransFeeApply") {	// 费用减免校验
			var sIsSave = RunMethod("公用方法", "GetColValue", "ACCT_FEE_LOG,SEQID,SERIALNO=(SELECT DOCUMENTSERIALNO FROM ACCT_TRANSACTION WHERE SERIALNO='"+sObjectNo+"')");
			//alert(sObjectNo+"|"+sSignOpinion+"|"+sIsSave+"|"+sIsSave.length+"|");
			
			if (sIsSave=="Null" || sIsSave.length==0) {
				alert("还未选择减免其次！");
				return;
			}
		}
		
		var sSignOpinion = RunMethod("公用方法", "GetColValue", "FLOW_OPINION,PHASEOPINION,serialno=(SELECT max(serialno) FROM FLOW_TASK WHERE OBJECTNO='"+sObjectNo+"')");
		
		if (sSignOpinion == "Null") {
			alert("请先签署意见再提交！");
			return;
		}
		
		//弹出审批提交选择窗口		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//提交成功！
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
	}
	
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function signOpinion(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	//收回
	function takeBack(){
		//所收回任务的流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = RunMethod("WorkFlowEngine","GetInitPahseNo",sObjectType+","+sObjectNo);
		//获取任务流水号
		var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
			if(confirm(getBusinessMessage('498'))){ //确认收回该笔业务吗？
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				//收回成功后才刷新页面
				if(sRetValue == "Commit"){
					reloadSelf();
				}
			}
		}else{
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}				
	}
	
	/*~[Describe=打印交易单据;InputParam=无;OutPutParam=无;]~*/
	function printBill(){
		var transactionSerialNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(transactionSerialNo)=="undefined"||transactionSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	 	var rtn = RunMethod("BusinessManage","GenerateEDoc","GeneralLedger,"+transactionSerialNo+",KJPZ_1,<%=CurOrg.getOrgID()%>");
	 	if(rtn=="true"){
			var sReturn = RunMethod("Insure","CheckPrintSerialNo",transactionSerialNo+",GeneralLedger,KJPZ_1");
			OpenComp("EDOCView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn,"_blank","");
	 	}else{
			alert("格式化文档生成失败");
	 	}
	}

	
	/*~[Describe=选择贷款信息;InputParam=无;OutPutParam=无;]~*/
	function selectTransObject(objectType,selectorname)//选择贷款
	{
		var s=setObjectValue(selectorname,"OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return objectType+"@"+serialNo;
	}

	function SelectFeeRecieve()//选择收取费用
	{
		var sTransCode = tempTransCode;
		tempTransCode = "";
		
		var s = setObjectValue("SelectFeeRecieve","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.fee%>@"+serialNo;
	}

	function SelectFeePay()//选择支付费用
	{
		var sTransCode = tempTransCode;
		tempTransCode = "";
		
		var s = setObjectValue("SelectFeePay","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.fee%>@"+serialNo;
	}

	function SelectWaiveFee()
	{
		var s=setObjectValue("SelectWaiveFee","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.fee%>@"+serialNo;

	}

	function SelectRefundFee()
	{
		var s=setObjectValue("SelectRefundFee","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.fee%>@"+serialNo;

	}
	
	function selectTransaction(TransCode)//选择原交易
	{
		var s=setObjectValue("SelectStrikeTransaction","OrgID,<%=CurOrg.getOrgID()%>,TransCode,"+TransCode,"",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.transaction%>@"+serialNo;

	}
	
	/*~[Describe=选择贷款信息;InputParam=无;OutPutParam=无;]~*/
	function selectLoan_FineBea()//选择贷款
	{
		var s=setObjectValue("SelectLoanFineBEA","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.loan%>@"+serialNo;
	}
	
	function selectBC(){
		var s=setObjectValue("SelectBelongContract","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.business_contract%>@"+serialNo;
	}

	//modify begin add by bhxiao 20120810
	//单证打印
	function print(){
		var sTransactionSerialNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sTransactionSerialNo)=="undefined"||sTransactionSerialNo.length==0){
			return;
		}
		//		var sBatchpaymentflag = RunMethod("BusinessInspectManage","CheckBatchPaymentFlag",sTransactionSerialNo);
	//	if(sBatchpaymentflag == '1'||sBatchpaymentflag.length == 0||typeof(sBatchpaymentflag) =="undefined"){
	//		var sDocNo = "PFR-DOC3A";
	//	}else{
	//		sDocNo = "PFR-DOC3AX";
	//		}
	    var sParemater = RunMethod("LoanAccount","GetEdocNoByTransSerialNo",sTransactionSerialNo);
	   
		//var sParemater = "@10710@10720@";
		sParemater = "@"+sParemater+"@";
		var sDocNo = setObjectValue("SelectPrintList","SortNoList,"+sParemater,"",0,0,"");
		if(typeof(sDocNo)=="undefined"||sDocNo.length==0||"_CANCEL_"==sDocNo||"_CLEAR_"==sDocNo){
			return;
		}
		if(sDocNo.indexOf("@")>-1){
			sDocNo = sDocNo.split("@")[0];
		}
		
		sReturn = RunMethod("Insure","CheckPrintSerialNo",sTransactionSerialNo+",TransactionChange,"+sDocNo);
		if(sReturn!='Null'&&sReturn.length!=0){
			if(confirm("该文档已经打印是否继续打印？")){
				rtn = RunMethod("BusinessManage","GenerateEDoc","TransactionChange,"+sTransactionSerialNo+","+sDocNo+",<%=CurOrg.getOrgID()%>");
				if(rtn=="true"){
					sReturn = RunMethod("Insure","CheckPrintSerialNo",sTransactionSerialNo+",TransactionChange,"+sDocNo);
					OpenComp("EDOCView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn,"_blank","");
			 	}else{
					alert("格式化文档生成失败");
				}
		 	}else{
		 		OpenComp("EDOCView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn,"_blank","");
		 	}
		}else{
		 	rtn = RunMethod("BusinessManage","GenerateEDoc","TransactionChange,"+sTransactionSerialNo+","+sDocNo+",<%=CurOrg.getOrgID()%>");
		 	if(rtn=="true"){
				sReturn = RunMethod("Insure","CheckPrintSerialNo",sTransactionSerialNo+",TransactionChange,"+sDocNo);
				OpenComp("EDOCView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn,"_blank","");
		 	}else{
				alert("格式化文档生成失败");
			}
		}
	}

	//打印还款凭证
	function printProof(){
		var DocumentSerialNo=getItemValue(0,getRow(),"DocumentSerialNo");
		var sDocumentType=getItemValue(0,getRow(),"DocumentType");
		if(sDocumentType!="jbo.app.ACCT_TRANS_PAYMENT"){
			alert("只有交易名称为还款的才能打印还款凭证");
			return;
		}
		if (typeof(DocumentSerialNo)=="undefined" || DocumentSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			OpenComp("TransactionPrintProof","/Accounting/Transaction/TransactionPrintProof.jsp","DocumentSerialNo="+DocumentSerialNo,"_blank","");
		}
	}
	//打印会计凭证
	function printAccounting(){
		var DocumentSerialNo=getItemValue(0,getRow(),"DocumentSerialNo");
		var sDocumentType=getItemValue(0,getRow(),"DocumentType");
		if (typeof(DocumentSerialNo)=="undefined" || DocumentSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		PopPage("/Accounting/PrintManage/PrintAccounting.jsp?DocumentType="+sDocumentType+"&TransSerialNo="+DocumentSerialNo,"","dialogWidth=730px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	//modify end
	
	</script>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>