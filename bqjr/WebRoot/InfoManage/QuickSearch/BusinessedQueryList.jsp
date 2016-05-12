<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 办结业务
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "办结业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;办结业务&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	//获得组件参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//利用sSql生成数据对象

	String sTempletNo = "BusinessedQueryList"; //模版编号
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setKeyFilter("SerialNo");
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//ccs-887 因数据量较大不需要默认查询，只显示查询条件去查询 update "and 1=2"  huzp 20150609
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";	
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","流程信息","查看流程信息","viewFlow()",sResourcesPath},
			{"false","","Button","任务调整","任务调整","",sResourcesPath},
			{"false","","Button","任务退回","任务退回","",sResourcesPath},
			{"true","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
			{"true","","Button","电话仓库","电话仓库","getPhoneCode()",sResourcesPath},
			{"true","","Button","查看申请表","查看申请表","viewApplyTable()",sResourcesPath},
			{"true","","Button","录音查询","录音查询","playTape()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	/*~[Describe=播放录音;InputParam=无;OutPutParam=无;]~*/
	function playTape(){
		var sContractNo=getItemValue(0,getRow(),"ObjectNo");
		var sRet = setObjectValue("SelectWMAUrl", "ContractNo,"+sContractNo, "", 0, 0, "");
		if (sRet==='_CLEAR_' || typeof(sRet)=='undefined' || sRet==='undefined') {
			return;
		}
		var sWmaUrl = sRet.split("@")[1];
		AsControl.PopComp("/Common/WorkFlow/playTape.jsp","WmaURL="+sWmaUrl,"");
	}
	
	/*~[Describe=取消原因;InputParam=无;OutPutParam=无;]~*/
	function cancelApply(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo =getItemValue(0,getRow(),"ObjectNo");	
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(sPhaseNo!="9000"){
			alert("该阶段不是取消阶段！");
			return;
		}
		var OpenStyle = "width=100px,height=60px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//弹出选择取消意见界面
		var sReturn = AsControl.PopComp("/Common/WorkFlow/CancelApplyInfo.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&PhaseNo="+sPhaseNo+"&FlowNo="+sFlowNo+"&TaskNo="+sSerialNo+"&Type=1&temp=temp",OpenStyle);
		window.returnValue = sReturn;
		window.close();
		reloadSelf();
	}

	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo =getItemValue(0,getRow(),"ObjectNo");	
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=任务调整;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewGradeCard(){
		
	}
	
	/*~[Describe=查看流程信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewFlow(){
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "ViewFlow";
			sCompURL = "/InfoManage/QuickSearch/ViewFlow.jsp";
			popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"dialogWidth=900px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	 
	//add   wlq    查看申请表    20140801  
	function viewApplyTable () {
		printTable("ApplySettle");
	}
    
//  ==============================  打印格式化报告  公共方法  add by yzhang9 ============================================================
	
	/*~[Describe=打印格式化报告;InputParam=无;OutPutParam=无;]~*/
	function printTable(type){
			var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
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
