<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
    Author: cbsu  2009.10.13
    Tester:
    Content: 该页面主要处理五级分类相关的申请列表，如待认定的申请列表，认定中的申请列表，认定通过的申请列表
    Input Param:
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "五级分类方案管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
        //将jsp中的变量值转化成js中的变量值
        var sObjectType = "<%=sObjectType%>";
        var sApplyType = "<%=sApplyType%>";
        var sPhaseType = "<%=sPhaseType%>";
        var sResultType = "<%=sResultType%>";
        
        //弹出新增申请参数对话框
        var sCompID = "ClassifyDialog";
        var sCompURL = "/CreditManage/CreditCheck/ClassifyDialog.jsp";
        var sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ResultType="+sResultType+"&PhaseType="+sPhaseType+"&ClassifyType=010","dialogWidth=500px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_" || sReturn.length == 0) return;
        RunMethod("WorkFlowEngine","UpdateClassifyModelResult",sReturn);
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
            as_del("myiframe0");
            as_save("myiframe0");  //如果单个删除，则要调用此语句
        }
    }

    /*~[Describe=模型分类;InputParam=无;OutPutParam=无;]~*/
    function viewDetail(){
        //获得ObjectType(五级分类对象类型，值为"Classify"),ObjectNo(借据号或合同号),SerialNo(Classify_Record表的SerialNo，即五级分类申请流水号)
        //AccountMonth(会计月份),ModelNo(五级分类评估模型号),ResultType(五级分类是借据或合同，值为"BusinessDueBill"或"BusinessContract")
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        var sObjectNo = getItemValue(0,getRow(),"DuebillNo");
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        
        var sResultType = "<%=sResultType%>";
        //五级分类的阶段ID：待处理的申请，认定中的申请，认定通过的申请
        var sPhaseType = "<%=sPhaseType%>";
        //根据sClassifyType来确定在显示ClassifyDetail.jsp页面时是否显示"保存"，"测算"按钮。
        if (sPhaseType == "1010") {
            sClassifyType = "010";
        } else {
            sClassifyType = "020";
        }
        
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        
        //将以上参数组合成参数字符串
        var sCompURL = "/CreditManage/CreditCheck/ClassifyDetail.jsp";
        var sCompID = "ClassifyDetails";
        var sParameter = "1=1"+
                     "&Action=_DISPLAY_"+
                     "&ClassifyType="+sClassifyType+
                     "&ObjectType="+sObjectType+
                     "&ObjectNo="+sObjectNo+
                     "&SerialNo="+sSerialNo+
                     "&AccountMonth="+sAccountMonth+
                     "&ModelNo=Classify1"+
                     "&ResultType="+sResultType;
        popComp(sCompID,sCompURL,sParameter);
        
        if (sClassifyType == "010") {
        	//将模型分类结果更新到CLASSIFY_RECORD表的FinallyResult字段。
            RunMethod("WorkFlowEngine","UpdateClassifyModelResult",sSerialNo);
        }
        reloadSelf();
    }
    
    /*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
    function viewTab(){
        //获得ObjectType(五级分类对象类型，为"Classify")， SerialNo(Classify_Record表的SerialNo，即五级分类申请流水号)，sDuebillNo(借据号或合同号), 
        //AccountMonth(会计月份),ResultType(五级分类是借据或合同，值为"BusinessDueBill"或"BusinessContract")
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sObjectNo = getItemValue(0,getRow(),"DuebillNo");
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        var sPhaseType = "<%=sPhaseType%>"; //五级分类的阶段ID：待处理的申请，认定中的申请，认定通过的申请
        
        if (sPhaseType == "1010") {
            sClassifyType = "010";
            sViewID = "000";//jschen@20100423 控制tab可修改
        } else {
            sClassifyType = "020";
            sViewID = "002";//jschen@20100423 控制tab只读
        }
        
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        var sResultType = "<%=sResultType%>";
        var sCompID = "CreditTab";
        var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
        var sParamString = "ComponentName=风险分类参考模型"+
				       "&OpenType=Tab"+ //jschen@20100412 用来区分打开分类模型界面的方式
            		   "&Action=_DISPLAY_"+
            		   "&ClassifyType="+sClassifyType+
            		   "&ObjectType="+sObjectType+
            		   "&ObjectNo="+sSerialNo+
            		   "&SerialNo="+sObjectNo+
            		   "&AccountMonth="+sAccountMonth+
            		   "&ModelNo=Classify1"+
            		   "&ResultType="+sResultType+
            		   "&ViewID="+sViewID;
        popComp(sCompID,sCompURL,sParamString,"");
        
        if (sClassifyType == "010") {
        	//将模型分类结果更新到CLASSIFY_RECORD表的FinallyResult字段.
            RunMethod("WorkFlowEngine","UpdateClassifyModelResult",sSerialNo);
        }
        reloadSelf();
    }

    /*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
    function doSubmit(){
        //获得申请类型、申请流水号、流程编号、阶段编号、申请类型
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        var sCRSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sFlowNo = getItemValue(0,getRow(),"FlowNo");
        var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
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

        //检查该业务是否已经进行模型评定
        var sModeResult = RunMethod("WorkFlowEngine","CheckClassifyModeResult",sCRSerialNo); 
        if(typeof(sModeResult)=="undefined" || sModeResult.length==0) {
            alert("请先进行模型评定");
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
        
        //弹出审批提交选择窗口  增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28 
        var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//提交成功！
            //更新finallyResult方法，此方法已经默认为把最新的人工认定结果赋值给finallyResult，如果有其他的更新逻辑，请自行更新类方法。
            RunMethod("WorkFlowEngine","UpdateClassifyManResult",sCRSerialNo + "," +sTaskNo);
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
        var sObjectType = getItemValue(0,getRow(),"ObjectType"); //"Classify"
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");//五级分类申请流水号
        var sFlowNo = getItemValue(0,getRow(),"FlowNo");
        var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        var sResultType = "<%=sResultType%>"; //五级分类借据或合同 
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }

        //检查该业务是否已经进行模型评定
        var sModeResult = RunMethod("WorkFlowEngine","CheckClassifyModeResult",sSerialNo); 
        if(typeof(sModeResult)=="undefined" || sModeResult.length==0) {
            alert("请先进行模型评定");
            return;
        }
        
        //获取Flow_Task表中的任务流水号
        var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
        if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
            alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
            return;
        }
        
        PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignClassifyOpinionInfo.jsp","TaskNo="+sTaskNo+"&ResultType="+sResultType+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo,"dialogWidth=700px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
        popComp("ViewClassifyFlowOpinions","/Common/WorkFlow/ViewClassifyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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