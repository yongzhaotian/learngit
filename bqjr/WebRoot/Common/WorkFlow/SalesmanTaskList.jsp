<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  ccxie 2010/03/22
		Tester:
		Content: 批复任务列表
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "批复任务列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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

	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()	
	{
		//获得对象类型、对象编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
		sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		sPhaseNo = getItemValue(0,getRow(),"PHASENO");

		//获得任务流水号
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
			reloadSelf();
			return;
		}
		
		//检查是否签署意见
		//sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		var sOpSerialNo = RunMethod("公用方法", "GetColValue", "Flow_Opinion,SerialNo,SerialNo='"+sSerialNo+"'");
		if("Null"==sOpSerialNo || sOpSerialNo.length==0) {
			alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
			return;
		}
		
		//弹出审批提交选择窗口	     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28	
		//sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog_RetailStore.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			//刷新件数及页面
			/* var sSvResult = RunMethod("公用方法", "GetColValue", "Flow_Opinion,SVRESULT,SerialNo='"+sSerialNo+"'");
			if ("01" == sSvResult) {
				RunMethod("公用方法", "UpdateColValue", "User_Info,Status,2,UserId='"+sObjectNo+"'");
			} else if ("02" == sSvResult) {
				RunMethod("公用方法", "UpdateColValue", "User_Info,Status,1,UserId='"+sObjectNo+"'");
			} */
			RunMethod("共用方法", "UpdateColValue", "User_Info,Status,1,UserId='"+sObjectNo+"'");
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//提交成功！
				//刷新件数及页面
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
	}
	
    
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function signOpinion()
	{
		//获得任务流水号、对象类型、对象编号
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
		sObjectNo = getItemValue(0,getRow(),"OBJECTNO");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		//签署对应的意见
		sCompID = "SignTaskOpinionInfo1";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo1.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=650px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
		
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
		sObjectNo = getItemValue(0,getRow(),"OBJECTNO");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		
		var sOpSerialNo = RunMethod("公用方法", "GetColValue", "Flow_Opinion,SerialNo,SerialNo='"+sSerialNo+"'");
		if ("Null"==sOpSerialNo || sOpSerialNo.length==0) {
			alert("请先签署意见!");
			return;
		}
		
		//签署对应的意见
		sCompID = "SignTaskOpinionInfo1";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo1.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewId=<%=sViewID%>","dialogWidth=680px;dialogHeight=650px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

	}
	
	/*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		/* sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sFlowNo=="TransformFlow" && sPhaseNo != "0010") {
			sParamString += "&ViewID=002"
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle); */
		var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
      	AsControl.PopView("/BusinessManage/CollectionManage/SalesmanApplyInfo.jsp", "EmpNo="+sObjectNo+"&ViewId=<%=sViewID%>", "");
		reloadSelf();
	}
	
	
	/*~[Describe=退回前一步;InputParam=无;OutPutParam=无;]~*/
	function backStep()
	{		
		//获取任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");				
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
        {	
    		alert(getHtmlMessage('1'));//请选择一条信息！
    		return;
		}
		if(!confirm(getBusinessMessage('497'))) return; //您确认要将该最终审批意见退回上一环节吗？
		//检查是否签署意见
		sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) 
		{
			//退回任务操作   	
			sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//如果成功，则刷新页面
			if (sRetValue == "Commit")
			{
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}
    	}else
		{
			alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
			return;
		}
	}
	
	/*~[Describe=任务收回;InputParam=无;OutPutParam=无;]~*/
	function takeBack()
	{
		//获取任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined"||sSerialNo.length == 0 )
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//收回任务操作
		sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"收回任务操作","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//如果成功，则刷新页面
		if (sRetValue == "Commit")
		{
		    OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
		}		
	}
		
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>

<script type="text/javascript">
	AsOne.AsInit();
	showFilterArea();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
