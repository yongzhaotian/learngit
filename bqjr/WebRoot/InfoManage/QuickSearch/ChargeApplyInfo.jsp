<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "代扣变更信息";
	//定义变量
	String sSql="",sCustomerName="",sCertID="",sMobileTelephone="",sReplaceName="",sReplaceAccount="",sOpenBank="",sArtificialNo="";
	String sOldCityName="",sOldCity="";
	String sProductID="";  //add by yzhang9 CCS-444  产品ID 用来判断是否是现金贷  
	//定义变量：查询结果集
	ASResultSet rs = null;
	//获得页面参数：
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	// add by yzhang9 CCS-444
	String sContractSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo")); // 合同编号 
	rs = Sqlca.getASResultSet(new SqlObject("select ProductID from business_contract where SerialNo='"+sContractSerialNo+"'"));
	if(rs.next()){
		sProductID = DataConvert.toString(rs.getString("ProductID"));
	}
	rs.getStatement().close();
	if(sContractSerialNo==null)  sContractSerialNo="";
	// end  by yzhang9 CCS-444
	if(sSerialNo==null)  sSerialNo="";
	%>
	<%/*~END~*/%>
	
	<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ChargeApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setLimit("NewAccount",30); //限定卡号的录入长度
	doTemp.setReadOnly("NewAccountName", true);
	
	if("020".equals(sProductID)){ // add by yzhang9 CCS-444   如果是现金贷  则显示 '新代扣账号开户行支行' 和 '原代扣账号开户行支行'
		doTemp.setVisible("NEWBANKBRANCHNAME", true);
		doTemp.setVisible("OLDBANKBRANCHNAME", true);
		doTemp.setReadOnly("OLDBANKBRANCHNAME", true);//只读 
		doTemp.setReadOnly("NEWBANKBRANCHNAME", true);//只读 
	}
	
	
	// 改变代扣方式 
	doTemp.setHTMLStyle("NEWREPAYMENTWAY"," onchange=\"javascript:parent.changeRepaymentWay()\" ");
	//add CCS-537 合同录入界面代扣银行账号当能录入数字，长度限制为32位
	doTemp.setHTMLStyle("NewAccount","style={width:150px}  onkeyup=\"parent.formatNoFomat(this)\" onkeydown=\"parent.formatNoFomat(this)\" onfocus=\"parent.formatNoFomat(this)\" onchange=\"javascript:parent.CheckReplaceAccount();parent.accountChange()\" ");
	//doTemp.setHTMLStyle("NewAccount"," onchange=\"javascript:parent.CheckReplaceAccount()\" ");
	doTemp.setHTMLStyle("RESULTINFO","style={width:150px}");
	doTemp.setHTMLStyle("NewBankName"," onchange=\"javascript:parent.bankNameChange()\" ");
	
	//end
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确认变更","确认变更","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------
	function bankNameChange(){
		onInfoChange();
	}
	
	function accountChange(){
		onInfoChange();
	}
	
	function onInfoChange(){
		setItemValue(0,0,"REQSTATUS","");
		setItemValue(0,0,"RESULTINFO","");
		setItemValue(0,0,"RESULTCODE","");
		setItemValue(0,0,"SUCCESS","");
	}

	function saveRecord()
	{
		//trimBlank();
		//add CCS-537 合同录入界面代扣银行账号当能录入数字，长度限制为32位
		var sRepayMentWay = getItemValue(0,getRow(),"NEWREPAYMENTWAY");
		//if("1" == sRepayMentWay)//还款方式为代扣，校验代扣帐号格式
		//{
			//var sReturnReplaceAccount=CheckReplaceAccount();
			//if(sReturnReplaceAccount=="error"){
				//return;
			//}
			
		//}
		//end
		if(!vI_all("myiframe0")) return;
		if("1" == sRepayMentWay){
			//更新代扣查询返回的信息 add by zty 201251210
			var saveFlag = getSaveFlag();
			//alert(saveFlag);
			if(saveFlag != "1"){
				var resultinfo = getItemValue(0,getRow(),"RESULTINFO");
				var resultcode = getItemValue(0,getRow(),"RESULTCODE");
				if("S037_02_1000" == resultcode || "S030_00_0003" == resultcode){
					alert("不允许确认变更，请客户换卡验证！");
				}else{
					alert("不允许确认变更，"+resultinfo);
				}
				return;
			}
			
			updateBankCardCheckInfo();
		}
		
		//return;
		
		//获取变更后的开户户名、扣款账户号、开户行
		ContractSerialno = getItemValue(0,getRow(),"ContractSerialNo");
		NewAccountName = getItemValue(0,getRow(),"NewAccountName");
		CustomerID = getItemValue(0,getRow(),"CustomerID");
		NewBankName = getItemValue(0,getRow(),"NewBankName");
		AccountIndicator = "01";//扣款
		NewAccount = getItemValue(0,getRow(),"NewAccount");
		NewAccount = NewAccount.replace(/\s/ig,'');
		NewCity = getItemValue(0,getRow(),"NewCity");		
		NewRePaymentWay = getItemValue(0,getRow(),"NEWREPAYMENTWAY");//新的还款方式1：代扣 2：非代扣
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		NewBankBranch=getItemValue(0,getRow(),"NEWBANKBRANCH"); //add by yzhang9 CCS-444   将代扣账号支行代码 更新到合同表 
		//变更客户信息、变更客户下所有合同的 还款方式(代扣/非代扣);  
		sReturnValue = RunMethod("CustomerManage","UpdateReplaceAccount", AccountIndicator+","+ContractSerialno+","+CustomerID+","+NewAccountName+","+NewBankName+","+NewAccount+","+NewCity+","+NewRePaymentWay+","+NewBankBranch);
	 	 if(sReturnValue=="Success") {
			alert("变更代扣账户信息成功!");
		}else{
			alert("变更代扣账户信息失败!");
			return;
		}
		as_save("myiframe0","top.close()");
	}
	
	//  add by yzhang9 CCS-444 
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"NewBankName");  //新贷扣账号开户行 取原来的下拉列表 
		var sCity     = getItemValue(0,0,"NewCity");//新贷扣账号开户行省市 
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
		sBankNo=sReturn[0];// 新代扣账号开户行支行代码 
		sBranch=sReturn[1];// 新代扣账号开户行支行名称  
		setItemValue(0,0,"NEWBANKBRANCH",sBankNo);
		setItemValue(0,0,"NEWBANKBRANCHNAME",sBranch);
	}
	
	
	function changeRepaymentWay() {
		var srpWay = getItemValue(0, 0, "NEWREPAYMENTWAY");
		var customerName = getItemValue(0, 0, "CustomerName");
		
		if ("1" == srpWay) {
			setItemRequired(0, 0, "NewAccountName", true);
			setItemRequired(0, 0, "NewAccount", true);
			setItemRequired(0, 0, "NewBankName", true);
			setItemRequired(0, 0, "NewCity", true);
			setItemRequired(0, 0, "NewCityName", true);
			setItemValue(0,0,"NewAccountName",customerName);
			//add by zty 20151209
			setItemRequired(0, 0, "REQSTATUS", true);
			setItemRequired(0, 0, "RESULTINFO", true);
			showItem(0, 0, "REQSTATUS", "block");
			showItem(0, 0, "RESULTINFO", "block");
			//设置新代扣账户户名、新代扣账户帐号、新代扣账户开户行、新代扣账户省市可见
			showItem(0, 0, "NewAccountName", "block");
			showItem(0, 0, "NewAccount", "block");
			showItem(0, 0, "NewBankName", "block");
			//showItem(0, 0, "NewCity", "block");
			showItem(0, 0, "NewCityName", "block");
			showItem(0,0,"NEWBANKBRANCHNAME", "block");//add by yzhang9 CCS-444 新代扣账号开户行支行名称 
		} else if ("2" == srpWay) {
			setItemRequired(0, 0, "NewAccountName", false);
			setItemRequired(0, 0, "NewAccount", false);
			setItemRequired(0, 0, "NewBankName", false);
			setItemRequired(0, 0, "NewCity", false);
			setItemRequired(0, 0, "NewCityName", false);
			setItemValue(0,0,"NewAccountName","");
			//add by zty 20151209
			setItemRequired(0, 0, "REQSTATUS", false);
			setItemRequired(0, 0, "RESULTINFO", false);
			hideItem(0,0,"REQSTATUS");
			hideItem(0,0,"RESULTINFO");
			//设置新代扣账户户名、新代扣账户帐号、新代扣账户开户行、新代扣账户省市不可见 
			hideItem(0,0,"NewAccountName");
			hideItem(0,0,"NewAccount");
			hideItem(0,0,"NewBankName");
			//hideItem(0,0,"NewCity");
			hideItem(0,0,"NewCityName");
			hideItem(0,0,"NEWBANKBRANCHNAME");//add by yzhang9 CCS-444  新代扣账号开户行支行名称 
			
			//jQuery('#REQSTATUS').hide();
			//jQuery('#RESULTINFO').hide();
		}
	}
	
	/*~[Describe=弹出省市选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getCityName()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NewCity","");
			setItemValue(0,getRow(),"NewCityName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"NewCity",sAreaCodeValue);
					setItemValue(0,getRow(),"NewCityName",sAreaCodeName);			
			}
		}
	}
	
	
	function initRow()
	{	
		var sOpenBank=RunMethod("公用方法","GetColValue","code_library,itemName,itemNo='<%=sOpenBank%>'");
		var sSerialNo =  getItemValue(0,getRow(),"ContractSerialNo");
		var sOldBankBranchNo = RunMethod("公用方法","GetColValue","business_contract,OpenBranch,SerialNo='"+sSerialNo+"'");
		var sOldBankBranchName = RunMethod("公用方法","GetColValue","bankput_info,bankname,bankno='"+sOldBankBranchNo+"'");
		if(sOldBankBranchName == "Null"){sOldBankBranchName = "";}
		setItemValue(0,0,"OLDBANKBRANCHNAME",sOldBankBranchName);//add by yzhang9 CCS-444  初始化 原代扣账号开户行支行 
		
		if(sOpenBank=="Null") {sOpenBank="";}
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
            //登记人信息
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
	    	setItemValue(0,0,"UpdateOrgID","<%=CurUser.getOrgID()%>");
	    	setItemValue(0,0,"UpdateOrgName","<%=CurUser.getOrgName()%>");
	    	setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
	    	setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
	    	setItemValue(0,0,"UpdateDate","<%=StringFunction.getTodayNow()%>");
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "WITHHOLD_CHARGE_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	//add CCS-537 合同录入界面代扣银行账号当能录入数字，长度限制为32位
	/*
	JIRA描述：
	请在【代扣账号变更审批】的页面增加验证。  
	1. 代扣账号必须是数字！
	2. 代扣账号长度在16-19位之间！
	3. 代扣账号不能以4和5开头！
	*/
	function CheckReplaceAccount(){
		var sReplaceAccount =getItemValue(0,getRow(),"NewAccount");
		sReplaceAccount=sReplaceAccount+"";
		sReplaceAccount=sReplaceAccount.replace(/\s/ig,'');
		//alert(sReplaceAccount);
		
			//var tst = /^\d+$/;
			//if(!tst.test(sReplaceAccount)){
				//alert("代扣账号必须是数字！");
				//return "error";
			//}
			//add by pli 2015/04/09 CCS-609 安硕系统支持代扣银行增加“哈尔滨银行”
			//如销售选择”哈尔滨银行股份有限公司“为客户的银行卡开户行后，对代扣账户账号框做出判断以下两项判断:填写的账号为”625952“开头、且卡号为16位
			var sOpenBank = getItemValue(0,getRow(),"NewBankName");//代扣银行代码
			if((typeof(sOpenBank) != "undefined" || sOpenBank.length != 0)&&sOpenBank=="142"){//选择了哈尔滨银行作为代扣银行
				if(typeof(sReplaceAccount) == "undefined" || sReplaceAccount.length == 0||sReplaceAccount.substring(0,12)!="625952100000"){
					alert("代扣/放款账号必须以“625952100000”开头！");
					return "error";
				}else if(sReplaceAccount.length!=16){
					alert("代扣/放款账号长度必须为16位！");
					return "error";
				}
			}else if(sReplaceAccount.length<16||sReplaceAccount.length>19){
				alert("代扣/放款账号长度在16-19位之间！");
				return "error";
			}
			//end by pli
			//if(typeof(sReplaceAccount) != "undefined" || sReplaceAccount.length != 0){
				//var sFirstStr=sReplaceAccount.substring(0,1);
			//update CCS-578  申请表中代扣/放款账号可以输入以4开头的银行卡卡号 by rqiao 20150316
			/*if(sFirstStr=="4"||sFirstStr=="5"){
				alert("代扣账号不能以4和5开头！");
				return "error";
			}*/
			//if(sFirstStr=="5"){
				//alert("代扣账号不能以5开头！");
				//return "error";
			//}
			//end
			//}
	}
	//142哈尔滨银行  402农村信用社、304华夏银行、310上海浦东发展银行、789宁波银行、806深圳农村商业银行、794东莞银行、790杭州银行、316浙商银行、791上海银行、306广发银行
	function noSuportBankDeal(serialno,bankcode){
			//数据库如果没有记录 先插入一条
		RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","insertCardvalidateInfo","serialno="+serialno);
			
		setItemValue(0,0,"SUCCESS","1111");
		setItemValue(0,0,"RESULTCODE","U000_01_4005");
		setItemValue(0,0,"RESULTINFO","暂不支持此银行验证");
		setItemValue(0,0,"REQSTATUS","暂不支持验证");
		setItemValue(0,0,"OUID","");
		setItemValue(0,0,"APPLYTIME","");
		
	}
	
	//var flag = false;
	//add by zty 20151202 银行卡校验
	function checkBankCard(obj){
		obj.disabled = true; 
		var serialno = getItemValue(0,getRow(),"ContractSerialNo");//合同号
		var realname = getItemValue(0,getRow(),"NewAccountName");//真实姓名
		var certno = getItemValue(0,getRow(),"CertID");//身份证号
		var bankcardtype = "DEBIT_CARD";//银行卡类型 借记卡
		var bankcode = getItemValue(0,getRow(),"NewBankName");//银行编码
		//alert("bankcode=="+bankcode);
		var servicetype = "INSTALLMENT";//服务类型
		var bankcardno = getItemValue(0,getRow(),"NewAccount");//银行卡号
		bankcardno = bankcardno.replace(/\s/ig,'');
		var mobileno = getItemValue(0,getRow(),"TelPhone");//手机号码
		var infotype = "1";//数据来源 p2p
		var customerid = getItemValue(0,getRow(),"CustomerID");//客户ID
		var newCity = getItemValue(0,getRow(),"NewCity");	
		//卡验证前校验是否是代扣 以及银行卡号和银行是否为空
		var sRepayMentWay = getItemValue(0,getRow(),"NEWREPAYMENTWAY");
		if("1" != sRepayMentWay){
			alert("新还款方式非代扣，无需银行卡验证！");
			obj.disabled = false; 
			return;
		}else{
			if("" == bankcode){
				alert("请选择新代扣账户开户行");
				obj.disabled = false; 
				return;
			}
			if("" == bankcardno){
				alert("请输入新代扣账户账号");
				obj.disabled = false; 
				return;
			}
		}
		if("142" == bankcode){
			var sReturnReplaceAccount=CheckReplaceAccount();
			if(sReturnReplaceAccount=="error"){
				obj.disabled = false; 
				return;
			}else{
				noSuportBankDeal(serialno,bankcode);
				obj.disabled = false; 
				return;
			}
		}
		//数据库如果没有记录 先插入一条
	   if("402" == bankcode || "304" == bankcode || "310" == bankcode || "789" == bankcode || "806" == bankcode || 
				"794" == bankcode || "790" == bankcode || "316" == bankcode || "791" == bankcode){
		   noSuportBankDeal(serialno,bankcode);
		   obj.disabled = false; 
		   return;
	   }
		//查询代扣平台对应的银行编码
		var dkbankcode = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","getBankCodeDK","xfbankcode="+bankcode);//代扣银行编码  
		//alert("dkbankcode=="+dkbankcode);
		//校验卡BIN
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","checkCardBin","xfbankcode="+bankcode+",bankcardno="+bankcardno);
		if("0" == sReturn){
			alert("您输入的银行卡号或开户行错误，请检查后重新提交。");
			obj.disabled = false; 
			return false;
		}
		if("2" == sReturn){
			bankcardtype = "CREDIT_CARD"; //贷记卡
		}
		//if("2" == sReturn){
			//alert("信用卡不支持代扣");
			//obj.disabled = false; 
			//return false;
		//}
		
		//数据库如果没有记录 先插入一条
		if("306" == bankcode){
			 noSuportBankDeal(serialno,bankcode);
			 obj.disabled = false; 
			 return;
		 }
		
		//校验调用次数
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","getCheckTimes","serialno="+serialno);
		//alert("调用次数"+sReturn);
		if(parseInt(sReturn) >= 3){
			alert("该合同今天的修改次数已经超过3次，不能再作修改！");
			obj.disabled = false; 
			return false;
		}
		//校验以前是否已调用过
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","isHadChecked","serialno="+serialno+",realname="+realname+",certno="+certno+",xfbankcode="+bankcode+",bankcardno="+bankcardno);
		if("fail" == sReturn){
			//alert("该合同以前没有校验过");
		}else{
			var strs = sReturn.split("@");
			var resultcode = strs[0];
			var resultinfo = strs[1];
			var success = strs[2];
			var reqstatus = strs[3];
			var ouid = strs[4];
			var applytime = strs[5];
			setItemValue(0,0,"SUCCESS",success);
			setItemValue(0,0,"RESULTCODE",resultcode);
			setItemValue(0,0,"RESULTINFO",resultinfo);
			setItemValue(0,0,"REQSTATUS",getStatusZh(reqstatus));
			setItemValue(0,0,"OUID",ouid);
			setItemValue(0,0,"APPLYTIME",applytime);
			
			//var saveFlag = getSaveFlag();
			//if("0" != saveFlag){
				 obj.disabled = false;
			 //}
			
			return false;
		}
		
		//调用代扣平台校验银行卡
		$.ajax({
			type:"post",
			url: sWebRootPath+"/servlet/idCheck",
			data: {"serialno":serialno,"realname":realname,"certno":certno,"bankcardtype":bankcardtype,"dkbankcode":dkbankcode,"xfbankcode":bankcode,"servicetype":"INSTALLMENT","bankcardno":bankcardno,"mobileno":mobileno,"infotype":"1","customerid":customerid},
			timeout: 40000,
			async: true,
			dataType:"json",
			success: function(data){
			     var resultcode = data.resultcode;
				 var resultinfo = data.info;
				 var result = data.result;
				 var reqstatus = data.reqstatus;
				 var ouid = data.ouid;
				 var applytime = data.applytime;
				 setItemValue(0,0,"SUCCESS",result);
				 setItemValue(0,0,"RESULTCODE",resultcode);
				 setItemValue(0,0,"RESULTINFO",resultinfo);
				 setItemValue(0,0,"REQSTATUS",getStatusZh(reqstatus));
				 setItemValue(0,0,"OUID",ouid);
				 setItemValue(0,0,"APPLYTIME",applytime);
				 
				 //var saveFlag = getSaveFlag();
				 //if("0" != saveFlag){
					 obj.disabled = false;
				 //}
			},
			error:function(data){
				var resultcode = data.resultcode;
				var resultinfo = data.info;
				var result = data.result;
				var reqstatus = data.reqstatus;
				var ouid = data.ouid;
				var applytime = data.applytime;
				setItemValue(0,0,"SUCCESS",result);
				setItemValue(0,0,"RESULTCODE",resultcode);
				setItemValue(0,0,"RESULTINFO",resultinfo);
				setItemValue(0,0,"REQSTATUS",getStatusZh(reqstatus));
				setItemValue(0,0,"OUID",ouid);
				setItemValue(0,0,"APPLYTIME",applytime);
				
				obj.disabled = false;
			}

		})
		
		
		return "0";
		
	}
	//请求状态[01：验证成功；02：验证失败；03：无返回结果；04：未连接平台；05：未连接渠道]
	function getStatusEn(statusZh){
		if("验证成功" == statusZh){
			return "01";
		}
		if("验证失败" == statusZh){
			return "02";
		}
		if("无返回结果" == statusZh){
			return "03";
		}
		if("未连接平台" == statusZh){
			return "04";
		}
		if("未连接渠道" == statusZh){
			return "05";
		}
		if("暂不支持验证" == statusZh){
			return "06";
		}
	}
	function getStatusZh(statusEn){
		if("01" == statusEn){
			return "验证成功";
		}
		if("02" == statusEn){
			return "验证失败";
		}
		if("03" == statusEn){
			return "无返回结果";
		}
		if("04" == statusEn){
			return "未连接平台";
		}
		if("05" == statusEn){
			return "未连接渠道";
		}
		if("06" == statusEn){
			return "暂不支持验证";
		}
	}
	
	function updateBankCardCheckInfo(){
		var serialno = getItemValue(0,getRow(),"ContractSerialNo");//合同号
		var customerid = getItemValue(0,getRow(),"CustomerID");//客户ID
		var realname = getItemValue(0,getRow(),"NewAccountName");//真实姓名
		var certno = getItemValue(0,getRow(),"CertID");//身份证号
		var bankcardtype = "DEBIT_CARD";//银行卡类型 借记卡
		var servicetype = "INSTALLMENT";//服务类型
		var bankcardno = getItemValue(0,getRow(),"NewAccount");//银行卡号
		bankcardno = bankcardno.replace(/\s/ig,'');
		var mobileno = getItemValue(0,getRow(),"TelPhone");//手机号码
		var bankcode = getItemValue(0,getRow(),"NewBankName");//银行编码
		if("142" == bankcode){
			bankcardtype = "CREDIT_CARD";
		}else if("402" == bankcode || "304" == bankcode || "310" == bankcode || "789" == bankcode || "806" == bankcode || 
				"794" == bankcode || "790" == bankcode || "316" == bankcode || "791" == bankcode){
			
		}else{
			//校验卡BIN
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","checkCardBin","xfbankcode="+bankcode+",bankcardno="+bankcardno);
			if("0" == sReturn){
				alert("卡bin不存在,请检查您输入的银行卡号或银行名称是否正确");
				return false;
			}
			if("2" == sReturn){
				bankcardtype = "CREDIT_CARD"; //贷记卡
			}
		}
		
		
		var dkbankcode = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","getBankCodeDK","xfbankcode="+bankcode);//代扣银行编码  
		
		var success = getItemValue(0,getRow(),"SUCCESS");
		var resultinfo = getItemValue(0,getRow(),"RESULTINFO");
		var resultcode = getItemValue(0,getRow(),"RESULTCODE");
		var reqstatus = getItemValue(0,getRow(),"REQSTATUS");
		var ouid = getItemValue(0,getRow(),"OUID");
		var applytime = getItemValue(0,getRow(),"APPLYTIME");
		
		RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","operateCardQueryInfo","serialno="+serialno+",customerid="+customerid+",realname="+realname+",certno="+certno+",bankcardtype="+bankcardtype+",servicetype="+servicetype+",bankcardno="+bankcardno+",mobileno="+mobileno+",xfbankcode="+bankcode+",dkbankcode="+dkbankcode+",success="+success+",resultinfo="+resultinfo+",resultcode="+resultcode+",reqstatus="+getStatusEn(reqstatus)+",ouid="+ouid+",applytime="+applytime);
	}
	
	/**
	 * 银行卡号格式化
	 onkeyup=\"parent.formatNoFomat(this)\" onkeydown=\"parent.formatNoFomat(this)\" onfocus=\"parent.formatNoFomat(this)\"
	 
	 **/
	function formatNoFomat(BankNo){
    	if (BankNo.value == "") return;
		var account = new String (BankNo.value);
		account = account.substring(0,23); /*帐号的总数, 包括空格在内 */
		if (account.match (".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}") == null){
			/* 对照格式 */
			if (account.match (".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}|" + ".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}|" +
			".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}|" + ".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}") == null){
				var accountNumeric = accountChar = "", i;
				for (i=0;i<account.length;i++){
					accountChar = account.substr (i,1);
					if (!isNaN (accountChar) && (accountChar != " ")) accountNumeric = accountNumeric + accountChar;
				}
				account = "";
				for (i=0;i<accountNumeric.length;i++){    /* 可将以下空格改为-,效果也不错 */
					if (i == 4) account = account + " "; /* 帐号第四位数后加空格 */
					if (i == 8) account = account + " "; /* 帐号第八位数后加空格 */
					if (i == 12) account = account + " ";/* 帐号第十二位后数后加空格 */
					if (i == 16) account = account + " ";/* 帐号第十六位后数后加空格 */
					account = account + accountNumeric.substr (i,1)
				}
			}
		} else {
			account = " " + account.substring (1,5) + " " + account.substring (6,10) + " " + account.substring (14,18) + "-" + account.substring(18,25);
		}
		if (account != BankNo.value) BankNo.value = account;
	}
	
	//去掉空格提交
	function trimBlank(){
		var account=getItemValue(0,getRow(),"NewAccount");//银行卡号
		account=account.replace(/\s/ig,'');
		setItemValue(0,0,"NewAccount",account);
	}
	//获取保存标记
	function getSaveFlag(){
		var resultcode = getItemValue(0,getRow(),"RESULTCODE");
		var returnStr = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","getSaveFlag","resultcode="+resultcode);
		return returnStr;
	}
	
	//end
	
	</script>

<script language=javascript>	
	AsOne.AsInit();
	//showFilterArea();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
