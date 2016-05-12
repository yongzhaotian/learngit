<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sObjectType = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("PhaseNo"));
	String sFlowNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("FlowNo"));
	
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	
	//获取最新的字段数据
	String sSql = "select Max(SerialNo) as SerialNo from FLow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo";
	sSerialNo = Sqlca.getString(new SqlObject(sSql)
			.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sFlowNo));
	sSql = "select PhaseNo from Flow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo and SerialNo =:SerialNo";
	sPhaseNo = Sqlca.getString(new SqlObject(sSql)
			.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sFlowNo).setParameter("SerialNo", sSerialNo));
	
	String sCustomerID = Sqlca.getString("select customerid from Business_Contract where SerialNo = '"+sObjectNo+"'");
	//
	String sCheckPoint = Sqlca.getString("select checkpoint from FLOW_MODEL where flowNo='"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"'");
	if(sCheckPoint == null) sCheckPoint = "";
	
%>
<!-- 
	<textarea type=textfield  bgcolor="#FDFDF3" readonly style='width:100%;height:100px;resize: none;'>
【审核要点提示】：<%="\r\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sCheckPoint%>
	</textarea>
	 -->
<%
	
	
	String sDoNo = "SignTaskOpinionInfo";
	/* 是否需要弹出页面选择意见 */
	boolean needPage = false;
	//暂时把各个阶段的显示模板编号配置到PHASEATTRIBUTE字段上(对应流程配置中的'阶段属性')
	/* {DONO:xxxInfo}{NEEDPAGE:true}  */
	String str = Sqlca.getString("select PHASEDESCRIBE from FLOW_MODEL where flowNo='"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"' and PHASEDESCRIBE is not null  ");
	System.out.println("*********"+str);
	if( ! StringX.isEmpty(str)){
		String[] strs = StringX.parseArray(str);
		for(String s: strs){
			String tempStr = s.replace(" ", "");
			if(tempStr.substring(0, 4).equalsIgnoreCase("DONO")){
				sDoNo = tempStr.substring(5);
			}else if(tempStr.substring(0,8).equalsIgnoreCase("NEEDPAGE")){
				needPage = StringX.parseBoolean(tempStr.substring(9));
			}
		}
	}
	
	
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sDoNo,Sqlca);
	
	// 专家审核隐藏用户字段
	if ("0140".equals(sPhaseNo) && "WF_MEDIUM02".equals(sFlowNo)) {
		doTemp.setVisible("InputUserName,InputTime,InputOrgName", false);
	}
	
	//PBOC检查取消意见提示
	boolean bFlow = true;
	String sPhasename = Sqlca.getString(new SqlObject("select PhaseName from FLow_Model where FlowNo = :Flowno and PhaseNo =:PhaseNo")
					.setParameter("Flowno", sFlowNo).setParameter("PhaseNo", sPhaseNo));
	if(sPhasename.startsWith("PBOC")){
		bFlow =false;
	}
	
	
	//家庭成员外呼核查   意见选项
	if ("0080".equals(sPhaseNo) && "WF_HARD".equals(sFlowNo) && "HomePhoneInfoOpinionInfo".equalsIgnoreCase(sDoNo)) {
		doTemp.setVRadioCode("PhaseOpinion", "FamilyMemberPhoneInfoCheck");
	}
	
	//生成ASDataWindow对象		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform形式
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"false","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
			{"true","","Button","审核要点","查看审核要点","viewApprove()",sResourcesPath},
			{"true","","Button","申请详情","查看详情","viewTab()",sResourcesPath},
			{"true","","Button","退回前一步","退回任务","backStep()",sResourcesPath},
			{"true","","Button","进一步验证","提交任务","doSubmit()",sResourcesPath},
			{"true","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
			{"true","","Button","电话仓库","查看电话仓库","getPhoneCode()",sResourcesPath},
			{"false","","Button","播放录音","播放录音","playTape()",sResourcesPath},
			{"true","","Button","查看照片","查看照片","viewImage()",sResourcesPath},
			{"true","","Button","取消申请","取消申请","cancelApply()",sResourcesPath},
			{"true","","Button","拨打电话","拨打电话","btnMakeCall_Click()",sResourcesPath},
			{"true","","Button","影像操作","影像操作","imageManage()",sResourcesPath},
			{"true","","Button","查看申请表","查看申请表","creatApplyTable()",sResourcesPath},
	};
	
	if ("0140".equals(sPhaseNo) && "WF_MEDIUM02".equals(sFlowNo)) sButtons[9][0] = "true";
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<embed name="3_devUnknown" id="3_devUnknown" src="E:\123.wma" type="audio/x-wav" hidden="true" autostart="false" loop="false"/>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	 /*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
        var sObjectNo   = "<%=sObjectNo%>";
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
//	   var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
//	   AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
     
    }
	
	function saveRecord(sPostEvents){
		var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0) {
			var sOpinionNo = getSerialNo("FLOW_OPINION", "OpinionNo", "");
			setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function chick(){
		var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
		if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			alert("未选择意见！");
			return true;
		}
	}
	
	//
	function svresult(){
		var sResult = getItemValue(0,getRow(),"SVRESULT");

		if(sResult=="01"){//拒绝  
			setItemRequired(0,0,"PhaseOpinion",true);
		}else if(sResult=="02"){//通过
			setItemRequired(0,0,"PhaseOpinion",false);
		}else{
			setItemRequired(0,0,"PhaseOpinion",false);
		}
		
		
	}
	
	/*~[Describe=删除已删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
	    var sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0){
	   		alert("您还没有签署意见，不能做删除意见操作！");
	 	}
	 	else if(confirm("你确实要删除意见吗？"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("意见删除成功!");
	  		}
	   		else
	   		{
	    		alert("意见删除失败！");
	   		}
			reloadSelf();
		}
	} 
	
    /*~[Describe=提交业务;InputParam=无;OutPutParam=无;]~*/
    function doSubmit()
	{
		//获得申请类型、申请流水号、阶段编号
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var OrgID = "<%=CurUser.getOrgID()%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sDoNo = "<%=sDoNo%>";
		var needPage = <%=needPage%>;
		//获得任务流水号
		var sSerialNo = "<%=sSerialNo%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		
		//  获取id5电话
		/* var sId5 = getItemValue(0, 0, "PhaseOpinion3");
		var sIdOpinion = getItemValue(0, 0, "PhaseOpinion");
		alert("|"+sId5+"|" + typeof sId5 + "|"+sIdOpinion+"|"+typeof sIdOpinion + "|");
		return; */
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		var sCancelApply = RunMethod("WorkFlowEngine","QueryCancelApply",sObjectNo);
		
		var sCreditReport=getItemValue(0,getRow(),"CreditReport");
		var sCreditNum=getItemValue(0,getRow(),"CreditNum");
		var sCreditLimit=getItemValue(0,getRow(),"CreditLimit");
		var sUseLimit=getItemValue(0,getRow(),"UseLimit");
		var sCreditStatus=getItemValue(0,getRow(),"CreditStatus");
		var sIsNormalCredit=getItemValue(0,getRow(),"IsNormalCredit");
		var sOverDueMonthCredit=getItemValue(0,getRow(),"OverDueMonthCredit");
		var sPutoutAccount=getItemValue(0,getRow(),"PutoutAccount");
		var sPutoutSum=getItemValue(0,getRow(),"PutoutSum");
		var sIsNormalPutout=getItemValue(0,getRow(),"IsNormalPutout");
		var sOverDueMonthPutout=getItemValue(0,getRow(),"OverDueMonthPutout");
		var sSuccessDate=getItemValue(0,getRow(),"SuccessDate");
		var sQueryTime1=getItemValue(0,getRow(),"QueryTime1");
		var sQueryTime2=getItemValue(0,getRow(),"QueryTime2");
		var sPhoneNumber=getItemValue(0,getRow(),"PhoneNumber");
		
		if(sCreditReport=="1"){
			if (typeof(sCreditNum)=="undefined" || sCreditNum.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sCreditLimit)=="undefined" || sCreditLimit.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sUseLimit)=="undefined" || sUseLimit.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sCreditStatus)=="undefined" || sCreditStatus.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sIsNormalCredit)=="undefined" || sIsNormalCredit.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sOverDueMonthCredit)=="undefined" || sOverDueMonthCredit.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sPutoutAccount)=="undefined" || sPutoutAccount.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sPutoutSum)=="undefined" || sPutoutSum.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sIsNormalPutout)=="undefined" || sIsNormalPutout.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sOverDueMonthPutout)=="undefined" || sOverDueMonthPutout.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sSuccessDate)=="undefined" || sSuccessDate.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sQueryTime1)=="undefined" || sQueryTime1.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sQueryTime2)=="undefined" || sQueryTime2.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sPhoneNumber)=="undefined" || sPhoneNumber.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
		}
		
		
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			if(sCancelApply == "100"){
				alert("该申请已被取消");
				window.close();
				return;
			}else{
				alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
				reloadSelf();
				return;
			}
		}
		if(sCancelApply == "100"){
			alert("该申请已被取消");
			window.close();
			return;
		}
		
		if(<%=bFlow%>){
			var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
			if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
				alert("未选择意见！");
				return true;
			} else {
				
				if (sPhaseOpinion=="060" && "ID5PhoneOpinionInfo"==="<%=sDoNo%>") {
					var sId5 = getItemValue(0, 0, "PhaseOpinion3");
					if (! (sId5 && CheckPhoneCode(sId5))) {
						//alert(sId5 + "|" +sId5.replace(/(\s+|[A-Za-z])/g, ""));
						alert("请输入正确的ID5电话号码");
						return;
					} 
				}
			}
		}
		
		saveRecord();
		
		//PBOC阶段插入意见表
		if(!<%=bFlow%>){
			var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
			sReturn= RunMethod("BusinessManage","InsertOpinion","PBOC已检查,<%=sSerialNo%>,"+sOpinionNo+",<%=sObjectNo%>,<%=sObjectType%>,"+sUserID+","+OrgID);
		}
		
		//弹出审批提交选择窗口	     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		if(needPage){
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}else{
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoFlagCommint","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}
		
		// 更新合同状态
		RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo="+sObjectNo+"");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			
			//alert(getHtmlMessage('18'));//提交成功！	// comment by tbzeng 2014/05/03 去掉提交成功提示框
			//top.close();
			/* var sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			var sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			
			var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
			AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,OpenStyle); */
			var isSameUser = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","sameUser","objectNo="+sObjectNo+",objectType="+sObjectType+",userID=<%=CurUser.getUserID()%>");
			//alert(isSameUser);
			
			if(isSameUser=="Yes"){
				window.returnValue = "SameUser";
				//var sCompURL = "";
				//sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoNew.jsp";
				//sReturn = OpenComp("SignTaskOpinionInfoViewLR",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
				parent.reloadSelf();
			}else{
				window.returnValue = "NotSameUser";
				parent.parent.reloadSelf();
			}
			//window.close();

			//刷新件数及页面
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
				
				}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
		
	}
    
    /*~[Describe=电话录入;InputParam=无;OutPutParam=无;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		
	 }
    
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=退回前一步;InputParam=无;OutPutParam=无;]~*/
	function backStep(){
		//获取任务流水号
		var sSerialNo = "<%=sSerialNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		//检查是否能退回
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","cancelCheck","serialNo="+sSerialNo+",userID="+sUserID);
		if(sReturn != "Success"){
			alert("上一步承办人不是当前用户，不允许退回");
			return;
		}else{
			sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","goBack","serialNo="+sSerialNo+",userID="+sUserID);
			if(sReturn =='Success'){
				window.returnValue = "SameUser";
				window.close();
				parent.reloadSelf();
			}else{
				window.returnValue = "NotSameUser";
			}
			return;
		}
		//检查是否签署意见
		//var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			//退回任务操作   	
			var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//如果成功，则刷新页面
			if(sRetValue == "Commit"){
				reloadSelf();
			}else{
				alert(sRetValue);
			}
		}else{
			alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
			return;
		}
	}
	
	/*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sCustomerID = "<%=sCustomerID%>";

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//OpenComp("SignTaskOpinionList","/Common/WorkFlow/SignTaskOpinionList.jsp","CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
		AsControl.OpenComp("/Common/WorkFlow/SignTaskOpinionList.jsp","CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank03","dialogWidth=950px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
	}
	
	/*~[Describe=播放录音;InputParam=无;OutPutParam=无;]~*/
	function playTape(){
		AsControl.PopComp("/Common/WorkFlow/playTape.jsp","","");
	}
	
	/*~[Describe=查看图片;InputParam=无;OutPutParam=无;]~*/
	function viewImage(){
		AsControl.PopComp("/Common/WorkFlow/SignTaskImage.jsp","ObjectNo=<%=sObjectNo%>","");
	}
	
	/*~[Describe=取消申请;InputParam=无;OutPutParam=无;]~*/
	function cancelApply(){
		var OpenStyle = "width=100px,height=60px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//弹出选择取消意见界面
		var sReturn = AsControl.PopComp("/Common/WorkFlow/CancelApplyInfo.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&PhaseNo=<%=sPhaseNo%>&FlowNo=<%=sFlowNo%>&TaskNo=<%=sSerialNo%>&Type=1",OpenStyle);
		window.returnValue = sReturn;
		parent.parent.parent.reloadSelf();
		//window.close();
	}
	
	
	
	//人行信用报告为是时，为必输
	function getCreditReport(){
		 var sCreditReport=getItemValue(0,getRow(),"CreditReport");
		 if(sCreditReport=="1"){
			 setItemRequired(0,0,"CreditReport",true);
			 setItemRequired(0,0,"CreditNum",true);
			 setItemRequired(0,0,"CreditLimit",true);
			 setItemRequired(0,0,"UseLimit",true);
			 setItemRequired(0,0,"CreditStatus",true);
			 setItemRequired(0,0,"IsNormalCredit",true);
			 setItemRequired(0,0,"OverDueMonthCredit",true);
			 setItemRequired(0,0,"PutoutAccount",true);
			 setItemRequired(0,0,"PutoutSum",true);
			 setItemRequired(0,0,"IsNormalPutout",true);
			 setItemRequired(0,0,"OverDueMonthPutout",true);
			 setItemRequired(0,0,"SuccessDate",true);
			 setItemRequired(0,0,"QueryTime1",true);
			 setItemRequired(0,0,"QueryTime2",true);
			 setItemRequired(0,0,"PhoneNumber",true);
		 }else{
			 setItemRequired(0,0,"CreditReport",false);
			 setItemRequired(0,0,"CreditNum",false);
			 setItemRequired(0,0,"CreditLimit",false);
			 setItemRequired(0,0,"UseLimit",false);
			 setItemRequired(0,0,"CreditStatus",false);
			 setItemRequired(0,0,"IsNormalCredit",false);
			 setItemRequired(0,0,"OverDueMonthCredit",false);
			 setItemRequired(0,0,"PutoutAccount",false);
			 setItemRequired(0,0,"PutoutSum",false);
			 setItemRequired(0,0,"IsNormalPutout",false);
			 setItemRequired(0,0,"OverDueMonthPutout",false);
			 setItemRequired(0,0,"SuccessDate",false);
			 setItemRequired(0,0,"QueryTime1",false);
			 setItemRequired(0,0,"QueryTime2",false);
			 setItemRequired(0,0,"PhoneNumber",false);
		 }
	}
	
	/*~[Describe=手机号码验证;InputParam=无;OutPutParam=无;]~*/
	function checkMobile(obj){ 
		
	    var sPhoneNumber = getItemValue(0,getRow(),"PhoneNumber");
	    if(typeof(sPhoneNumber) == "undefined" || sPhoneNumber.length==0){
	    	return false;
	    }
	    if(!(/^1[3|4|5|8][0-9]\d{8}$/.test(sPhoneNumber))){ 
	        alert("手机号码输入有误，请重新输入"); 
	        //obj.focus();
		    setItemValue(0,0,"PhoneNumber","");
	        return false; 
	    } 
	} 
	
	//信用卡数量检查
	function creditNum(){
		var sCreditNum = getItemValue(0,getRow(),"CreditNum");
		if(sCreditNum<=0 ){
			alert("信用卡数量在1~99之间");
    		 setItemValue(0,0,"CreditNum","");
    	}
    	if(sCreditNum>99 ){
			alert("信用卡数量在1~99之间");
    		 setItemValue(0,0,"CreditNum","");
    	}
	}
	
	//最近24期最大逾期月数检查
	function overDueMonthCredit(){
		var sOverDueMonthCredit = getItemValue(0,getRow(),"OverDueMonthCredit");
		if(sOverDueMonthCredit<=0 ){
			alert("最近24期最大逾期月数在1~99之间");
    		 setItemValue(0,0,"OverDueMonthCredit","");
    	}
    	if(sOverDueMonthCredit>99 ){
			alert("最近24期最大逾期月数在1~99之间");
    		 setItemValue(0,0,"OverDueMonthCredit","");
    	}
	}
	
	//贷款账户数检查
	function putoutAccount(){
		var sPutoutAccount = getItemValue(0,getRow(),"PutoutAccount");
		if(sPutoutAccount<=0 ){
			alert("贷款账户数在1~99之间");
    		 setItemValue(0,0,"PutoutAccount","");
    	}
    	if(sPutoutAccount>99 ){
			alert("贷款账户数在1~99之间");
    		 setItemValue(0,0,"PutoutAccount","");
    	}
	}
	
	//贷款最近24期最大逾期月数检查
	function overDueMonthPutout(){
		var sOverDueMonthPutout = getItemValue(0,getRow(),"OverDueMonthPutout");
		if(sOverDueMonthPutout<=0 ){
			alert("贷款最近24期最大逾期月数在1~99之间");
    		 setItemValue(0,0,"OverDueMonthPutout","");
    	}
    	if(sOverDueMonthPutout>99 ){
			alert("贷款最近24期最大逾期月数在1~99之间");
    		 setItemValue(0,0,"OverDueMonthPutout","");
    	}
	}
	
	
	//最近6个月被查询次数检查
	function queryTime1(){
		var sQueryTime1 = getItemValue(0,getRow(),"QueryTime1");
		if(sQueryTime1<=0 ){
			alert("最近6个月被查询次数在1~99之间");
    		 setItemValue(0,0,"QueryTime1","");
    	}
    	if(sQueryTime1>99 ){
			alert("最近6个月被查询次数在1~99之间");
    		 setItemValue(0,0,"QueryTime1","");
    	}
	}
	
	//最近6个月被查询次数检查
	function queryTime2(){
		var sQueryTime2 = getItemValue(0,getRow(),"QueryTime2");
		if(sQueryTime2<=0 ){
			alert("最近30天被查询次数在1~99之间");
    		 setItemValue(0,0,"QueryTime2","");
    	}
    	if(sQueryTime2>99 ){
			alert("最近30天被查询次数在1~99之间");
    		 setItemValue(0,0,"QueryTime2","");
    	}
	}
	
	//总授信额度检查
	function creditLimit(){
		var sCreditLimit = getItemValue(0,getRow(),"CreditLimit");
		if(sCreditLimit<1 ){
			alert("总授信额度在1~1000w之间");
    		 setItemValue(0,0,"CreditLimit","");
    	}
    	if(sCreditLimit>10000000 ){
			alert("总授信额度在1~1000w之间");
    		 setItemValue(0,0,"CreditLimit","");
    	}
	}
	
	
	//已用额度检查
	function useLimit(){
		var sUseLimit = getItemValue(0,getRow(),"UseLimit");
		if(sUseLimit<1 ){
			alert("已用额度在1~1000w之间");
    		 setItemValue(0,0,"UseLimit","");
    	}
    	if(sUseLimit>10000000 ){
			alert("已用额度在1~1000w之间");
    		 setItemValue(0,0,"UseLimit","");
    	}
	}
	
	
	//贷款总额检查
	function putoutSum(){
		var sPutoutSum = getItemValue(0,getRow(),"PutoutSum");
		if(sPutoutSum<1 ){
			alert("贷款总额在1~99999999之间");
    		 setItemValue(0,0,"PutoutSum","");
    	}
    	if(sPutoutSum>99999999 ){
			alert("贷款总额在1~99999999之间");
    		 setItemValue(0,0,"PutoutSum","");
    	}
	}
	
	
	//拨打软电话
	function btnMakeCall_Click()
	{
		var sRetVal = PopPage("/Common/WorkFlow/PhoneCallInputInfo.jsp", "", "dialogWidth=450px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sRetVal!="_none_"){
			var txt_Pfhc;
			Pfhc="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=ecMakeCall& CustomerNumber=";
			Pfhc+= sRetVal+"&CallerParty=";
	        window.location= Pfhc;
		}
		
	}

	function creatApplyTable(){
		var sObjectNo = "<%=sObjectNo%>";
			sObjectType = "ApplySettle";
			sExchangeType = "";
		//检查出帐通知单是否已经生成
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //未生成出帐通知单
			alert("申请单未生成!");
			return;
		}
		//获得加密后的出帐流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 

	}
	
	/*~[Describe=查询审核要点提示;InputParam=无;OutPutParam=无;]~*/
	function viewApprove(){
		alert("审核要点提示！");
	}
	
	/*~[Describe=意见选择触发事件;InputParam=无;OutPutParam=无;]~*/
	function selectID5Opinion() {
		
		/* var sSelOp = getItemValue(0, 0, "PhaseOpinion");
		if (sSelOp!=null && sSelOp && sSelOp=="060") {
			setItemRequired(0, 0, "PhaseOpinion3", true);
			showItem(0, 0, "PhaseOpinion3");
		} else {
			setItemRequired(0, 0, "PhaseOpinion3", false);
			hideItem(0, 0, "PhaseOpinion3");
		} */
	}
	
	function trimAlpha(obj) {
		
		var sId5 = getItemValue(0, 0, "PhaseOpinion3");
		setItemValue(0, 0, "PhaseOpinion3", sId5.replace(/(\s+|[a-zA-z])/g,""));
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
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		bCheckBeforeUnload = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
