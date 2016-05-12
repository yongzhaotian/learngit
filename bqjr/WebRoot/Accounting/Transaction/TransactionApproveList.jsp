<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: 该页面主要处理业务相关的审查审批列表
		Input Param:
		Output param:
		History Log: 
			2005.08.03 jbye    重新修改流程审查相关信息
			2005.08.05 zywei   重检页面
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
	<%@include file="/Common/WorkFlow/TaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	
/*~[Describe=交易详情;InputParam=无;OutPutParam=无;]~*/
function viewTask(){
	//获得申请类型、申请流水号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	var transactionCode = "<%=transactionFilter%>";
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("请先锁定任务！");
			return;
		}
		if(sFlowState=="1"){
			alert("该任务已被锁定,请选择其他任务！");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("请先锁定任务！");
				return;
			}
		}
	}
	
	if(transactionCode=="@0090@" || transactionCode=="@3530@"){
		sCompID = "CreditTab";
		sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo;
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
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	
	if(confirm(getHtmlMessage('70'))){ //您真的想取消该信息吗？
		as_del("myiframe0");
		as_save("myiframe0");  //如果单个删除，则要调用此语句
	}
}

/*~[Describe=退回前一步;InputParam=无;OutPutParam=无;]~*/
function backStep(){
	//获取任务流水号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("请先锁定任务！");
			return;
		}
		if(sFlowState=="1"){
			alert("该任务已被锁定,请选择其他任务！");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("请先锁定任务！");
				return;
			}
		}
	}	
	if(!confirm(getBusinessMessage('509'))) return; //您确认要将该申请退回上一环节吗？
	//检查是否签署意见
	var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
	if(typeof(sReturn)=="undefined" || sReturn.length==0){
		//退回任务操作   	
		var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//如果成功，则刷新页面
		if(sRetValue == "Commit"){
			//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			alert("退回成功!");
			reloadSelf();
		}else{
			alert(sRetValue);
		}
	}else{
		alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
		return;
	}
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
	var sReturn = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>");
	if(sReturn=="true"){
		alert("交易执行成功！");
		reloadSelf();
	}
	else{
		alert("交易执行失败！错误原因："+sReturn);
	}
}

/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
function doSubmit(){
	//add by hwang,新增获取参数sApplyType1申请类型
	//获得申请类型、申请流水号、流程编号、阶段编号、申请类型
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sApproveType1 = "<%=sApproveType%>";
	var sOccurType=getItemValue(0,getRow(),"OccurType");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("请先锁定任务！");
			return;
		}
		if(sFlowState=="1"){
			alert("该任务已被锁定,请选择其他任务！");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("请先锁定任务！");
				return;
			}
		}
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
	
	<%-- var sReturn = autoRiskScan("017","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ApplyType1="+sApproveType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo);
	if(sReturn != true){
		return;
	} --%>
	var sSignOpinion = RunMethod("公用方法", "GetColValue", "FLOW_OPINION,PHASEOPINION,serialno=(SELECT max(serialno) FROM FLOW_TASK WHERE OBJECTNO='"+sObjectNo+"')");
	
	if (sSignOpinion == "Null") {
		alert("请先签署意见再提交！");
		return;
	}

	//弹出审批提交选择窗口		
	var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=580px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	// !LoanAccount.RunTransaction2(#ObjectNo,#UserID,N)
	if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
	else if (sPhaseInfo == "Success"){
		var sLastPhaseNo = RunMethod("公用方法", "GetColValue", "FLOW_OBJECT,PHASENO,FLOWNO='TransFeeFlow' AND OBJECTTYPE='TransactionApply' AND OBJECTNO='"+sObjectNo+"'");
		if (sLastPhaseNo == "1000") {
			RunMethod("LoanAccount", "RunTransaction2", sObjectNo+",<%=CurUser.getUserID()%>,N");
		}
		if (sLastPhaseNo == "8000") {
			RunMethod("公用方法", "UpdateColValue", "ACCT_TRANSACTION,TRANSSTATUS,4,serialno='"+sObjectNo+"'");
		}
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
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("请先锁定任务！");
			return;
		}
		if(sFlowState=="1"){
			alert("该任务已被锁定,请选择其他任务！");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("请先锁定任务！");
				return;
			}
		}
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
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("请先锁定任务！");
			return;
		}
		if(sFlowState=="1"){
			alert("该任务已被锁定,请选择其他任务！");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("请先锁定任务！");
				return;
			}
		}
	}
	//popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID=001","");
	//popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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
function lock(){
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");

//	var sFlowState=getItemValue(0,getRow(),"FlowState");
	//获得任务流水号
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！ 
		return;
	}
	if(sFlowState=="1"){
		LockUser = RunMethod("WorkFlowEngine","LockUser",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		alert("该任务已被-"+LockUser+"-锁定,不能对该客户进行业务办理，请选择其他任务！");
		//alert("该任务已被锁定,请选择其他任务！");
		return;
	}
	if(sFlowState=="2"){
		var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if(islock=="true"){
			alert("该任务已被锁定,不能重复锁定！");
			return;
		}
	}
	//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
	var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
	if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
		alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
		reloadSelf();
		return;
	}
	var lock=RunMethod("WorkFlowEngine","LockOrUnLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>"+",1");
	if(lock=="SUCCESS"){
		alert("任务锁定成功！");
	}
//	reloadSelf();

}

function unlock(){
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	
//	var sFlowState=getItemValue(0,getRow(),"FlowState");
	
	//获得任务流水号
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);
	
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！ 
		return;
	}
	if(sFlowState==""){
		alert("请先锁定任务！");
		return;
	}
	if(sFlowState=="1"){
		LockUser = RunMethod("WorkFlowEngine","LockUser",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		//alert("该任务已被-"+LockUser+"-锁定,不能对该客户进行业务办理，请选择其他任务！");
		alert("该任务已被-"+LockUser+"-锁定,请选择其他任务！");
		return;
	}
	if(sFlowState=="2"){
		var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if(islock=="false"){
			alert("该任务处于解锁状态，不能重复解锁！");
			return;
		}
	}
	//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
	var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
	if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
		alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
		reloadSelf();
		return;
	}
	//ObjectType = 'CreditApply' and ObjectNo= '2013073000000080' and FlowNo = 'PerRetCenFlow' and PhaseNo = '0020' and UserID <> 'test13' and (EndTime is null or EndTime = '')
	var lock=RunMethod("WorkFlowEngine","LockOrUnLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>" + ",2");
	if (lock == "SUCCESS") {
		alert("任务解锁成功！");
	}
//	reloadSelf();
}

</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
