<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: 该页面主要处理业务相关的申请列表，如授信额度申请列表，额度项下业务申请列表，
			 单笔授信业务申请列表
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 重检页面 
		zywei 2007/10/10 修改取消最终审批意见的提示语
		hwang 2009/06/30 额度项下业务提交时新增额度有效性检查
		sxjiang  2010/07/12   Line138  加了个！  Line26 修改浏览器标题
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "最终审批意见列表页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	/*~[Describe=登记最终审批意见;InputParam=无;OutPutParam=无;]~*/
	function newApprove(){
		var sApproveType = "";//最终审批意见类型（01－同意最终审批意见；02－否决最终审批意见）
		//审批通过的申请信息
		var sParaString = "ObjectType"+","+"CreditApply"+","+"SortNo"+","+"<%=CurOrg.getSortNo()%>"+","+"UserID,"+"<%=CurUser.getUserID()%>";
		sReturn = setObjectValue("SelectApply",sParaString,"",0,0,"");		
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;

		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sPhaseNo = sReturn[1];
		//如果申请审批结果为批准，则登记同意的最终审批意见，否则，登记否决的最终审批意见
		if(sPhaseNo == '1000') sApproveType = '01';
		else sApproveType = '02';
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.InitializeApprove","initialize","ApplySerialNo="+sObjectNo+",ApproveOpinion="+sApproveType+",UserID=<%=CurUser.getUserID()%>,ApplyType=<%=sApplyType%>,InitFlowNo=<%=sInitFlowNo%>,InitPhaseNo=<%=sInitPhaseNo%>");
		reloadSelf();
	}

	/*~[Describe=取消最终审批意见;InputParam=无;OutPutParam=无;]~*/
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
		var sApproveType = getItemValue(0,getRow(),"ApproveType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	
		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doSubmit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = getItemValue(0,getRow(),"ApplyType");//申请类型：IndependentApply,DepententApply,CreditLineApply
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("该登记最终审批意见已经提交了，不能再次提交！");
			reloadSelf();
			return;
		}
						
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('499'));//该最终审批意见所对应的流程任务不存在，请核对！
			return;
		}
		
		//进行风险智能探测
		var sReturn = autoRiskScan("008","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApplyType1="+sApplyType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo);
		if(sReturn != true){
			return;
		}
		
		//弹出审批提交选择窗口		增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28 
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
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
		var sCompID = "SignTaskOpinionInfo";
		var sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
				//如果成功，则刷新页面
				if(sRetValue == "Commit"){
					reloadSelf();
				}
			}			
		}else{
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
	}

	/*~[Describe=自动风险探测;InputParam=无;OutPutParam=无;]~*/
	function riskSkan(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		var sOccurType=getItemValue(0,getRow(),"OccurType");

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//进行风险智能探测
		var result = autoRiskScan("008","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		return result;
	}
	
	/*~[Describe=打印最终审批意见;InputParam=无;OutPutParam=无;]~*/
	function print() {
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sApproveType = getItemValue(0,getRow(),"ApproveType");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} else {
			PopComp("PrintSheetAction","/Common/WorkFlow/PrintSheetAction.jsp","ObjectNo="+sObjectNo,"","");
		}
	}	
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>