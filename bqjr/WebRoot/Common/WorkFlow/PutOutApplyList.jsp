<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: 该页面主要处理放贷申请
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 重检页面 
		zywei 2007/10/10 修改取消出帐的提示语
		djia  2009/08/13 整合AmarOTI --> putOut()/putOff()
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
	<%@include file="/Common/WorkFlow/ApplyList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增放贷申请;InputParam=无;OutPutParam=无;]~*/
	function newApply()
	{
		//设置合同对象
		sObjectType = "BusinessContract";		
		//待出帐的合同信息
		sParaString = "ManageUserID"+","+"<%=CurUser.getUserID()%>"+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		sReturn = setObjectValue("SelectContractOfPutOut",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//合同流水号
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sBusinessType = sReturn[1];
		sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sObjectNo);
		if(parseFloat(sSurplusPutOutSum) <= 0) //如果合同没有可用金额，则终止出帐申请
		{	
			alert(getBusinessMessage('573'));//此业务合同已没有可用金额，不能进行放贷申请！
			return;
		}
		//当业务品种为贴现业务时，需要检验是否有票据。
		if(sBusinessType =="1020010" || sBusinessType == "1020020" || sBusinessType == "1020030"){
			sReturn = RunMethod("BusinessManage","CheckBillInfo",sObjectNo+","+sBusinessType);
			if(sReturn == "00"){
				alert("没有录入相关的票据信息，请录入后再进行出账申请！");
				return;
			}
		}
		
		//进行风险智能探测
		sReturn=RunMethod("BusinessManage","CheckContractRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != ""){
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
			//return;  //该“return”是否有效视具体业务需求而定
		}
		
		//如果贴现业务需要单张票出帐时，请项目组自行编写选择票据的列表，将所选择的汇票编号赋给sBillNo
		//产品原型中是将该贴现合同项下的票据一次性出帐
		var sBillNo="";
				
		//初始化放贷申请,返回出帐流水号
		sReturn = RunMethod("WorkFlowEngine","InitializePutOut","<%=sObjectType%>,"+sObjectNo+","+sBusinessType+","+sBillNo+",<%=CurUser.getUserID()%>,<%=sApplyType%>,<%=sInitFlowNo%>,<%=sInitPhaseNo%>,<%=CurUser.getOrgID()%>");
		if(typeof(sReturn) == "undefined" || sReturn == "") return;

		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=PutOutApply&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
			
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function cancelApply(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
				
		if(confirm(getHtmlMessage('70'))){ //您真的想取消该信息吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句			
		}
	}

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sPhaseNo != "0010" && sPhaseNo != "3000") {
			sParamString += "&ViewID=002";
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doSubmit(){
		//获得出帐类型、出帐流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");	
		var sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");	
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("该放贷申请已经提交了，不能再次提交！");//该放贷申请已经提交了，不能再次提交！
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
		isBizSort = RunMethod("BusinessManage","GetBizSort",sBusinessType);
		sUserID = getItemValue(0,getRow(),"InputUserID");
		sReturn = autoRiskScan("003","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sTaskNo+"&BusinessType="+sBusinessType+"&ContractSerialNo="+sContractSerialNo+"&IsBizSort="+isBizSort+"&BusinessSum="+sBusinessSum+"&BusinessCurrency="+sBusinessCurrency+"&UserID="+sUserID);
		if(sReturn != true){
			return;
		}
		
		//弹出审批提交选择窗口		
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&oldPhaseNo="+sPhaseNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else if (sPhaseInfo == "Working"){
			//同一用户在不同机器上登陆后，对同一笔业务同时提交到下一阶段时，可能会出现这种情况 
			alert("该放贷申请已经提交了，不能再次提交！");//处理中！
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	
	//签署意见
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
		sCompID = "SignTaskOpinion";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*~[Describe=转入贷后;InputParam=无;OutPutParam=无;]~*/
	function transToAfterLoan(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!confirm("确定转入贷后吗？")){
			return;
		}
		
		sReturn = RunMethod("WorkFlowEngine","TransToAfterLoan",sObjectType+","+sObjectNo);
		if(parseInt(sReturn) == 1){
			reloadSelf();
		}else{
			alert("转入贷后失败！");
		}
	}
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		//获得出帐类型、出帐流水号、流程编号、阶段编号
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

	/*~[Describe=归档;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		//获得出帐类型、出帐流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('56'))){ //您真的想将该信息归档吗？
			//归档操作
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_PUTOUT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getHtmlMessage('60'));//归档失败！
				return;			
			}else{
				reloadSelf();	
				alert(getHtmlMessage('57'));//归档成功！
			}			
		}
	}

	/*~[Describe=取消归档;InputParam=无;OutPutParam=无;]~*/
	function cancelarch(){
		//获得出帐类型、出帐流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('58'))){ //您真的想将该信息归档取消吗？
			//取消归档操作
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_PUTOUT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//取消归档失败！
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('59'));//取消归档成功！
			}
		}
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
		var sPhaseNo = "<%=sInitPhaseNo%>";	
		//获取任务流水号
		var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
			if(confirm(getBusinessMessage('498'))){ //确认收回该笔业务吗？
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				reloadSelf();
			}
		}else{
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}				
	}
	
	/*~[Describe=打印出帐通知书;InputParam=无;OutPutParam=无;]~*/
	function print(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		//检查出帐通知单是否已经生成
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //未生成出帐通知单
			//生成出帐通知单	
			PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?DocID="+sExchangeType+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//获得加密后的出帐流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	
	/*~[Describe=发送放款信息到核心;InputParam=无;OutPutParam=无;]~*/
	function putOut(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialno = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sOperateType = "10";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sReturn = PopPageAjax("/Common/WorkFlow/PutOutAjax.jsp?SerialNo="+sSerialno+"&BusinessType="+sBusinessType+"&OperateType="+sOperateType,"","");
		if(typeof(sReturn) != "undefined"){
			sReturn=sReturn.split("@");
	        sStatus=sReturn[0];
	        sTradeNo=sReturn[1];
	        sMessage=sReturn[2];
	    	if(sStatus == "0"){
	    		sReturn = "操作成功！交易代码："+sTradeNo;
	    	}else{
	    		sReturn = "核心提示："+sTradeNo+"交易失败！失败信息："+sMessage;
	    	}
	    	alert(sReturn);
        }
	}
	
	/*~[Describe=发送冲销信息到核心;InputParam=无;OutPutParam=无;]~*/
	function putOff(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialno = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sOperateType = "20";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sReturn = PopPageAjax("/Common/WorkFlow/PutOutAjax.jsp?SerialNo="+sSerialno+"&BusinessType="+sBusinessType+"&OperateType="+sOperateType,"","");
		if(typeof(sReturn) != "undefined"){
			sReturn=sReturn.split("@");
	        sStatus=sReturn[0];
	        sTradeNo=sReturn[1];
	        sMessage=sReturn[2];
	    	if(sStatus == "0"){
	    		sReturn = "操作成功！交易代码："+sTradeNo;
	    	}else{
	    		sReturn = "核心提示："+sTradeNo+"交易失败！失败信息："+sMessage;
	    	}
	    	alert(sReturn);
        }
	}

	/*~[Describe=发送支付信息到核心;InputParam=无;OutPutParam=无;]~*/
	function sendPayment(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialno = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sOperateType = "30";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sReturn = PopPageAjax("/Common/WorkFlow/PutOutAjax.jsp?SerialNo="+sSerialno+"&BusinessType="+sBusinessType+"&OperateType="+sOperateType,"","");
		if(typeof(sReturn) != "undefined"){
			sReturn=sReturn.split("@");
	        sStatus=sReturn[0];
	        sTradeNo=sReturn[1];
	        sMessage=sReturn[2];
	    	if(sStatus == "0"){
	    		sReturn = "操作成功！交易代码："+sTradeNo;
	    	}else{
	    		sReturn = "核心提示："+sTradeNo+"交易失败！失败信息："+sMessage;
	    	}
	    	alert(sReturn);
        }
	}
	
	/*******************核算增加代码***********/
	
	/*~[Describe=费用收取;InputParam=无;OutPutParam=无;]~*/
	function recieveFee(){
		FeeTransaction('3508');
	}
	
	/*~[Describe=费用支付;InputParam=无;OutPutParam=无;]~*/
	function payFee(){
		FeeTransaction('3520');
	}
	
	/*~[Describe=费用交易;InputParam=无;OutPutParam=无;]~*/
	function FeeTransaction(transCode){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sBPObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.business_putout%>";
		var sBCObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.business_contract%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(transCode == "3508")
			sParaString = "SerialNo,"+sObjectNo+",FeeFlag,R";
		else
			sParaString = "SerialNo,"+sObjectNo+",FeeFlag,P";
		sReturn = setObjectValue("SelectAcctFee",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_CLEAR_")
		{
			return;
		}
		var feeSerialNo = sReturn.split("@")[0];
		if(typeof(feeSerialNo) == "undefined" || feeSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		var transactionSerialNo = RunMethod("LoanAccount","CheckExistsTransaction","<%=BUSINESSOBJECT_CONSTATNTS.fee%>,"+feeSerialNo+","+transCode+"");
		if(typeof(transactionSerialNo)=="undefined" || transactionSerialNo.length==0||transactionSerialNo=="Null") {
			//创建不需要流程的交易
			var returnValue = RunMethod("LoanAccount","CreateTransaction",","+transCode+",<%=BUSINESSOBJECT_CONSTATNTS.fee%>,"+feeSerialNo+",,<%=CurUser.getUserID()%>,2");
			returnValue = returnValue.split("@");
			transactionSerialNo = returnValue[1];
			if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
				alert("创建交易{"+transCode+"}时失败！错误原因为："+returnValue);
				return;
			}
		}
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&ViewID=000";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		if(confirm("请确认是否进行入账处理！"))
		{
			var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,Y");
			if(typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("系统处理异常！");
				return;
			}
			var message=returnValue.split("@")[1];
			alert(message);
			reloadSelf();
		}
	}
	
	/*~[Describe=记账;InputParam=无;OutPutParam=无;]~*/
	function KeepAccounts(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialno = getItemValue(0,getRow(),"SerialNo");
		var productID = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sReturn = RunMethod("LoanAccount","RunTransaction3",productID+",,TRA001,<%=BUSINESSOBJECT_CONSTATNTS.business_putout%>,"+sObjectNo+",<%=CurUser.getUserID()%>,");
		if(typeof(sReturn)=="undefined"||sReturn.length==0){
			alert("系统处理异常！");
			return;
		}
		alert(sReturn.split("@")[1]);
		reloadSelf();
	}
	/*******************核算增加代码***********/
	
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