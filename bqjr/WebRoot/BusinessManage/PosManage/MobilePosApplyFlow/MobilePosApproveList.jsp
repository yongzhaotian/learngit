<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
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
    <%@include file="./TaskList.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
    /*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
    function signOpinion()
    {
    	 //获得申请类型、申请流水号、阶段编号
        sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sPhaseNo = getItemValue(0,getRow(),"PHASENO");
  //      alert("sObjectType=:"+sObjectType+",sObjectNo=:"+sObjectNo+"sPhaseNo=:"+sPhaseNo);
        //获得任务流水号
        sSerialNo = getItemValue(0,getRow(),"FSerialNo");
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
        

        //弹出审批提交选择窗口
        sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogPos.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&oldPhaseNo="+sPhaseNo+"&objectNo="+sObjectNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        
        
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//提交成功！
            //更新finallyResult方法，此方法已经默认为把最新的人工认定结果赋值给finallyResult，如果有其他的更新逻辑，请自行更新类方法。
            RunMethod("WorkFlowEngine","UpdateClassifyManResult",sObjectNo + "," + sSerialNo);
            //刷新件数及页面
            top.reloadSelf();
        }else if (sPhaseInfo == "Failure"){
            alert(getHtmlMessage('9'));//提交失败！
            return;
        }else{
            sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogPos.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
            //如果提交成功，则刷新页面
            if (sPhaseInfo == "Success"){
                alert(getHtmlMessage('18'));//提交成功！
                //刷新件数及页面
                top.reloadSelf();
            }else if (sPhaseInfo == "Failure"){
                alert(getHtmlMessage('9'));//提交失败！
                return;
            }
        }
    }



    /*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
    function viewTab(){
    	var sApplySerialNo = getItemValue(0,getRow(),"ApplySerialNo");
    	var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
    	var sSNo = getItemValue(0,getRow(),"RetativeStoreNo");
    	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    	var sMobilePosNo = getItemValue(0,getRow(),"MobilePosNo");
        if (typeof(sApplySerialNo)=="undefined" || sApplySerialNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
 
		AsControl.PopView("/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosInfoDetail.jsp", "ApplySerialNo="+sApplySerialNo+"&ObjectNo="+sObjectNo+"&MobilePosNo="+sMobilePosNo+"&PhaseNo="+sPhaseNo+"&sNo="+sSNo, "");
		reloadSelf();
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