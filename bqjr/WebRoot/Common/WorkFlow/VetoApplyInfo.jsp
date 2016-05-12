<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sFlowName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowName"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	//获取当前业务的流程阶段编号 
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sTemp = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sObjectNo==null) sObjectNo="";
	if(sTemp==null) sTemp="";
	String sSql = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "VetoApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sType.equals("1")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute1 = '1'";
	}
	if(sType.equals("2")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute2 = '1'";
	}
	if(sType.equals("3")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute3 = '1'";
	}
	if(sType.equals("4")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute4 = '1'";
	}
	if(sType.equals("5")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute5 = '1'";
	}
	if(sType.equals("6")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute6 = '1'";
	}
	//销售代表使用的取消原因     add by awang 2014/12/29
     if(sType.equals("7")){
			sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute7='1'";
		}
	//风控专家使用的取消原因
		if(sType.equals("8")){
			sSql="select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute8='1'";
		}
	//设置意见选项为单选框
	doTemp.setVRadioSql("Attribute1", sSql);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确定","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","取消","返回列表页面","goBack()",sResourcesPath}
	};
	if(sTemp.equals("temp")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		var sPhaseOpinion1=getItemValue(0,0,"Attribute1");
		var sSerialNo=getItemValue(0,0,"SerialNo");
		var sInputOrg=getItemValue(0,0,"InputOrg");
		var sInputOrgName=getItemValue(0,0,"InputOrgName");
		var sInputUser=getItemValue(0,0,"InputUser");
		var sInputUserName=getItemValue(0,0,"InputUserName");
		var sInputTime=getItemValue(0,0,"InputTime");
		var sRemark=getItemValue(0,0,"Remark");
		
		
		if(typeof(sPhaseOpinion1)=="undefined" || sPhaseOpinion1.length==0){
			alert("请选择取消原因再点击确定");
			return;
		}
		/**20150515 update tangyb 非CE专家取消，备注都为必输项 start*/
		var sCE=<%=CurUser.hasRole("1027")%>;
		//alert("sCE："+sCE);
		if(sCE){ //CE专家取消
			if(sPhaseOpinion1=="0180"){
				var sRemark=getItemValue(0,0,"Remark");
				if(typeof(sRemark)=="undefined" || sRemark.length==0){
					alert("选择原因为其他时，备注为必输项");
					return;
				}
			}
		}else{
			if(typeof(sRemark)=="undefined" || sRemark.length==0){
				alert("备注为必输项，请输入");
				return;
			}
		}
		/**20150515 update tangyb 非CE专家取消，备注都为必输项 end*/
		
		var sCount=RunMethod("BusinessManage","selectOpinoinCount",sSerialNo);
		if(sCount!=0.0){
			alert("此合同此阶段已处理！");
			self.close();
		}
		if(bIsInsert){
			beforeInsert();
		}
		
		var sOpinionNo=getItemValue(0,0,"OpinionNo");
		as_save("myiframe0",sPostEvents);
		alert("否决合同成功！");
		vetoApply();
	}
	
	function goBack(){
		window.close();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		//var serialNo = getSerialNo("FLOW_OPINION","OpinionNo");// 获取流水号
		var serialNo = "<%=DBKeyUtils.getSerialNo("FO")%>";// 获取流水号

		setItemValue(0,getRow(),"OpinionNo",serialNo);

		bIsInsert = false;
	}
	
	function vetoApply(){
		//获得申请类型、申请流水号、阶段编号
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sUserName = "<%=CurUser.getUserName()%>";
		var sOrgName = "<%=CurUser.getOrgName()%>";
		var sOrgID = "<%=CurUser.getOrgID()%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sFlowName = "<%=sFlowName%>";
		var sApplyType = "<%=sApplyType%>";
		
		//获得审核中阶段的合同任务流水号，就是否决阶段的relativeserialno字段的值
		var sSerialNo = "<%=sSerialNo%>";	
		sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","vetoApply","serialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID+",userName="+sUserName+",orgName="+sOrgName+",orgID="+sOrgID+",flowNo="+sFlowNo+",flowName="+sFlowName+",applyType="+sApplyType);
		
		// 更新合同状态
		RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo="+sObjectNo+"");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			
			var sCancelType="020";
		  	//将取消类型插入表Flow_Opinion中
		    RunMethod("Flow_Opinion","ModifyFO",sSerialNo+","+sCancelType);
			
			
			<%-- 否决合同不需要这个// add by tbzeng 2104/07/15 记录合同取消事件，事件类型记录060
			var sEvtSerialNo = getSerialNo("Event_Info", "Serialno", "");
			var sCols = "Serialno@Eventname@Eventtime@Contractno@Inputuser@Inputorg@Type@Remarks";
			var sVals = sEvtSerialNo+"@合同取消@<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>@"+sObjectNo+"@<%=CurUser.getUserID()%>@<%=CurOrg.orgID%>@060@取消合同事件记录";
			RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.InsertEvalue", "recordEvent", "colName="+sCols+",colValue="+sVals);
			// end 2014/07/15 --%>
			
			
		    
			window.returnValue = "NotSameUser";
			window.close();

			//刷新件数及页面
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}
	}
	
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	function getValue(obj){
		/**20150515 update tangyb 非CE专家取消，备注都为必输项  start */
		var sCE=<%=CurUser.hasRole("1027")%>;
		if(sCE){ //CE专家取消
			if(obj.value=="0180"){
	    		setItemRequired(0, 0, "Remark", true);
	    	}else{
	    		setItemRequired(0, 0, "Remark", false);
	    	}
		} else {
			setItemRequired(0, 0, "Remark", true);
		}
    	/**20150515 update tangyb 非CE专家取消，备注都为必输项  end */
    }
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		bCheckBeforeUnload = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
