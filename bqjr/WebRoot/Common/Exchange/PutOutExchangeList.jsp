<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   fxie  2005.01.21
		Tester:
		Content: 出帐交易列表主界面
		Input Param:
			                sDealType:树图子叶类型
		Output param:
		History Log: 
			fXie 2005-01-22    出帐交易处理
	 */
	%>
<%/*~END~*/%>
<%
	//获得组件参数
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	//获取对象类型、流程编号、阶段编号、经办人代码、完成标志
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	
	//测试时使用
	sApproveType="PutOutApprove";
	//调试标志：0 ：不显示调试信息 1：显示调试信息   
	String sDegbugFlag ="1" ; 
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "出帐交易主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	ASResultSet rs = null;
	String sTempletNo="PutOutExchangeList";
	String sWhereClause1="";
	String sWhereClause2="";
	
	if(sDealType.substring(0,3).equals("010")){
		sWhereClause1 = " and ExchangeState = '1' and ExchangeType not like 'A%'";
	}else if (sDealType.substring(0,3).equals("020")){
		sWhereClause1 = " and ExchangeState = '2' and ExchangeType not like 'A%'";
	}else if (sDealType.substring(0,3).equals("030")){
		sWhereClause1 = " and ExchangeState = '3' and ExchangeType not like 'A%'";
	}else if (sDealType.substring(0,3).equals("090")){
		sWhereClause1 = " and ExchangeState = '9' and ExchangeType not like 'A%'";
	}

	//选择分支点
	if (sDealType.equals("010")||sDealType.equals("020")||sDealType.equals("030")) {
		sWhereClause2=" and (ExchangeType is not null and ExchangeType <> ' ' and ExchangeType <> '0000')";
	//展期
	}else if (sDealType.equals("010010")||sDealType.equals("020010")||sDealType.equals("030010")){
		sWhereClause2=" and ExchangeType = '6201'";
	//国内信用证
	}else if (sDealType.equals("010020")||sDealType.equals("020020")||sDealType.equals("030020")){
		sWhereClause2=" and ExchangeType = '6801'";
	//银行承兑汇票
	}else if (sDealType.equals("010030")||sDealType.equals("020030")||sDealType.equals("030030")){
		sWhereClause2=" and ExchangeType = '8315'";
	//贴现	
	}else if (sDealType.equals("010040")||sDealType.equals("020040")||sDealType.equals("030040")){
		sWhereClause2=" and ExchangeType = '6501'";
	//一般贷款
	}else if (sDealType.equals("010050")||sDealType.equals("020050")||sDealType.equals("030050")){
		sWhereClause2=" and ExchangeType = '6002'";
	//委托贷款
	}else if (sDealType.equals("010060")||sDealType.equals("020060")||sDealType.equals("030060")){
		sWhereClause2=" and ExchangeType = '6003'";
	//银团贷款
	}else if (sDealType.equals("010070")||sDealType.equals("020070")||sDealType.equals("030070")){
		sWhereClause2=" and ExchangeType = '6005'";
	//进出口押汇
	}else if (sDealType.equals("010080")||sDealType.equals("020080")||sDealType.equals("030080")){
		sWhereClause2=" and ExchangeType = '6007'";
	//按揭贷款
	}else if (sDealType.equals("010090")||sDealType.equals("020090")||sDealType.equals("030090")){
		sWhereClause2=" and ExchangeType = '2201'";
	//循环贷款登记
	}else if (sDealType.equals("010100")||sDealType.equals("020100")||sDealType.equals("030100")){
		sWhereClause2=" and ExchangeType = '6901'";
	}else{
		sWhereClause2="";
	}				
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    // 复核通过状态，限定审核者
    doTemp.WhereClause += " and (FLOW_OBJECT.ObjectType||FLOW_OBJECT.ObjectNo) "+
						  " in (select ObjectType||ObjectNo from FLOW_TASK where UserID = '"+CurUser.getUserID()+"' and PhaseNo='0035')"+
						  " and FLOW_OBJECT.ApplyType='PutOutApply' "+
						  " and FLOW_OBJECT.FlowNo='PutOutFlow' "+
						  " and FLOW_OBJECT.PhaseNo in('1000','0040') "+sWhereClause1+sWhereClause2+
						  " Order by FLOW_OBJECT.ObjectNo Desc";
	
    //生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	doTemp.setHTMLStyle("SerialNo,BusinessTypeName,ArtificialNo"," style={width:120px}");
	doTemp.setHTMLStyle("ExchangeTypeName,ExchangeStateName"," style={width:60px}"); 
	doTemp.setHTMLStyle("CustomerName"," style={width:200px}"); 
	
	if (sDealType.equals("020020")||sDealType.equals("030020")||sDealType.equals("020040")||sDealType.equals("030040")||sDealType.equals("090020")||sDealType.equals("090040")){ 
		doTemp.setVisible("ArtificialNo",true); 
		doTemp.setVisible("DuebillSerialNo",true); 
	}else if (sDealType.equals("010030")||sDealType.equals("020030")||sDealType.equals("030030")||sDealType.equals("090030")){
		doTemp.setVisible("ArtificialNo",false); 
		doTemp.setVisible("DuebillSerialNo",false); 
		doTemp.setVisible("RenameArtificialNo",true); 
		if (sDealType.equals("010030")||sDealType.equals("090030")){
			doTemp.setVisible("RenameDuebillSerialNo",false); 
		}else{
			doTemp.setVisible("RenameDuebillSerialNo",true); 
		}			
	}else if (sDealType.equals("010020")||sDealType.equals("010040")){
		doTemp.setVisible("ArtificialNo",true); 
		doTemp.setVisible("DuebillSerialNo",false); 
	}else{
		doTemp.setVisible("ArtificialNo",false); 
		doTemp.setVisible("DuebillSerialNo",true); 
	}
	
	//设置多选项   
	doTemp.multiSelectionEnabled = true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    
	//设置DataWindow展现风格和编辑格式
	dwTemp.Style="1";
	dwTemp.ReadOnly = "1";
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
		
		String sButtons[][] = {
								{"true","","Button","全选","全选","SelectedAll()",sResourcesPath},
								{"true","","Button","反选","反选","SelectedBack()",sResourcesPath},
								{"true","","Button","取消全选","取消全选","SelectedCancel()",sResourcesPath},
								{"true","","Button","放贷详情","查看放贷详情","viewTab()",sResourcesPath},
								{"true","","Button","退回放贷申请人","退回放贷申请人","back()",sResourcesPath},
								{"true","","Button","发送","交易发送","TradeTransfer()",sResourcesPath},
								{"true","","Button","重新发送","交易重新发送","TradeTransfer()",sResourcesPath},
								{"true","","Button","撤销交易","抹帐交易","TradeCancel()",sResourcesPath},
								{"true","","Button","放款出帐申请单","放款出帐申请单","PutOutBook()",sResourcesPath},
								{"false","","Button","归档","未发送交易归档","PigeonHole()",sResourcesPath},
								{"true","","Button","交易日志","查看交易日志","ViewLog()",sResourcesPath}
							  };
							  
	    if (sDealType.substring(0,3).equals("010")){
			sButtons[4][0] = "true";
			sButtons[5][0] = "true";
			sButtons[6][0] = "false";
			sButtons[7][0] = "false";
			sButtons[8][0] = "true";
			sButtons[9][0] = "true";
		}else if (sDealType.substring(0,3).equals("020")){
			sButtons[4][0] = "false";
			sButtons[5][0] = "false";
			sButtons[6][0] = "true";
			sButtons[7][0] = "true";
			sButtons[8][0] = "true";
		}else if (sDealType.substring(0,3).equals("090")){
			sButtons[4][0] = "false";
			sButtons[5][0] = "false";
			sButtons[6][0] = "false";
			sButtons[7][0] = "false";
			sButtons[8][0] = "true";
		}else{
			sButtons[4][0] = "false";
			sButtons[5][0] = "false";
			sButtons[6][0] = "false";
			sButtons[7][0] = "true";
			sButtons[8][0] = "true";
		}

		if (sDealType.equals("030030")){
			sButtons[9][0] = "true";
		}
	    if (sDealType.equals("010")){
			sButtons[4][0] = "false";
	    }
		
	%> 
<%/*~END~*/%>



<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	/*~[Describe=退回放贷申请人;InputParam=无;OutPutParam=无;]~*/
	function back()
	{
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sReturn = getItemValueArray(0,"SerialNo");
		if (sReturn.length==0){
			alert(getHtmlMessage('1'));
			return;
		}

		if(sBusinessType == "2010" || sBusinessType == "1090010")
		{
			if(confirm("退回放贷申请人吗？"))
			{
				sRelativePutOutNo = getItemValue(0,getRow(),"RelativePutOutNo");
				//alert(sRelativePutOutNo);
				PopPage("/Common/WorkFlow/DeleteAcceptBillAction.jsp?PutOutNo="+sRelativePutOutNo,"","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
				reloadSelf();
			}
		}else if(confirm("退回放贷申请人吗？")) 
		{
			for(var iMSR = 0; iMSR < getRowCount(0) ; iMSR++)
			{
				var a = getItemValue(0,iMSR,"MultiSelectionFlag");
				if(a == "√"){
					sReturn = getItemValue(0,iMSR,"SerialNo");
					PopPageAjax("/Common/WorkFlow/AutoSubmitActionAjax.jsp?ObjectType=PutOutApply&ObjectNo="+sReturn+"&FlowNo=PutOutFlow&PhaseNo=1000&PhaseAction=发回补充资料","","");
				}
			}
			alert("操作成功");
			reloadSelf();
		}
	}
	
	/*~[Describe=交易单笔发送ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function doSubmit(){
		var sReturn = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sReturn)=="undefined" || sReturn.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		if (confirm("确定要发送该笔交易吗？")){
			PopPage("/Common/Exchange/PutOutExchangeAction.jsp?SerialNoArray="+sReturn+"&DegbugFlag=<%=sDegbugFlag%>","","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
	}
	
	/*~[Describe=交易批量发送ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function TradeTransfer()
	{
		var sReturnArrary = getItemValueArray(0,"SerialNo");
		if (sReturnArrary.length==0){
			doSubmit();
			return;
		}
		
		var sMessage="";
		
		if (sReturnArrary.length>1){
			sMessage = "确定要批量发送打√选择的交易吗？";
		}else{
			sMessage = "确定要发送打√选择的交易吗？";
		}
		
		if (confirm(sMessage)){
			PopPage("/Common/Exchange/PutOutExchangeAction.jsp?SerialNoArray="+sReturnArrary+"&DegbugFlag=<%=sDegbugFlag%>","","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
	}
	
	/*~[Describe=单笔抹帐 ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function doCancle(){
		var sReturn = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sReturn)=="undefined" || sReturn.length==0){
			alert(getHtmlMessage('1'));
			return;
		}		
		
		if (confirm("确定要撤消该笔交易吗？")){
			PopPage("/Common/Exchange/PutOutExchangeCancel.jsp?SerialNoArray="+sReturn+"&DegbugFlag=<%=sDegbugFlag%>","","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			reloadSelf();
		}	
	}
	
	/*~[Describe=批量抹帐 ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function TradeCancel()
	{
		var sReturnArrary = getItemValueArray(0,"SerialNo");
		if (sReturnArrary.length==0){
			doCancle();
			return;
		}		
		
		if (sReturnArrary.length>1){
			sMessage = "确定要批量撤销打√选择的交易吗？";
		}else{
			sMessage = "确定要撤销打√选择的交易吗？";
		}
		
		if (confirm(sMessage)){
			PopPage("/Common/Exchange/PutOutExchangeCancel.jsp?SerialNoArray="+sReturnArrary+"&DegbugFlag=<%=sDegbugFlag%>","","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			reloadSelf();
		}	
	}
	
	/*~[Describe=全选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedAll(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "√"){
				setItemValue(0,iMSR,"MultiSelectionFlag","√");
			}
		}
	}
	
	
	/*~[Describe=反选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedBack(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "√"){
				setItemValue(0,iMSR,"MultiSelectionFlag","√");
			}else{
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=取消全选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedCancel(){
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != ""){
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function viewDetail()
	{
		sObjectType = "PutOutApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
	
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		openObject(sObjectType,sObjectNo,"001");
	}
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "PutOutApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sExchangeState = getItemValue(0,getRow(),"ExchangeState");
		if (sExchangeState != "1") {
			sParamString += "&ViewID=002"
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=打印出帐通知书ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function PutOutBook()
	{
		sObjectType = "CreditPutOut";
		sObjectNo = getItemValueArray(0,"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			sObjectNo = getItemValue(0,getRow(),"SerialNo");
			if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
		}

		sExchangeType = PopPage("/Common/WorkFlow/GetExchangeTypeAction.jsp?ObjectNo="+sObjectNo,"_self","dialogWidth=0;dialogHeight=0;minimize:yes");
		
		if(typeof(sExchangeType)=="undefined" || sExchangeType.length==0) {
			return;
		}
		
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/ProducePutoutOtherFile.jsp?ExchangeType="+sExchangeType,"_blank02",CurOpenStyle); 
		
	}
	
	function ViewLog(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenPage("/Common/Exchange/ExchangeLogList.jsp?SerialNo="+sSerialNo,"_blank02","width=720,height=600,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes"); 
	}
	
		
	/*~[Describe=单笔未发送交易归档ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function doPigeonHole(){
		var sReturn = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sReturn)=="undefined" || sReturn.length==0){
			alert(getHtmlMessage('1'));
			return;
		}		
		
		if (confirm("归档后不能再重新发送交易，请仔细核对要归档的交易申请，确定要归档该笔交易吗？")){
			sReturnStatus = PopPageAjax("/Common/Exchange/ExchangePigeonHoleActionAjax.jsp?SerialNoArray="+sReturn,"","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			sReturn = getSplitArray(sReturnStatus);
			sStatus=sReturn[0];
			sMsg = sReturn[1];
			alert(sMsg);
			reloadSelf();
		}	
	}
	
	/*~[Describe=批量未发送交易归档ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function PigeonHole(){
		var sReturnArrary = getItemValueArray(0,"SerialNo");
		if (sReturnArrary.length==0){
			doPigeonHole()
			return;
		}		
		
		if (sReturnArrary.length>1){
			sMessage = "归档后不能再重新发送交易，请仔细核对要归档的交易申请，确定要批量归档打√选择的交易吗？";
		}else{
			sMessage = "归档后不能再重新发送交易，请仔细核对要归档的交易申请，确定要归档打√选择的交易吗？";
		}
		
		if (confirm(sMessage)){
			sReturnStatus = PopPageAjax("/Common/Exchange/ExchangePigeonHoleActionAjax.jsp?SerialNoArray="+sReturnArrary,"","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			sReturn = getSplitArray(sReturnStatus);
			sStatus=sReturn[0];
			sMsg = sReturn[1];
			alert(sMsg);
			reloadSelf();
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