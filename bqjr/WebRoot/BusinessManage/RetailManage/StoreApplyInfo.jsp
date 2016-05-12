<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo==null) sSerialNo="";
	String sRSerailNo="";
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005")){
	//doTemp.setReadOnly("", false);	
	}else{
	doTemp.setReadOnly("", true);	
	}
	
	//当某些市级单位没有下属县区时，县区非必选
	String city = Sqlca.getString("select city from STORE_INFO where SERIALNO = '"+sSerialNo+"'");
	if(city == null) city="";
	String sortNo = Sqlca.getString("select sortNo from code_library where codeno = 'AreaCode' and itemno='"+city+"'");
	if(sortNo == null) sortNo="";
	String count = Sqlca.getString("select count(1) FROM code_library WHERE codeno = 'AreaCode' "
			+ " AND isinuse = '1' AND sortno LIKE '"+sortNo+"%' AND sortno <> '"+sortNo+"'");
	int iCnt = Integer.parseInt(count);
	if(iCnt == 0){
		doTemp.setRequired("COUNTRYNAME", false);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTBANK", "onchange=\"javascript:parent.clearBranchCode()\"");
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	// 设置默认值
	// 获取零售商帐号信息,如果存在设置到门店中
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005"))?"true":"false","All","Button","保存","保存所有修改","saveRecord()","","","","btn_icon_save",""},
			{"true","","Button","返回","返回列表页面","goBack()","","","","",""},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		//-- add by 零售商门店准入审批功能优化 tangyb 20151223 --//
		var sRegCode = getItemValue(0, 0, "REGCODE");//注册号
		if((!(typeof(sRegCode) == "undefined" || sRegCode.length == 0||sRegCode==null))&&sRegCode.substring(0,1)!="P"){
			setItemValue(0,getRow(),"REGCODE","P"+sRegCode);
		}
		//-- end --//
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();	
		if(!CheckRegCode()){
			return;
		}
		if(!CheckStoreName()){
			return;
		}

		//设置是否委托收款
		setIsEntrustedCollection();
			
		as_save("myiframe0",sPostEvents);
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function doSubmit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	}
	
	//设置是否委托收款
	function setIsEntrustedCollection(){
		var RetailName = getItemValue(0, 0, "RetailName");
		var ACCOUNTNAME = getItemValue(0, 0, "ACCOUNTNAME");
		if(RetailName == ACCOUNTNAME){
			setItemValue(0, 0, "ISENTRUSTEDCOLLECTION", "2");
		}else{
			setItemValue(0, 0, "ISENTRUSTEDCOLLECTION", "1");
		}
	}
	
	function getPassedReatil() {
		var sParaString = "InputUser,<%=CurUser.getUserID()%>";
		// 由SelectPermitRetailSingle改为SelectPermitRetailSingle2  CCS-1276商户门店准入功能改进需求
		var sRetVal = setObjectValue("SelectPermitRetailSingle2", sParaString, "", 0, 0,"");
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (typeof(sRetVal)=='undefined'||sRetVal=='_CLEAR_') {
			alert("请选择零售商！");
			return;
		}
		
		var sRserialno = sRetVal.split("@")[0];
		setItemValue(0, 0, "RSERIALNO", sRserialno);
		setItemValue(0, 0, "RetailName", sRetVal.split("@")[1]);
		var sAccount=sRetVal.split("@")[2];
		var sAccountName=sRetVal.split("@")[3];
		var sAccountBank=sRetVal.split("@")[4];
		var sAccountbankCity=sRetVal.split("@")[5];
		var sBranchCode=sRetVal.split("@")[6];
		var sServiceFee=sRetVal.split("@")[7];//-- add by huzp CCS-1040 反显零售商服务费 20160127 --//
		var sIsindaccount=sRetVal.split("@")[8]; //-- add by huzp CCS-1040 反显零售商服务费 20160127 将原来7改为8了--//
		setItemValue(0, 0, "isindaccount", sIsindaccount);
		setItemValue(0, 0, "SERVICEFEE", sServiceFee);//-- add by huzp CCS-1040 反显零售商服务费 20160127 --//
		//-- add by tangyb CCS-1040 反显零售商服务费 20160125 --//
		//var sServiceFee = RunMethod("公用方法", "GetColValue", "retail_info, servicefee, serialno="+sRserialno);
		//setItemValue(0, 0, "SERVICEFEE", sServiceFee);
		//-- end --//
		
		if (sNetBank=="1") {
			setItemReadOnly(0,0,"BranchCodeName", true);
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNT",true);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",true);
			
			setItemValue(0, 0, "ACCOUNT", sAccount);
			setItemValue(0, 0, "ACCOUNTNAME", sAccountName);
			setItemValue(0, 0, "ACCOUNTBANK", sAccountBank);
			setItemValue(0, 0, "ACCOUNTBANKCITY", sAccountbankCity);
			setItemValue(0, 0, "BranchCode", sBranchCode);
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", RunMethod("公用方法", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo="+sAccountbankCity));
			var sBranchCodeName = RunMethod("公用方法", "GetColValue", "bankput_info,bankname, bankno ="+sBranchCode);
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
	function goBack(){
		self.close();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// 获取流水号
		setItemValue(0,getRow(),"ExampleID",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
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

	//检查注册号码的重复性
	
	function CheckRegCode(){
		var sRegcode = getItemValue(0,getRow(),"REGCODE");
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var company=getItemValue(0, getRow(), "company");
		//-- add by 零售商门店准入审批功能优化 tangyb 20151223 --//
		sRegcode = sRegcode.replace(/\s+/g,"");
		setItemValue(0,0,"REGCODE",sRegcode);
		//-- end --//
		
		//门店注册号必须以P开头
		if(sRegcode.indexOf("P", 0) != 0){
			alert("门店注册号必须以P开头");
			return false;
		}
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		if(typeof(company)=="undefined"|| company.length==0)
			{
			company="";
			}
		var sReturnRegcode = RunMethod("CustomerManage","SelectStoreRegcode",sRegcode+","+company+","+sSerialNo);
		if((!(typeof(sRegcode)=="undefined" || sRegcode.length==0))&&sReturnRegcode!=0.0){ // update tangyb
			alert("注册号在业务所属于公司已存在，请重新填写！");
			return false;
		}
		return true;
			}
	
	//检查门店名称的重复性
	function CheckStoreName(){
		var sSname = getItemValue(0,getRow(),"SNAME");
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var company=getItemValue(0,getRow(),"company");
		//-- add by 零售商门店准入审批功能优化 tangyb 20151223 --//
		sSname = sSname.replace(/\s+/g,"");
		setItemValue(0,0,"SNAME",sSname);
		//-- end --//
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		if (typeof(company)=="undefined" || company.length==0) {
			company = " ";
		}
		var sReturnRegcode = RunMethod("公用方法","GetColValue","STORE_INFO,count(1),SNAME='"+sSname+"'and company='"+company+"' and serialno<>'"+sSerialNo+"'");
		if((!(typeof(sSname)=="undefined" || sSname.length==0))&&sReturnRegcode!="0.0"){
			alert("门店名称在业务所属于公司已存在，请重新填写！");
			return false;
		}
		return true;
			}
	
	// 如果是商户网银，门店结算等信息不可修改
	function isNetBank() {
	
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		var sRSERIALNO=getItemValue(0, 0, "RSERIALNO");
		if(sRSERIALNO==""){
			alert("请先选择零售商");
			return;
		}
		var accoutInfo= RunMethod("公用方法", "selectRetailAccount", sRSERIALNO);
		var sAccount=accoutInfo.split("@")[1];
		var sAccountName=accoutInfo.split("@")[2];
		var sAccountBank=accoutInfo.split("@")[3];
		var sAccountbankCity=accoutInfo.split("@")[4];
		var sBranchCode=accoutInfo.split("@")[5];
		
		if (sNetBank=="1") {
			
			setItemReadOnly(0,0,"BranchCodeName", true);
			
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNT",true);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",true);
			
			
			setItemValue(0, 0, "ACCOUNT", sAccount);
			setItemValue(0, 0, "ACCOUNTNAME", sAccountName);
			setItemValue(0, 0, "ACCOUNTBANK", sAccountBank);
			setItemValue(0, 0, "ACCOUNTBANKCITY", sAccountbankCity);
			setItemValue(0, 0, "BranchCode", sBranchCode);
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", RunMethod("公用方法", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo='sAccountbankCity'"));
			var sBranchCodeName = RunMethod("公用方法", "GetColValue", "bankput_info,bankname, bankno ='sBranchCode'");
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
	/*~[Describe=弹出单选框选择销售人员;InputParam=无;OutPutParam=无;]~*/
	function selectSalesmanSingle() {
		
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
		setItemValue(0, 0, "SALESMANPHONE", sRetVal.split("@")[2]);
		setItemValue(0, 0, "SALESMANEMAIL", sRetVal.split("@")[5]+"@"+sRetVal.split("@")[6]);

		setItemValue(0, 0, "CITYMANAGERNAME", sRetVal.split("@")[4]);
		setItemValue(0, 0, "CITYMANAGER", sRetVal.split("@")[3]);
		
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
		//重新选择城市需要清空县区
		setItemValue(0, 0, "COUNTRY", ""); //赋值县区
		setItemValue(0, 0, "COUNTRYNAME", ""); //赋值县区
		
		var sStreet = getItemValue(0, 0, "STREET"); //街道
		if(sStreet == null || sStreet == 'undefined'){
			sStreet = "";
		}
		setItemValue(0, 0, "ADDRESS", sStreet); //门店具体地址 
		//var sSNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getStoreNo", "cityCode="+retVal.split("@")[0]);
		//setItemValue(0, 0, "SNO", sSNo);
		
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
		
		var sStreet = getItemValue(0, 0, "STREET"); //街道
		if(sStreet == null || sStreet == 'undefined'){
			sStreet = "";
		}
		setItemValue(0, 0, "ADDRESS", retVal.split("@")[1]+""+sStreet); //商户具体地址 

	}
	
	/**
	 * 根据县区和街道赋值门店具体地址 
	 */
	function setAddress(){
		var sCountry = getItemValue(0, 0, "COUNTRYNAME"); //县区
		if(sCountry == null || sCountry == 'undefined'){
			sCountry = "";
		}

		var sStreet = getItemValue(0, 0, "STREET"); //街道
		if(sStreet == null || sStreet == 'undefined'){
			sStreet = "";
		}

		var sAddress = sCountry + sStreet; //门店具体地址 
		if(sAddress != null && sAddress != ""){
			setItemValue(0, 0, "ADDRESS", sAddress); //赋值县区
		}
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode1() {

		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
			return;
		}
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		
		setItemValue(0, 0, "ACCOUNTBANKCITY", retVal.split("@")[0]);
		setItemValue(0, 0, "ACCOUNTBANKCITYNAME", retVal.split("@")[1]);

		//清空门店结算账号开户支行
		clearBranchCode();

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
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_" || sReturn.indexOf("undefined", 0) >= 0) return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"BranchCode",sBankNo);
		setItemValue(0,0,"BranchCodeName",sBranch);
	}
	
	//清空门店结算账号开户支行
	function clearBranchCode(){
		setItemValue(0,0,"BranchCode","");
		setItemValue(0,0,"BranchCodeName","");
	}
	
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var serialNo = getSerialNo("Store_Info","SerialNo");// 获取流水号
			setItemValue(0,getRow(),"SERIALNO",serialNo);
			
			setItemValue(0,0,"STOREMAINCONTRACTPOSITION","店长");
			setItemValue(0,0,"Status","01");
			setItemValue(0,0,"PrimaryApproveStatus","3");
			setItemValue(0,0,"AgreementApproveStatus","3");
			setItemValue(0,0,"SafDepApproveStatus","3");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "INPUTORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
            setItemValue(0,0,"company","BQJR");
			
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "UPDATEORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}

		setItemDisabled(0,getRow(),"company",true);
		setItemDisabled(0,getRow(),"relative_sno",true);
		setItemRequired(0,0,"relative_sno",false);
		gCityManager = getItemValue(0, 0, "CITYMANAGER");
		gSalesManager = getItemValue(0, 0, "SALESMANAGER");

		//当某些市级单位没有下属县区时，县区非必选
		setCountryRequired();
	}

	$(document).ready(function() {
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2, 0, 'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
