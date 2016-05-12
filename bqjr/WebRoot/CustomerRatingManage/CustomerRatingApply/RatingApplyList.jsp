<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    bwang 2009/04/02 
		Tester:	
		Content:   信用等级认定列表
		Input Param:
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用等级评估申请列表(新)"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	/*~[Describe=新增信用等级认定申请;InputParam=无;OutPutParam=无;]~*/
	function newApply()
	{
		var sStyle = "dialogWidth=350px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		var sReturn = PopComp("RatingApplyCreateDialog","/CustomerRatingManage/CustomerRatingApply/RatingApplyCreateDialog.jsp","",sStyle);
		if(typeof(sReturn)=="undefined"||sReturn =='' || sReturn=="_CANCEL_"){
			reloadSelf();
			return;
		}
		sReturn = sReturn.split("@");
		var sRatingAppID = sReturn[0];
		var sModelID = sReturn[1];
		var sObjectNo = sReturn[2];
		var sObjectType = "<%=sObjectType%>";
		var sPhaseType = "<%=sPhaseType%>";
		var sApplyType = "<%=sApplyType%>";
		var sFlowNo = "<%=sInitFlowNo%>";
		var sPhaseNo = "<%=sInitPhaseNo%>";
		if(typeof(sPhaseNo)=='undefined'||sPhaseNo=='')sPhaseNo = '0010';
		var sOrgID = "<%=CurUser.getOrgID()%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var param = "applyNo="+sRatingAppID+",refModelID="+sModelID+",objectType="+sObjectType+",objectNo="+sObjectNo+",applyType="+sApplyType+",flowNo="+sFlowNo+",phaseNo="+sPhaseNo+",userID="+sUserID+",orgID="+sOrgID;
		var sReturn = RunJavaMethod("com.amarsoft.app.als.rating.action.RatingProcess","startRating",param);
		if(sReturn=='SUCCESS') alert("新增评级成功！");
		else {
			alert("新增评级失败！");
			return;
		}
		if(!confirm("评级测算前需保证客户信息的准确和完善，确定进行评级测算吗？"))return;
	    //var wizardId = "2011101400000001";
	    var param = "RatingAppID="+sRatingAppID;
	    if(sModelID=="WZBANK_DG_003"){//事业单位评级页面
			PopComp("RatingTranOnceList","/CustomerRatingManage/CustomerRatingApply/RatingTranOnceList.jsp","RatingAppID="+sRatingAppID+"&ViewFlag=2");
		}else{
	    	//popWizard(wizardId,param,"");
		}
		reloadSelf();
	}
	
	/*~[Describe=信用等级评估详情;InputParam=无;OutPutParam=无;]~*/
	function viewDetail()
	{
		var sRatingAppID = getItemValue(0,getRow(),"RatingAppID");
		if(typeof(sRatingAppID)=="undefined"||sRatingAppID.length==0){
			alert("请选择一条信息！");
			return;
		}
		var sModelID = getItemValue(0,getRow(),"RefModelID");
	    var wizardId = "2011101400000001";
	    var param = "RatingAppID="+sRatingAppID+"&ViewFlag=2";
	    if(sModelID=="WZBANK_DG_003"){//事业单位评级页面
			PopComp("RatingTranOnceList","/CustomerRatingManage/CustomerRatingApply/RatingTranOnceList.jsp",param,"");
		}else{
	    	//AsControl.popWizard(wizardId,param,"");
		}
	    reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function cancelApply()
	{
		var sApplyNo = getItemValue(0,getRow(),"RatingAppID");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sApplyNo) == "undefined" || sApplyNo.length == 0){
			alert("请选择一条信息");
			return;
		}
		if(!confirm("你确定取消该笔评级申请吗？")) return;
		var sReturn = RunJavaMethod("com.amarsoft.app.als.rating.action.RatingProcess","cancelRating","applyNo="+sApplyNo+",objectNo="+sObjectNo+",objectType="+sObjectType);
		if(sReturn == "SUCCESS"){
			alert("取消评级成功");
			reloadSelf();
		} else {
			alert("取消评级失败");
		}
	}
	
	//签署意见
	function signOpinion()
	{
		return;
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sTaskNo= getItemValue(0,getRow(),"RelativeTaskNo");
		var sApplyType = getItemValue(0,getRow(),"ApplyType");
		var sApplyNo = getItemValue(0,getRow(),"RatingAppID");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sRatingGrade01 = getItemValue(0,getRow(),"RatingGrade01");
		if (typeof(sApplyNo)=="undefined" || sApplyNo.length==0){
			alert("请选择一条信息！");//请选择一条信息！
			return;
		}
		//校验是否完成测算
		//var sCompleteSingl = RunJavaMethod("com.amarsoft.app.als.rating.action.CheckBeforeSubmit","checkCompleteSignal","RatingAppID="+sApplyNo);
		if(typeof(sRatingGrade01)=="undefined"||sRatingGrade01.length==0){
			alert("该评级申请尚未完成测算，请先完成测算 再进行人工调整");
			return;
		}
		sCompURL = "/CustomerRatingManage/CustomerRatingApply/signOpinionView.jsp";
		PopComp("signOpinionView",sCompURL,"TaskNo="+sTaskNo+"&ApplyType="+sApplyType+"&ApplyNo="+sApplyNo+"&CustomerID="+sCustomerID,"");
		//RunJavaMethodTrans("com.amarsoft.app.als.rating.action.UpdateRatingResult","updateRatingGrade","SerialNo="+sTaskNo+",RatingAppID="+sApplyNo);
		reloadSelf();
	}
	
	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sApplyType = getItemValue(0,getRow(),"ApplyType");
		sApplyNo = getItemValue(0,getRow(),"RatingAppID");
		if (typeof(sApplyType)=="undefined" || sApplyType.length==0){
			alert("请选择一条信息！");//请选择一条信息！
			return;
		}
		PopComp("CRViewOpinionList","/CustomerRatingManage/CustomerRatingApprove/CRViewOpinionList.jsp","ApplyType="+sApplyType+"&ApplyNo="+sApplyNo,"");
	}
	
	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{
		alert('采用内置流程不进行演示');
		return;
		var sApplyType = getItemValue(0,getRow(),"ApplyType");
		var sApplyNo = getItemValue(0,getRow(),"RatingAppID");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sRatingGrade01 = getItemValue(0,getRow(),"RatingGrade01");
		var sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sApplyNo)=="undefined" || sApplyNo.length==0){
			alert("请选择一条信息");//请选择一条信息！
			return;
		}
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		//sNewPhaseNo=RunJavaMethod("com.amarsoft.app.als.workflow.action.WorkFlowEngine","getPhaseNo","ApplyType="+sApplyType+",ApplyNo="+sApplyNo+",SerialNo="+sSerialNo);
		//if(sNewPhaseNo != sPhaseNo) {
		//	alert("该申请已经提交了，不能再次提交！");//该申请已经提交了，不能再次提交！
		//	reloadSelf();
		//	return;
		//}
		if(typeof(sRatingGrade01)=="undefined"||sRatingGrade01.length==0){
			alert("本次评级尚未完成测算，请先完成测算再提交！");
			return
		}

		//获取任务流水号
		var sTaskNo = RunJavaMethod("com.amarsoft.app.als.rating.action.RatingProcess","getUnfinishedTaskNo","objectType="+sObjectType+",objectNo="+sObjectNo+",flowNo="+sFlowNo+",phaseNo="+sPhaseNo+",userID="+sUserID);
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
	
		//检查是否签署意见
		//var sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		//if(typeof(sReturn)=="undefined" || sReturn.length==0) {
		//	alert("请先签署认定意见，然后再提交！");//先签署认定意见
		//	return;
		//}

		//弹出审批提交选择窗口     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_"){
			return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
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
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
    var bHighlightFirst = true;//自动选中第一条记录
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>