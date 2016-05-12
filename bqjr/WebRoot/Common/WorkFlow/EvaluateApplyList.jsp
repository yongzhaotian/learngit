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
	String PG_TITLE = "信用等级评估申请列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		PopComp("EvaluateApplyCreateInfo","/Common/WorkFlow/EvaluateApplyCreateInfo.jsp","Action=display&CustomerID="+sObjectNo+"&ObjectType=<%=sObjectType%>&ApplyType=<%=sApplyType%>&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&SerialNo="+sSerialNo,"dialogWidth=400px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=信用等级评估详情;InputParam=无;OutPutParam=无;]~*/
	function viewDetail()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sUserID   = getItemValue(0,getRow(),"UserID");
		var sOrgID    = getItemValue(0,getRow(),"OrgID");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			var sEditable="true";
			if(sPhaseNo!="0010")
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID="+sObjectNo+"&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo+"&Editable="+sEditable+"&ModelNo="+sModelNo,"_blank",OpenStyle);
		    reloadSelf();
		}		
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function cancelApply()
	{
		//获得类型、流水号
		var ObjectType = getItemValue(0,getRow(),"ObjectType");
		var SerialNo = getItemValue(0,getRow(),"SerialNo");		
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sAccountMonth        = getItemValue(0,getRow(),"AccountMonth");
		var sReportScope        = getItemValue(0,getRow(),"ReportScope");
		if (typeof(SerialNo)=="undefined" || SerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			sReportStatus = '02';//取消评估申请时，要将报表的状态设置为完成。01表示新增状态，02表示完成状态，03表示锁定状态。
			sReturn = RunMethod("CustomerManage","UpdateFSStatus",sObjectNo+","+sReportStatus+","+sAccountMonth+","+sReportScope);
			var sReturn = RunMethod("WorkFlowEngine","DeleteCreditCognTask",ObjectType+","+SerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("删除成功！");
			}	
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	//签署意见
	function signOpinion(){
     //获得类型、流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sEvaluateScore = getItemValue(0,getRow(),"EvaluateScore");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (typeof(sEvaluateScore)=="undefined" || sEvaluateScore.length==0){
			alert("请先进行模型评定！");//请先进行模型评定
			return;
		}
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}

		var sParaString = "TaskNo="+sTaskNo
		                  +"&ObjectType="+sObjectType
		                  +"&ObjectNo="+sObjectNo
		                  +"&ERSerialNo="+sSerialNo
		                  +"&PhaseNo="+sPhaseNo;
		PopComp("SignEvaluateOpinionInfo","/Common/WorkFlow/SignEvaluateOpinionInfo.jsp",sParaString,"dialogWidth=550px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

		//将人工评估分数和结果更新到EVALUATE_RECORD表中 add by cbsu 2009-11-11
        RunMethod("WorkFlowEngine","UpdateEvaluateManResult",sSerialNo + "," + sTaskNo);
		reloadSelf();
	}
/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得类型、流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		PopComp("ViewEvaluateOpinions","/Common/WorkFlow/ViewEvaluateOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"dialogWidth=680px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{//获得类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sEvaluateScore = getItemValue(0,getRow(),"EvaluateScore");
	    sFinishDate = "<%=StringFunction.getToday()%>";
		sUserId="<%=CurUser.getUserID()%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if (typeof(sEvaluateScore)=="undefined" || sEvaluateScore.length==0){
			alert("请先进行模型评定！");//请先进行模型评定
			return;
		}
		
		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
	
		//检查是否签署意见
		var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("请先签署认定意见，然后再提交！");//先签署认定意见
			return;
		}

		//弹出审批提交选择窗口		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sSerialNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
