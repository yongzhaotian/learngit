<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 用户信息详情
	 */
	String PG_TITLE = "用户信息详情";
	
	//获得页面参数	
	String sUserID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	if(sUserID==null) sUserID="";
	//获取组建参数
	String sIsCar = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isCar"));
	if(sIsCar == null) sIsCar = "";
	
	double dCnt = 0.0;
	if (!"".equals(sUserID)) {
		dCnt = Sqlca.getDouble("select count(1) from user_role where roleid='1006' and userid='"+sUserID+"'");
	}
	
// 	ARE.getLog().debug("是否车贷用户管理isCar="+sIsCar);
	
	//设置初始密码welcome!bqjr
	String sInitPwd = "welcome!bqjr88";
	String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", sInitPwd);
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "UserInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	/* if (dCnt > 0.0) {
		doTemp.setRequired("CertID", true);
	} else {
		doTemp.setRequired("CertID", false);
	} */
	
//	doTemp.appendHTMLStyle("UserID"," onkeyup=\"value=value.replace(/[^0-z]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;)\" ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{((CurUser.hasRole("1000") || CurUser.hasRole("3000"))?"true":"false"),"","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"false","","Button","返回","返回到列表界面","doReturn('Y')",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    var sCurUserID=""; //记录当前所选择行的代码号
    var bIsInsert = false;
    
    /* 选择用户上级 */
    function selectSuperUser() {
    	var BelongOrg = getItemValue(0, 0, "BelongOrg"); //所属机构
    	if(BelongOrg == null || BelongOrg == "" || typeof(BelongOrg)=="undefined"){
    		alert("请先选择所属机构");
    		return;
    	}
    	
    	var retVal  = setObjectValue("SelectSalesmanSingle", "BelongOrg,"+BelongOrg, "", 0, 0, "");
    	if (typeof retVal=="undefined" || retVal=="_CLEAR_") {
    		return;
    	}
    	setItemValue(0, 0, "SuperId", retVal.split("@")[0]);
    	setItemValue(0, 0, "Attribute8", retVal.split("@")[1]);
    }
	
    /*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
    function getRegionCode() {
    	
    	var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
    	if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
    		return;
    	}
    	
    	setItemValue(0, 0, "City", retVal.split("@")[0]);
    	setItemValue(0, 0, "CityName", retVal.split("@")[1]);
    }
    
    function getJobTitle() {
    	
    	var retVal = setObjectValue("SelectJobTitle","","",0,0,"");
    	setItemValue(0, 0, "JOB_TITLE", retVal.split("@")[0]);
    	
    	// 获取职位名称
    	var jobTitleName = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction", "getJobTitleName", "itemNO=" + retVal.split("@")[0]);
    	setItemValue(0, 0, "JOB_TITLE_NAME", jobTitleName);
    }
    
	function saveRecord(){
		if(bIsInsert && checkPrimaryKey("USER_INFO","UserID")){
			alert("该编号已存在，请检查输入！");
			return;
		}
		
		if (!isCardNo()) return;
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		as_save("myiframe0","");
		// 如果管理门店，更新门店中的信息
		RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "updateSaleManagerLinkInfo", "userId=<%=sUserID%>");
		//关闭窗口
		//alert(checkRequired());
		if(!checkRequired()){
			return;
		}else{
			//alert(1);
		window.close();
		}
		
	}
	function checkRequired(){
		sUserID=getItemValue(0,getRow(),"UserID");
		sLoginID=getItemValue(0,getRow(),"LoginID");
		sUserName=getItemValue(0,getRow(),"UserName");
		sUserType=getItemValue(0,getRow(),"UserType");
		sBelongOrg=getItemValue(0,getRow(),"BelongOrg");
		sStatus=getItemValue(0,getRow(),"Status");
		sCityName=getItemValue(0,getRow(),"CityName");
		sCompany = getItemValue(0,getRow(),"Company");
		 if((typeof(sUserID) == "undefined" || sUserID.length==0)||(typeof(sLoginID) == "undefined" || sLoginID.length==0)
			||	(typeof(sUserName) == "undefined" || sUserName.length==0) ||(typeof(sUserType) == "undefined" || sUserType.length==0)
			||(typeof(sBelongOrg) == "undefined" || sBelongOrg.length==0)||(typeof(sStatus) == "undefined" || sStatus.length==0)
			||(typeof(sCityName) == "undefined" || sCityName.length==0 )||(typeof(sCompany)=="undefined" ||sCompany.length==0)
		 ){
			 return false;
		 }
		 return true;
	}

    function doReturn(sIsRefresh){
        OpenPage("/AppConfig/OrgUserManage/UserList.jsp","_self","");
	}

    <%/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;]~*/%>
	function selectOrg(){
		sParaString = "OrgID,"+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
		
		//机构改变清空上级，重新选择
		setItemValue(0, 0, "SuperId", "");
    	setItemValue(0, 0, "Attribute8", "");
	}
	
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
            setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
            setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
            setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
            setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
            setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"Password","<%=sPassword%>"); //如果是新增用户，设置初始密码
            setItemValue(0,0,"IsCar","<%=sIsCar%>"); //是否车贷用户
            setItemValue(0,0,"CertType","Ind01"); //证件类型必须是身份证
            
            bIsInsert = true;
		}
	}
	//身份证正则表达校验
	function isCardNo()  
	{
		var card = getItemValue(0,getRow(),"CertID");
		//var flag=true;
		//alert("==================="+card);
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
	
	<%/*~[Describe=有效性检查;通过true,否则false;]~*/%>
	function ValidityCheck(){
		//1:校验证件类型为身份证或临时身份证时，出生日期是否同证件编号中的日期一致
		sCertType = getItemValue(0,getRow(),"CertType");//证件类型
		sCertID = getItemValue(0,getRow(),"CertID");//证件编号
		sBirthday = getItemValue(0,getRow(),"Birthday");//出生日期
		if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
			if(sCertType == 'Ind01' || sCertType == 'Ind08'){
				//将身份证中的日期自动赋给出生日期,把身份证中的性别赋给性别
				if(sCertID.length == 15){
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					if(sSex%2==0)//奇男偶女
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sCertID.length == 18){
					sSex = sCertID.substring(16,17);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					if(sSex%2==0)//奇男偶女
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sBirthday != sCertID){
					alert(getBusinessMessage('200'));//出生日期和身份证中的出生日期不一致！	
					return false;
				}
			
			}
		
		}
	
		return true;	
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>