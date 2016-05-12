<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	if(sUserID == null) sUserID = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "SchoolAgentInfo1";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
	{"true","All","Button","保存","保存所有修改","saveRecord()","","","","btn_icon_save",""},
	{"true","All","Button","保存并返回","保存并返回列表","saveAndGoBack()","","","","",""},
	{"true","","Button","返回","返回列表页面","goBack()","","","","",""},
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		var sPhone =getItemValue(0,getRow(),"PHONE");
		var sOtherTel =getItemValue(0,getRow(),"OTHERTEL");
		if(bIsInsert && checkPrimaryKey("school_agent_info","USERID")){
			alert("登录账号已存在，请检查输入！");
			return;
		}
		if(bIsInsert && checkPrimaryKey("school_agent_info","WORKID")){
			alert("工号已存在，请检查输入！");
			return;
		}
		if(bIsInsert){
			beforeInsert();
		}
		
		if(!CheckWorkID()){
			return;
		}
		if (!isCardNo()) return;
		
		
		if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sPhone))){
	        alert("联系电话输入有误，请重新输入");
	        return false; 
	    }
		
		if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sOtherTel))){
	        alert("其他联系方式输入有误，请重新输入");
	        return false; 
	    }
		
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/BusinessManage/RetailManage/SchoolAgentApplyList.jsp","","_self");
	}
	
	/* 选择用户上级 */
    function selectSuperUser() {
    	var retVal  = setObjectValue("SelectSchoolAgentSalesman", "","", 0, 0, "");
    	if (typeof retVal=="undefined" || retVal=="_CLEAR_") {
    		return;
    	}
    	setItemValue(0, 0, "SURPERORG", retVal.split("@")[0]);
    }
	
	//检查工号
    /* function CheckWorkID(){
		var sWorkID = getItemValue(0,getRow(),"WORKID");
		var sUserID = getItemValue(0,getRow(),"USERID");
		if (typeof(sWorkID)=="undefined" || sWorkID.length==0) {
			sWorkID = " ";
		}
		if (typeof(sUserID)=="undefined" || sUserID.length==0) {
			sUserID = " ";
		}
		var sReturnWorkID= RunMethod("公用方法","GetColValue","school_agent_info,count(1),WorkID='"+sWorkID+"'and userid<>'"+sUserID+"'");
		if((!(typeof(sWorkID)=="undefined" || sWorkID.length==0))&&sReturnWorkID!="0.0"){
			alert("工号已存在，请重新填写！");
			return false;
		}
		return true;

	} */

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
	function initRow() {
		if (getRowCount(0) == 0) {//如当前无记录，则新增一条
			as_add("myiframe0");
			bIsInsert = true;
		} else {
			setItemReadOnly(0, 0, "USERID", true);
			setItemReadOnly(0, 0, "WORKID", true);
		}
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
    function getRegionCode() {
    	
    	var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
    	if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
    		return;
    	}
    	
    	setItemValue(0, 0, "CITY", retVal.split("@")[0]);
    	setItemValue(0, 0, "CITYNAME", retVal.split("@")[1]);
    }
	
	//身份证正则表达校验
	function isCardNo() {
		var card = getItemValue(0, getRow(), "CERTID");
		if (card != "" || card.length != 0) {
			if (!checkIdcard(card)) {
				return false;
			}
			return true;
		} else {
			alert("身份证不能为空！");
			return false;
		}
	}
	//身份证
	function checkIdcard(idcard) {
		var Errors = new Array("验证通过!", "身份证号码位数不对!", "身份证号码出生日期超出范围或含有非法字符!",
				"身份证号码校验错误!", "身份证地区非法!");
		var area = {
			11 : "北京",
			12 : "天津",
			13 : "河北",
			14 : "山西",
			15 : "内蒙古",
			21 : "辽宁",
			22 : "吉林",
			23 : "黑龙江",
			31 : "上海",
			32 : "江苏",
			33 : "浙江",
			34 : "安徽",
			35 : "福建",
			36 : "江西",
			37 : "山东",
			41 : "河南",
			42 : "湖北",
			43 : "湖南",
			44 : "广东",
			45 : "广西",
			46 : "海南",
			50 : "重庆",
			51 : "四川",
			52 : "贵州",
			53 : "云南",
			54 : "西藏",
			61 : "陕西",
			62 : "甘肃",
			63 : "青海",
			64 : "宁夏",
			65 : "新疆",
			71 : "台湾",
			81 : "香港",
			82 : "澳门",
			91 : "国外"
		}
		var idcard, Y, JYM;
		var S, M;
		var idcard_array = new Array();
		idcard_array = idcard.split("");
		//地区检验 
		if (area[parseInt(idcard.substr(0, 2))] == null) {
			alert(Errors[4]);
			return false;
		}
		//身份号码位数及格式检验 
		switch (idcard.length) {
		case 15:
			if ((parseInt(idcard.substr(6, 2)) + 1900) % 4 == 0
					|| ((parseInt(idcard.substr(6, 2)) + 1900) % 100 == 0 && (parseInt(idcard
							.substr(6, 2)) + 1900) % 4 == 0)) {
				ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性 
			} else {
				ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性 
			}
			if (ereg.test(idcard)) {
				alert(Errors[0]);
				return true;
			} else {
				alert(Errors[2]);
				return false;
			}
			break;
		case 18:
			//18位身份号码检测 
			//出生日期的合法性检查  
			//闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
			//平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
			if (parseInt(idcard.substr(6, 4)) % 4 == 0
					|| (parseInt(idcard.substr(6, 4)) % 100 == 0 && parseInt(idcard
							.substr(6, 4)) % 4 == 0)) {
				ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式 
			} else {
				ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式 
			}
			if (ereg.test(idcard)) {//测试出生日期的合法性 
				//计算校验位 
				S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10]))
						* 7
						+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11]))
						* 9
						+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12]))
						* 10
						+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13]))
						* 5
						+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14]))
						* 8
						+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15]))
						* 4
						+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16]))
						* 2 + parseInt(idcard_array[7]) * 1
						+ parseInt(idcard_array[8]) * 6
						+ parseInt(idcard_array[9]) * 3;
				Y = S % 11;
				M = "F";
				JYM = "10X98765432";
				M = JYM.substr(Y, 1);//判断校验位 
				if (M == idcard_array[17]) {
					return Errors[0]; //检测ID的校验位 
				} else {
					alert(Errors[3]);
					return false;
				}
			} else {
				alert(Errors[2]);
				return false;
			}
			break;
		default:
			alert(Errors[1]);
			return false;
			break;
		}
	}
	$(document).ready(function() {
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2, 0, 'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>