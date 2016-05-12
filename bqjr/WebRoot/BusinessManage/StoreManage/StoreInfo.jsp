<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%

	/*
		Author:  
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 2015/06/19 CCS-863 PRM-451 门店详情中销售经理有值则不能修改
	*/

	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "门店信息";

	// 获得页面参数
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));
	String sModify=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));

	if(sStatus == null) sStatus = "";
	if(sSSerialNo == null) sSSerialNo = "";
	if(sFlag == null) sFlag = ""; 
	if(sModify == null) sModify = ""; 
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setReadOnly("SALESMANAGERNAME", true);
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTBANK", "style={width=250px;");
	doTemp.setHTMLStyle("SNAME", "style={width=250px;");
	doTemp.setHTMLStyle("RETAILNAME", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTNAME", "style={width=250px;");
	
	// 设置城市不能修改
	String sStoreNo = Sqlca.getString(new SqlObject("SELECT SNO FROM STORE_INFO WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sSSerialNo));
	if (sStoreNo !=null ) doTemp.setUnit("CITYNAME", "");
	
	//门店状态为“激活”和“暂时关闭”，不可修改“销售经理”和“城市经理”；
	if("05".equals(sStatus) || "07".equals(sStatus)){
		doTemp.setUnit("SALESMANAGERNAME", "");
	}
	
	// 设置默认值
	// 获取零售商帐号信息,如果存在设置到门店中
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Account,AccountName,AccountBank,AccountbankCity,BranchCode,isindaccount from Retail_Info where SerialNo=(Select RSerialNo from Store_Info where SerialNo=:SerialNo) ").setParameter("SerialNo", sSSerialNo));
	String sAccount = "";
	String sAccountName = "";
	String sAccountBank = "";
	String sAccountbankCity = "";
	String sBranchCode = "";
	String sBranchCodeName = "";
	String sIsindaccount = "";
	if (rs.next()) {
		
		sAccount = rs.getString("Account");
		sAccountName = rs.getString("AccountName");
		sAccountBank = rs.getString("AccountBank");
		sAccountbankCity = rs.getString("AccountbankCity");
		sBranchCode = rs.getString("BranchCode");
		sIsindaccount = rs.getString("isindaccount");
		
		// if null set the value ""
		if (sAccount == null) sAccount = "";
		if (sAccountName == null) sAccountName = "";
		if (sAccountBank == null) sAccountBank = "";
		if (sAccountbankCity == null) sAccountbankCity = "";
		if (sBranchCode == null) sBranchCode = "";
		if (sIsindaccount == null) sIsindaccount = "";
		
		sBranchCodeName=Sqlca.getString(new SqlObject("select bankname from bankput_info where bankno =:bankno ").setParameter("bankno", sBranchCode));
		
		doTemp.setDefaultValue("ACCOUNT", sAccount);
		doTemp.setDefaultValue("ACCOUNTNAME", sAccountName);
		doTemp.setDefaultValue("ACCOUNTBANK", sAccountBank);
		doTemp.setDefaultValue("ACCOUNTBANKCITY", sAccountbankCity);
		doTemp.setDefaultValue("BranchCode", sBranchCode);
		doTemp.setDefaultValue("BranchCodeName", sBranchCodeName);
		doTemp.setDefaultValue("isindaccount", sIsindaccount);
	}
	rs.getStatement().close();
	
	//当某些市级单位没有下属县区时，县区非必选
	String city = Sqlca.getString("select city from STORE_INFO where SERIALNO = '"+sSSerialNo+"'");
	if(city == null) city="";
	String sortNo = Sqlca.getString("select sortNo from code_library where codeno = 'AreaCode' and itemno='"+city+"'");
	if(sortNo == null) sortNo="";
	String count = Sqlca.getString("select count(1) FROM code_library WHERE codeno = 'AreaCode' "
			+ " AND isinuse = '1' AND sortno LIKE '"+sortNo+"%' AND sortno <> '"+sortNo+"'");
	int iCnt = Integer.parseInt(count);
	if(iCnt == 0){
		doTemp.setRequired("COUNTRYNAME", false);
	}
		
	//业务需求项目PRM-657 商户/门店详情的信息修改限制
	//门店名称、是否采用商户、网银信息（门店结算账号开户行、门店结算账号开户行所在省市、门店结算账号户名、门店结算账号、门店结算账号开户支行）
	if("N".equals(sModify) && !CurUser.hasRole("1705")){
		doTemp.setReadOnly("SNAME,ISNETBANK,ACCOUNTBANK,ACCOUNTBANKCITYNAME,ACCOUNTNAME,ACCOUNT,BranchCodeName", true);
		doTemp.setUnit("ACCOUNTBANKCITYNAME,BranchCodeName", "");
	}
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	
	//关闭状态不允许编辑 update CCS-884 关闭状态隐藏保存按钮 tangyb 20150720
	if(!"06".equals(sStatus)){
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	}else{
		dwTemp.ReadOnly = "1"; // 设置是否只读 1:只读 0:可写
	}
	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
	if("CountAndCheck".equals(sFlag)){
		dwTemp.ReadOnly = "1"; // 设置是否只读 1:只读 0:可写
		sButtons[0][0] ="false";
		sButtons[1][0] ="false";
		sButtons[2][0] ="false";

	}else{
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写

	}
	
	//add CCS-884 关闭状态隐藏保存按钮 tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	var gCityManager = "";
	var gSalesManager = "";
	
		// 获取城市经理
		function getCityManager() {
			var sSNO = getItemValue(0, 0, "SNO");
			var oldManager = RunMethod("GetElement","GetElementValue","CITYMANAGER,store_info,SNO='"+sSNO+"'");
			if("<%=sStatus%>"!="05"){
				return;
			}
			if(typeof(oldManager)!='undefined' && oldManager.length!=0 && oldManager!=""){
				return;
			}
			
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
			
			var returnValue=RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "checkCityManager", "salesManager="+sUserId+",sNo="+sSNO);
			if(returnValue=="true"){
				alert("该门店下销售代表中已存在其他城市经理！");
				setItemValue(0, 0, "CITYMANAGER", "");
				setItemValue(0, 0, "CITYMANAGERNAME", "");
			}
		}
		
		// 如果是商户网银，门店结算等信息不可修改
		function isNetBank() {
			var sNetBank = getItemValue(0, 0, "ISNETBANK");
			if (sNetBank=="1") {
				setItemReadOnly(0,0,"ACCOUNT", true);
				setItemReadOnly(0,0,"ACCOUNTNAME", true);
				setItemReadOnly(0,0,"ACCOUNTBANK", true);
				setItemReadOnly(0,0,"BranchCodeName", true);
				setItemValue(0, 0, "ACCOUNT", "<%=sAccount%>");
				setItemValue(0, 0, "ACCOUNTNAME", "<%=sAccountName%>");
				setItemValue(0, 0, "ACCOUNTBANK", "<%=sAccountBank%>");
				setItemValue(0, 0, "ACCOUNTBANKCITY", "<%=sAccountbankCity%>");
				setItemValue(0, 0, "BranchCode", "<%=sBranchCode%>");
				var sCityName = RunMethod("公用方法", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo='<%=sAccountbankCity%>'");
				var sBranchCodeName = RunMethod("公用方法", "GetColValue", "bankput_info,bankname, bankno ='<%=sBranchCode%>'");

				if (sCityName == "Null") sCityName = "";
				if (sBranchCodeName == "Null") sBranchCodeName = "";
				setItemValue(0, 0, "ACCOUNTBANKCITYNAME", sCityName);
				setItemValue(0, 0, "BranchCodeName", sBranchCodeName);
			} else if (sNetBank=="2") {
				setItemReadOnly(0,0,"ACCOUNT", false);
				setItemReadOnly(0,0,"ACCOUNTNAME", false);
				setItemReadOnly(0,0,"ACCOUNTBANK", false);
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
			var sSNO = getItemValue(0, 0, "SNO");
			//var oldManager = RunMethod("GetElement","GetElementValue","salesmanager,store_info,SNO='"+sSNO+"'");
			//alert("sSNO: "+sSNO+"\noldManager : "+oldManager);
			
			/*update 销售经理未保存数据库之前需求修改选择 tangyb 20150804 start
			//add by xswang 2015/06/19 CCS-863 PRM-451 门店详情中销售经理有值则不能修改
			var sSalesManagerName = getItemValue(0, 0, "SALESMANAGERNAME");
			if(sSalesManagerName != "" && sSalesManagerName.length != 0 && typeof(sSalesManagerName) != 'undefined'){
				return;
			}
			//end by xswang 2015/06/19
			*/
			var salesmanager = RunMethod("公用方法", "GetColValue", "store_info, salesmanager, sno='"+ sSNO+"'");
			if(salesmanager != null && salesmanager != "" && typeof(salesmanager) != 'undefined'){
				return;
			}
			/*--update tangyb end--*/
			
			/*
			if(typeof(oldManager)!='undefined' && oldManager.length!=0 && oldManager!=""){
				return;
			}
			*/
			var sCity = getItemValue(0, 0, "CITY");
			if (typeof(sCity)=="undefined" || sCity.length==0) {
				alert("请先选择门店所在城市！");
				return;
			}
			var sRetVal = setObjectValue("SelectSalesmanSingleByCity1", "City,"+ sCity, "", 0, 0, "");
			
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
			//alert("请选择商品范畴！");
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
	
	function selectAccount() {
		alert("选择账号，自动填充户名和开户行");
	}
	
	function selectMainProductCategory() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			//alert("请选择主推品牌！");
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
			//alert("请选择所要选择的城市！");
			return;
		}
		
		setItemValue(0, 0, "CITY", retVal.split("@")[0]);
		setItemValue(0, 0, "CITYNAME", retVal.split("@")[1]);
		var sSNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getStoreNo", "cityCode="+retVal.split("@")[0]);
		setItemValue(0, 0, "SNO", sSNo);

		//重新选择城市需要清空县区
		setItemValue(0, 0, "COUNTRY", ""); //赋值县区
		setItemValue(0, 0, "COUNTRYNAME", ""); //赋值县区
		//当某些市级单位没有下属县区时，县区非必选
		setCountryRequired();
	}

	//当某些市级单位没有下属县区时，县区非必选 addby daihuafeng 20151014
	function setCountryRequired() {
		var city = getItemValue(0, 0, "CITY");
		if(typeof(city) == "undefined" || city.length == 0){
			setItemRequired(0,0,"COUNTRYNAME",true);
			return;
		}
		var cnt = RunMethod("BusinessManage", "CountAreaCode", city);
		var iCnt = parseInt(cnt);
		if(iCnt == 0){
			setItemRequired(0,0,"COUNTRYNAME",false);
		}else{
			setItemRequired(0,0,"COUNTRYNAME",true);
		}
	}
	
	
	//选择门店具体地址	
	function getAddressCode() {
		var sCity = getItemValue(0,0,"CITY");
		if(typeof(sCity) =="undefined" || sCity == null || sCity ==""){
			alert("请先选择门店所在城市！");
			return;
		}
		
		var sSortNo = RunMethod("公用方法", "GetColValue", "code_library,sortno,codeno='AreaCode' and isinuse='1' and itemno='"+sCity+"'");
		
		var retVal = setObjectValue("SelectCityCodeSingle for retail1","SortNo,"+sSortNo,"",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的县区");
			return;
		}
		setItemValue(0, 0, "COUNTRY", retVal.split("@")[0]); //赋值县区
		setItemValue(0, 0, "COUNTRYNAME", retVal.split("@")[1]); //赋值县区
		
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
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		/* 
		var curCityManager = getItemValue(0, 0, "CITYMANAGER");
		var curSalesManager = getItemValue(0, 0, "SALESMANAGER");
		var sSNo = getItemValue(0, 0, "SNO");
		
		
		if (curCityManager.length>0) { // 改变了城市经理
			RunMethod("公用方法", "UpdateColValue", "User_Info,SuperId,"+curCityManager+",UserId='"+curSalesManager+"'");
		}
		
		if (curSalesManager.length>0) { // 改变了销售经理
			RunMethod("公用方法", "UpdateColValue", "User_Info,SuperId,"+curSalesManager+",UserId in (select SalesmanNo from storerelativesalesman where SNo is not null and SNo='"+sSNo+"')");
		}
		*/
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		//AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp", "", "_self","");
		top.close();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

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
			bIsInsert = true;
		}
		
		setItemValue(0, 0, "isindaccount", "<%=sIsindaccount%>");
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
			setItemReadOnly(0,0,"ACCOUNT", true);
			setItemReadOnly(0,0,"ACCOUNTNAME", true);
			setItemReadOnly(0,0,"ACCOUNTBANK", true);
			setItemValue(0, 0, "ACCOUNT", "<%=sAccount%>");
			setItemValue(0, 0, "ACCOUNTNAME", "<%=sAccountName%>");
			setItemValue(0, 0, "ACCOUNTBANK", "<%=sAccountBank%>");
			setItemValue(0, 0, "ACCOUNTBANKCITY", "<%=sAccountbankCity%>");
			setItemValue(0, 0, "BranchCode", "<%=sBranchCode%>");
			var sCityName =  RunMethod("公用方法", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo='<%=sAccountbankCity%>'");
			var sBranchCodeName = RunMethod("公用方法", "GetColValue", "bankput_info,bankname, bankno ='<%=sBranchCode%>'");
			if (sCityName == "Null") sCityName = "";
			if (sBranchCodeName=="Null") sBranchCodeName = "";
			setItemValue(0, 0, "BranchCodeName", sBranchCodeName);
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", sCityName);
		}
		
		// 获取城市经理，销售经理
		gCityManager = getItemValue(0, 0, "CITYMANAGER");
		gSalesManager = getItemValue(0, 0, "SALESMANAGER");
		var sREBATETYPE = getItemValue(0, 0, "REBATETYPE");
		var sREBATEUNIT = getItemValue(0, 0, "REBATEUNIT");
		var sISREBATEMERCHANT = getItemValue(0, 0, "ISREBATEMERCHANT");
		var sREBATEMERCHANT = getItemValue(0, 0, "REBATEMERCHANT");
		var sMONTHREBATEMERCHAN = getItemValue(0, 0, "MONTHREBATEMERCHAN");
		var sQUARTERREBATEMERCHAN = getItemValue(0, 0, "QUARTERREBATEMERCHAN");
		var sYEARREBATEMERCHAN = getItemValue(0, 0, "YEARREBATEMERCHAN");
		if (typeof(sREBATETYPE)=="undefined" || sREBATETYPE.length==0) {
			setItemValue(0, 0, "REBATETYPE", "001");
		}
		if (typeof(sREBATEUNIT)=="undefined" || sREBATEUNIT.length==0) {
			setItemValue(0, 0, "REBATEUNIT", "002");
		}
		if (typeof(sISREBATEMERCHANT)=="undefined" || sISREBATEMERCHANT.length==0) {
			setItemValue(0, 0, "ISREBATEMERCHANT", "2");
		}
		if (typeof(sREBATEMERCHANT)=="undefined" || sREBATEMERCHANT.length==0) {
			setItemValue(0, 0, "REBATEMERCHANT", "002");
		}
		if (typeof(sMONTHREBATEMERCHAN)=="undefined" || sMONTHREBATEMERCHAN.length==0) {
			setItemValue(0, 0, "MONTHREBATEMERCHAN", "001");
		}
		if (typeof(sQUARTERREBATEMERCHAN)=="undefined" || sQUARTERREBATEMERCHAN.length==0) {
			setItemValue(0, 0, "QUARTERREBATEMERCHAN", "001");
		}
		if (typeof(sYEARREBATEMERCHAN)=="undefined" || sYEARREBATEMERCHAN.length==0) {
			setItemValue(0, 0, "YEARREBATEMERCHAN", "001");
		}  
		
		//当某些市级单位没有下属县区时，县区非必选
		setCountryRequired();
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>