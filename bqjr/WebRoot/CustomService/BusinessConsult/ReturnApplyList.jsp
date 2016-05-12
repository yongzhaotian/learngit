<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "退货审批页面";
    //定义变量
    String sTempletNoType="";
    String sBusinessDate=SystemConfig.getBusinessTime();
    String sSystemDate = SystemConfig.getBusinessDate();
    
	//获得页面参数
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
	
	if(sApplyType.equals("Y001")){//退货审批
		sTempletNoType="ReturnApplyList";
	}
	if(sApplyType.equals("Y002")){//保险取消
		sTempletNoType="InsureCancelApplyList";
	}
	if(sApplyType.equals("Y003")){//保险金审批
		sTempletNoType="InsureApplyList";
	}
	if(sApplyType.equals("Y004")){//提前还款审批
		sTempletNoType="BeginRepayList";
	}
	if(sApplyType.equals("Y005")){//退款审批
		sTempletNoType="RefundRepayList";
	}
	if(sApplyType.equals("Y006")){//代扣账号变更审批
		sTempletNoType="ChargeApplyList";
	}
	if("Y007".equals(sApplyType)){ //进账文件查询
		sTempletNoType = "BankLinkInfo";
	}
	if("Y010".equals(sApplyType)){ //还款文件查询
		sTempletNoType = "WithholdFileQuery";
	}
	if("Y011".equals(sApplyType)){ //送盘文件查询
		sTempletNoType = "SendFileQuery";
	}
	if("Y012".equals(sApplyType)){ //再次代扣审批
		sTempletNoType = "WithholdApproveList";
	}
	if("Y013".equals(sApplyType)){ //退款申请查询
		sTempletNoType="RefundRepayList";
	}
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = sTempletNoType;//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	if(sApplyType.equals("Y013")){
		doTemp.setFilter(Sqlca, "0030", "customername", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0040", "inputuserid", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0050", "inputdate", "Operators=EqualsString,BeginsWith;"); 
	}
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()) {
	  if(sApplyType.equals("Y013")){
			doTemp.WhereClause = " where status in ('1','3')";
		}else{
			doTemp.WhereClause = " where 1=2";
		}
	}
	if ( "Y010".equals(sApplyType)) {
		String dateFormat = "";
		String dataParam = "";
		String tip = "";
		if ("Y010".equals(sApplyType)) {
			dateFormat = "yyyy/MM/dd";
			dataParam = "导入日期";
			tip = "1990/01/01";
		}
		doTemp.WhereClause = " where 1 = 1";
		doTemp.setFilter(Sqlca, "0001", "InputDate", "Operators=EqualsString,BeginsWith;");
		doTemp.setCheckFormat("InputDate", "3");
		doTemp.parseFilterData(request, iPostChange);
		String tmp = "";
		for (int k = 0; k < doTemp.Filters.size(); k++) {
			
			if (("0001").equals(doTemp.getFilter(k).sFilterID)) {
				tmp = doTemp.Filters.get(k).sFilterInputs[0][1];
				if (tmp == null || "".equals(tmp)) {
					doTemp.WhereClause += " and 1 = 2";
				} else {
					boolean flag = true;
					SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
					sdf.setLenient(false);
					try {
						sdf.parse(tmp);
					} catch (Exception e) {
						flag = false;
					}
					if (!flag) {
						%>
							<script type="text/javascript">
								alert("为了查询数据流畅，<%=dataParam %>(格式：<%=tip %>)格式必须正确！");
							</script>
						<%
						doTemp.WhereClause += " and 1 = 2";
					}
				}
			}
		}
	}
	
	//System.out.println("sApplyType="+sApplyType);
	if(sApplyType.equals("Y004")){
		boolean flag = false;
		for(int k = 0; k < doTemp.Filters.size(); k++){
			if(doTemp.Filters.get(k).sFilterInputs[0][1] != null 
					&& (("al.putoutno").equals(doTemp.getFilter(k).sFilterColumnID))){
				flag = true;
				break;
			}
			if(doTemp.Filters.get(k).sFilterInputs[0][1] != null 
					&& (("at.inputtime").equals(doTemp.getFilter(k).sFilterColumnID))){
				flag = true;
				break;
			}
		}
		//System.out.println("flag="+flag);
		if(!flag && doTemp.haveReceivedFilterCriteria()) {
			%>
			<script type="text/javascript">
				alert("为了查询数据流畅，合同号/申请时间(格式：1990/01/01)必须录入一项！");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
		}	
	}
	
	if("Y011".equals(sApplyType)){ //送盘文件查询
		doTemp.WhereClause = " where 1 = 1";
		doTemp.setFilter(Sqlca, "0001", "CONTRACTSERIALNO", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0002", "CUSTOMERID", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0003", "CUSTOMERNAME", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0004", "WITHHOLDDATE", "Operators=EqualsString,BeginsWith;");
		doTemp.parseFilterData(request, iPostChange);
		
		if (doTemp.haveReceivedFilterCriteria()) {
			 
			 //必输项查询限制
			 boolean flag = true;
			 for (int k=0; k<doTemp.Filters.size(); k++) {
				if((("0001").equals(doTemp.getFilter(k).sFilterID)
						|| ("0002").equals(doTemp.getFilter(k).sFilterID)
						|| ("0003").equals(doTemp.getFilter(k).sFilterID)
						|| ("0004").equals(doTemp.getFilter(k).sFilterID))
						&& doTemp.Filters.get(k).sFilterInputs[0][1] != null) {
					flag = false;
					break;
				}
			 }
			 
			 if(flag){
				%>
					<script type="text/javascript">
						alert("合同编码、客户编码、客户名称、送盘日期必须输入一项!");
					</script>
				<%
				doTemp.WhereClause += " and 1 = 2";
			 }
			 
			 /* for (int k=0; k<doTemp.Filters.size(); k++) {
				if((("0001").equals(doTemp.getFilter(k).sFilterID)
						|| ("0002").equals(doTemp.getFilter(k).sFilterID)
						|| ("0003").equals(doTemp.getFilter(k).sFilterID)
						|| ("0004").equals(doTemp.getFilter(k).sFilterID))
						&& doTemp.Filters.get(k).sFilterInputs[0][1] != null) {
					flag = false;
					break;
				}
			 } */
		} else {
			doTemp.WhereClause = " where 1 = 2";
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{(sApplyType.equals("Y001")?"true":"false"),"","Button","确认退货","确认退货","saveRecord()",sResourcesPath},
		{(sApplyType.equals("Y002")?"true":"false"),"","Button","确认保险取消","确认保险取消","InsureCancel()",sResourcesPath},
		{(sApplyType.equals("Y003")?"true":"false"),"","Button","确认保险金","确认保险金","InsureApply()",sResourcesPath},
		{(sApplyType.equals("Y004")?"true":"false"),"","Button","确认提前还款","确认提前还款","BeginRepay()",sResourcesPath},
		{(sApplyType.equals("Y004")?"true":"false"),"","Button","取消提前还款","取消提前还款","cancelRepay()",sResourcesPath},
		{(sApplyType.equals("Y005")?"true":"false"),"","Button","确认退款","确认退款","Refund()",sResourcesPath},
		{(sApplyType.equals("Y005")?"true":"false"),"","Button","拒绝退款","拒绝退款","CancelRefund()",sResourcesPath},
		/* {(sApplyType.equals("Y006")?"true":"false"),"","Button","确认收到代扣账号变更申请","确认收到代扣账号变更申请","UpdateWithhold()",sResourcesPath},
		 */
		 {(sApplyType.equals("Y006")?"true":"false"),"","Button","代扣账号变更详情","代扣账号变更详情","withholdChange()",sResourcesPath},
		 {(sApplyType.equals("Y007")?"true":"false"),"","Button","文件详情","确认变更","queryDocument()",sResourcesPath},
		 {(sApplyType.equals("Y007")?"true":"false"),"","Button","导出Excel","导出Excel","exportAll()","","","",""},
		 {(sApplyType.equals("Y010")?"true":"false"),"","Button","代扣文件详情","代扣文件详情","WithholdDetails()","","","",""},
		 {((sApplyType.equals("Y012") && (CurUser.hasRole("1039")||CurUser.hasRole("1036")||CurUser.hasRole("1051")||CurUser.hasRole("1052")))?"false":"false"),"","Button","确认","确认","affirmWithhold()","","","",""},
		 {((sApplyType.equals("Y012") && (CurUser.hasRole("1039")||CurUser.hasRole("1036")||CurUser.hasRole("1051")||CurUser.hasRole("1052")))?"false":"false"),"","Button","取消","取消","cancelWithhold()","","","",""},
	};
    
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function check(val){
		
		if (val != null && val != "") {
			var a = /^(\d{4})-(\d{2})-(\d{2})$/
			if (!a.test(val)) { 
				alert("日期格式不正确!") 
				return false 
			} 
			else {
				return true;
			}
		} 
	} 
	<%/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/%>
	function exportAll(){
		amarExport("myiframe0");
	}

	<%/*~[Describe=再次代扣申请确认;InputParam=无;OutPutParam=无;]~*/%>
	function affirmWithhold(){
		var sSerialNo = getItemValue(0,getRow(),"serialno");
		var sStatus = getItemValue(0,getRow(),"status");
		var sInputDate = getItemValue(0,getRow(),"inputdate");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(sStatus == "2" || sStatus == "3"){
			alert("该申请已审批通过或已取消");
			return;
		}
		
		if("<%=sSystemDate%>"!=sInputDate){
			alert("隔天的申请不允许审批");
			return;
		}
		
		sApproveDate="<%=sBusinessDate%>";
		sApproveUserID="<%=CurUser.getUserID()%>";
		sApproveOrgID="<%=CurOrg.orgID %>";
		
		var sReturnValue=RunMethod("BusinessManage","UpdateAffirmWithhold",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sSerialNo);
		if(sReturnValue=="1.0"){
			alert("确认成功");
		}else{
			alert("确认失败");
		}
		reloadSelf();
	}
	
	<%/*~[Describe=取消再次代扣申请;InputParam=无;OutPutParam=无;]~*/%>
	function cancelWithhold(){
		var sSerialNo = getItemValue(0,getRow(),"serialno");
		var sStatus = getItemValue(0,getRow(),"status");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(sStatus == "2" || sStatus == "3"){
			alert("该申请已审批通过或已取消");
			return;
		}
		
		sApproveDate="<%=sBusinessDate%>";
		sApproveUserID="<%=CurUser.getUserID()%>";
		sApproveOrgID="<%=CurOrg.orgID %>";
		
		var sReturnValue=RunMethod("BusinessManage","UpdateCancelWithhold",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sSerialNo);
		if(sReturnValue=="1.0"){
			alert("取消成功");
		}else{
			alert("取消失败");
		}
		reloadSelf();
	}
	
	// 查询文件
	function queryDocument() {
		sInputDate = getItemValue(0,getRow(),"InputDate");
		sFlag = getItemValue(0,getRow(),"flag");
		//alert(sFlag);
		AsControl.PopView("/CustomService/BusinessConsult/QueryDocTreeView.jsp", "InputDate="+sInputDate+"&flag="+sFlag, "");
	}
	
	// 查询代扣文件详情
	function WithholdDetails() {
		sFlag = getItemValue(0,getRow(),"Flag");
		sInputDate = getItemValue(0,getRow(),"InputDate");
		AsControl.PopView("/CustomService/BusinessConsult/WithholdFileQuery.jsp", "InputDate="+sInputDate+"&Flag="+sFlag, "");
	}
	
	function saveRecord()
	{
		var sSerialNo =getItemValue(0,getRow(),"serialno");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		 
		
		var sApproveDate = getItemValue(0,getRow(),"approvedate");
		
		if (typeof(sApproveDate)=="undefined" || sApproveDate.length==0)
		{
			//是否在犹豫期内
			var sReturn=RunMethod("BusinessManage","HesitateDay",sSerialNo);
			if(sReturn==0){
				alert("该笔合同已超过犹豫期限,不能退货");
				return;
			} 
			
			//获取合同借据号、原交易信息
			var sLoanSerialNo = RunMethod("PublicMethod","GetColValue","SerialNo,ACCT_LOAN,String@PutOutNo@"+sSerialNo);//合同借据号
			if(typeof(sLoanSerialNo)=="undefined" || sLoanSerialNo.length==0){
				alert("系统处理异常！");
				return;
			}else{
				sLoanSerialNo = sLoanSerialNo.split("@")[1];
			}
			
			var sTransReturn = RunMethod("公用方法","GetColValue","ACCT_TRANSACTION,SerialNo,documentserialno='"+sSerialNo+"' and relativeobjectno='"+sLoanSerialNo+"' " );//交易流水号
			var sTransSerialNo = sTransReturn;
			var returnValue = runTransaction(sLoanSerialNo,sTransSerialNo);
			if(returnValue){
				sReturn=RunMethod("BusinessManage","UpdateRefundContractStatus",sSerialNo);
				sApproveDate="<%=sBusinessDate%>";
				sApproveUserID="<%=CurUser.getUserID()%>";
				sApproveOrgID="<%=CurOrg.orgID %>";
				var sReturnValue=RunMethod("BusinessManage","UpdateRefundCargoApply",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sSerialNo);
				if(sReturn=="1.0" && sReturnValue=="1.0"){
					 if(sSerialNo){
						var sUserID = "<%=CurUser.getUserID()%>";
						var policyNo = RunMethod("BusinessManage","GetLatstPolicy",sSerialNo);
						//后台抓取数据处理
						//RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "httpPostPolicyno","policyno="+policyNo+",updateBy="+sUserID);//退货后同时退保
					} 
					alert("确认成功");
				}else{
					alert("确认失败");
				}
			}
		}else{
			alert("该退货申请已审批通过");
		}
		reloadSelf();
		
	}
	
	//强制退款
	<%-- function returnTransaction(sLoanSerialNo,sTransSerialNo){
		var objectType = "";
		var transactionCode = "4030";
		var relativeObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.transaction%>";
		
		var relativeObjectNo = sTransSerialNo;
		var transactionDate = "<%=SystemConfig.getBusinessDate()%>";

		//创建交易同时创建单据信息
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>,2");
		if(returnValue.substring(0,5) != "true@") {
			alert("创建交易失败！错误原因-"+returnValue);
			return;
		}
		//执行交易
		var transactionSerialNo = returnValue.split("@")[1];	
		var returnTransValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
		if(typeof(returnTransValue)=="undefined"||returnTransValue.length==0||returnTransValue.split("@")[0]=="false"){
			//如果交易执行失败则删除交易信息和单据信息
			RunMethod("LoanAccount","DeleteAcctTransPayment",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			RunMethod("LoanAccount","DeleteAcctTransaction",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			alert("系统处理异常！");
			return false;
		}
		return true;		
	} --%>
	
	function runTransaction(sLoanSerialNo,sTransSerialNo){
		var objectType = "";
		var transactionCode = "4015";
		var relativeObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.transaction%>";
		
		var relativeObjectNo = sTransSerialNo;
		var transactionDate = "<%=SystemConfig.getBusinessDate()%>";

		//创建交易同时创建单据信息
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>,2");
		if(returnValue.substring(0,5) != "true@") {
			alert("创建交易失败！错误原因-"+returnValue);
			return;
		}
		//执行交易
		var transactionSerialNo = returnValue.split("@")[1];	
		var returnTransValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
		if(typeof(returnTransValue)=="undefined"||returnTransValue.length==0||returnTransValue.split("@")[0]=="false"){
			//如果交易执行失败则删除交易信息和单据信息
			var documentserialno = RunMethod("PublicMethod","GetColValue","documentserialno,ACCT_TRANSACTION,String@transcode@4015@String@SerialNo@"+transactionSerialNo+"@String@relativeobjectno@"+sLoanSerialNo);
			RunMethod("PublicMethod","DeleteAcctPaymentValue",documentserialno);//"acct_trans_payment,SerilNo,"
			RunMethod("PublicMethod","DeleteColValue",transactionSerialNo);//"ACCT_TRANSACTION,SerialNo,"
			alert("系统处理异常！");
			return false;
		}
		var message=returnValue.split("@")[1];	
		return true;		
	}
	
	
	//保险取消
	function InsureCancel(){
		var sSerialNo = getItemValue(0,getRow(),"ApplySerialNo");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		//修改处理状态
		
		
		
	}
	
	
	//保险金
	function InsureApply(){
		var sSerialNo = getItemValue(0,getRow(),"ApplySerialNo");//

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
	
		
	}
	//代扣账号详情 add by cliu 2013/05/20 begin
	function withholdChange(){
    	//变更申请流水号
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo"); //add by yzhang9  获取合同编号 CCS-444 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		 sCompID = "ChargeApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&ContractSerialNo="+sContractSerialNo;// add by yzhnag 9  CCS-444 将合同编号传给下个页面  用来查找ProductID 
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
    }
	//代扣账号详情 add by cliu 2013/05/20 end 
	
	/* //代扣账号变更
	function UpdateWithhold(){
		var sSerialNo = getItemValue(0,getRow(),"CustomerID");//申请编号
		var sNewAccountName = getItemValue(0,getRow(),"NewAccountName");//新代扣账户户名
		var sNewAccount = getItemValue(0,getRow(),"NewAccount");//新代扣账户账号
		var sNewBankName = getItemValue(0,getRow(),"NewBankName");//新代扣账户开户行

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
			//2.更新代扣账号
			sReturn = RunMethod("BusinessManage","UpdateReplace",sSerialNo+","+sNewAccountName+","+sNewAccount+","+sNewBankName);
			//alert("======"+sReturn);
			if(sReturn=="1.0"){
				alert("代扣账号更新完成！");
			}else{
				alert("代扣账号无法更新，请检查！");
			}

	} */
	
	//提前还款
	function BeginRepay(){
		var sSerialno = getItemValue(0,getRow(),"Serialno");
		var sContractSerialNo=getItemValue(0,getRow(),"PutoutNo");//合同编号 
		var sTransStatus = getItemValue(0,getRow(),"TransStatus");//交易状态
		var sAdvanceHesitateDate1=RunMethod("BusinessManage","BusinessHesitateDate",sContractSerialNo);//获取犹豫期天数
		var sAdvanceHesitateDate=parseInt(sAdvanceHesitateDate1);
		var sReturn1=RunMethod("BusinessManage","ApproveHesitateDay",sContractSerialNo+","+sSerialno+","+sAdvanceHesitateDate);
		if (typeof(sSerialno)=="undefined" || sSerialno.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(sTransStatus!="0"){
			alert("只有申请状态为审批中的申请才允许进行复核操作。。");
			return;
		}
		
		var sApproveDate = getItemValue(0,getRow(),"ApproveDate");
		
		if (typeof(sApproveDate)=="undefined" || sApproveDate.length==0)
		{
			sApproveDate="<%=sBusinessDate%>";
			sApproveUserID="<%=CurUser.getUserID()%>";
			sApproveOrgID="<%=CurOrg.orgID %>";
			
			var sReturn=RunMethod("BusinessManage","UpdatePrePaymentApply",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sSerialno);
		
			if(sReturn=="1.0"){
				if(sReturn1!=0){
				RunMethod("BusinessManage","UpdateIswaver",sContractSerialNo);//是犹豫期标志	
				}else{
				RunMethod("公用方法", "UpdateColValue", "Business_Contract,Iswaver,,SerialNo='"+sContractSerialNo+"'");//非犹豫期标志为空
				}
				alert("确认成功");
			}else{
				alert("确认失败,请检查");
			}
		}else{
			alert("该提前还款申请已经审批通过");
		}
		reloadSelf();
	}
	
	//取消提前还款
	function cancelRepay(){
		var sSerialno = getItemValue(0,getRow(),"Serialno");//交易流水号
		var sLoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");//借据号
		var sTransStatus = getItemValue(0,getRow(),"TransStatus");//交易状态
		var sTransDate = getItemValue(0,getRow(),"TransDate");//交易日期
		var sContractSerialNo=getItemValue(0,getRow(),"PutoutNo");//合同编号 
		if (typeof(sSerialno)=="undefined" || sSerialno.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(sTransStatus!="0" && sTransStatus!="3"){
			alert("只有申请状态为审批中或者审批通过的申请才允许取消。。");
			return;
		}
		
		if(sTransDate<="<%=SystemConfig.getBusinessDate()%>"){
			alert("提前还款日期小于系统日期，不允许做该操作。。");
			return;
		}

		var sReturn=RunMethod("BusinessManage","CancelPrePaymentApply",sLoanSerialNo+","+sSerialno);

		if(sReturn=="Success"){	
			RunMethod("公用方法", "UpdateColValue", "Business_Contract,Iswaver,,SerialNo='"+sContractSerialNo+"'");//提前还款取消后合同犹豫期标志清空 
			alert("取消成功");
		}else{
			alert("取消失败,请检查");
		}
		reloadSelf();
	}
	
	//确认退款
	function Refund(){
		var sCustomerID = getItemValue(0,getRow(),"customerid");
		var sReturnAmt = getItemValue(0,getRow(),"returnamt");
		var sStatus = getItemValue(0,getRow(),"status");
		var sSerailNo = getItemValue(0,getRow(),"serialno");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if (typeof(sStatus)=="undefined" || sStatus.length==0)
		{
			alert("审批状态为空!");  //请选择一条记录！
			return;
		}
		if(sStatus!="1"){
			alert("非审批中的退款不允许确认退款!");
			return;
		}
		var sReturn=RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
		
		if(parseFloat(sReturn)<parseFloat(sReturnAmt)){
			alert("退款金额大于预存款余额,不能退款");
			return;
		}	
		
		var sApproveDate = getItemValue(0,getRow(),"approvedate");
		
		if (typeof(sApproveDate)=="undefined" || sApproveDate.length==0)
		{
			sApproveDate="<%=sBusinessDate%>";
			sApproveUserID="<%=CurUser.getUserID()%>";
			sApproveOrgID="<%=CurOrg.orgID %>";
			
			var sResult=RunMethod("BusinessManage","UpdateRefundApply",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sCustomerID);
			var sUpdateReturn=RunMethod("BusinessManage","UpdateDepositsAmount",sCustomerID+","+sReturnAmt);
		
			if(sResult=="1.0" && sUpdateReturn=="1.0"){	
				alert("确认成功");
				var sSerialNo = getSerialNo("BATCH_ADVANCE_LOG","SERIALNO","");
				var lastDeposits = sReturn;
				RunMethod("公用方法", "UpdateColValue", "refund_deposits,status,2, serialno='"+sSerailNo+"'");
				var sReturnnow=RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
				RunMethod("BusinessManage","InsertAdvanceLog",sSerialNo+",<%=sBusinessDate%>,"+sCustomerID+","+lastDeposits+","+sReturnnow);
			}else{
				alert("确认失败,请检查");
			}
		}else{
			alert("该退款已经审批通过");
		}
		reloadSelf();
	}
	
	
	//取消退款
	function CancelRefund(){
		if(!confirm("是否确认拒绝退款")){
			return;
		}
		var sCustomerID = getItemValue(0,getRow(),"customerid");
		var sStatus = getItemValue(0,getRow(),"status");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if (typeof(sStatus)=="undefined" || sStatus.length==0)
		{
			alert("审批状态为空!");  //请选择一条记录！
			return;
		}
		if(sStatus!="1"){
			alert("非审批中的退款不允许取消退款!");
			return;
		}
		var sApproveDate = getItemValue(0,getRow(),"approvedate");
		
		if (typeof(sApproveDate)=="undefined" || sApproveDate.length==0)
		{
			sApproveDate="<%=sBusinessDate%>";
			sApproveUserID="<%=CurUser.getUserID()%>";
			sApproveOrgID="<%=CurOrg.orgID %>";
			
			var sResult=RunMethod("BusinessManage","CancelRefundApply",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sCustomerID);
		
			if(sResult=="1.0"){	
				alert("取消成功");
			}else{
				alert("取消失败,请检查");
			}
		}else{
			alert("该退款已取消");
		}
		reloadSelf();
	}


	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//查询条件展开设置
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>