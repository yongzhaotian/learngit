<%@page import="com.sun.org.apache.xpath.internal.objects.XString"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.sadre.util.DateUtil"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: 该页面主要处理业务相关的申请列表，如授信额度申请列表，额度项下业务申请列表，
			 单笔授信业务申请列表
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 重检页面 
		zywei 2007/10/10 修改取消申请的提示语
		zywei 2007/10/10 新增调查报告时，仅低风险业务、授信项下业务、银票贴现业务、综合授信业务、个人客户、
						 中小企业之外的业务才进行调查报告格式保留与否的判断
		zywei 2007/10/10 解决用户打开多个界面进行重复操作而产生的错误
		qfang 2011/06/13 增加判断：如果为"贷款新规适用产品"，则弹出页面，显示业务品种分类的三个标志位字段
		xswang 2015/05/25 CCS-808 系统全流程电子化改造：文件质量检查
		xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
<%
	String PG_TITLE = "授信方案管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String sSubApplyType= DataConvert.toRealString(iPostChange,(CurComp.getParameter("subApplyType")));
	//add by xswang 2015/05/25 CCS-808 系统全流程电子化改造：文件质量检查
	String sToday = StringFunction.getTodayNow();
	//end by xswang 
	String sNo= CurUser.getAttribute8();
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
<%@include file="/Common/WorkFlow/ApplyList.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	/*~[Describe=Segment上传附件;InputParam=无;OutPutParam=无;]~*/
	function uploadAttachment(){
		var serialNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//验证合同产品是否已经在影响配置中配置
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sAmount = RunMethod("公用方法","GetColValueTables","product_ecm_type,product_type_ctype,count(1),product_ecm_type.PRODUCT_TYPE_ID = product_type_ctype.PRODUCT_TYPE_ID and product_type_ctype.PRODUCT_ID ='"+sBusinessType+"' ");
		if(sAmount == 0){
			alert("请先在商品影像配置中配置该产品对应的影像文件！");
			return false;
		}
		// 如果附件已经上传，先删除该记录再上传
		/*var sDocNo = RunMethod("公用方法", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+serialNo+"'");
		if (sDocNo!="Null") {
			RunMethod("公用方法", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+serialNo+"'");
		}
		
		AsControl.PopView("/AppConfig/Document/AttachmentChooseDialog3.jsp","DocNo="+serialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();*/
	    var param = "ObjectType=Business&TypeNo=20&ObjectNo="+serialNo;
	    AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
	    // var param = "ObjectType=Business&TypeNo=20&RightType=&ObjectNo="+serialNo;
	    // AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
	}
		
	/*~[Describe=Segment表校验;InputParam=无;OutPutParam=无;]~*/
	function CheckSegment(){
		var SerialNo = getItemValue(0, getRow(), "SerialNo");//合同流水号
		sCount = RunMethod("LoanAccount","CheckSegment", SerialNo);
		if(sCount > 0){
			return true;
		}
		return false;
	}
	
	/*~[Describe=ID5检查;InputParam=无;OutPutParam=无;]~*/
	function id5Check() {
		var smath = trim("   1EE650");
		var reg = /^[1-9]\d*[Ee]\d+/g;
		var sresult = reg.test(smath)
		alert(sresult);
		return;
		if ("<%=CurUser.getUserID()%>" !== "140001") {
			alert("请用用户140001测试！");
			return;
		}
		
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (false && (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		
		// 测试ID5身份证
		var sIndName = getItemValue(0, getRow(), "CustomerName");
		var sIdCardNum = RunMethod("公用方法", "GetColValue", "IND_INFO,CERTID,CUSTOMERID='"+getItemValue(0, getRow(), "CustomerID")+"'");
		//alert("reqHeader=1A020201,reqData="+sIndName+"@"+sIdCardNum);
		var sRetId5 = RunJavaMethodSqlca("com.amarsoft.webclient.RunID5", "runParserId5", "reqHeader=1A020201,reqData="+sIndName+"@"+sIdCardNum+",savepath=<%=CurConfig.getConfigure("ImageFolder")%>"+",stype=010");
		var sretHead = sRetId5.split("@")[0];
		
		if ("010" === sretHead) {
			alert("用户已经存在于本地数据库， 查询结果返回值：" + sRetId5.substring(4,sRetId5.length));
		} else if("020" === sretHead) {
			alert("不存在数据库，从国政通查询， 查询结果返回值：" + sRetId5.substring(4,sRetId5.length));
		} else {
			alert("未处理情况： " + sRetId5);
		}
		// 测试ID5固话
		if (confirm("是否继续测试ID5固话")) {
			var sPhone = RunMethod("公用方法", "GetColValue", "IND_INFO,WORKTEL,CUSTOMERID='"+getItemValue(0, getRow(), "CustomerID")+"'");
			if (sPhone==="Null" || sPhone==="") {
				alert("电话为空");
			} else {
				sPhone = sPhone.replace(/-/g, "");
			}
			//alert(sPhone);
			//var sIdCardNum = RunMethod("公用方法", "GetColValue", "IND_INFO,CERTID,CUSTOMERID='"+getItemValue(0, getRow(), "CustomerID")+"'");
			//alert("reqHeader=1A020201,reqData="+sIndName+"@"+sIdCardNum);
			var sRetPhone = RunJavaMethodSqlca("com.amarsoft.webclient.RunID5", "runParserId5", "reqHeader=1G010101,reqData="+sPhone+",savepath=<%=CurConfig.getConfigure("ImageFolder")%>"+",stype=020");
			var sretHead = sRetPhone.split("@")[0];
			if ("010" === sretHead) {
				alert("固话已经存在于本地数据库， 查询结果返回值：" + sRetPhone.substring(4,sRetPhone.length));
			} else if("020" === sretHead) {
				alert("不存在数据库，从国政通查询， 查询结果返回值：" + sRetPhone.substring(4,sRetPhone.length));
			} else {
				alert("未处理情况： " + sRetPhone);
			}
		}
	}
		
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newApply(){
		
		//将jsp中的变量值转化成js中的变量值
		var sObjectType = "<%=sObjectType%>";	
		var sApplyType = "<%=sApplyType%>";	
		var ssSubApplyType="<%=sSubApplyType%>";
		var sPhaseType = "<%=sPhaseType%>";
		var sInitFlowNo = "<%=sInitFlowNo%>";
		var sInitPhaseNo = "<%=sInitPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		// add by xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
		//var sStore = RunMethod("BusinessManage","getStore",sUserID);
		var sSno = "<%=CurUser.getAttribute8()%>";
		var sStore = RunMethod("BusinessManage","getStoreNew",sSno);
		// end by xswang 2015/06/01
		var ssCity=RunMethod("GetElement","GetElementValue","city,user_info,userid='"+sUserID+"'");
		
		if(typeof(sStore)=="undefined" || sStore.length==0 || sStore == "Null"){
			alert("选择做单门店为空，请在主页按钮旁边点击门店选择门店重新选择门店！");
			return;
		}
		var subProductType=null;
		if(sApplyType == "CreditLineApply"){
			if(ssSubApplyType=="StuEducation"){//进入学生贷
				subProductType = 5;
			}else if("AdultEducation"==ssSubApplyType){//进入成人贷
				subProductType = 4;
			}else if("ssSubApplyType"==ssSubApplyType){//进入学生消费
				subProductType = 7;
			}else{
				subProductType = 0;
			}
		}
		
		if(confirm("当前登录所在门店为：\n\r"+sStore+"\n\r是否确认在该门店发起申请？")){
			var rValues=RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getCreditID", "ProductType="+subProductType+",citys="+ssCity);
			 if(rValues=="false"){
				alert("该城市下产品类型为消费贷没有相关贷款人！");
				return;
			} 
			//弹出新增申请参数对话框
			if(sApplyType == "CreditLineApply"){
				if(ssSubApplyType=="StuEducation"){//进入学生贷
					sCompID = "CreditLineApplyCreationInfo";
					sCompURL = "/BusinessManage/ApplyEducationMain/CreditEducationApplyCreationInfo.jsp";
					subProductType="5";
				} else if("AdultEducation"==ssSubApplyType){//进入成人贷
					sCompID = "CreditLineApplyCreationInfo";
					sCompURL = "/BusinessManage/ApplyEducationMain/CreditEducationApplyCreationInfo.jsp";
					subProductType="4";
				}else if( "StuPos" == ssSubApplyType ){//学生消费贷   add by dahl
					sCompID = "CreditStuPosApplyCreationInfo";
					sCompURL = "/CreditManage/CreditApply/CreditStuPosApplyCreationInfo.jsp";	 
					subProductType="7";
				}else{
			 		sCompID = "CreditLineApplyCreationInfo";
					sCompURL = "/CreditManage/CreditApply/CreditLineApplyCreationInfo.jsp";	 
				}
			}else{
				sCompID = "CreditApplyCreation";
				sCompURL = "/CreditManage/CreditApply/CreditApplyCreationInfoAll.jsp";
			}
	    	 sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo+"&SubProductType="+subProductType,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
			sReturn = sReturn.split("@");
			sObjectNo=sReturn[0];

			//add by qfang 增加判断：如果为"贷款新规适用产品"，则弹出页面，显示业务品种分类的三个标志位字段
			sObjectType=sReturn[1];	
			if(sReturn[2] != null){ 
				sTypeNo=sReturn[2];
				sSortReturn = RunMethod("CreditLine","CheckProductSortFlag",sTypeNo);
				if(sSortReturn.split("@")[0] == "true"){
					popComp("SortFlagInfo","/CreditManage/CreditApply/SortFlagInfo.jsp","TypeNo="+sTypeNo+"&ObjectNo="+sObjectNo,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");		
				}
			} 
			//add end
			
	         //根据新增申请的流水号，打开申请详情界面
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle); 
		}
		reloadSelf();		
	}
	
    /*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
    }
    
	
	/*~[Describe=取消申请;InputParam=无;OutPutParam=无;]~*/
	function cancelApply(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sUserID = "<%=CurUser.getUserID()%>";
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		/***************begin update huzp CCS-1334,二段式提单*******************************/
		if("1"=="<%=switch_status%>"){
			var sPretrialSerialNo = getItemValue(0,getRow(),"PretrialSerialNo");
		}
		/********************end*********************************************************/

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var contract_status=RunMethod("公用方法", "GetColValue", "BUSINESS_CONTRACT,ContractStatus,serialNo='"+sObjectNo+"'");
		if("0701"==contract_status||"0702"==contract_status||"0703"==contract_status){
			alert("Engine正运行，请稍后提交");//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}
		if (confirm("你确定要取消该笔申请吗？")) {
			
			var sSerialNo = RunMethod("公用方法", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"'");	//RunMethod("BusinessManage","SelectFlowSerialno",sObjectNo+","+sPhaseNo+","+sObjectType);
			var sSales=<%=CurUser.hasRole("1006")%>;
			var sCE=<%=CurUser.hasRole("1027")%>;
			var edu1=<%=CurUser.hasRole("1626")%>;
			var edu2=<%=CurUser.hasRole("1628")%>;
			var sReturn = "";
			if(sSales){
				sReturn=popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo1.jsp","SerialNo="+sSerialNo+"&Type=7",OpenStyle);
			}else if(sCE){
				sReturn=popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo1.jsp","SerialNo="+sSerialNo+"&Type=8",OpenStyle);
			}else if(edu1||edu2){
				sReturn=popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo1.jsp","SerialNo="+sSerialNo+"&Type=7",OpenStyle);
			}
			if (typeof(sReturn)=="undefined" || sReturn.length==0||sReturn=="_CANCEL_"){
				return;
			}
			//修改阶段为"已取消"中
			var sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","CancelTask","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
			
			
			if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
			else if (sPhaseInfo == "Success"){
				alert("取消合同成功！");
				//将取消类型插入表Flow_Task中
				
			    if(sSales){
			    	RunMethod("Flow_Opinion","ModifyFO",sSerialNo+","+"销售取消");
			    }else if(sCE){
					RunMethod("Flow_Opinion","ModifyFO",sSerialNo+","+"CE专家取消");
			    }else{
			    	RunMethod("Flow_Opinion","ModifyFO",sSerialNo+","+"审核取消");
			    } 
				//RunMethod("BusinessManage","UpdateApplyPhaseType",sObjectNo+","+sObjectType+","+"1060");
				//修改合同状态RunMethod("BusinessManage","UpdateContractStatus",sObjectNo+","+"100");
				//刷新件数及页面 
				// add by tbzeng 2014/07/10 如果取消合同，记录依然存在于审核页面，无法继续提交 
				var sTimeNullSerialNo = RunMethod("公用方法", "GetColValue", "FLOW_TASK,SERIALNO,OBJECTNO='"+sObjectNo+"' and (endtime is null or endtime='')");
				//alert(sTimeNullSerialNo+"|"+typeof sTimeNullSerialNo);
				if (sTimeNullSerialNo!="Null" && sTimeNullSerialNo.length>0) {
					
					var sBeginTime = RunMethod("公用方法", "GetColValue","FLOW_TASK,BEGINTIME,SERIALNO=(SELECT MAX(SERIALNO) FROM FLOW_TASK WHERE OBJECTNO='"+sObjectNo+"')");
					RunMethod("公用方法", "UpdateColValue", "FLOW_TASK,ENDTIME,"+sBeginTime+",SERIALNO='"+sTimeNullSerialNo+"'");
				}
				// end 2014
				
				// add by tbzeng 2104/07/15 记录合同取消事件，事件类型记录060
				var sEvtSerialNo = getSerialNo("Event_Info", "Serialno", "");
				var sCols = "Serialno@Eventname@Eventtime@Contractno@Inputuser@Inputorg@Type@Remarks";
				var sVals = sEvtSerialNo+"@合同取消@<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>@"+sObjectNo+"@<%=CurUser.getUserID()%>@<%=CurOrg.orgID%>@060@取消合同事件记录";
				//RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.InsertEvalue", "recordEvent", "colName="+sCols+",colValue="+sVals);
				// end 2014/07/15
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
				alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
				reloadSelf();
				return;
			} else if (sPhaseInfo == "RuleError"){//by yzheng,qxu 2013/6/28
				alert("规则引擎调用失败!");//该申请已经提交了，不能再次提交！
				reloadSelf();
				return;
			}
			
			/***************begin update huzp CCS-1334,二段式提单*******************************/
			//更新预审信息表中对应的状态
			if("1"=="<%=switch_status%>"){
				if (typeof(sPretrialSerialNo)!="undefined" || sPretrialSerialNo.length!=0){
					//RunMethod("公用方法", "UpdateColValue", "Pretrial_Info,STATE,005,SERIALNO="+sPretrialSerialNo);
					var sParam = "SERIALNO=" +sPretrialSerialNo;
					RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateIndInfoAction", "updatePretrialInfoState", sParam);
				}
			}
			/***************end*******************************/
			// 更新合同状态
			RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo="+sObjectNo+"");
			reloadSelf();
		}
	}
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		//reloadSelf(); //update CCS-499 贷款申请菜单下合同状态列表数据超过一页的，查看某页合同的申请详情关闭后跳到了第一页  by rqiao 20150331
	}

	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit(){
		
		//add by hwang,新增获取参数sApplyType1申请类型
		//获得申请类型、申请流水号、流程编号、阶段编号、申请类型
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		 var sUserID = "<%=CurUser.getUserID()%>";
		
		//var sReturnVal=RunMethod("BusinessManage","SelectUnlogContractOverTime",sObjectType+","+sApplyType1+","+sUserID); 
		var sReturnVal=RunMethod("BusinessManage","SelectUnlogContractOverTime",sObjectType+","+sUserID); 
		
		var sObFlowNo = RunMethod("公用方法", "GetColValue", "FLOW_OBJECT,OBJATTRIBUTE5,OBJECTNO='"+sObjectNo+"'");
		if (sObFlowNo!="Null" && sObFlowNo.length>0) {
			alert("请勿重复提交！");
			return;
		}
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		// add by tbzeng 2014/07/11 校验合同和客户信息是否已经保存
		var sContratNo = getItemValue(0, getRow(), "SerialNo");

		//统一获取合同表所需字段
		var sColName = "TEMPSAVEFLAG@Manufacturer1@RepaymentWay@ContractStatus@SalesManager@CreditID";
		var sTableName = "BUSINESS_CONTRACT";
		var sWhereClause = "String@SERIALNO@"+sContratNo;
		var	bcReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		var bcReturnArr = bcReturn.split("@");
		var sContractTempFlag = bcReturnArr[1];
		var sManufacturer1 = bcReturnArr[3];
		var sRepaymentWay = bcReturnArr[5];
		var contract_status = bcReturnArr[7];
		//以下一个变量在上面已获取
		//var sContractTempFlag = RunMethod("PublicMethod", "GetColValue", "BUSINESS_CONTRACT,TEMPSAVEFLAG,Manufacturer1,SERIALNO='"+sContratNo+"'");
		var sIndTempFlag = RunMethod("公用方法", "GetColValue", "IND_INFO,TEMPSAVEFLAG, CUSTOMERID=(SELECT CUSTOMERID FROM BUSINESS_CONTRACT WHERE SERIALNO='"+sContratNo+"')");
		var sAssistTempFlag=RunMethod("公用方法", "GetColValue", "ASSISTINVESTIGATE,TEMPSAVEFLAG,OBJECTNO='"+sContratNo+"'");
		//add CCS-363 PRM-81 个人月收入没有填写也能提交
		var sSelfMonthIncome = RunMethod("公用方法", "GetColValue", "IND_INFO,SelfMonthIncome, CUSTOMERID=(SELECT CUSTOMERID FROM BUSINESS_CONTRACT WHERE SERIALNO='"+sContratNo+"')");
		if(null == sSelfMonthIncome || "" == sSelfMonthIncome) sSelfMonthIncome = "0";
		//end
		
		//add PRM-499 型号跟还款方式必填项没有填写也能提交 by huanghui 20150713
		//以下两个变量在上面已获取
		//var sManufacturer1 = RunMethod("公用方法", "GetColValue", "BUSINESS_CONTRACT,Manufacturer1,SERIALNO='"+sContratNo+"'");
		//var sRepaymentWay = RunMethod("公用方法", "GetColValue", "BUSINESS_CONTRACT,RepaymentWay,SERIALNO='"+sContratNo+"'");
		//end
		
		if (sIndTempFlag == "1" || parseFloat(sSelfMonthIncome)<=0) { // 校验客户信息是否已经保存// update CCS-363 PRM-81 个人月收入没有填写也能提交
			alert("请先保存客户信息再提交！");
			return;
		}
		
		//add PRM-499 型号跟还款方式必填项没有填写也能提交 by huanghui 20150713
		if (sContractTempFlag == "1" || null== sManufacturer1 || ""==sManufacturer1|| "Null"==sManufacturer1 || null== sRepaymentWay || ""==sRepaymentWay|| "Null"==sRepaymentWay) {	// 校验合同信息是否已经保存
			alert("请先保存合同信息再提交！");
			return;
		}
		// end 2014/07/11
		//校验协审信息是否已经保存
		if(sAssistTempFlag!="2"){
			alert("请先保存协审信息再提交！");
			return;
	    	}
		// 请先生成还款信息再保存
		var params = "objectNo=" + sContratNo;
		var res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", 
									"gainIsGenSchedule", params);
		if (res != "2") {
			alert("请先在合同界面生成还款信息！");
			return;
		}
		
		// 学生选择产品验证 add by tbzeng 2014/08/27
		var sCusTypeNo = RunMethod("公用方法", "GetColValue", "IND_INFO,HEADSHIP,CUSTOMERID='"+sObjectNo.substring(0,8)+"'"); 
		var sBizType = getItemValue(0, getRow(), "BusinessType");
		var sBizTypeUse = sBizType;
		if (sBizType && sBizType.length>1) sBizType = sBizType.substring(0, 2);
		//alert(sCusTypeNo + "|" + sBizType);
		var adultEducationType="<%=sSubApplyType%>";
		if("AdultEducation"==adultEducationType ||"StuEducation"==adultEducationType){// 4 5  是学生贷 或是成人da
			var educationPutoutno=RunMethod("公用方法", "GetColValue", "business_education_info,SCHOOL_NAME,putoutno='"+sContratNo+"'");
			if( null== educationPutoutno || ""==educationPutoutno|| "Null"==educationPutoutno){
				if("AdultEducation"==adultEducationType){
				
				}else{
					alert("请先保存学生贷信息");
				    return;
				}
			}
			var  isRepeat=	RunJavaMethodSqlca("com.amarsoft.app.billions.IsRepeatEducationInfo", "InserOrupdateEducationInfoByServerNo", "putoutno='"+sContratNo+"'");
			//  验证该单所以电话号码不能重复
			if("K"!=isRepeat){
				alert("所有关系的电话存在重复号码,请检测重复号码并修改!");
			}
		}else{
			if (sBizType=="XS" || sBizType=="xs" || sBizType=="Xs" || sBizType=="xS") {
					if (sCusTypeNo != "9") {
						//不用校验学生消费贷 add by dyh 20150618
						if("StuPos" != adultEducationType){
							alert("该产品："+sBizTypeUse+",只供学生用户使用！");
							return;
						}
					}
			} else {
				if (sCusTypeNo == "9") {
					alert("学生用户不能使用该产品："+sBizTypeUse+"！");
					return;
				}
			}
		}
		// 2014/08/27--end
		
		
		// 核算加校验 CCS-685 slyang 2015/04/09
		/* var sSpecialBizType = RunMethod("公用方法", "IsSpecialBizType", sObjectNo);
		if(!CheckSegment() && sSpecialBizType=="false"){
			
			alert("合同保存无效,请检查合同重新保存！");
			return;
		} */
		
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ApplyCheak","cheakMangees","serialNo="+sObjectNo);
		if (result.split("@")[0] != "true") {
			alert(result.split("@")[1]);
			return;
		}
		var sUserID = "<%=CurUser.getUserID()%>";
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);		
		if(sNewPhaseNo != sPhaseNo) {
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}

		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		} 
		
		//CCS-1210 身份证正反面、现场照改为必须项  start
		// add by tbzeng 2014/05/28  已经上传现场照片并且打印申请表才允许提交
		//var sApplyTablePath = RunMethod("公用方法", "GetColValue", "Formatdoc_Record,SavePath,ObjectType='ApplySettle' and  ObjectNo='"+sObjectNo+"'");
		//var sIsTransScenePhoto = RunMethod("公用方法", "GetColValue", "ecm_page,DocumentId,ObjectNo='"+sObjectNo+"'");
		//if (sIsTransScenePhoto=="Null") {
		//	alert("请先上传现场照片再提交！");
		//	return;
		//}
		var uploadImages = RunJavaMethodSqlca("com.amarsoft.app.billions.UploadedImageCommon","getUploadedImageTypes","objectNo="+sObjectNo);
		if (uploadImages.indexOf("客户身份证正面")==-1 || uploadImages.indexOf("客户现场照片")==-1 || uploadImages.indexOf("客户身份证背面")==-1) {
			alert("请先上传现场照片、身份证正面照与身份证背面照再提交！");
			return;
		}
		//CCS-1210 身份证正反面、现场照改为必须项  end
		
		//if (sApplyTablePath=="Null") {
		//	alert("请先在合同详情页面打印申请表再提交！");
		//	return;
		//} 		
		var sProductID = getItemValue(0,getRow(),"ProductID");
		if(sReturnVal!=0){
			alert("请先处理逾期未注册合同");
			return false;
		} 
		
		//判断当前合同是否需要上传贷后资料
		var uploadStatus = RunJavaMethodSqlca("com.amarsoft.app.als.image.ImageUploadAfterLoan","isNeedUploadImageAfterLoan","sObjectNo = "+sObjectNo);
		if(uploadStatus =="未上传"){
			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,uploadFlag,2,SerialNo = '"+sObjectNo+"'");
		}else if(uploadStatus =="无需上传"){
			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,uploadFlag,3,SerialNo = '"+sObjectNo+"'");
		}else {
			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,uploadFlag,3,SerialNo = '"+sObjectNo+"'");
		}
		RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,OPERATEDSTATUS,1,SerialNo = '" + sObjectNo + "'");
		ShowMessage("系统正在提交，请等待...",true,true);
		//记录提交时间 add by jli5 20150422 位置不要修改，需放到所有校验之后提交动作之前
		RunJavaMethodSqlca("com.amarsoft.app.als.rule.InsertRuleRunLog","insertSubTime","SerialNo = "+sObjectNo);
		
		
		//判断当前申请是否打印申请表
		/* var sApplyRepot = RunMethod("BusinessManage","getApplyReport",sObjectNo+","+sProductID);
		if(typeof(sApplyRepot)=="undefined" || sApplyRepot.length==0 || sApplyRepot == "Null") {
			alert("未生成申请表，请生成申请表后再提交！");
			return;
		} */ 		
		//弹出审批提交选择窗口		增加参数传递，防止重复提交 by yzheg,qxu 2013/6/28 
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		if(sFlowNo=="CarFlow"){ //如果是车贷流程，根据流程配置提交
			//调用规则计算申请等级
			var sRet = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getGrade","objectType="+sObjectType+",objectNo="+sObjectNo);
			if(sRet!="Success"){
				alert("计算申请等级出错！");
				try{hideMessage();}catch(e) {}//add in 
				return;
			}
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sTaskNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}else{ //如果 是消费贷流程，需要调规则以及更改flowNo
		//	sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommitWithRule","SerialNo="+sTaskNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
			//以下一个变量在上面已获取
			//var contract_status=RunMethod("公用方法", "GetColValue", "BUSINESS_CONTRACT,ContractStatus,serialNo='"+sObjectNo+"'");
			if("070"==contract_status||"0701"==contract_status){
				alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
				reloadSelf();
				return;
			}
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.InsertAutoRuleAction","updateBusinssConByserialNo","serialNo="+sObjectNo);
			//检查是否走p2p流程
			RunJavaMethodSqlca("com.amarsoft.proj.action.P2PCredit","checkIsUseP2p","ContractSerialNo="+sObjectNo);
			//RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,070,commit_Date,,SerialNo = '"+sObjectNo+"'");
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		
		}
		
		// 更新合同状态
		//RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo="+sObjectNo+"");
if(sFlowNo=="CarFlow"){		
		try{hideMessage();}catch(e) {}//add in 
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,070,SerialNo = '"+sObjectNo+"'");
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,070,SerialNo = '"+sObjectNo+"'");
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}else if (sPhaseInfo == "RuleError"){
			alert("规则引擎调用失败!");
			reloadSelf();
			return;
		}else if (sPhaseInfo == "Failure9000") {
			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,100,SerialNo = '"+sObjectNo+"'");
			alert("该申请已经取消!");
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success"){
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,070,SerialNo = '"+sObjectNo+"'");
				alert(getHtmlMessage('18'));//提交成功！
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
	}
}	
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function signOpinion(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		//alert("---"+sObjectType+"----"+sObjectNo+"----"+sFlowNo+"----"+sPhaseNo);
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	//收回
	function takeBack(){
		//所收回任务的流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		//PhaseNo = "<%=sInitPhaseNo%>";
		var sPhaseNo = RunMethod("WorkFlowEngine","GetInitPahseNo",sObjectType+","+sObjectNo);
		//获取任务流水号
		var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
			if(confirm(getBusinessMessage('498'))){ //确认收回该笔业务吗？
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				//收回成功后才刷新页面
				if(sRetValue == "Commit"){
					reloadSelf();
				}
			}
		}else{
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}				
	}

	/*~[Describe=归档;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('56'))){ //您真的想将该信息归档吗？
			//归档操作
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getHtmlMessage('60'));//归档失败！
				return;			
			}else{
				reloadSelf();	
				alert(getHtmlMessage('57'));//归档成功！
			}			
		}
	}

	/*~[Describe=取消归档;InputParam=无;OutPutParam=无;]~*/
	function cancelarch(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('58'))){ //您真的想将该信息归档取消吗？
			//取消归档操作
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//取消归档失败！
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('59'));//取消归档成功！
			}
		}
	}

	/*~[Describe=自动风险探测;InputParam=无;OutPutParam=无;]~*/
	function riskSkan(){
		RunJavaMethod("com.amarsoft.app.als.rule.impl.DefaultService","getResultJs","");
		//获得申请类型、申请流水号
		/*
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");

		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//进行风险智能探测
        autoRiskScan("001","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ApplyType1="+sApplyType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo);
		//autoRiskScan("001","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,20);
		*/
	}
		
	/*~[Describe=填写调查报告;InputParam=无;OutPutParam=无;]~*/
	function genReport(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sDocID = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sReturn = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			sFlag = AsControl.RunJsp("/FormatDoc/GetBusinessTypeAction.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
			if(sFlag =="1") sDocID = "06";//公司客户低风险业务调查报告
			else if(sFlag =="2") sDocID = "04";//公司客户授信额度项下授信业务调查报告
			else if(sFlag =="3") sDocID = "05";//公司客户银票贴现业务调查报告
			else if(sFlag =="4") sDocID = "03";//公司客户综合授信调查报告
			else if(sFlag =="8"){
				sDocID = "08";//个人客户授信业务调查报告
				alert("个贷业务不需要填写调查报告");  //added by yzheng 2013-6-25
				return;
			}
			else if(sFlag =="9") sDocID = "09";//中小企业授信业务调查报告
			else{
				sDocID = setObjectValue("SelectReportType","","",0,0,"");
				if(sDocID == "" || sDocID == "_CANCEL_" || sDocID == "_NONE_" || sDocID == "_CLEAR_" || typeof(sDocID) == "undefined") return;			
				sDocID = sDocID.split("@");
				sDocID = sDocID[0];
			}
		}else{
			sDocID = sReturn;
			sFlag = AsControl.RunJsp("/FormatDoc/GetBusinessTypeAction.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
			if(sFlag == "5"){   //5代表除了其他调查报告以外的所有类型
				sReturn = PopPage("/Common/WorkFlow/ButtonDialog.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if(typeof(sReturn)=="undefined" || sReturn.length==0){
					return;
				}else if (sReturn == "_CANCEL_"){
					PopPage("/FormatDoc/DeleteReportAction.jsp?ObjectNo="+sObjectNo,"","");
					sDocID = setObjectValue("SelectReportType","","",0,0,"");
					if(sDocID == "" || sDocID == "_CANCEL_" || sDocID == "_NONE_" || sDocID == "_CLEAR_" || typeof(sDocID) == "undefined") return;			
					sDocID = sDocID.split("@");
					sDocID = sDocID[0];	
				}				
			}			
		}
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)!='undefined' && sReturn!=""){
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("FormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
	}
	
	/*~[Describe=生成调查报告;InputParam=无;OutPutParam=无;]~*/
	function createReport(){
		//获得申请类型、申请流水号、客户编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		
		var sDocID = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if (typeof(sDocID)=="undefined" || sDocID.length==0){
			alert(getBusinessMessage('505'));//调查报告还未填写，请先填写调查报告再查看！
			return;
		}
		
		if (confirm(getBusinessMessage('504'))){ //是否要增加打印内容,如果是请点击确定按钮！
			var sAttribute1 = PopPage("/Common/WorkFlow/DefaultPrintSelect.jsp?DocID="+sDocID+"&rand="+randomNumber(),"","dialogWidth=800px;dialogHeight=600px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
			if (typeof(sAttribute1)=="undefined" || sAttribute1.length==0)
				return;
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute1,"_blank02",CurOpenStyle); 
		}else{
			var sAttribute = PopPage("/FormatDoc/DefaultPrint/GetAttributeAction.jsp?DocID="+sDocID,"","");
			if (typeof(sAttribute)=="undefined" || sAttribute.length==0) return;
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute,"_blank02",CurOpenStyle); 
		}
	}	
	
	/*~[Describe=查看调查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sDocID = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if (typeof(sDocID)=="undefined" || sDocID.length==0){
			alert(getBusinessMessage('505'));//调查报告还未填写，请先填写调查报告再查看！
			return;
		}
		
		var sReturn = AsControl.RunJsp("/FormatDoc/GetReportFile.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID);
		if (sReturn == "false"){
			createReport();
			return;  
		}else{
			if(confirm(getBusinessMessage('503'))){ //调查报告有可能更改，是否生成调查报告后再查看！
				createReport();
				return; 
			}else{
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
				OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
		}
	}
	
	/*~[Describe=复制当前;InputParam=无;OutPutParam=无;]~*/
	function copyThis(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (confirm("你确认复制这条信息！")){
			sReturn = RunMethod("WorkFlowEngine","CopyApplyFlow",sObjectType+","+sObjectNo);
			if(typeof(sReturn)!="undefined" && sReturn.length!=0){
				alert("复制成功");
				reloadSelf();
			}
		}
	}	

	/*~[Describe=绿色通道;InputParam=无;OutPutParam=无;]~*/
	function greenWay(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
		    sReturn=RunMethod("BusinessManage","initializeGreenWay",sObjectNo+","+"<%=CurUser.getUserID()%>"+","+"<%=CurOrg.getOrgID()%>");
		    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;

			sObjectType = "BusinessContract";
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
	}	

	/*~[Describe=流程图形展示;InputParam=无;OutPutParam=无;]~*/
	function viewFlowGraph(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			var iViewFileLength = RunMethod("WorkFlowEngine","GetViewFileLength",sFlowNo);
			if(typeof(iViewFileLength)=="undefined" || iViewFileLength.length==0){
				alert("流程的图形定义不存在，请先配置流程图再查看！");
				return;
			}
			popComp("FlowGraphView","/Common/WorkFlow/FlowGraphView.jsp","ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo);
		}
	}
	
	/*~[Describe=打印申请表;InputParam=无;OutPutParam=无;]~*/
	function creatApplyTable(){
			var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
			sObjectType = "ApplySettle";
			sExchangeType = "";
			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}else{
						//检查出帐通知单是否已经生成
						var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
						if (sReturn == "false"){ //未生成出帐通知单
							//生成出帐通知单	
							PopPage("/FormatDoc/Report17/03.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
							//记录生成动作
							RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=produce");
						}else{
							//记录查看动作
							RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=view");
						}
						//获得加密后的出帐流水号
						var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
						//通过　serverlet 打开页面
						var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
						//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
						OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	/*~[Describe=打印电子合同;InputParam=无;OutPutParam=无;]~*/
	function creatContract(){//CCS-652  教育产品 - 电子合同打印模板，打印逻辑
		printTable("ApplySettle");
	}
	
	/*~[Describe=打印第三协议;InputParam=无;OutPutParam=无;]~*/
	function creatThirdTable(){
		printTable("ThirdSettle");
	}
	
	/*~[Describe=打印审批意见书;InputParam=无;OutPutParam=无;]~*/
	function printApprove(){
		printTable("ApproveSettle");
	}
	
	/*~[Describe=打印还款小贴士;InputParam=无;OutPutParam=无;]~*/
	function printRemind(){
		printTable("CreditSettle");
	}
	
	/*~[Describe=打印还风险函;InputParam=无;OutPutParam=无;]~*/
	function printRishTip(){

		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type=RishSettle");
		if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
			alert("请联系系统管理员检查合同模板配置和合同信息!");
			return;
		}
		var sDocID = returnValue.split("@")[0];
		var sUrl = returnValue.split("@")[1];
		//add by daihuafeng 20150708 ----begin 多传一个参数，控制当业务来源是APP时客户签名是URL签名
		sUrl = sUrl+"?ObjectNo="+sObjectNo;
		//add by daihuafeng 20150708 ----end
		
		OpenPage(sUrl,"_blank02",CurOpenStyle); 

	}
	
	/*~[Describe=打印随心还服务申请书;InputParam=无;OutPutParam=无;]~*/
	function printSuiXinHuan(){

		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
	    var sBugPayPkgind = RunMethod("公用方法", "GetColValue", "business_contract,BugPayPkgind,serialno='"+sObjectNo+"'");
		if (typeof(sBugPayPkgind)=="undefined" || sBugPayPkgind.length==0 || (sBugPayPkgind!="1" && sBugPayPkgind!="2")){
			alert("该合同未购买随心还服务包!");
			return;
		}
		
		var sUrl = "/FormatDoc/Report17/ApplySuiXinHuan.jsp?ObjectNo="+sObjectNo;
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		OpenPage(sUrl,"_blank02",CurOpenStyle); 

	}

	/*~[Describe=打印佰保袋合同 ;InputParam=无;OutPutParam=无;]~*/
	function printBaiBaoDai(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sBusinessType2 = RunMethod("公用方法", "GetColValue", "business_contract,BusinessType2,serialno='"+sObjectNo+"'");
		if (typeof(sBusinessType2)=="undefined" || sBusinessType2.length==0 || sBusinessType2!="2015061500000017"){
			alert("该合同未购买佰保袋!");
			return; 
		}
		printTable("BaiBaoDai");
	}
	
	
	//   ==============================  打印格式化报告  公共方法  add by yzhang9  CCS-613  ============================================================
		
	/*~[Describe=打印格式化报告;InputParam=无;OutPutParam=无;]~*/
	function printTable(type){
			var sObjectNo = getItemValue(0,getRow(),"SerialNo");
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			
			var sObjectType = type;
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}else{
				//检查出帐通知单是否已经生成
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if(sReturn == "move"){
					//alert("以前生成的文件已经被移动了，无法展示，也不可重新生成");
					return;
				}else if (sReturn == "false"){ //未生成出帐通知单
					var returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
					if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
						alert("请联系系统管理员检查合同模板配置和合同信息!");
						return;
					}
					var sDocID = returnValue.split("@")[0];
					var sUrl = returnValue.split("@")[1];
					var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
					//生成出帐通知单	
						PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
					//记录生成动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
				}else{
					//记录查看动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
				}
				//获得加密后的出帐流水号
				var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
				//通过　serverlet 打开页面
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
				//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
				OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	
	//   ============================== end  打印格式化报告 ============================================================
	
	
	var time_range = function (beginTime, endTime, nowTime) {
	    var strb = beginTime.split (":");
	    if (strb.length != 2) {
	         return false;
	     }

	    var stre = endTime.split (":");
	     if (stre.length != 2) {
	         return false;
	    }
	 
	     var strn = nowTime.split (":");
	     if (stre.length != 2) {
	         return false;
	     }
	     var b = new Date ();
	     var e = new Date ();
	     var n = new Date ();
	 
	     b.setHours (strb[0]);
	     b.setMinutes (strb[1]);
	     e.setHours (stre[0]);
	     e.setMinutes (stre[1]);
	     n.setHours (strn[0]);
	     n.setMinutes (strn[1]);
	 
	     if (n.getTime () - b.getTime () > 0 && n.getTime () - e.getTime () < 0) {
	    	 alert("当前时间是段正在执行批量，请 " + endTime + " 再提交注册！");
	         return true;
	    } else {
	        //alert ("当前时间是：" + n.getHours () + ":" + n.getMinutes () + "，不在该时间范围内！");
	        return false;
	    }
	}
	
	/*~[Describe=合同提交注册;InputParam=无;OutPutParam=无;]~*/
	function doRegistration(){

			/***********CCS-1041,系统跑批时不能登录系统 huzp 20151217**************************************/
			var sTaskFlag = RunMethod("公用方法","GetColValue","system_setup,taskflag,1=1");
			if(sTaskFlag=="1"){
				alert("系统正在跑批，暂时无法提交注册!");
				return;
			}else{
				var sObjectNo = getItemValue(0,getRow(),"SerialNo");
				var sObjectType = getItemValue(0,getRow(),"ObjectType");
				var sCustomerType = getItemValue(0,getRow(),"CustomerType");
				var sSureType = RunMethod("公用方法","GetColValue","Business_Contract,SureType,serialNo = '"+sObjectNo+"' ");
				if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
					alert(getHtmlMessage('1'));//请选择一条信息！
					return;
				}
				if(confirm("是否确定提交注册 ？")){//CCS-1154,合同提交注册，增加“二次确认提示”
					//add by yongxu 20150709  
					if (sSureType=="APP"){
						alert("PAD端合同不能在PC端提交！");
						return false;
					}
					//end by yongxu
					var sSignRet = RunJavaMethodSqlca("com.amarsoft.app.billions.CommonTransationFix", "contractRegistration", "objectno="+sObjectNo);
					if ("Failure" === sSignRet) {
						alert("提交注册失败，请检查数据库连接！");
					}
					//add by fangxq 20151228
					reloadSelf();
					return;
				}
				//end by fangxq
				//if(sCustomerType=="0310"){//个人客户
					//修改当前选中申请的状态为"已签署"020合同状态
					<%-- RunMethod("BusinessManage","UpdateReturn",sObjectNo+","+"020,<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>"); --%>
					//修改阶段为"已签署"中
					/* RunMethod("BusinessManage","UpdateApplyPhaseType",sObjectNo+","+sObjectType+","+"1070"); */
				reloadSelf();
				//}
				return;
			}
			/***********end**********************************************************************/
	}
	/*~[Describe=执行放款交易;InputParam=无;OutPutParam=无;]~*/
	function makePaymentPlan(){
		/* 测试用····················································*/
		//var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var productID = getItemValue(0,getRow(),"BusinessType");
		/* if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} */
		if(confirm("您真的确定执行放款交易吗？")){
			CalcMaturity();
			var sReturn = RunMethod("LoanAccount","RunTransaction3",productID+",,TRA001,<%=BUSINESSOBJECT_CONSTATNTS.business_contract%>,"+sObjectNo+",<%=CurUser.getUserID()%>,");
			if(typeof(sReturn)=="undefined"||sReturn.length==0){
				alert("系统处理异常！");
				return;
			}
			alert(sReturn.split("@")[1]);
			reloadSelf();
			return;
		}
	}
	/*~[Describe=计算到期日;InputParam=无;OutPutParam=无;]~*/
	function CalcMaturity(){
		var SerialNo=getItemValue(0,getRow(),"SerialNo");//合同流水号
		<%-- var sPutOutDate = "<%=DateUtil.getToday()%>";//合同生效日 --%>
		var sPutOutDate = "<%=SystemConfig.getBusinessDate()%>";
		var sDay = sPutOutDate.substring(8,10); 
		var deDaultDueDay = "";
		if(sDay == "29" ){
			deDaultDueDay = "02";
			RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//合同生效日
		}else if(sDay == "29"){
			deDaultDueDay = "03";
			RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//合同生效日
		}else if(sDay == "30"){
			deDaultDueDay = "04";
			RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//合同生效日
		}	
    	var sTermMonth_ = RunMethod("GetElement","GetElementValue","Periods,business_contract,SerialNo='"+SerialNo+"'");//期限
    	var sTermMonth = parseInt(sTermMonth_,10);
    	var sMaturity = "";
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 ) {
			alert("合同未录入贷款期次！");
			return ;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";//期限单位(月)
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermMonth+","+sPutOutDate);
		}
		RunMethod("PublicMethod","UpdateColValue","String@PutOutDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同生效日
		RunMethod("PublicMethod","UpdateColValue","String@contractEffectiveDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同生效日
		RunMethod("PublicMethod","UpdateColValue","String@Maturity@"+sMaturity+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同到期日
	}
	
	
	/*~[Describle=贷后资料上传;InputParam=无;OutPutParam=无;]*/
	function informationUpload(){
		//获得申请类型、申请流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		 if(getItemValue(0,getRow(),"uploadFlag")=="无需上传"){
			 alert("该产品无需上传贷后资料！");
			 return false;
		 } 
		 var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.image.ImageUploadAfterLoan","checkUploadImageEnabled","sNo="+'<%=sNo%>'+",sObjectNo="+sObjectNo);
		 if(sReturn=="PASS"){
			 var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo+"&uploadPeriod=1";
			 AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
		 }else if(sReturn == "NIDC"){
			 alert("不在指定城市不能上传贷后资料！");
			 reloadSelf();
			 return false;
		 }else if(sReturn == "ORD"){
			 //超期未上传贷后资料状态
			 var sStatus = RunJavaMethodSqlca("com.amarsoft.app.als.image.ImageUploadAfterLoan","getUploadStatusWhenOverdue","sObjectNo="+sObjectNo);
//			 RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkresult2,"+sStatus+",SerialNo='"+sObjectNo+"' ");
			 alert("已超过指定的贷后资料上传时间！");
			 reloadSelf();
			 return false;
		 }
	}
	
	//上传完贷后资料提交
	function uploadImageSubmit(){
		//获得申请类型、申请流水号、流程编号、阶段编号、申请类型
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sToday = "<%=sToday%>";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//判断是否已上传贷后资料
		var sAmount = RunMethod("公用方法","GetColValue","ECM_PAGE,count(1),objectno = '"+sObjectNo+"' and  objectType = 'BusinessLoan' ");
		if(sAmount==0){
			alert("未上传任何贷后资料！");
			return false;
		}
		//更新贷后上传状态为“已上传”
		RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,uploadFlag,1,SerialNo = '"+sObjectNo+"' ");
		//更新贷后检查状态为未检查
		RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,2,SerialNo = '"+sObjectNo+"' ");
		//更新贷后资料进入任务池时间
		RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checktime,"+sToday+",SerialNo = '"+sObjectNo+"' ");
		alert("提交成功!");
		reloadSelf();
		return false;
	}
	/*~[Describle=附条件审批资料;InputParam=无;OutPutParam=无;]*/
	/**
	function subjoinCondition(){
		//获得申请类型、申请流水号
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	}**/

	//add CCS-574 PRM-256 原地复活计划安硕系统需求  by rqiao 20150401
	/*~[Describle=提起复议;InputParam=无;OutPutParam=无;]*/
	function ReconsiderSubmit()
	{
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");//合同编号
		var sObjectType = "<%=sObjectType%>";	
		var sApplyType = "<%=sApplyType%>";	
		//获取当前FLOW_TASK被否决合同的的编号 ，就是FLOW_TASK最后一条数据 
		var sSerialNo = RunMethod("公用方法", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'");
		var sUserName = "<%=CurUser.getUserName()%>";
		var sOrgName = "<%=CurUser.getOrgName()%>";
		var returnValue = RunMethod("公用方法", "GetColValue", "FLOW_OBJECT,FlowNo||'@'||FlowName,ObjectNo='"+sObjectNo+"'");
		
		var sNextFlowNo = returnValue.split("@")[0];
		var sFlowName = returnValue.split("@")[1];
		var sInitFlowNo = "<%=sInitFlowNo%>";
		var sInitPhaseNo = "<%=sInitPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurOrg.orgID%>";
		var sInputTime= "<%=StringFunction.getTodayNow()%>"
		var sAllowReconsider = getItemValue(0,getRow(),"AllowReconsider");//add “能否原地复活”  by  hhuang 20150630
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		//检查是否发起过原地复活申请，避免重复发起
		var sRelativeCount = RunMethod("公用方法", "GetColValue", "BUSINESS_CONTRACT,SerialNo,RelativeSerialNo='"+sObjectNo+"'");
		if(null == sRelativeCount) sRelativeCount = "";
		
		if("undefined" != sRelativeCount && "Null" != sRelativeCount && sRelativeCount.length > 0)
		{
			alert("该合同已进行过原地复活，请重新选择");
			return;
		}
		
		if(confirm("确认复活该任务？")){
			//add 增加IF条件：如果销售提交复活”能否原地复活“ = N的合同，系统提示”无权限“  BY HUANGHUI 20150706
			var sPar_Value = "ObjectType="+sObjectType+",ObjectNo="+sObjectNo+",ApplyType="+sApplyType+",FlowNo="+sInitFlowNo+",PhaseNo="+sInitPhaseNo+",serialNo="+sSerialNo+",UserID="+sUserID+",OrgID="+sOrgID+",userName="+sUserName+",orgName="+sOrgName+",NextFlowNo="+sNextFlowNo+",FlowName="+sFlowName+",InputTime="+"<%=StringFunction.getTodayNow()%>";
			returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddReconsiderInfo", "CheckReconsiderRule",sPar_Value);
			if(typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("系统处理异常！");
				return;
			}
			
			if("否"==sAllowReconsider || "Success" != returnValue)
			{
				alert("无权限");
				return;
			}
			
			// 原地复活原因弹出框   add by yzhang9 
			var sCompID = "ResurrectionReason";
			var sCompURL = "/Common/WorkFlow/ResurrectionReason.jsp";
			var sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApplyType="+sApplyType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo+"&SerialNo="+sSerialNo+"&UserID="+sUserID+"&OrgID="+sOrgID+"&UserName="+sUserName+"&OrgName="+sOrgName+"&NextFlowNo="+sNextFlowNo+"&FlowName="+sFlowName+"&InputTime="+sInputTime,"dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			
			if (typeof(sReturn)=="undefined" || sReturn.length==0){
				reloadSelf();
				return;
			}
			//var sResurrectionReason = returnValue.split("@")[0]; //对应Code: ResurrectionReason  
			//var sResurrectionReasonRemark = returnValue.split("@")[1];//当下拉选择'其他'时  填写的其他备注 
			//将复活原因更新到 合同表字段 
			/* RunMethod("公用方法","UpdateColValue","business_contract,ResurrectionReason,"+sResurrectionReason+",serialno='"+sObjectNo+"'");
			if(sResurrectionReasonRemark!=""){
				RunMethod("公用方法","UpdateColValue","business_contract,ResurrectionReasonRemark,"+sResurrectionReasonRemark+",serialno='"+sObjectNo+"'");
			} */
			if(sReturn == "false"){
				reloadSelf();
				return;
			}
			
			//var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddReconsiderInfo", "GenerateReconsiderContractInfo",sPar_Value);

			if(typeof(sReturn)=="undefined"||sReturn.length==0||("Success" == sReturn.split("@")[0] && sReturn.indexOf("@")==-1)){
				alert("系统处理异常！");
				return;
			}
			else if("Faile" == sReturn.split("@")[0])
			{
				alert("无权限");
				/* RunMethod("公用方法","UpdateColValue","business_contract,ResurrectionReason,,serialno='"+sObjectNo+"'");
				RunMethod("公用方法","UpdateColValue","business_contract,ResurrectionReasonRemark,,serialno='"+sObjectNo+"'"); */
				return;
			}else 
			{
				ShowMessage("系统正在提交，请等待...",true,true);
				alert("复活成功");
					
				try{hideMessage();}catch(e) {}//add in 
				reloadSelf();
			}
		}
	}
	//end
	
	// add by xswang 2015/05/25 CCS-808 系统全流程电子化改造：文件质量检查
	//文件错误详情
	function viewErrorDoc(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo"); //合同流水号
		//贷后资料上传，区分贷前贷后
		var sContractStatus = getItemValue(0,getRow(),"ContractStatus"); //合同状态
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(sContractStatus == "已注册"){
			var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo+"&OperateMode=upload";
			AsControl.OpenView("/ImageManage/ImageAfterLoanCheckList.jsp",param,"_blank","");
		}
	}
	
	//补充资料提交
	function checkdocSubmit(){
		//根据合同状态判断是否需要提交
		var sContractStatus = getItemValue(0,getRow(),"ContractStatus"); //合同状态

		//获得申请类型、申请流水号、流程编号、阶段编号、申请类型
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sToday = "<%=sToday%>";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sContractStatus == "已注册"){
			//贷后资料检查
			//补充完贷后资料更新状态
			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,6,SerialNo = '"+sObjectNo+"' ");
			alert("提交成功!");
			reloadSelf();
			return false;
		}
	}
	// end by xswang 2015/05/25
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">		
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>