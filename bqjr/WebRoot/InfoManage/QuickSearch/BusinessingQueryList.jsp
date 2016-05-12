<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 在办业务
		Input Param:
		Output param:
		History Log: xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
					 xswang 20150615 CCS-900 审核中的任务不能被暂停
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "在办业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;在办业务&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	//获得组件参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//利用sSql生成数据对象

	String sTempletNo = "BusinessingQueryList"; //模版编号
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setKeyFilter("SerialNo");
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//
	doTemp.multiSelectionEnabled=true;
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

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
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","流程信息","查看流程信息","viewFlow()",sResourcesPath},
			{"true","","Button","任务调整","任务调整","adjustTask()",sResourcesPath},
			{"true","","Button","任务退回","任务退回","returnToPool()",sResourcesPath},
			{"true","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
			{"true","","Button","取消申请","取消申请","cancelApply()",sResourcesPath},
			{"true","","Button","电话仓库","电话仓库","getPhoneCode()",sResourcesPath},
			{"true","","Button","查看申请表","查看申请表","viewApplyTable()",sResourcesPath},
			// add by xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
			{(CurUser.hasRole("5001"))?"true":"false","","Button","暂停合同","暂停合同","suspendContractBatch()",sResourcesPath},
			{(CurUser.hasRole("5001"))?"true":"false","","Button","恢复合同","恢复合同","recoveryContractBatch()",sResourcesPath},
			// end by xswang 20150427

	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	
	// 任务调整给有权限的人 
	// fixme 权限还未控制  add by tbzeng 2014/05/11
	function adjustTask() {
		
		//var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		//var sPhaseNo = getItemValue(0, getRow(), "PhaseNo");
		//修改为多选框后拿值不一样 zty
		var sObjectNo = getItemValueArray(0,"ObjectNo");
		var sPhaseNo = getItemValueArray(0,"PhaseNo");
		if (typeof(sObjectNo)=='undefined' || sObjectNo.length==0) {
			alert("请选择一条记录!");
			return;
		}
		if (sObjectNo.length>1) {
			alert("不支持批量操作，请只选择一条记录");
			return;
		}
		
		if ("0010" == sPhaseNo) {
			alert("该笔合同处于调查阶段，不能进行任务调整！");
			return;
		}
		var retUserVal = setObjectValue("SelectSalesmanSingleByRole", "UserId,<%=CurUser.getUserID()%>", "", 0, 0, "");
		//alert(retUserVal + "|" + typeof retUserVal);
		if (!retUserVal || retUserVal=="_CLEAR_") {
			return;
		}
		var userId = retUserVal.split("@")[0];
		//alert(userId+"|"+sObjectNo);
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.BqjrFlowAction", "adjustTask", "objectNo="+sObjectNo+",userId="+userId+",phaseNo="+sPhaseNo);
		if(sReturn == "Success"){
			alert("任务调整成功");
		}else if(sReturn == "FailError"){
			alert("已经是当前用户处理，无需调整");
		}else if(sReturn == "Working"){
			alert("当前阶段已经处理");
		}else{
			alert("任务调整失败");
		}
		reloadSelf();
	}
	
	// 将任务退回任务池 add by tbzeng 2014/05/11
	function returnToPool(){
		//var sObjectType = getItemValue(0,getRow(),"ObjectType");
		//var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		//var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		var sObjectType = getItemValueArray(0,"ObjectType");
		var sObjectNo = getItemValueArray(0,"ObjectNo");
		var sPhaseNo = getItemValueArray(0,"PhaseNo");
		if (typeof(sObjectNo)=='undefined' || sObjectNo.length==0) {
			alert("请选择一条记录!");
			return;
		}
		if (sObjectNo.length>1) {
			alert("不支持批量操作，请只选择一条记录");
			return;
		}
		
		if (sPhaseNo=='0010') {
			alert("调查阶段任务不能退回任务池!");
			return;
		}
		
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.BqjrFlowAction","backFlowPool","objectNo="+sObjectNo+",phaseNo="+sPhaseNo);
		if(sReturn == "Success"){
			//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMainNew.jsp","ComponentNam=授信业务审批&ComponentType=MainWindow&ApproveType=XFApprove","_top","");
			alert("退回任务池成功");
		}else if(sReturn == "FailPool"){
			alert("已在任务池中无需退回");
		}else if(sReturn == "Working"){
			alert("当前阶段已经处理");
		}else{
			alert("退回任务失败");
		}
		reloadSelf();
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValueArray(0,"ObjectNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(sSerialNo.length > 1){
			alert("不支持批量操作，请只选择一条记录");
		}else{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	 /*~[Describe=电话录入;InputParam=无;OutPutParam=无;]~*/
	function getPhoneCode()
	{
		var sCustomerID=getItemValueArray(0,"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if (sCustomerID.length>1) {
			alert("不支持批量操作，请只选择一条记录");
			return;
		}
		
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		
	 }
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValueArray(0,"ObjectType");
		var sObjectNo =getItemValueArray(0,"ObjectNo");	
		var sFlowNo = getItemValueArray(0,"FlowNo");
		var sPhaseNo = getItemValueArray(0,"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (sObjectNo.length>1) {
			alert("不支持批量操作，请只选择一条记录");
			return;
		}
		
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=任务调整;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewGradeCard(){
		
	}
	
	/*~[Describe=查看流程信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewFlow(){
		//获得业务流水号
		sSerialNo =getItemValueArray(0,"ObjectNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(sSerialNo.length > 1){
			alert("不支持批量操作，请只选择一条记录");
		}
		else
		{
			sCompID = "ViewFlow";
			sCompURL = "/InfoManage/QuickSearch/ViewFlow.jsp";
			popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"dialogWidth=900px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}
	}
	
	
	/*~[Describe=取消申请;InputParam=无;OutPutParam=无;]~*/
	function cancelApply(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValueArray(0,"ObjectType");
		var sObjectNo =getItemValueArray(0,"ObjectNo");	
		var sFlowNo = getItemValueArray(0,"FlowNo");
		var sPhaseNo = getItemValueArray(0,"PhaseNo");
		var sSerialNo = getItemValueArray(0,"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if (sObjectNo.length>1) {
			alert("不支持批量操作，请只选择一条记录");
			return;
		}
		
		//获取当前业务的流程阶段编号  edit by pli2
		var sTaskNo = RunMethod("公用方法", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'");	
		
		//var OpenStyle = "width=100px,height=60px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//弹出选择取消意见界面
		var sReturn = popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&PhaseNo="+sPhaseNo+"&FlowNo="+sFlowNo+"&TaskNo="+sTaskNo+"&Type=6","dialogWidth=600px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		window.returnValue = sReturn;
		window.close();
		reloadSelf();
	}
	
	// 查看申请表    
	function viewApplyTable () {
	printTable("ApplySettle");
}

//==============================  打印格式化报告  公共方法  add by yzhang9 ============================================================

/*~[Describe=打印格式化报告;InputParam=无;OutPutParam=无;]~*/
function printTable(type){
		var sObjectNo = getItemValueArray(0,"ObjectNo");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurOrg.getOrgID()%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (sObjectNo.length>1) {
			alert("不支持批量操作，请只选择一条记录");
			return;
		}
		
		var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
		if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
			alert("请联系系统管理员检查合同模板配置和合同信息!");
			return;
		}
		var sDocID = 	returnValue.split("@")[0];
		var sUrl = returnValue.split("@")[1];
		var sObjectType = type;
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			//检查出帐通知单是否已经生成
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //未生成出帐通知单
				//生成出帐通知单	
					PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
				//记录生成动作
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
			}else{
				//记录查看动作
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
			}
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}
}

//   ============================== end  打印格式化报告 ============================================================
	
	//add by zty 20151026  批量暂停
	function suspendContractBatch(){
		
		var sSerialNo =getItemValueArray(0,"ObjectNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var sSerialNoArray = "";
		
		for(var i=0;i<sSerialNo.length;i++){
			sSerialNoArray = sSerialNoArray +"@'"+sSerialNo[i]+"'";
		}
		
		sSerialNoArray = sSerialNoArray.substring(1);
		
		var msg1 = RunJavaMethodSqlca("com.amarsoft.app.billions.BatchSuspendOrRecoveryContract", "contractSuspendValidate","objectNos="+sSerialNoArray);
		
		if(msg1 == "0"){
			var msg2 = RunJavaMethodSqlca("com.amarsoft.app.billions.BatchSuspendOrRecoveryContract", "contractSuspendExecute","objectNos="+sSerialNoArray);
			if(msg2 == "0"){
				alert("合同暂停成功");
				reloadSelf();
			}else{
				alert("合同暂停执行系统异常，请稍后重试或联系IT。");
			}
		}else if(msg1 == "1"){
			alert("传入后台合同号为空！");
		}else if(msg1 == "2"){
			alert("所选择的合同有审核中的合同，请按条件搜索合同再进行操作!");
		}else if(msg1 == "3"){
			alert("所选择的合同有已暂停的合同，请按条件搜索合同再进行操作!");
		}else if(msg1 == "4"){
			alert("合同暂停校验系统异常，请稍后重试或联系IT。");
		}
		
	
	}
	
	//add by zty 20151026  批量恢复
    function recoveryContractBatch(){
		
		var sSerialNo =getItemValueArray(0,"ObjectNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var sSerialNoArray = "";
		
		for(var i=0;i<sSerialNo.length;i++){
			sSerialNoArray = sSerialNoArray +"@'"+sSerialNo[i]+"'";
		}
		
		sSerialNoArray = sSerialNoArray.substring(1);
		
		var msg1 = RunJavaMethodSqlca("com.amarsoft.app.billions.BatchSuspendOrRecoveryContract", "contractRecoveryValidate","objectNos="+sSerialNoArray);
		
		if(msg1 == "0"){
			var msg2 = RunJavaMethodSqlca("com.amarsoft.app.billions.BatchSuspendOrRecoveryContract", "contractRecoveryExecute","objectNos="+sSerialNoArray);
			if(msg2 == "0"){
				alert("合同恢复成功");
				reloadSelf();
			}else{
				alert("合同恢复执行系统异常，请稍后重试或联系IT。");
			}
		}else if(msg1 == "1"){
			alert("传入后台合同号为空！");
		}else if(msg1 == "2"){
			alert("所选择的合同有未暂停的合同，请按条件搜索合同再进行操作!");
		}else if(msg1 == "3"){
			alert("合同恢复校验系统异常，请稍后重试或联系IT。");
		}
		
	
	}
	
	// add by xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
	//暂停合同
	function suspendContract(){
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var sObjectNo =getItemValue(0,getRow(),"ObjectNo");
		
		// add by xswang 20150615 CCS-900 审核中的任务不能被暂停
		var sReturn2 = RunMethod("公用方法","GetColValue","FLOW_TASK,max(serialno),objectno='"+sObjectNo+"'");//调查阶段
		var sReturn3 = RunMethod("公用方法","GetColValue","FLOW_TASK,phasetype,objectno='"+sObjectNo+"' and serialno ='"+sReturn2+"'");//阶段
		var sReturn4 = RunMethod("公用方法","GetColValue","FLOW_TASK,taskstate,objectno='"+sObjectNo+"' and serialno ='"+sReturn2+"'");// taskstate
		if( (sReturn3 != "1010") && (sReturn4 == "1") ){
			alert("审核中的合同不能被暂停!");
			return;
		}
		// end by xswang 20150615
		
		//已暂停的合同无需再次暂停
		var sReturn1 = RunMethod("公用方法","GetColValue","BUSINESS_CONTRACT,cancelstatus,SerialNo='"+sObjectNo+"'");
		if(sReturn1 == "1"){
			alert("此合同已暂停!");
			return;
		}else{
			RunMethod("BusinessManage", "UpdateContractCancelStatus",sObjectNo);
			alert("合同暂停成功");
			reloadSelf();
		}
	}
	
	//恢复合同
	function recoveryContract(){
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var sObjectNo =getItemValue(0,getRow(),"ObjectNo");
		//若合同没有被暂停，则无需恢复
		var sReturn1 = RunMethod("公用方法","GetColValue","BUSINESS_CONTRACT,cancelstatus,SerialNo='"+sObjectNo+"'");
		if(sReturn1 != "1"){
			alert("此合同未暂停,无需恢复!");
			return;
		}else{
			RunMethod("BusinessManage", "UpdateContractCancelStatus1",sObjectNo);
			alert("合同恢复成功");
			reloadSelf();
		}
	}
	
	// end by xswang 20150427
		
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