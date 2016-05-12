<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	System.out.print("------------"+sSerialNo);
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RetailApproveInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHRadioSql("PrimaryApproveStatus", "Select itemno,itemname from code_library  where codeno='PrimaryApproveStatus' and itemno in ('1','2') ");
	
	String sPrimaryApproveStatus = Sqlca.getString(new SqlObject("select PrimaryApproveStatus from RETAIL_INFO where Serialno= :Serialno").setParameter("Serialno", sSerialNo));
	if (sPrimaryApproveStatus == null) sPrimaryApproveStatus = "";
	if(sPrimaryApproveStatus.equals("4")){
	doTemp.setReadOnly("", true);	
	doTemp.setReadOnly("PrimaryApproveStatus,Remark,Refusereason", false);
	}
/* 	if(sPrimaryApproveStatus.equals("1")){
		doTemp.setRequired("RefuseReason",false);
		doTemp.setVisible("RefuseReason",false);
	}else if(sPrimaryApproveStatus.equals("2")){
		doTemp.setVisible("RefuseReason",true);
		doTemp.setRequired("RefuseReason",true);
	} */
		 
	     		 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","提交","提交所有修改","saveRecord()","","","","btn_icon_save",""},
			{"false","All","Button","保存并返回","保存并返回列表","saveAndGoBack()","","","","",""},
			{"true","","Button","返回","返回列表页面","goBack()","","","","",""},
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/FrameCase/ExampleList.jsp","","_self");
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
	
	function selectStatus(){
		var sPrimaryApproveStatus = getItemValue(0,getRow(),"PrimaryApproveStatus");
		if(sPrimaryApproveStatus=="1"){
			hideItem(0, 0, "RefuseReason");//隐藏
			setItemValue(0, 0, "RefuseReason","");
			setItemRequired(0,0, "RefuseReason", false);
			}else if (sPrimaryApproveStatus=="2"){
				showItem(0, 0, "RefuseReason");//显示
		        setItemRequired(0,0, "RefuseReason", true);
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
		var sStoreNum=getItemValue(0,0,"STORENUM");
		var sIsrelative = getItemValue(0,0,"ISRELATIVE");//add by clhuang 2015/05/14 CCS-432 零售商,门店准入申请和审批变更需求
		
		if(sStoreNum=="0"){
			alert("分店数量不能为0");
			return;
		}
		var sPrimaryApproveStatus = getItemValue(0,0,"PrimaryApproveStatus");
		if(sPrimaryApproveStatus=="4"){
			alert("请选择初审状态！");
			return;
		}
		if (sIsSuper == '1' && sIsrelative =='1') {
			var sSuperNo = getItemValue(0, 0, "SUPERNO");
			if (typeof(sSuperNo)=='undefined' || sSuperNo.length==0) {
				alert("请选择上级大商户！");
				return;
			}
		}
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		if(!vI_all("myiframe0")){
			return;
		}
		
		as_save("myiframe0",sPostEvents);
		selectStatus();
		}
	
	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("Retail_Info", "SerialNo");
		setItemValue(0,getRow(),"SERIALNO",serialNo);
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
	
	function initRow(){
		setItemValue(0,0,"PrimaryApproveTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		setItemValue(0,0,"PRIMARYAPPROVEPERSON","<%=CurUser.getUserID()%>");
		selectStatus();
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			
			as_add("myiframe0");//新增记录
			//
		
			setItemValue(0,getRow(),"SERIALNO","<%=sSerialNo%>");
		
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
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
