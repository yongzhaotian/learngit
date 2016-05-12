<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
    Content: 该页面主要处理相关的申请列表，如待认定的申请列表，认定中的申请列表，认定通过的申请列表
    Input Param:
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>
    %>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
    <%@include file="./ApplyList.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">
	
	function AppDetail(){
	}
	function backStep(){
	}

    
    /*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
    function newApply(){
    	var sURL = "/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosInfoDetail.jsp";
    	var ssObjectType="<%=sObjectType%>";
    	
		AsControl.PopView(sURL, "ObjectType=<%=sObjectType%>&ApplyType=<%=sApplyType%>&FlowNo=<%=sInitFlowNo%>&PhaseNo=<%=sInitPhaseNo%>", "");
		reloadSelf();
    }
    
    /*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
    function cancelApply(){
        //获得申请类型、申请流水号
       var sApplySerialNo = getItemValue(0,getRow(),"ApplySerialNo");
        if (typeof(sApplySerialNo)=="undefined" || sApplySerialNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        
        if(confirm(getHtmlMessage('70'))){ //您真的想取消该信息吗？
        	RunMethod("公用方法","DelByWhereClause","mobilepos_info,APPLYSERIALNO='"+sApplySerialNo+"'");
            as_del("myiframe0");
            as_save("myiframe0");  //如果单个删除，则要调用此语句
        }
    }

    
    /*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
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
 	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
    function doSubmit(){
        //获得申请类型、申请流水号、流程编号、阶段编号、申请类型
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        var sApplySerialNo = getItemValue(0,getRow(),"ApplySerialNo");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
        var sMobilePosNo = getItemValue(0,getRow(),"MobilePosNo");
     //   alert("sObjectType="+sObjectType+"，sObjectNo="+sObjectNo+"，sApplySerialNo="+sApplySerialNo+"，sFlowNo="+sFlowNo+"，sPhaseNo="+sPhaseNo);
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        
		var sCount = RunMethod("公用方法", "GetColValue", "DOC_ATTACHMENT,count(1),OBJECTNO='"+sObjectNo+"'");
		if(sCount=="0.0"){
			alert("请先上传附件信息！");
			return;
		}
		var sSalCount = RunMethod("公用方法", "GetColValue", "MOBLIEPOSRELATIVESALMAN,count(1),posno='"+sMobilePosNo+"'");
		if(sSalCount=="0.0"){
			alert("请先关联销售人员！");
			return;
		}
		var sProductCount = RunMethod("公用方法", "GetColValue", "MOBILEPOSRELATIVEPRODUCT,count(1),posNo='"+sMobilePosNo+"'");
		if(sProductCount=="0.0"){
			alert("请先关联产品！");
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

     //   alert("sTaskNo"+sTaskNo);
        //弹出审批提交选择窗口
        var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogPosPrimary.jsp?SerialNo="+sTaskNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
 //       alert("sPhaseInfo"+sPhaseInfo);
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		
        else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//提交成功！
            //更新finallyResult方法，此方法已经默认为把最新的人工认定结果赋值给finallyResult，如果有其他的更新逻辑，请自行更新类方法。
           	RunMethod("公用方法","UpdateColValue","MOBILEPOS_INFO,Status,02,SerialNo = '"+sObjectNo+"'");
            reloadSelf();
        }else if (sPhaseInfo == "Failure"){
            alert(getHtmlMessage('9'));//提交失败！
            return;
        }else{
  //     	alert("33333");
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
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE"); 
        var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");       
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
        
        PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignClassifyOpinionInfo.jsp","TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo,"dialogWidth=700px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    }
    
    /*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
    function viewOpinions(){
        //获得申请类型、申请流水号、流程编号、阶段编号
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
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