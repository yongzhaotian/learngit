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
			xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
			xswang 20150615 CCS-900 审核中的任务不能被暂停
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
	<%@include file="/Common/WorkFlow/TaskNewList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	var sFlowNo = "<%=sFlowNo%>";
	var sPhaseNo = "<%=sPhaseNo%>";
	var sUserID = "<%=CurUser.getUserID()%>";
	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doSubmit(){
		//获得申请类型、申请流水号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		//获得任务流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
			reloadSelf();
			return;
		}
		
		//弹出审批提交选择窗口	     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		if(sFlowNo=="CarFlow"){
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}else{
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}	
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			
			//刷新件数及页面
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}else if (sPhaseInfo == "Failure9000") {
			alert("该申请已经取消!");
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
	
	function cancelTask(){
		//获得申请类型、申请流水号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		
		//获得任务流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("该业务这阶段审批已经提交，不能取消！");
			reloadSelf();
			return;
		}
				

		//弹出审批提交选择窗口	     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sRet = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","CancelTask","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID+",FlowNo="+sFlowNo);
		if(sRet == 'Success'){
			alert("操作成功");
		}else{
			alert("操作失败");
		}
		return;
		
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			//刷新件数及页面
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
				alert("取消成功！");//取消成功！
				//刷新件数及页面
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
	}

	//获取任务池任务
	function getTask(){
	
		// 弹出未读公告
		ReloadNotice();
		
		var sFlows = sFlowNo.split(",");
		var sFl = "";
		for(var i=0; i < sFlows.length; i++){
			sFl += sFlows[i]+"@";
		}
		sFl = sFl.substring(0, sFl.length-1);
		var sObjectNo = "";//合同编号
		
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getTask","flowNo="+sFl+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		if(sReturn == "FailError"){
			alert("当前有未处理的任务，请处理完后再获取！！！");
			return;
		}else if(sReturn != "Failure"){
			RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctFlowNotMatch", "sObjectNo="+sReturn.split("@")[0]+"");
			//刷新件数及页面
			//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMainNew.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			sReturn = sReturn.split("@");
			sObjectNo = sReturn[0];
		    //----------打印申请表begin---------------
			 printTable("ApplySettle",sObjectNo);//调用打印逻辑打印
		    //-------打印申请表end---------
			 signCheckOpinionOne(sObjectNo,"<%=CurUser.getUserID()%>");
		}else{
			alert("没有可以获得的任务！");
			return;
		}
	}
	// 弹出公告
    function ReloadNotice(){
    	<%/*~begin判断登录身份flag为2则是管理员只显示菜单不弹界面反之只弹界面不显示菜单add CSS-225审核员身份进入弹出公告栏页面   20150519 huzp~~已在下面的jira中撤了flag=2的判断*/%>
 	    <%/*~begin判断登录身份org为11则是审核部都弹屏 add CSS-913审核员身份进入弹出公告栏页面   20150701 huzp~*/%>
 	    if('<%=CurUser.getOrgID()%>'=='11'){
 	    	var UserId = "<%=CurUser.getUserID()%>";
 	    	//若有新公告则弹出界面，否则不弹出界面
 	    	//add by byang CCS-1252	控制弹出公告为本部门的发出的公告
 	    	var userOrg = "<%=CurUser.getOrgID()%>";
 	    	var count= RunMethod("Unique","uniques","notice_info,count(1),noticeid not in (select t.noticeid  from USER_NOTICE t  where t.isflag = '1' and t.UserID = '"+UserId+"') and InputOrg='"+userOrg+"'");
 	    	if(count>0){
 	    		UpNotice();
 	    	}
 	    }
 	    <%/*~end~*/%>
    }
    /******************add CSS-225审核员身份进入弹出公告栏页面   20150515 huzp***/
	//进入此页面,权限为审核员时弹出公告栏
	function UpNotice(){//CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		AsControl.PopView("/Common/WorkFlow/UpNoticeList.jsp", "identtype=01", "dialogWidth=850px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*********************end***************************************/
	
	
	//将任务退回任务池
	function returnToPool(){
		//获得任务流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","returnToPool","objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",objectType="+sObjectType);
		if(sReturn == "Success"){
			//刷新件数及页面
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMainNew.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			alert("退回任务池成功");
			}else{
				alert("退回任务池失败");
			}
		
	}
	
	//签署意见
	function signCheckOpinionOne(sObjectNo, userID){
		sSortReturn = RunMethod("BusinessManage","getFlowSerialno",sObjectNo+","+userID);
		sSortReturn = sSortReturn.split("@");

		//获得任务流水号
		var sSerialNo = sSortReturn[0];
		var sObjectNo = sSortReturn[1];
		var sObjectType = sSortReturn[2];
		var sFlowNo1 = sSortReturn[3];
		var sPhaseNo1 = sSortReturn[4];
		//alert("|"+sSerialNo+"|"+sObjectType+"|"+sObjectNo+"|"+sFlowNo1+"|"+sPhaseNo1+"|");
		
		//设置"审核中"标志;　已获取但未点击过按钮的任务，超过Ｘ小时则自动回退到任务池
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
		if(sReturn!=="Success"){
			alert("设置'审核中'标志出错!");
			return;
		}
		
		// 去掉，不起作用
		/* if(sFlowNo=="CarFlow"){
			doSubmit();
			return;
		} */
		
		var sCancelApply = RunMethod("WorkFlowEngine","QueryCancelApply",sObjectNo);
		if(sCancelApply == "100"){
			alert("该申请已被取消");
			reloadSelf();
			return;
		}

		//add 现金贷需求
		var sProductID = RunMethod("PublicMethod","GetColValue","productid,business_contract,String@SerialNo@"+sObjectNo);
		if(null == sProductID){
			 sProductID = "";
		}else{
			if("020" == sProductID.split("@")[1])
			{
				SignOpinionForCashLoan(sObjectType,sObjectNo,sSerialNo,sFlowNo1,sPhaseNo1);
				return;
			}
		}
		//end
		
		var OpenStyle = "width=1000px,height=600px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		var sCompURL = "";
		//sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoViewLR.jsp";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoView.jsp";
		
		//sReturn = OpenComp("SignTaskOpinionInfoViewLR",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
		sReturn = OpenComp("SignTaskOpinionInfoView",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo1+"&PhaseNo="+sPhaseNo1,"_self");
		//sReturn = AsControl.OpenPage(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self",OpenStyle);
		//审核页面TAB方式展示
		//sReturn = parent.addtabCompent("","消费金融审核页面","AsControl.OpenComp('"+sCompURL+"','ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ViewID=001','TabContentFrame')");
		
		//alert(sReturn);
		//sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
		//如果提交到的人仍是自己，则继续弹出页面
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//设置'审核中'标志
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			//sReturn = AsControl.OpenView(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle, "_self");
			//sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
			//alert(sReturn);
		}
		//reloadSelf();
		//parent.reloadSelf();
	}

	//签署意见
	function signCheckOpinion(){
		//获得任务流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		// edit by xswang 20150615 CCS-900 审核中的任务不能被暂停
		/* // add by xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
		// 从合同表中取当前合同的“cancelstatus”标识
		var sReturn1 = RunMethod("BusinessManage", "SelectContractCancelStatus",sObjectNo);
		if("1" == sReturn1){
			alert("该合同已被暂停，不能提交");
			return;
		}
		// end by xswang 20150427 */
		// end by xswang 20150615		
		
		//设置"审核中"标志;　已获取但未点击过按钮的任务，超过Ｘ小时则自动回退到任务池
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
		if(sReturn!=="Success"){
			alert("设置'审核中'标志出错!");
			return;
		}
		
		if(sFlowNo=="CarFlow"){
			doSubmit();
			return;
		}
		
		var sCancelApply = RunMethod("WorkFlowEngine","QueryCancelApply",sObjectNo);
		if(sCancelApply == "100"){
			alert("该申请已被取消");
			reloadSelf();
			return;
		}

		//add 现金贷需求
		var sProductID = getItemValue(0,getRow(),"ProductID");
		if("020" == sProductID)
		{
			SignOpinionForCashLoan(sObjectType,sObjectNo,sSerialNo,sFlowNo,sPhaseNo);
			return;
		}
		//end
		
		var OpenStyle = "width=1000px,height=600px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		var sCompURL = "";
		//sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoViewLR.jsp";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoView.jsp";
		
		//sReturn = OpenComp("SignTaskOpinionInfoViewLR",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
		sReturn = OpenComp("SignTaskOpinionInfoView",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
		//sReturn = AsControl.OpenPage(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self",OpenStyle);
		//审核页面TAB方式展示
		//sReturn = parent.addtabCompent("","消费金融审核页面","AsControl.OpenComp('"+sCompURL+"','ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ViewID=001','TabContentFrame')");
		
		//alert(sReturn);
		//sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
		//如果提交到的人仍是自己，则继续弹出页面
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//设置'审核中'标志
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			//sReturn = AsControl.OpenView(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle, "_self");
			//sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
			//alert(sReturn);
		}
		//reloadSelf();
		//parent.reloadSelf();
	}
	
	//签署意见1
	function signCheckOpinionNew(Serialno,ObjectNo,ObjectType,FLowNo,PhaseNo){
		//获得任务流水号
		var sSerialNo = Serialno;
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		var sObjectType = ObjectType;
		var sObjectNo = ObjectNo;		
		var sFlowNo = FLowNo;
		var sPhaseNo = PhaseNo;
		//设置"审核中"标志;　已获取但未点击过按钮的任务，超过Ｘ小时则自动回退到任务池
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
		if(sReturn!=="Success"){
			alert("设置'审核中'标志出错!");
			return;
		}
		
		if(sFlowNo=="CarFlow"){
			doSubmit();
			return;
		}
		//add 现金贷需求
		var sProductID = RunMethod("PublicMethod","GetColValue","productid,business_contract,String@SerialNo@"+sObjectNo);
		if(null == sProductID){
			 sProductID = "";
		}else{
			if("020" == sProductID.split("@")[1])
			{
				SignOpinionForCashLoan(sObjectType,sObjectNo,sSerialNo,sFlowNo,sPhaseNo);
				return;
			}
		}
		//end
		var OpenStyle = "width=1000px,height=600px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		var sCompURL = "";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoViewLR.jsp";
		//sReturn = AsControl.OpenView(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle, "_self");
		sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
		//如果提交到的人仍是自己，则继续弹出页面
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//设置'审核中'标志
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			//sReturn = AsControl.OpenView(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle, "_self");
			sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
			//alert(sReturn);
		}
		//reloadSelf();
		//parent.reloadSelf();
	}
		
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
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
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	function printTable(type,sObjectNo){
		
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurOrg.getOrgID()%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//CCS-316 需要根据合同状态控制快速查询里的按钮     add by Roger 2015/03/09
		var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
		    if(sContractStatus == "060" || sContractStatus == "070"){   //新发生、审核中合同除了admin，其他人都不能打印合同
		    	//给管理员角色这个特权 
		    	if(!<%=CurUser.hasRole(new String[]{"000","099","1000"})%>){
		    		alert("只有管理员才能调阅该笔合同");
		    		return;
		    	}
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

	/*~[Describe=查看申请表 ;InputParam=无;OutPutParam=无;]~*/
	function viewApplyTable () {
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		 printTable("ApplySettle",sObjectNo);//调用打印逻辑打印
	}
	
	/*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0035") {
			sParamString += "&ViewID=002";
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	/*~[Describe=退回前一步;InputParam=无;OutPutParam=无;]~*/
	function backStep(){
		//获取任务流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sUserID = "<%=CurUser.getUserID()%>";
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
    		alert(getHtmlMessage('1'));//请选择一条信息！
    		return;
		}
		if(!confirm(getBusinessMessage('509'))) return; //您确认要将该申请退回上一环节吗？
		//检查是否能退回
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","cancelCheck","serialNo="+sSerialNo+",userID="+sUserID);
		if(sReturn != "Success"){
			alert("上一步承办人不是当前用户，不允许退回");
			return;
		}else{
			sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","goBack","serialNo="+sSerialNo+",userID="+sUserID);
			if(sReturn =='Success'){
				alert("退回成功。");
			}else{
				alert("退回上一步失败!");
			}
			reloadSelf();
			return;
		}
		//检查是否签署意见
		//var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			//退回任务操作   	
			var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//如果成功，则刷新页面
			if(sRetValue == "Commit"){
				//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
				reloadSelf();
			}else{
				alert(sRetValue);
			}
		}else{
			alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
			return;
		}
	}
	
	/*~[Describe=任务收回;InputParam=无;OutPutParam=无;]~*/
	function takeBack(){
		//获取任务流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined"||sSerialNo.length == 0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//收回任务操作
		var sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"收回任务操作","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//如果成功，则刷新页面
		if (sRetValue == "Commit"){
		    OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}		
	}
	
	/*~[Describe=自动风险探测;InputParam=无;OutPutParam=无;]~*/
	function riskSkan(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		//进行风险智能探测
		autoRiskScan("001","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,20);
		//sReturn=RunMethod("BusinessManage","CheckApplyRisk",sObjectType+","+sObjectNo);
		//if(typeof(sReturn) != "undefined" && sReturn != "") 
			//PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
	}
	
	/*~[Describe=查看尽职调查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sDocID = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if (typeof(sDocID)=="undefined" || sDocID.length==0){
			alert(getBusinessMessage('505'));//尽职调查报告还未填写，请先填写尽职调查报告再查看！
			return;
		}
		
		var sReturn = AsControl.RunJsp("/FormatDoc/GetReportFile.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID);
		if (sReturn == "false"){
			alert("尽职调查报告还未生成，请先生成尽职调查报告再查看！");
			return;  
		}
				
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	//add by cdeng  2009-02-17  增加查看流程历史按钮
	function flowHistory(){
		 //获取任务流水号
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectNo) == "undefined" || sObjectNo.length == 0){
    		alert(getHtmlMessage('1'));//请选择一条信息！
    		return;
		}
		OpenComp("FlowSubList","/Common/WorkFlow/FlowSubList.jsp","PhaseNo="+sPhaseNo+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&ObjectType="+sObjectType,"_blank");
	}

	/*~[Describe=流程图形展示;InputParam=无;OutPutParam=无;]~*/
	//add by yxzhang 2010-04-09  用于查看流程图
	function viewFlowGraph(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			var iViewFileLength = RunMethod("WorkFlowEngine","GetViewFileLength",sFlowNo);
			if(typeof(iViewFileLength)=="undefined" || iViewFileLength.length==0){
				alert("流程的图形定义不存在，请先配置流程图再查看！");
				return;
			}
			popComp("FlowGraphView","/Common/WorkFlow/FlowGraphView.jsp","ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo);
		}
	}
	
	 /*~[Describe=电话录入;InputParam=无;OutPutParam=无;]~*/
	function getPhoneCode()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		
	 }

	//add 现金贷需求
	//签署意见（copy消费贷签署意见）
	function SignOpinionForCashLoan(sObjectType,sObjectNo,sSerialNo,sFlowNo,sPhaseNo)
	{
		/* var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo"); */
		
		var OpenStyle = "width=1000px,height=600px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		var sCompURL = "";
		sCompURL = "/CreditManage/CashLoan/CashLoanOpinionInfoView.jsp";
		
		sReturn = OpenComp("CashLoanOpinionInfoView",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
		//如果提交到的人仍是自己，则继续弹出页面
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//设置'审核中'标志
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
		}
	}
	
	function initRow(){
		setTimeout("reloadSelf()",10000);
		
	}
	
	//end
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	//initRow();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>