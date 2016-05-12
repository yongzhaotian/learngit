<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "零售商准入申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	// 获得页面参数
	String sRSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RSSerialNo"));
	String sRSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RSerialNo"));
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewId"));
	String sPermitType=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PermitType"));
	String sModify =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	if (sRSSerialNo == null) sRSSerialNo = "";
	if (sRSerialNo == null) sRSerialNo = "";
	if (sApplyType == null) sApplyType = "";
	if (sViewId == null) sViewId = "";
	if (sPermitType == null) sPermitType = "";
	if(sModify == null) sModify = "";
	
	if (CommonConstans.ReTAILSTORE_APPROVE_TYPE.equals(sApplyType) || "02".equals(sViewId)) CurPage.setAttribute("RightType", "ReadOnly");
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RetailInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTBANK", "style={width=250px;");
	doTemp.setHTMLStyle("RNAME", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTNAME", "style={width=250px;");
	
	// 如果商户已经审核通过，不允许修改城市
	String sRetialNo = Sqlca.getString(new SqlObject("SELECT RNO FROM RETAIL_INFO WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sRSerialNo));
	if (sRetialNo != null) doTemp.setUnit("CITYNAME", "");
	
	//当某些市级单位没有下属县区时，县区非必选
		String city = Sqlca.getString("select city from RETAIL_INFO where SERIALNO = '"+sRSerialNo+"'");
		if(city == null) city="";
		String sortNo = Sqlca.getString("select sortNo from code_library where codeno = 'AreaCode' and itemno='"+city+"'");
		if(sortNo == null) sortNo="";
		String count = Sqlca.getString("select count(1) FROM code_library WHERE codeno = 'AreaCode' "
				+ " AND isinuse = '1' AND sortno LIKE '"+sortNo+"%' AND sortno <> '"+sortNo+"'");
		int iCnt = Integer.parseInt(count);
		if(iCnt == 0){
			doTemp.setRequired("COUNTY", false);
		}
	
	// 设置默认值
	
	//业务需求项目PRM-657 商户/门店详情的信息修改限制
	if("N".equals(sModify) && !CurUser.hasRole("1705")){
		doTemp.setReadOnly("RNAME,REGCODE,LAWPERSON,LAWPERSONCARDNO", true);
	}

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	if(sPermitType.equals("02")){ 
		dwTemp.ReadOnly = "1";
	}else{
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	 }
	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sRSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	
	 
	String	sButtons[][] = {
				{"true","","Button","保存","保存记录","saveRecord()",sResourcesPath},
				
				{sPermitType.equals("02")?"false":"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
				{"false","","Button","返回xxxx","返回列表也面","selectAreaInfo()",sResourcesPath},
			};
		
	
	
	
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	
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
	/*~[Describe=选择打上户经营范围多选;InputParam=无;OutPutParam=无;]~*/
	function getBizScope() {
		
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
		setItemValue(0, 0, "BUSINESSSCOPE", sCTypeIds.substring(0, sCTypeIds.length-1));
		setItemValue(0, 0, "BUSINESSSCOPENAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	/*~[Describe=选择上级大商户弹出框单选;InputParam=无;OutPutParam=无;]~*/
	function selectSuperRetailSingle() {
		
		var sIsRelative = getItemValue(0, 0, "ISRELATIVE");
		if ("1" != sIsRelative) {
			alert("请先确认是否有大商户已选择是！");
			return ;
		}
		
		var sRetVal = setObjectValue("SelectPermitRetailSingle", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择要选择的大商户！");
			return;
		}
		
		setItemValue(0, 0, "SUPERNO", sRetVal.split("@")[1]);
	}
	
	/*~[Describe=选择上级大商户弹出框单选;InputParam=无;OutPutParam=无;]~*/
	function selectBankAccount() {
		alert("选择账号，自动设置账户名和银行账号");
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
		setItemValue(0, 0, "COUNTY", ""); //赋值县区
		
		var street = getItemValue(0, 0, "STREET"); //街道
		if(street == null || street == 'undefined'){
			street = "";
		}
		setItemValue(0, 0, "ADDRESS", street); //商户具体地址 

		//当某些市级单位没有下属县区时，县区非必选
		setCountryRequired();
	}
	
	//当某些市级单位没有下属县区时，县区非必选 addby daihuafeng 20151014
	function setCountryRequired() {
		var city = getItemValue(0, 0, "CITY");
		if(typeof(city) == "undefined" || city.length == 0){
			setItemRequired(0,0,"COUNTY",true);
			return;
		}
		var cnt = RunMethod("BusinessManage", "CountAreaCode", city);
		var iCnt = parseInt(cnt);
		if(iCnt == 0){
			setItemRequired(0,0,"COUNTY",false);
		}else{
			setItemRequired(0,0,"COUNTY",true);
		}
	}
	
	/*零售商信息的商户具体地址需添加到区一级的选择框*/
	//add by jshu
	function getRegionCodeforretail() {
		var retVal = setObjectValue("SelectCityCodeSingle for retail","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		
		setItemValue(0, 0, "ADDRESS", retVal.split("@")[0]);
		setItemValue(0, 0, "ADDRESSNAME", retVal.split("@")[1]);
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
	
	//商户账号开户支行
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"ACCOUNTBANK");
		var sCity     = getItemValue(0,0,"ACCOUNTBANKCITY");
		
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

	
	function CheckPhone(obj) {
		var ret = CheckPhoneCode(obj.value);
		if(!ret) {
			alert("输入的电话号码有误，请重新输入！");
			obj.value = "";
			return;
		} 
	}
	
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		var sIsSuper = getItemValue(0, 0, "ISSUPER");
		var sAccountBankCity = getItemValue(0, 0, "ACCOUNTBANKCITY");
		var sAccount = getItemValue(0, 0, "ACCOUNT");
		var sAccountName = getItemValue(0, 0, "ACCOUNTNAME");
		var sAccountBank = getItemValue(0, 0, "ACCOUNTBANK");
		var sBranchCode = getItemValue(0, 0, "BranchCode");
		sRSerialNo="<%=sRSerialNo%>";
		var sStoreNum=getItemValue(0,0,"STORENUM");
		
		if(sStoreNum=="0"){
			alert("分店数量不能为0");
			return;
		}
		/**update CCS-883 取消否有上级大商户、上级大商户字段维护 tangyb 20150715
		if (sIsSuper == '1') {
			var sSuperNo = getItemValue(0, 0, "SUPERNO");
			if (typeof(sSuperNo)=='undefined' || sSuperNo.length==0) {
				alert("请选择上级大商户！");
				return;
			}
		}*/
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		
		as_save("myiframe0",sPostEvents);
		
		//add   wlq    同时修改门店支行信息   20140721  
		RunMethod("UpdateStore","GetUpdateStore",sAccountBankCity+","+sAccount+","+sAccountName+","+sAccountBank+","+sBranchCode+","+sRSerialNo);
		RunMethod("ModifyNumber","GetModifyNumber","store_info,UPDATEDATE='<%=StringFunction.getToday()%>', RSERIALNO='"+sRSerialNo+"' and ISNETBANK='1'");
	}
	
	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
	}
	
	// 返回交易列表
	function goBack()
	{
		//AsControl.OpenView("/BusinessManage/ChannelManage/RetailStoreApplyList.jsp","","_self");
		self.close();
	}
	//是否大商户”（手工选择“否”），则”是否有上级大商户”和”上级大商户”直接锁定变成灰色区域，无法手动更改和选择
	function isBigCheck(){
		var sIssuper=getItemValue(0,0,"ISSUPER");
		if(sIssuper=="2"){
			setItemDisabled(0,getRow(),"ISRELATIVE",true);
			setItemDisabled(0,getRow(),"SUPERNO",true);
		}else{
			setItemDisabled(0,getRow(),"ISRELATIVE",false);
			setItemDisabled(0,getRow(),"SUPERNO",false);
		
		}
		
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"SERIALNO","<%=sRSSerialNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			
			
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
			bIsInsert = true;
		}

		//当某些市级单位没有下属县区时，县区非必选
		setCountryRequired();
    }
	
	/*add CCS-883 县区选择 tangyb 20150716*/
	function getAddressCode() {
		var city = getItemValue(0, 0, "CITY");
		if(typeof(city)=="undefined" || city == null || city == ""){
			alert("请先选择商户所在城市");
			return;
		}
		
		var sortno = RunMethod("公用方法", "GetColValue", "code_library,sortno,codeno='AreaCode' and isinuse='1' and itemno='"+city+"'");

		var retVal = setObjectValue("SelectCityCodeSingle for retail1","SortNo,"+sortno,"",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的县区！");
			return;
		}
		
		//setItemValue(0, 0, "ADDRESSCITY", retVal.split("@")[0]);
		setItemValue(0, 0, "COUNTY", retVal.split("@")[1]); //赋值县区
		
		var street = getItemValue(0, 0, "STREET"); //街道
		if(street == null || street == 'undefined'){
			street = "";
		}
		setItemValue(0, 0, "ADDRESS", retVal.split("@")[1]+""+street); //商户具体地址 

	}
	
	/**
	 * 根据县区和街道赋值商户具体地址 
	 */
	function setAddress(){
		var county = getItemValue(0, 0, "COUNTY"); //县区
		if(county == null || county == 'undefined'){
			county = "";
		}

		var street = getItemValue(0, 0, "STREET"); //街道
		if(street == null || street == 'undefined'){
			street = "";
		}

		var address = county + street; //商户具体地址 
		if(address != null && address != ""){
			setItemValue(0, 0, "ADDRESS", address); //赋值县区
		}
	}
	/*add CCS-883 选择商户具体地址 tangyb 20150716 end*/

	</script>

<script language=javascript>
	bFreeFormMultiCol = true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
