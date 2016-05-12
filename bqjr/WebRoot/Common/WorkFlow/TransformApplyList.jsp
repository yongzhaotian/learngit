<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
    Author: ccxie 2010/03/18
    Tester:
    Content: 该页面主要处理担保合同变更相关的申请列表，如待认定的申请列表，认定中的申请列表，认定通过的申请列表
    Input Param:
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "担保合同变更管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
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

    /*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
    function newApply(){
    	var sParaString = "ManageUserID"+","+"<%=CurUser.getUserID()%>";
    	var sReturn = setObjectValue("SelectContractOfTransform",sParaString,"",0,0,"");
        if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CLEAR_" || sReturn.length == 0) return;
		sReturns = sReturn.split('@');
		sReturn = sReturns[0];
		var sObjectNo = RunMethod("WorkFlowEngine","InitializeTransform",sReturn+",<%=sObjectType%>,<%=sApplyType%>,<%=sInitFlowNo%>,<%=sInitPhaseNo%>,<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType=TransformApply&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
    }
    
    /*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
    function cancelApply(){
        //获得申请类型、申请流水号
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        if(confirm(getHtmlMessage('70'))){ //您真的想取消该信息吗？
            RunMethod("WorkFlowEngine","UpdateTransformFlag","0,"+sObjectNo);
            as_del("myiframe0");
            as_save("myiframe0");  //如果单个删除，则要调用此语句
        }
    }

    /*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
    function viewTab(){
    	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        var sCompID = "CreditTab";
        var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
        var sParamString = "ObjectType=TransformApply&ObjectNo="+sObjectNo;
        var sFlowNo = getItemValue(0,getRow(),"FlowNo");
        var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sFlowNo=="TransformFlow" && sPhaseNo != "0010" && sPhaseNo != "3000") {
			sParamString += "&ViewID=002"
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
    }

    /*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
    function doSubmit(){
        //获得申请类型、申请流水号、流程编号、阶段编号、申请类型、合同号
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        var sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
        var sFlowNo = getItemValue(0,getRow(),"FlowNo");
        var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        var sApplyType1 = "<%=sApplyType%>";      
        var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        var sApplyType = "<%=sApplyType%>";
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
        
        //检查是否签署意见
        var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
        if(typeof(sReturn)=="undefined" || sReturn.length==0) {
            alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
            return;
        }

        
        //【担保合同变更申请】-【提交】时，显示框改成风险探测，因此此段代码被替换，场景模型014是新配置的  add by zhuang 2010-04-02
	    //count = popComp("ShowTransformDialog","/Common/WorkFlow/ShowTransformDialog.jsp","ObjectNo="+sObjectNo,"dialogWidth=400px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    //if(typeof(count) == "undefined" || count == "_none_"){
		//	return;
	    //}else if(count == "0"){
		//	alert("当前担保合同没有变更！");
		//	return;
		//}
        sReturn = autoRiskScan("014","ApplyType="+sApplyType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo);
        if(sReturn != true){
            return;
        }
		
        //弹出审批提交选择窗口     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		
		var sCompID = "SignTaskOpinionInfo";
		var sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
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
        popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
    }

	/*~[Describe=归档;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('56'))){ //您真的想将该信息归档吗？
			//归档操作
			var sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",GUARANTY_TRANSFORM");
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
	function cancelarchive(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('58'))){ //您真的想将该信息归档取消吗？
			//取消归档操作
			var sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",GUARANTY_TRANSFORM");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//取消归档失败！
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('59'));//取消归档成功！
			}
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


<%@ include file="/IncludeEnd.jsp"%>