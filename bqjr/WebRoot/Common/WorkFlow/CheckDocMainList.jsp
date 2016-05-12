<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: 文件质量检查信息
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "文件质量检查"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sToday = StringFunction.getTodayNow();//系统时间
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
	<%@include file="/Common/WorkFlow/CheckDocTaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	
	//获取任务池任务
	function getTask(){
		
		var sToday = "<%=sToday%>";
		var sUser = "<%=CurUser.getUserID()%>";
		//判断是否有待处理任务
		var sReturn3 = RunMethod("公用方法","GetColValueTables","BUSINESS_CONTRACT,Check_Contract,count(1),BUSINESS_CONTRACT.serialno=Check_Contract.contractserialno and (business_contract.suretype = 'APP' or business_contract.suretype = 'FC') and (Check_Contract.CheckDocStatus = '2' and Check_Contract.gettaskuserid1='"+sUser+"' or Check_Contract.CheckDocStatus = '7' and Check_Contract.gettaskuserid2='"+sUser+"') and (business_contract.contractstatus='160' or business_contract.contractstatus='050') ");
		if(sReturn3 > 0){
			alert("当前有未处理的任务!");
			return;
		}
		//合同号
		var sReturn4 = RunMethod("公用方法","GetColValueTables","BUSINESS_CONTRACT,Check_Contract,Check_Contract.ContractSerialNo,BUSINESS_CONTRACT.serialno=Check_Contract.contractserialno and (BUSINESS_CONTRACT.contractstatus='160' or BUSINESS_CONTRACT.contractstatus='050') and (Check_Contract.checkdocstatus = '1' or Check_Contract.checkdocstatus = '6')  and (business_contract.suretype = 'APP' or business_contract.suretype = 'FC') ");
		//文件质量检查状态
		var sReturn2 = RunMethod("公用方法","GetColValue","Check_Contract,CheckDocStatus,ContractSerialNo='"+sReturn4+"'");
		if(sReturn2 == "6"){// "6":补充资料完成
			//更新状态为复审中、更新复审开始时间、更新当前获取任务的用户
			RunMethod("PublicMethod","UpdateColValue","String@GetTaskUserID2@"+sUser+"@String@CheckDocStatus@7@String@checkagainbegintime@" + sToday + ",check_contract,String@contractserialno@" + sReturn4);
			alert("获取成功!");
			parent.reloadSelf();
		}else if(sReturn2 == "1"){// "1":未检查
			//更新状态为检查中、更新文件检查开始时间、更新当前获取任务的用户
			RunMethod("PublicMethod","UpdateColValue","String@GetTaskUserID1@"+sUser+"@String@CheckDocStatus@2@String@checkbegintime@" + sToday + ",check_contract,String@contractserialno@" + sReturn4);
			alert("获取成功!");
			parent.reloadSelf();
		}else{
			alert("没有可以获取的任务!");
			return;
		}
	}
	
	function checkDoc(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //合同流水号
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//往ECM_IMAGE_OPINION插入数据
		RunJavaMethodSqlca("com.amarsoft.proj.action.InitCheckDocEcmImageOpinion","InitOpinion","objectNo="+sObjectNo+",objectType=Business");
		var param = "ObjectType=Business&ObjectNo="+sObjectNo;
		AsControl.OpenView("/Common/WorkFlow/ImageCheckList.jsp",param,"_blank","");
	}
	
	function updateDocOpinion(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //合同流水号
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var param = "ObjectType=Business&ObjectNo="+sObjectNo;
		AsControl.OpenView("/Common/WorkFlow/ImageCheckList.jsp",param,"_blank","");
	}
	function doSubmit(){
		var sToday = "<%=sToday%>";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //合同流水号
		var sSureType = getItemValue(0,getRow(),"SureType"); //合同来源
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//初审意见
		var sReturn0 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='3' ");
		var sReturn1 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='2' ");
		var sReturn11 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='1' ");
		//复审意见
		var sReturn20 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion2 ='3' ");
		var sReturn2 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion2 ='2' ");
		var sReturn21 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion2 ='1' ");
		//文件质量检查状态
		var sReturn3 = RunMethod("公用方法","GetColValue","CHECK_CONTRACT,CheckDocStatus,CONTRACTSERIALNO='"+sObjectNo+"' ");
		if(sReturn3 == "2"){//检查中
			//是否已填初审意见
			var sReturn = RunMethod("公用方法","GetColValueTables","ecm_page,ecm_image_opinion,count(*),ecm_page.typeno=ecm_image_opinion.typeno and ecm_page.objectno=ecm_image_opinion.objectno and ecm_image_opinion.objectno='"+sObjectNo+"' and ecm_page.objecttype='Business' and ecm_image_opinion.objecttype='Business' and ecm_image_opinion.opinion1 is null ");
			if(sReturn > 0){
				alert("还有文件未填写初审意见!");
				return false;
			}
			if(sReturn0 > 0){//有关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@3@String@CheckDocStatus@4@String@adddoctime@" + sToday + ",check_contract,String@contractserialno@" + sObjectNo);
			}else if(sReturn1 > 0){//有非关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@2@String@CheckDocStatus@4@String@adddoctime@" + sToday + ",check_contract,String@contractserialno@" + sObjectNo);
			}else if(sReturn1 == 0 && sReturn11 > 0){// 都合格
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@1@String@CheckDocStatus@3@String@adddoctime@" + sToday + ",check_contract,String@contractserialno@" + sObjectNo);
			}
			alert("提交成功!");
			parent.reloadSelf();
			//文件质量检查初审向PAD端发送通知消息
			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=1,sObjectNo="+sObjectNo+",sSureType="+sSureType);
		}else if(sReturn3 == "7"){//复审中
			//是否已填初审意见
			var sReturn31 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='2' and opinion2 is null ");
			if(sReturn31 > 0){
				alert("还有文件未填写复审意见!");
				return false;
			}
			if(sReturn20 > 0){//关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@3@String@CheckDocStatus@5@String@checkagainendtime@"+ sToday+",check_contract,String@contractserialno@" + sObjectNo);
			}else if(sReturn2 > 0){//有非关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@2@String@CheckDocStatus@5@String@checkagainendtime@"+ sToday+",check_contract,String@contractserialno@" + sObjectNo);
			}else if(sReturn2 == 0 && sReturn21 > 0){// 都合格
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@1@String@CheckDocStatus@3@String@checkagainendtime@"+ sToday+",check_contract,String@contractserialno@" + sObjectNo);
			}
			alert("提交成功!");
			parent.reloadSelf();
			//文件质量检查复审向PAD端发送通知消息
			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=2,sObjectNo="+sObjectNo+",sSureType="+sSureType);
		}else if(sReturn3 == "4"){//补充资料中
			//是否已填初审意见
			var sReturn32 = RunMethod("公用方法","GetColValueTables","ecm_page,ecm_image_opinion,count(*),ecm_page.typeno=ecm_image_opinion.typeno and ecm_page.objectno=ecm_image_opinion.objectno and ecm_image_opinion.objectno='"+sObjectNo+"' and ecm_page.objecttype='Business' and ecm_image_opinion.objecttype='Business' and ecm_image_opinion.opinion1 is null ");
			if(sReturn32 > 0){
				alert("还有文件未填写初审意见!");
				return false;
			}
			if(sReturn0 > 0){//有关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@3@String@CheckDocStatus@4,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!质量等级变更至关键错误!");
			}else if(sReturn1 > 0){//有非关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@2@String@CheckDocStatus@4,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!质量等级变更至非关键错误!");
			}else if(sReturn1 == 0 && sReturn11 > 0){// 都合格
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@1@String@CheckDocStatus@3,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!质量等级变更至合格");
			}
//			parent.reloadSelf();
			//文件质量检查复审向PAD端发送通知消息
//			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=2,sObjectNo="+sObjectNo);
		}else if(sReturn3 == "3"){//合格
			//是否已填初审意见
//			var sReturn31 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='2' and opinion2 is null ");
			var sCheckDocResult = RunMethod("公用方法","GetColValue","Check_Contract,checkDocResult,contractSerialNo='"+sObjectNo+"' ");
/* 			if(sReturn31 > 0){
				alert("还有文件未填写复审意见!");
				return false;
			} */
			if(sReturn0 > 0 && sCheckDocResult == "1"){
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@2@String@CheckDocStatus@4,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!初审合格变更至关键错误");
			}else if(sReturn1 > 0 && sCheckDocResult == "1"){
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@2@String@CheckDocStatus@4,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!初审合格变更至非关键错误");
			}else if(sReturn20 > 0 && sCheckDocResult != "1"){ //有关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@2@String@CheckDocStatus@5,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!复审合格变更至关键错误");
			}else if(sReturn2 > 0 && sCheckDocResult != "1"){ //有非关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@2@String@CheckDocStatus@5,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!复审合格变更至非关键错误");
			}else if(sReturn2 == 0 && sReturn21 > 0){// 都合格
				//RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@1@String@CheckDocStatus@3,check_contract,String@contractserialno@" + sObjectNo);
				alert("无变更!");
			}
//			parent.reloadSelf();
			//文件质量检查复审向PAD端发送通知消息
//			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=2,sObjectNo="+sObjectNo);
		}else if(sReturn3 == "5"){//非关键错误通过
			//是否已填初审意见
			var sReturn31 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='2' and opinion2 is null ");
			if(sReturn31 > 0){
				alert("还有文件未填写复审意见!");
				return false;
			}

			if(sReturn20 > 0){//有关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@3@String@CheckDocStatus@5,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!非关键错误通过变更至关键错误!");
			}else if(sReturn2 > 0){//有非关键错误
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@2@String@CheckDocStatus@5,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!非关键错误通过变更至非关键错误!");
			}else if(sReturn2 == 0 && sReturn21 > 0){// 都合格
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@1@String@CheckDocStatus@3,check_contract,String@contractserialno@" + sObjectNo);
				alert("提交成功!非关键错误通过变更至合格通过");
			}
//			parent.reloadSelf();
			//文件质量检查复审向PAD端发送通知消息
//			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=2,sObjectNo="+sObjectNo);
		}
	}
	
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	//initRow();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>