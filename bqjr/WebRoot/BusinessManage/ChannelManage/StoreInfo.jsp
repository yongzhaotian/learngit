<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "门店信息";

	// 获得页面参数
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SSerialNo"));
	String sRSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSSerialNo"));
	String sRSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSerialNo"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sViewId =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	
	if (sSSerialNo == null) sSSerialNo = "";
	if (sRSSerialNo == null) sRSSerialNo = "";
	if (sRSerialNo == null) sRSerialNo = "";
	if (sApplyType == null) sApplyType = "";
	if (sViewId == null) sViewId = "01";
	
	if (CommonConstans.ReTAILSTORE_APPROVE_TYPE.equals(sApplyType) || "02".equals(sViewId)) CurPage.setAttribute("RightType", "ReadOnly");
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTBANK", "style={width=150px;");
	
	
	// 设置默认值
	// 获取零售商帐号信息,如果存在设置到门店中
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Account,AccountName,AccountBank,AccountbankCity,BranchCode from Retail_Info where SerialNo=:SerialNo ").setParameter("SerialNo", sRSerialNo));
	String sAccount = "";
	String sAccountName = "";
	String sAccountBank = "";
	String sAccountbankCity = "";
	String sBranchCode = "";
	String sBranchCodeName = "";
	if (rs.next()) {
		
		sAccount = rs.getString("Account");
		sAccountName = rs.getString("AccountName");
		sAccountBank = rs.getString("AccountBank");
		sAccountbankCity = rs.getString("AccountbankCity");
		sBranchCode = rs.getString("BranchCode");
		
		// if null set the value ""
		if (sAccount == null) sAccount = "";
		if (sAccountName == null) sAccountName = "";
		if (sAccountBank == null) sAccountBank = "";
		if (sAccountbankCity == null) sAccountbankCity = "";
		if (sBranchCode == null) sBranchCode = "";
		
		sBranchCodeName=Sqlca.getString(new SqlObject("select bankname from bankput_info where bankno =:bankno ").setParameter("bankno", sBranchCode));
		
		doTemp.setDefaultValue("ACCOUNT", sAccount);
		doTemp.setDefaultValue("ACCOUNTNAME", sAccountName);
		doTemp.setDefaultValue("ACCOUNTBANK", sAccountBank);
		doTemp.setDefaultValue("ACCOUNTBANKCITY", sAccountbankCity);
		doTemp.setDefaultValue("BranchCode", sBranchCode);
		doTemp.setDefaultValue("BranchCodeName", sBranchCodeName);
	}
	rs.getStatement().close();
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	var gCityManager = "";
	var gSalesManager = "";
	
	// 获取城市经理
	function getCityManager() {
		
		var sCity = getItemValue(0, 0, "CITY");
		if (typeof(sCity)=="undefined" || sCity.length==0) {
			alert("请先选择门店所在城市！");
			return;
		}
		
		var sRetVal = setObjectValue("SelectCityResponsiblePerson", "CityNo,"+getItemValue(0, 0, "CITY"),"",0,0,"");
		if (typeof(sRetVal)=='undefined' || sRetVal=="_CLEAR_") {
			return;
		}
		var sUserId = sRetVal.split("@")[0];
		var sUserName = sRetVal.split("@")[1];
		setItemValue(0, 0, "CITYMANAGER", sUserId);
		setItemValue(0, 0, "CITYMANAGERNAME", sUserName);
	}
	/*~[Describe=检查电子邮件合法性;InputParam=无;OutPutParam=无;]~*/
	function checkEmail(obj) {
		var bEmail = CheckEMail(obj.value);
		
		var Letters = "@";
		//检查字符串中"@"字符的位置
		
		var index=obj.value.indexOf(Letters) ;
			
		if (!bEmail) {
			alert("请输入正确的电子邮箱！");
			return;
		}
		
		if((((obj.value.charAt(index+1))=="q"&&(obj.value.charAt(index+2))=="q"))||(((obj.value.charAt(index+1))=="Q"&&(obj.value.charAt(index+2))=="Q"))||(((obj.value.charAt(index+1))=="q"&&(obj.value.charAt(index+2))=="Q"))||(((obj.value.charAt(index+1))=="Q"&&(obj.value.charAt(index+2))=="q"))){
			
			alert("不能使用QQ邮箱");
			return false;
			
		}
	}
	// 如果是商户网银，门店结算等信息不可修改
	function isNetBank() {
	
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
		
			setItemReadOnly(0,0,"BranchCodeName", true);
			
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNT",true);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",true);
			
			
			setItemValue(0, 0, "ACCOUNT", "<%=sAccount%>");
			setItemValue(0, 0, "ACCOUNTNAME", "<%=sAccountName%>");
			setItemValue(0, 0, "ACCOUNTBANK", "<%=sAccountBank%>");
			setItemValue(0, 0, "ACCOUNTBANKCITY", "<%=sAccountbankCity%>");
			setItemValue(0, 0, "BranchCode", "<%=sBranchCode%>");
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", RunMethod("公用方法", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo='<%=sAccountbankCity%>'"));
			var sBranchCodeName = RunMethod("公用方法", "GetColValue", "bankput_info,bankname, bankno ='<%=sBranchCode%>'");
			setItemValue(0, 0, "BranchCodeName", sBranchCodeName);
		} else if (sNetBank=="2") {
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",false);
			setItemDisabled(0,getRow(),"ACCOUNT",false);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",false);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",false);
			
			
			setItemReadOnly(0,0,"BranchCodeName", false);
			setItemValue(0,0,"ACCOUNT", "");
			setItemValue(0,0,"ACCOUNTNAME", "");
			setItemValue(0,0,"ACCOUNTBANK", "");
			setItemValue(0, 0, "ACCOUNTBANKCITY", "");
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", "");
			setItemValue(0, 0, "BranchCodeName", "");
		}
	}
	
	// 如果使用商户网银，设置成默认值，替代下拉框不能设置成只读
	function setBankDefValue() {
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
			setItemValue(0, 0, "ACCOUNTBANK", "<%=sAccountBank%>");
		}
	}
	/*~[Describe=弹出单选框选择销售人员;InputParam=无;OutPutParam=无;]~*/
	function selectSalesmanSingle() {
		/*
		var sCity = getItemValue(0, 0, "CITY");
		if (typeof(sCity)=="undefined" || sCity.length==0) {
			alert("请先选择门店所在城市！");
			return;
		}
		*/
		
		var sRetVal = setObjectValue("SelectSalesmanSingleByCity1", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
		setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
		setItemValue(0, 0, "SALESPHONE", sRetVal.split("@")[2]);
		setItemValue(0, 0, "CITYMANAGER", sRetVal.split("@")[3]);
		setItemValue(0, 0, "CITYMANAGERNAME", sRetVal.split("@")[4]);
		var email = sRetVal.split("@")[5] + "@" + sRetVal.split("@")[6];
		setItemValue(0, 0, "EMAIL", email);
		return;
	}
	
	/*~[Describe=弹出多选框选择商品范畴;InputParam=无;OutPutParam=无;]~*/
	function selectProductCategoryMulti() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择商品范畴！");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "PRODUCTCATEGORY", sCTypeIds.substring(0, sCTypeIds.length-1));
		setItemValue(0, 0, "PRODUCTCATEGORYNAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	function selectMainProductCategory() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择主推品牌！");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "MAINBUSINESSTYPE", sCTypeIds.substring(0, sCTypeIds.length-1));
		setItemValue(0, 0, "MAINBUSINESSTYPENAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode() {
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		
		setItemValue(0, 0, "CITY", retVal.split("@")[0]);
		setItemValue(0, 0, "CITYNAME", retVal.split("@")[1]);
		//var sSNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getStoreNo", "cityCode="+retVal.split("@")[0]);
		//setItemValue(0, 0, "SNO", sSNo);
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode1() {
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		
		setItemValue(0, 0, "ACCOUNTBANKCITY", retVal.split("@")[0]);
		setItemValue(0, 0, "ACCOUNTBANKCITYNAME", retVal.split("@")[1]);

	}
	
	//门店结算账号开户支行
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"ACCOUNTBANK");
		var sCity     = getItemValue(0,0,"ACCOUNTBANKCITY");
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
			return;
		}
		
		if(sCity=="" ||sOpenBank==""){
			alert("请选择开户银行或省市！");
			return;
		}
		
		sCompID = "SelectWithholdList";
		sCompURL = "/CreditManage/CreditApply/SelectWithholdList.jsp";
		sParaString="OpenBank="+sOpenBank+"&City="+sCity;
		
		sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"BranchCode",sBankNo);
		setItemValue(0,0,"BranchCodeName",sBranch);
	}
	
	function saveRecord(sPostEvents){
		var sPredictloanAmount= getItemValue(0, 0, "PREDICTLOANAMOUNT");
		var ssSSerialNo= "<%=sRSerialNo%>";
		
		var sssSSerialNo=ssSSerialNo.substring(1);
		
		if(sPredictloanAmount=="0"){
			alert("预计每月分期贷款单量不能为0！");
			return;
		}
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "batchGenerateStoreNo", "serialNo="+sssSSerialNo);
		var curCityManager = getItemValue(0, 0, "CITYMANAGER");
		var curSalesManager = getItemValue(0, 0, "SALESMANAGER");
		
		
		
		if (curCityManager.length>0 || curSalesManager.length>0) { // 改变了城市经理或销售经理
			RunMethod("公用方法", "UpdateColValue", "User_Info,SuperId,"+curCityManager+",UserId='"+curSalesManager+"'");
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
		
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/ChannelManage/RetailRetiveStoreList.jsp","RSSerialNo=<%=sRSSerialNo %>&RSerialNo=<%=sRSerialNo %>","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
		
			var serialNo = getSerialNo("Store_Info","SerialNo","S");// 获取流水号
			setItemValue(0,getRow(),"SERIALNO",serialNo);
			
			setItemValue(0, 0, "RSERIALNO", "<%=sRSerialNo %>");
			setItemValue(0, 0, "RSSERIALNO", "<%=sRSSerialNo %>");
			
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "INPUTORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "UPDATEORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNT",true);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",true);
			setItemValue(0, 0, "ACCOUNT", "<%=sAccount%>");
			setItemValue(0, 0, "ACCOUNTNAME", "<%=sAccountName%>");
			setItemValue(0, 0, "ACCOUNTBANK", "<%=sAccountBank%>");
			setItemValue(0, 0, "ACCOUNTBANKCITY", "<%=sAccountbankCity%>");
			setItemValue(0, 0, "BranchCode", "<%=sBranchCode%>");
			var sBankCityName = RunMethod("公用方法", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo='<%=sAccountbankCity%>'");
			var sBranchCodeName = RunMethod("公用方法", "GetColValue", "bankput_info,bankname, bankno ='<%=sBranchCode%>'");
			if (sBankCityName=="Null") sBankCityName = "";
			if (sBranchCodeName=="Null") sBranchCodeName = "";
			setItemValue(0, 0, "BranchCodeName", sBranchCodeName);
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", sBankCityName);
		}
		
		// 获取城市经理，销售经理
		gCityManager = getItemValue(0, 0, "CITYMANAGER");
		gSalesManager = getItemValue(0, 0, "SALESMANAGER");
		
    }
	
	$(document).ready(function(){
		bFreeFormMultiCol = true;
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
