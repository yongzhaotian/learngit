<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
	页面说明: 延期还款申请列表
	*/
	String PG_TITLE = "变更还款日申请";
	
	String serialNo = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("serialNO"))); //流水号
	String contractNo = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("contractNO")));	// 
	String customerId = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("customerId")));	// 
	String customerName = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("customerName")));	// 
	String certId = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("certId")));	// 
	String certType = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("certType")));	// 
	String certTypeName = DataConvert.toString(DataConvert.toRealString(
			 	iPostChange, (String)CurPage.getParameter("certTypeName")));	//
	String applyTime = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("applyTime")));	//
	String curPayDate = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("curPayDate")));	//
	String leftTime = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("leftTime")));	//
	String perIods = DataConvert.toString(DataConvert.toRealString(
			 	iPostChange, (String)CurPage.getParameter("perIods")));	//
			
	String btnShow[] = new String[2];
	if(serialNo == null || "".equals(serialNo)){
		serialNo = DBKeyUtils.getSerialNo();
		btnShow[0] = "true";
		btnShow[1] = "true";
	}else{
		btnShow[0] = "false";
		btnShow[1] = "false";
	}
%>
	
<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ChangeBOMTRInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo, Sqlca);
	doTemp.parseFilterData(request, iPostChange);
	CurPage.setAttribute("FilterHTML", doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";   //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(serialNo);
	for(int i = 0; i < vTemp.size(); i++) {
		out.print((String)vTemp.get(i));
	}
	
	String sButtons[][] = {
		{btnShow[0], "", "Button", "提交", "保存", "saveRecord()", sResourcesPath},
		{btnShow[1], "", "Button", "取消", "取消", "cancelRecord()", sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function initRow() {
		if (getRowCount(0) == 0) { // 如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");
			setItemValue(0, 0, "ALTER_TYPE", "01");
			setItemValue(0, 0, "ALTER_VALUE", "");
			setItemValue(0, 0, "STATUS", "0");
			setItemValue(0, 0, "SERIALNO", "<%=serialNo %>");
			setItemValue(0, 0, "CONTRACTNO", "<%=contractNo %>");
			setItemValue(0, 0, "CUSTOMERID", "<%=customerId %>");
			setItemValue(0, 0, "CUSTOMERNAME", "<%=customerName %>");
			setItemValue(0, 0, "CUSTOMERID", "<%=customerId %>");
			setItemValue(0, 0, "CUSTOMERNAME", "<%=customerName %>");
			setItemValue(0, 0, "CERTID", "<%=certId %>");
			setItemValue(0, 0, "CERTTYPE_NAME", "<%=certTypeName %>");
			setItemValue(0, 0, "CERTTYPE", "<%=certType %>");
			setItemValue(0, 0, "APPLY_TIME", "<%=applyTime %>");
			setItemValue(0, 0, "CUR_PAYDATE", "<%=curPayDate == null || "null".equals(curPayDate) ? "" : curPayDate %>");
			setItemValue(0, 0, "LEFT_TIMES", "<%=leftTime %>");
			setItemValue(0, 0, "INPUT_USERID", "<%=CurUser.getUserID() %>");
			alterValueOnchange();
		} else {
			showOtherItem("contractNOBtn", "none");
			setItemDisabled(0, 0, "APPLY_REASON", true);
		}
		setItemRequired(0, 0, "PRE_APPLYTIME", false);
	}
	
	function alterValueOnchange() {

		var alterType = getItemValue("0", "0", "ALTER_TYPE");
		var alterValue = getItemValue("0", "0", "ALTER_VALUE");
		var curPayDate = getItemValue("0", "0", "CUR_PAYDATE");
		var applyTime = "<%=applyTime %>";
		if(alterType == null || alterType == ""){
			alert("请选择服务类型！");
			setItemOption("0", "0", "ALTER_PAYDATE", "");
			setItemValue("0", "0", "ALTER_PAYDATE", "");
			return;
		}
		if(alterValue == null || alterValue == ""){
			setItemOption("0", "0", "ALTER_PAYDATE", "");
			setItemValue("0", "0", "ALTER_PAYDATE", "");
			return;
		}
		if (curPayDate == null || curPayDate == "" || curPayDate == "null") {
			alert("获取不到开始变更日期！");
			setItemOption("0", "0", "ALTER_PAYDATE", "");
			setItemValue("0", "0", "ALTER_PAYDATE", "");
			return;
		}
		var params = "alterType=" + alterType + ",alterValue=" + alterValue 
					+ ",curPayDate=" + curPayDate + ",applyTime=" + applyTime;
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BOMTRApplyCheck", 
								"queryAlterPayDate", params);		// 校验返回结果
		if (result.split("@")[0] == "false") {
			setItemValue(0, 0, "ALTER_VALUE", "");
			setItemOption("0", "0", "ALTER_PAYDATE", "");
			setItemValue("0", "0", "ALTER_PAYDATE", "");
			alert(result.split("@")[1]);
			return;
		} else {
			var opts = result.split("@")[1];
			setItemOption("0", "0", "ALTER_PAYDATE", opts);
			setItemValue("0", "0", "ALTER_PAYDATE", "");
		}
	}
	
	function saveRecord() {
		
		var curPayDate = "<%=curPayDate %>";
		if (curPayDate == null || curPayDate == "" || curPayDate == "null") {
			alert("获取不到开始变更日期！");
			return;
		}
		var alterPayDate = getItemValue("0", "0", "ALTER_PAYDATE");
		if(alterPayDate == null || alterPayDate == ""){
			alert("变更后还款日期不能为空！");
			return;
		}
		var contractNo = getItemValue(0, 0, "CONTRACTNO");
		var alterType = getItemValue(0, 0, "ALTER_TYPE");
		var alterValue = getItemValue(0, 0, "ALTER_VALUE");
		var applyReason = getItemValue(0, 0, "APPLY_REASON");//申请原因
		var alterPayDate = getItemValue(0, 0, "ALTER_PAYDATE");
		var params = "contractNo=" + contractNo + ",alterType=" + alterType + ",alterValue=" + alterValue
					+ ",customerId=<%=customerId %>,customerName=<%=customerName %>"
					+ ",applyTime=<%=applyTime %>,curPayDate=" + curPayDate + ",inputUserId=<%=CurUser.getUserID() %>"
					+ ",inputDate=<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>,pt=<%=perIods %>,alterPayDate=" + alterPayDate;
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BOMTRApplyCheck", "applyCheck", params);		// 校验返回结果
		if (result.split("@")[0] == "false") {
			alert(result.split("@")[1]);
			return;
		}

		if (contractNo == null || contractNo == ""){
			alert("请输入合同号！");
			return;
		}
		if(alterType == null || alterType == ""){
			alert("请选择服务类型！");
			return;
		}
		if(alterValue == null || alterValue == ""){
			alert("请选择变更还款日！");
			return;
		}
		var preApplyTime = result.split("@")[1];	// 上次申请时间
		preApplyTime = preApplyTime == null || preApplyTime == "null" ? "" : preApplyTime; 
		var alterPayDate = getItemValue(0, 0, "ALTER_PAYDATE");	// 变更后的还款日
		var serialNO = getItemValue(0, 0, "SERIALNO");	// 流水号
		var customerId = getItemValue(0, 0, "CUSTOMERID");	// 客户ID
		var customerName = getItemValue(0, 0, "CUSTOMERNAME");	// 客户姓名
		var certType = getItemValue(0, 0, "CERTTYPE");	// 证件类型
		var certId = getItemValue(0, 0, "CERTID");	// 证件号码
		
		if (serialNO == null || serialNO == "") {
			alert("获取不到流水号！");
			return;
		}
		if (customerName == null || customerName == ""){
			alert("请输入客户姓名！");
			return;
		}
		if (certType == null || certType == "") {
			alert("获取不到证件类型！");
			return;
		}
		if (certId == null || certId == "") {
			alert("获取不到证件号码！");
			return;
		}
		if (certId == null || certId == "") {
			alert("获取不到首次变更后还款日期！");
			return;
		}
		
		setItemValue(0, 0, "PRE_APPLYTIME", preApplyTime == null || preApplyTime == "null" ? "" : preApplyTime);
		params = "serialNo=" + serialNO + ", contractNO=" + contractNo + ", customerId=" + customerId 
				+ ", customerName=" + customerName + ", alterType=" + alterType + ", alterPaydate=" + alterPayDate 
				+ ", alterValue=" + alterValue + ", status=0" + ", applyReason=" + applyReason + ", curPaydate=" + curPayDate
				+ ", leftTimes=<%=leftTime %>" + ", preApplytime=" + preApplyTime + ", inputUserid=<%=CurUser.getUserID() %>" 
				+ ", updateUserid=<%=CurUser.getUserID() %>, certId=" + certId + ", certType=" + certType
				+ ", applyTime=<%=applyTime %>";
		// 保存信息
		if(confirm("一旦提交，将在晚上产生费用记录，是否提交？")){
			result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BOMTRApply", "submitApply", params);	
			if (result.split("@")[0] != "true") {
				alert(result.split("@")[1]);
				return;
			} else {
				alert("保存成功！");
				return;
			}
		}
		
	}
	
	// 显示/隐藏控件
	function showOtherItem(id, display) {
		window.frames["myiframe0"].document.getElementById(id).style.display = display;
	}
	
	
	function cancelRecord() {
		
		if (window.confirm("你确定要取消吗？")) {
			window.close();
		}
	}
</script>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	bFreeFormMultiCol = true;
	my_load(2, 0, 'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>
