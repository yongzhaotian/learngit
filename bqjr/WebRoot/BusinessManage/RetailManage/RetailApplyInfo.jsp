<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	System.out.print("------------"+sSerialNo);
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RetailInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//当某些市级单位没有下属县区时，县区非必选
	String city = Sqlca.getString("select city from RETAIL_INFO where SERIALNO = '"+sSerialNo+"'");
	if(city == null) city="";
	String sortNo = Sqlca.getString("select sortNo from code_library where codeno = 'AreaCode' and itemno='"+city+"'");
	if(sortNo == null) sortNo="";
	String count = Sqlca.getString("select count(1) FROM code_library WHERE codeno = 'AreaCode' "
			+ " AND isinuse = '1' AND sortno LIKE '"+sortNo+"%' AND sortno <> '"+sortNo+"'");
	int iCnt = Integer.parseInt(count);
	if(iCnt == 0){
		doTemp.setRequired("COUNTY", false);
	}
	
	
	if((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005")){
		doTemp.setReadOnly("relative_rno", true);
		doTemp.setRequired("relative_rno", false);
		//不做任何操作
	}else{
		doTemp.setReadOnly("", true);	
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005"))?"true":"false","","Button","保存","保存所有修改","saveRecord()","","","","btn_icon_save",""},
			//{"true","All","Button","保存并返回","保存并返回列表","saveAndGoBack()","","","","",""},
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
	
	//-- add by 商户账户名和商户账号去空 tangyb 20151223 --//
	function checkAccount(){
		var sAccount = getItemValue(0,getRow(),"ACCOUNT");
		sAccount = sAccount.replace(/\s+/g,"");
		
		// CCS-1276 商户门店准入功能改进需求     结算账号只能填写数字
		if (!/^[0-9]*$/.test(sAccount)) {
			alert("结算账号只能是填写数字!");
			sAccount="";
		}
		
		setItemValue(0,0,"ACCOUNT",sAccount);
	}
	
	function checkAccountName(){
		var sAccountName = getItemValue(0,getRow(),"ACCOUNTNAME");
		sAccountName = sAccountName.replace(/\s+/g,"");
		setItemValue(0,0,"ACCOUNTNAME",sAccountName);
	}
	//-- end --//
	
	//检查商户注册号码的重复性	
	function CheckRegCode(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegcode = getItemValue(0,getRow(),"REGCODE");
		var company = getItemValue(0,getRow(),"company");
		//-- add by 商户账户名和商户账号去空 tangyb 20151223 --//
		sRegcode = sRegcode.replace(/\s+/g,"");
		setItemValue(0,0,"REGCODE",sRegcode);
		//-- end --//
		
		//检查商户注册号是否以R开头
		if(sRegcode.indexOf("R", 0) != 0){
			alert("商户注册号必须以R开头");
			return false;
		}
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		if (typeof(company)=="undefined" || company.length==0) {
			company = "";
		}
		var sReturnRegcode = RunMethod("CustomerManage","SelectRetailRegcode",sRegcode+","+company+","+sSerialNo);
		if((!(typeof(sRegcode)=="undefined" || sRegcode.length==0))&&sReturnRegcode!="0.0"){
			alert("注册号在业务所属于公司已存在，请重新填写！");
			return false;
		}
		return true;
			}
	//检查商户名称的重复性
	function CheckRetailName(){
		var sRname = getItemValue(0,getRow(),"RNAME");
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var company = getItemValue(0,getRow(),"company");
		//-- add by 商户账户名和商户账号去空 tangyb 20151223 --//
		sRname = sRname.replace(/\s+/g,"");
		setItemValue(0,0,"RNAME",sRname);
		//-- end --//
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		if (typeof(company)=="undefined" || company.length==0) {
			company = "";
		}
		var sReturnRegcode = RunMethod("公用方法","GetColValue","RETAIL_INFO,count(1),RNAME='"+sRname+"'and company ='"+company+"' and serialno<>'"+sSerialNo+"'");
		if((!(typeof(sRname)=="undefined" || sRname.length==0))&&sReturnRegcode!="0.0"){
			alert("商户名称在业务所属于公司已存在，请重新填写！");
			return false;
		}
		return true;
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
		
		//清空商户账号开户支行
		clearBranchCode();

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
			alert("请选择所要选择的县区");
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
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_" || sReturn.indexOf("undefined", 0) >= 0) return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"BranchCode",sBankNo);
		setItemValue(0,0,"BranchCodeName",sBranch);
	}
	
	//清空商户账号开户支行
	function clearBranchCode(){
		setItemValue(0,0,"BranchCode","");
		setItemValue(0,0,"BranchCodeName","");
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
		var sStoreNum = getItemValue(0,0,"STORENUM");
		var sIsrelative = getItemValue(0,0,"ISRELATIVE");//add by clhuang 2015/05/14  CCS-432 零售商,门店准入申请和审批变更需求

		if(typeof(sStoreNum) == undefined || sStoreNum == "undefined" || sStoreNum.length == 0
				|| sStoreNum=="" || sStoreNum == "0" || sStoreNum == "0.0" || sStoreNum == 0 
				|| sStoreNum == NaN || parseInt(sStoreNum)==NaN){
			alert("分店数量最少为1");
			return;
		}
		
		//-- add by 注册号首字母加"R" tangyb 20151223 --//
		var sRegCode = getItemValue(0, 0, "REGCODE");//注册号
		if((!(typeof(sRegCode) == "undefined" || sRegCode.length == 0||sRegCode==null))&&sRegCode.substring(0,1)!="R"){
			setItemValue(0,getRow(),"REGCODE","R"+sRegCode);
		}
		//-- end --//	
		
		/**update CCS-883 取消否有上级大商户、上级大商户字段维护 tangyb 20150715
		if (sIsSuper == '1'  && sIsrelative =='1') {
			var sSuperNo = getItemValue(0, 0, "SUPERNO");
			if (typeof(sSuperNo)=='undefined' || sSuperNo.length==0) {
				alert("请选择上级大商户！");
				return;
			}
		}*/
		if(!CheckLawPersonCardNo()){
			return;
		}
		if(!CheckRegCode()){
			return;
		}
		if(!CheckRetailName()){
			return;
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		
		as_save("myiframe0",sPostEvents);
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
	
	function CheckLawPersonCardNo(sIdcard){
		var card = getItemValue(0,getRow(),"LAWPERSONCARDNO"); //身份证件编号	
		if(card!=""||card.length!=0){
			if(!checkIdcard(card)){
				return false;
				//flag=false;
			}
			return true;
			}else{
				alert("身份证不能为空！");
				return false;
			}
		}
	//身份证
	function checkIdcard(idcard){ 
			var Errors=new Array( 
								"验证通过!", 
								"身份证号码位数不对!", 
								"身份证号码出生日期超出范围或含有非法字符!", 
								"身份证号码校验错误!", 
								"身份证地区非法!" 
								); 
			var area={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"} 
								 
			var idcard,Y,JYM; 
			var S,M; 
			var idcard_array = new Array(); 
			idcard_array     = idcard.split(""); 
			//alert(area[parseInt(idcard.substr(0,2))]);
			
			//地区检验 
			if(area[parseInt(idcard.substr(0,2))]==null){
				alert(Errors[4]); 
				//setItemValue(0,0,"CertID","");
				//return Errors[4];
				return false;
			}
			 
			//身份号码位数及格式检验 
			
			switch(idcard.length){
			case 15: 
				if((parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){ 
					ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性 
				}else{ 
					ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性 
				} 
			 
				if(ereg.test(idcard)){
					alert(Errors[0]);
					//setItemValue(0,0,"CertID","");
					//return Errors[0]; 
					return true;
			        
				}else{ 
					alert(Errors[2]);
					//setItemValue(0,0,"CertID","");
					//return Errors[2];  
					return false;
				}
				break; 
			case 18: 
				//18位身份号码检测 
				//出生日期的合法性检查  
				//闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
				//平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
				if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
					ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式 
				}else{
					ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式 
				} 
				if(ereg.test(idcard)){//测试出生日期的合法性 
					//计算校验位 
					S  =  (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 
						+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 
						+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 
						+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 
						+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 
						+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 
						+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 
						+  parseInt(idcard_array[7]) * 1  
						+  parseInt(idcard_array[8]) * 6 
						+  parseInt(idcard_array[9]) * 3 ; 
					Y    = S % 11; 
					M    = "F"; 
					JYM  = "10X98765432"; 
					M    = JYM.substr(Y,1);//判断校验位 
					if(M == idcard_array[17]){
						return  Errors[0];		//检测ID的校验位 
					}else{
						alert(Errors[3]);
						//setItemValue(0,0,"CertID","");
						//return  Errors[3]; 
						return false;
			        }
				}else{
					alert(Errors[2]);
					//setItemValue(0,0,"CertID","");
					//return Errors[2]; 
					return false;
			    }
				break;
			default:
			    alert(Errors[1]);
			    //setItemValue(0,0,"CertID","");
				//return  Errors[1]; 
				return false;

				break;
			}	 

	}



	function initRow(){
		//setItemValue(0,0,"PrimaryApproveTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		
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
			setItemValue(0,0,"PrimaryApproveStatus","3");
			setItemValue(0,0,"AgreementApproveStatus","3");
			setItemValue(0,0,"SafDepApproveStatus","3");
			setItemValue(0,0,"company","BQJR");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
			bIsInsert = true;
		}
		setItemDisabled(0,getRow(),"company",true);
		setItemDisabled(0,getRow(),"relative_rno",true);
		setItemReadonly(0,getRow(),"relative_rno",true);
		setItemRequired(0,0,"relative_rno",false);
		//当某些市级单位没有下属县区时，县区非必选
		setCountryRequired();
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
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
