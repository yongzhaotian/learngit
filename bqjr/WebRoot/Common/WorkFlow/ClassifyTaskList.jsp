<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author: cbsu 2009-10-12
        Tester:
        Content: 该页面主要处理五级分类的审查审批列表
        Input Param:
        Output param:
        History Log: 
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
    
    /*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
    function doSubmit()
    {
        //获得申请类型、申请流水号、阶段编号
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        
        //获得任务流水号
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
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
        sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
        if(typeof(sReturn)=="undefined" || sReturn.length==0) {
            alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
            return;
        }

        //弹出审批提交选择窗口     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28 
        sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//提交成功！
            //更新finallyResult方法，此方法已经默认为把最新的人工认定结果赋值给finallyResult，如果有其他的更新逻辑，请自行更新类方法。
            RunMethod("WorkFlowEngine","UpdateClassifyManResult",sObjectNo + "," + sSerialNo);
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
        //获得申请类型、申请流水号、流程编号、阶段编号
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        sResultType = "<%=sResultType%>";
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
        {
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }

        //获取任务流水号
        sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
        if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
            alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
            return;
        }
        
        sCompID = "SignClassifyOpinionInfo";
        sCompURL = "/Common/WorkFlow/SignClassifyOpinionInfo.jsp";
        popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ResultType="+sResultType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&PhaseNo="+sPhaseNo,"dialogWidth=50;dialogHeight=37;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    }

    /*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
    function viewOpinions() 
    {
        //获得申请类型、申请流水号、流程编号、阶段编号
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
        {
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        popComp("ViewClassifyFlowOpinions","/Common/WorkFlow/ViewClassifyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
    }

    /*~[Describe=模型分类;InputParam=无;OutPutParam=无;]~*/
    function viewDetail()
    {
        //获得ObjectType(五级分类对象类型，值为"Classify"),ObjectNo(借据号或合同号),SerialNo(Classify_Record表的SerialNo，即五级分类申请流水号)
        //AccountMonth(会计月份),ModelNo(五级分类评估模型号),ResultType(五级分类是借据或合同，值为"BusinessDueBill"或"BusinessContract")
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"DuebillNo");
        sSerialNo = getItemValue(0,getRow(),"ObjectNo");
        sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        sResultType = "<%=sResultType%>";
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        
        //将以上参数组合成参数字符串
        sCompURL = "/CreditManage/CreditCheck/ClassifyDetail.jsp";
        sCompID = "ClassifyDetails";
        sParameter = "1=1"+
                     "&Action=_DISPLAY_"+
                     "&ClassifyType=080"+ //根据这个参数来确定在显示ClassifyDetail.jsp页面时是否显示"保存"，"测算"按钮。
                     "&ObjectType="+sObjectType+
                     "&ObjectNo="+sObjectNo+
                     "&SerialNo="+sSerialNo+
                     "&AccountMonth="+sAccountMonth+
                     "&ModelNo=Classify1"+
                     "&ResultType="+sResultType;
        popComp(sCompID,sCompURL,sParameter);
}

    /*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
    function viewTab()
    {
        //获得ObjectType(五级分类对象类型，为"Classify")， SerialNo(Classify_Record表的SerialNo，即五级分类申请流水号)，sDuebillNo(借据号或合同号), 
        //AccountMonth(会计月份),ResultType(五级分类是借据或合同，值为"BusinessDueBill"或"BusinessContract")
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sSerialNo = getItemValue(0,getRow(),"ObjectNo");
        sDuebillNo = getItemValue(0,getRow(),"DuebillNo");
        sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        if (typeof(sDuebillNo)=="undefined" || sDuebillNo.length==0)
        {
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        sResultType = "<%=sResultType%>";
        sCompID = "CreditTab";
        sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
        sParamString = "ComponentName=风险分类参考模型&Action=_DISPLAY_&OpenType=Tab&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&SerialNo="+sDuebillNo+"&ResultType="+sResultType+"&DuebillNo="+sDuebillNo+"&AccountMonth="+sAccountMonth+"&ModelNo=Classify1&ClassifyType=080";
        OpenComp(sCompID,sCompURL,sParamString,"_blank","");
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
        if(!confirm(getBusinessMessage('509'))) return; //您确认要将该申请退回上一环节吗？
        //检查是否签署意见
        sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
        if(typeof(sReturn)=="undefined" || sReturn.length==0){
            //退回任务操作
            sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
            //如果成功，则刷新页面
            if (sRetValue == "Commit"){
                OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
            }else{
                alert(sRetValue);
            }
        }else{
            alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
            return;
        }
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