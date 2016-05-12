<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID==null) sCustomerID="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PretrialInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","保存","保存所有修改","saveAndGoBack()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		//交叉校验电话号码是否重复
		if(checkTelPhone() == false) return;

		var sCertID = getItemValue(0,0,"CertID");//身份证号
		var sCustomerName = getItemValue(0,0,"CustomerName");//客户名称
		var sReturn = RunMethod("BusinessManage","IsReplaseState",sCertID.trim()+","+sCustomerName.trim());
		var sReturnTwo= RunMethod("BusinessManage","GetPretrialInfoByDay",sCertID.trim()+","+sCustomerName.trim());//当天预审否决的数量
		if(parseFloat(sReturn)==0){
			if(parseFloat(sReturnTwo) <5){ 
				saveRecord("saveAfter()");
			}else{
				alert("该客户当天频繁申请，请先处理后再申请!");
			}
		}else{
			alert("该客户有预审通过的信息未处理，请先处理后再申请!");
		}
	}
	
	function goBack(){
		AsControl.OpenView("/Common/WorkFlow/PretrialInfoList.jsp","","_self");
	}
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function saveAfter(){
		RunMethod("BusinessManage","AddPretrialTaskInfo",getItemValue(0,0,"SERIALNO"));
		goBack();
	}
	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var sCustomerName = getItemValue(0,0,"CustomerName");//客户名称
		var sCertID = getItemValue(0,0,"CertID");//身份证号
		var sCustomerID = RunMethod("BusinessManage","CustomerID",sCustomerName.trim()+","+sCertID.trim());
		//判断当前客户是否是白名单
		var sReturnBmd = RunMethod("BusinessManage","IsBaimingdan",sCustomerName.trim()+","+sCertID.trim());
		if(parseInt(sReturnBmd) > 0){
			sCustomerID = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId",null)
		}else{
			if(sCustomerID == null || sCustomerID == "Null" ||sCustomerID == ""){
				var sReturn = RunMethod("BusinessManage","IsReplaseCustomerid",sCertID.trim()+","+sCustomerName.trim());
				if(sReturn == null || sReturn=="Null"||sReturn == ""){
					sCustomerID = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId",null)
				}else{
					sCustomerID = sReturn ;
				}
			}
		}
		
		var SERIALNO = "<%=DBKeyUtils.getSerialNo()%>";
		
		setItemValue(0,0,"SERIALNO",SERIALNO);
		
		setItemValue(0,0,"CustomerID",sCustomerID);
		setItemValue(0,0,"STATE","001");//001:待扫描状态。002：预审通过.003:否决状态.004:已完成状态.005:已取消状态
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
	}
	
	function checkTelPhone(){
		//判断所有手机号码不能重复
		
		//手机号码
		var sMobileTelephone = getItemValue(0,0,"MobileTelephone");
		//亲属联系号码
		var sKinshipTel = getItemValue(0,0,"KinshipTel");
		//其他联系人号码
		var sContactTel = getItemValue(0,0,"ContactTel");
		
		var myArray =new Array(); 
		//把电话号码为空的去掉
		var k=0;
		if(typeof(sMobileTelephone) != "undefined" && sMobileTelephone.length>0){
			myArray[k++] = sMobileTelephone; 
		}
		if(typeof(sKinshipTel) != "undefined" && sKinshipTel.length>0){
			myArray[k++] = sKinshipTel;
		}
		if(typeof(sContactTel) != "undefined" && sContactTel.length>0){
			myArray[k++] = sContactTel;
		}
				
		var flag = "1";
		for(var i=0;i<myArray.length;i++){
			for(var j=i+1;j<myArray.length;j++){
				if(myArray[i] == myArray[j]){
					flag="0";
					break;
				}
			}
		}
		if(flag == "1"){
			return true;
		}else{
			alert("所有关系的电话存在重复号码,请检测重复号码并修改!");
			return false;
		}
	}
	
	//亲属姓名校验
	function checkKinshipName(obj){
		var sName=getItemValue(0,getRow(),"KinshipName");
		if(typeof(sName) == "undefined" || sName.length==0 ){
			//alert("亲属姓名不允许为空!");
			return false;
		}else{
		if(/\s+/.test(sName)){
			alert("亲属姓名含有空格，请重新输入");
			setItemFocus(0, 0, "KinshipName");
			return false;
		}
		//姓名必须是中文或者字母
		if(!(/^[\u4e00-\u9fa5]+|[a-zA-Z]+$/.test(sName))){
			    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)·([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("亲属姓名输入非法");
				setItemFocus(0, 0, "KinshipName");
				return false;
			    }
			    
			}
		 }
		return true;
	}
	//其他人姓名校验
	function checkOtherContactName(){
		var sName=getItemValue(0,getRow(),"OtherContact");
		if(typeof(sName) == "undefined" || sName.length==0 ){
			//alert("其他联系人姓名不允许为空!");
			return false;
		}else{
		if(/\s+/.test(sName)){
			alert("其他联系人姓名含有空格，请重新输入");
			setItemFocus(0, 0, "OtherContact");
			return false;
		}
		//姓名必须是中文或者字母
		if(!(/^[\u4e00-\u9fa5]+|[a-zA-Z]+$/.test(sName))){
			    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)·([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("其他联系人姓名输入非法");
				setItemFocus(0, 0, "OtherContact");
				return false;
			    }
			    
			}
		 }
		return true;
	}
	//单位名称校验
	function checkWorkCorpName(){
		var sWorkCorp=getItemValue(0, getRow(), "WorkCorp");
		if(typeof(sWorkCorp) == "undefined" || sWorkCorp.length==0){
			return false;
		}
		if(/\s+/.test(sWorkCorp)){
			alert("单位名称含有空格，请重新输入");
			setItemFocus(0, 0, "WorkCorp");
			return false;
		}
		if(!(/^[a-zA-Z0-9\u4e00-\u9fa5]+$/.test(sWorkCorp))){
			alert("单位名称输入非法");
			setItemFocus(0, 0, "WorkCorp");
			return false;
		}
		return true;
	}
	
	//身份证校验
	function checkType(){
		if(!isCardNo()){
			return;
		}
		var sIdentityId   = getItemValue(0,0,"CertID");
		if(sIdentityId ==""){
		   alert("请填写身份证号！");  	
		}
		//判断是否大于18岁，小于55岁
		if(typeof(sIdentityId)=="undefined" || sIdentityId.length==0 ){
		}else{
		var myDate=new Date(); 
		   var thisYear = myDate.getFullYear(); 
		   var thisMonth = myDate.getMonth()+1; 
		   var thisDay = myDate.getDate(); 
		   var age = myDate.getFullYear() - sIdentityId.substring(6, 10) - 1;
		   if (sIdentityId.substring(10, 12) < thisMonth || sIdentityId.substring(10, 12) == thisMonth && sIdentityId.substring(12, 14) <= thisDay) { 
			   age++; 
			 }
	        if((age>55)||(age<18)){
	        	alert("客户年龄必须在18到55之间");
				setItemFocus(0, 0, "CertID");
	        	return;
	        }
		}
	}
	//身份证正则表达校验
	function isCardNo()  
	{
		var card = getItemValue(0,getRow(),"CertID");
		if(card!=""||card.length!=0){
		if(!checkIdcard(card)){
			return false;
		}
		return true;
		}else{
			//alert("身份证不能为空！");
			return false;
		}
	}

	//校验身份证合法性
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
			
			//地区检验 
			if(area[parseInt(idcard.substr(0,2))]==null){
				alert(Errors[4]); 
				setItemFocus(0, 0, "CertID");
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
					setItemFocus(0, 0, "CertID");
					return true;
			        
				}else{ 
					alert(Errors[2]);
					setItemFocus(0, 0, "CertID");
					return false;
				}
				break; 
			case 18: 
				//18位身份号码检测 
				//出生日期的合法性检查  
				//闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
				//平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
				if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
					ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式 
				}else{
					ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式 
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
						setItemFocus(0, 0, "CertID");
						return false;
			        }
				}else{
					alert(Errors[2]);
					setItemFocus(0, 0, "CertID");
					return false;
			    }
				break;
			default:
			    alert(Errors[1]);
				setItemFocus(0, 0, "CertID");
				return false;
				break;
			}	 
	}
	
	//验证手机号正确性
	function checkMobile(obj){
	    var sMobile = getItemValue(0,getRow(),"MobileTelephone");
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	//alert("手机号码不能空");
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("手机号码输入有误，请重新输入"); 
			setItemFocus(0, 0, "MobileTelephone");
	        return false; 
	    } 
	}
	
	//亲属联系电话验证手机号或者座机号正确性
	function isCheckMobilePhone(obj){
		var sSchCouTel=getItemValue(0,getRow(),"KinshipTel");
		//空格自动忽略
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
		     //alert("亲属联系人电话不能空");
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){//非手机号
						alert("手机号码格式填写错误"); 
						setItemFocus(0, 0, "KinshipTel");
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("固定电话格式填写错误"); 
						setItemFocus(0, 0, "KinshipTel");
				        return false; 
					}else{
						alert("号码格式填写不合法");
						setItemFocus(0, 0, "KinshipTel");
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("固定电话格式填写错误");
						setItemFocus(0, 0, "KinshipTel");
						return false;
					}
				}else{
					alert("区号填写错误");
					setItemFocus(0, 0, "KinshipTel");
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				setItemFocus(0, 0, "KinshipTel");
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("分机号码填写错误");
								setItemFocus(0, 0, "KinshipTel");
							 return false;
						 }
					}else{
						alert("固定电话格式填写错误");
						setItemFocus(0, 0, "KinshipTel");
						return false;
					}
				}else{
					alert("区号填写错误");
					setItemFocus(0, 0, "KinshipTel");
					return false;
				}
			}
	}	
	
	//其他联系人电话验证手机号或者座机号正确性
	function isCheckOtherMobilePhone(obj){
		var sSchCouTel=getItemValue(0,getRow(),"ContactTel");
		//空格自动忽略
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
		     //alert("其他联系人电话不能空");
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){//非手机号
						alert("手机号码格式填写错误"); 
						setItemFocus(0, 0, "ContactTel");
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("固定电话格式填写错误"); 
						setItemFocus(0, 0, "ContactTel");
				        return false; 
					}else{
						alert("号码格式填写不合法");
						setItemFocus(0, 0, "ContactTel");
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("固定电话格式填写错误");
						setItemFocus(0, 0, "ContactTel");
						return false;
					}
				}else{
					alert("区号填写错误");
					setItemFocus(0, 0, "ContactTel");
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				setItemFocus(0, 0, "ContactTel");
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("分机号码填写错误");
							 setItemFocus(0, 0, "ContactTel");
							 return false;
						 }
					}else{
						alert("固定电话格式填写错误");
						setItemFocus(0, 0, "ContactTel");
						return false;
					}
				}else{
					alert("区号填写错误");
					setItemFocus(0, 0, "ContactTel");
					return false;
				}
			}
	}	
	
	//校验个人月收入不能小于等于0
	function checkSelfMonthIncome(obj){
		var sSelfMonthIncome=getItemValue(0,getRow(),"SelfMonthIncome");
		if(typeof(sSelfMonthIncome) == "undefined" || sSelfMonthIncome.length==0){
		    //alert("个人月收入不能空");
			return false;
		}
		if(parseFloat(sSelfMonthIncome)<=0){
			alert("个人月收入必须大于0！");
			setItemFocus(0, 0, "SelfMonthIncome");
			return false;
		}
	}
	
	//界面初始化加载
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName() %>");
			setItemValue(0,0,"OrgName","<%=CurUser.getOrgName() %>");
			
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
