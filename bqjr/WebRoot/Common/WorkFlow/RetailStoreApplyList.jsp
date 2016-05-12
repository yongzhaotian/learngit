<%@page import="com.amarsoft.app.billions.CommonConstans"%>
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
    String PG_TITLE = "零售商门店准入管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
    
    String sViewId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewId"));
    if (sViewId == null) sViewId = "01";
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
		var sInitFlowNo = "<%=sInitFlowNo%>";
		var sInitPhaseNo = "<%=sInitPhaseNo%>";
		
    	var sRetVal = PopPage("/BusinessManage/ChannelManage/PrepareRetailStoreApplyInfo.jsp", "ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo, "dialogWidth=450px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    	if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			return;
		}
    	var sPermitType = sRetVal.split("@")[1];
		var sUrl = "";
    	if (sPermitType == '01') {
    		
			sUrl = "/BusinessManage/ChannelManage/RetailApplyTV.jsp"; 
		} else if (sPermitType == '02') {
			sUrl = "/BusinessManage/ChannelManage/StoreApplyTV.jsp"; 
		}
    	
		AsControl.PopView(sUrl, "RSSerialNo="+sRetVal.split("@")[0]+"&RSerialNo="+sRetVal.split("@")[2]+"&ApplyType="+sApplyType, "");
		reloadSelf();
    }
    
    /*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
    function cancelApply(){
        //获得申请类型、申请流水号
        //var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        if(confirm(getHtmlMessage('70'))){ //您真的想取消该信息吗？
            as_del("myiframe0");
            as_save("myiframe0");  //如果单个删除，则要调用此语句
            reloadSelf();
        }
    }

    /*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
    function viewTab(){
    	var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        
		var sPermitType = getItemValue(0, getRow(), "PERMITTYPE");
        if (sPermitType == '01') {
			sUrl = "/BusinessManage/ChannelManage/RetailApplyTV.jsp";
		} else if (sPermitType == '02') {
			sUrl = "/BusinessManage/ChannelManage/StoreApplyTV.jsp"; 
		}
        //alert(sRetVal);
		AsControl.PopView(sUrl, "RSSerialNo="+getItemValue(0, getRow(), "SERIALNO")+"&RSerialNo="+getItemValue(0, getRow(), "RSERIALNO")+"&ViewId=<%=sViewId%>&ApplyType="+getItemValue(0, getRow(), "APPLYTYPE"), "");
		reloadSelf();
    }

    /*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit(){
		//add by hwang,新增获取参数sApplyType1申请类型
		//获得申请类型、申请流水号、流程编号、阶段编号、申请类型
		var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
		var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sUserID = "<%=CurUser.getUserID()%>";

		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);		
		if(sNewPhaseNo != sPhaseNo) {
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}
		
		// 判定零售商是否已经录入数据
		var sRSerialNo = getItemValue(0, getRow(), "RSERIALNO");
		var sIsSave = RunMethod("公用方法", "GetColValue", "Retail_Info,IsSave,SerialNo='"+sRSerialNo+"'");
		if (sIsSave != "01") {
			alert("请先录入大商户数据再提交！");
			return;
		}
		
		// 如果为门店申请判断是否该笔门店申请下已经添加了门店
		//var sPermitType = getItemValue(0, getRow(), "PERMITTYPE");
		var dStoreCnt = RunMethod("公用方法", "GetCountByWhereClause", "Store_Info,SerialNo,Rsserialno='"+getItemValue(0, getRow(), "SERIALNO")+"'");
		if (dStoreCnt <= 0.0) {
			alert("该笔申请下还没有关联门店，请在\n详情-门店列表中添加门店！");
			return;
		}
		
		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		} 
		
		//弹出审批提交选择窗口		增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28 
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sTaskNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			//alert(getHtmlMessage('18'));//提交成功！
			alert("下一步提交到安全部门审核,审批\n结果可在审批通过或被否决中查看!");
			var sPermitType = getItemValue(0, getRow(), "PERMITTYPE");
			if (sPermitType == "01") {
				var sRSerialNo = getItemValue(0, getRow(), "RSERIALNO");
				RunMethod("公用方法", "UpdateColValue", "Retail_Info,Status,02,SerialNo='"+sRSerialNo+"'");
			} 
			RunMethod("公用方法", "UpdateColValue", "Store_Info,Status,02,RSSerialNo='"+sObjectNo+"'");
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
		var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
		var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
		
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
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
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
    initRow();
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>