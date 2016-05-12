<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  yongxu 2015/05/28
		Tester:
		Content: 贷后资料检查
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后资料检查"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sToday = StringFunction.getTodayNow();//系统时间
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
	<%@include file="/Common/WorkFlow/PutOutApply/CheckImageList.jsp"%>	
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
		var sReturn3 = RunMethod("公用方法","GetColValueTables","BUSINESS_CONTRACT,check_contract,count(1),BUSINESS_CONTRACT.serialno=check_contract.contractSerialNo and (check_contract.checkstatus = '4'  and check_contract.checkimageuserid='"+sUser+"' or check_contract.checkstatus = '7'  and check_contract.checkimageuserid2='"+sUser+"') and BUSINESS_CONTRACT.contractstatus = '050' ");
		if(sReturn3 > 0){
			alert("当前有未处理的任务!");
			return;
		}
		//合同号
		var sReturn4 = RunMethod("公用方法","GetColValueTables","BUSINESS_CONTRACT,check_contract,SerialNo,BUSINESS_CONTRACT.serialno=Check_Contract.contractserialno and (BUSINESS_CONTRACT.suretype = 'APP' or BUSINESS_CONTRACT.suretype = 'FC') and BUSINESS_CONTRACT.contractstatus = '050' and check_contract.uploadFlag = '1' and (check_contract.checkstatus = '2' or check_contract.checkstatus = '6') ");
		//贷后资料上传状态
		var sReturn5 = RunMethod("公用方法","GetColValue","check_contract,uploadFlag,ContractSerialNo='"+sReturn4+"' ");
		//贷后资料检查状态
		var sReturn2 = RunMethod("公用方法","GetColValue","check_contract,checkstatus,ContractSerialNo='"+sReturn4+"' ");
		if(sReturn2 == "2" && sReturn5 == "1"){// 注册完成并且已上传贷后资料
			//更新状态为检查中
			RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,4,ContractSerialNo='"+sReturn4+"' ");
			//更新复审开始时间
//			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkagainbegintime,"+sToday+",PassTime = '"+sReturn1+"'");
			//更新第一次获取任务时间
			RunMethod("公用方法","UpdateColValue","check_contract,getLoanTaskTime,"+sToday+",ContractSerialNo = '"+sReturn4+"'");
			//更新当前获取任务的用户
			RunMethod("公用方法","UpdateColValue","check_contract,checkImageUserID,"+sUser+",ContractSerialNo = '"+sReturn4+"'");
			alert("获取成功!");
			parent.reloadSelf();
		}else if(sReturn2 == "6" && sReturn5 == "1"){// 补充贷后资料完成
			//更新状态为检查中
			RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,7,ContractSerialNo='"+sReturn4+"' ");
			//更新复审开始时间
//			RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkagainbegintime,"+sToday+",PassTime = '"+sReturn1+"'");
			//更新当前获取任务的用户
			RunMethod("公用方法","UpdateColValue","check_contract,checkImageUserID2,"+sUser+",ContractSerialNo = '"+sReturn4+"'");
			//更新第一次获取任务时间
			RunMethod("公用方法","UpdateColValue","check_contract,getLoanTaskTime2,"+sToday+",ContractSerialNo = '"+sReturn4+"'");
			alert("获取成功!");
			parent.reloadSelf();
		}else{
			alert("没有可以获取的任务!");
			return;
		}
	}
	
	function doSubmit(){
		var sToday = "<%=sToday%>";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //合同流水号
		var sSureType = getItemValue(0,getRow(),"SureType"); //合同来源
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//贷后资料总条数
//		var sReturn = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' ");
		//初审未填写意见条数
//		var sReturn4 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 is null ");
		//初审合格条数
//		var sReturn1 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='1' ");
		//初审关键错误条数
		var sReturn23 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='3' ");
		//初审非关键错误条数
		var sReturn22 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='2'  ");
		//复审未填写意见条数
//		var sReturn5 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 is null ");
		//复审关键错误条数
		var sReturn63 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 ='3' ");
		//复审非关键错误条数
		var sReturn62 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 ='2'  ");

		//上传过贷后资料但是未签署初审意见的记录条数
		var sNoSigned1 = RunMethod("公用方法","GetColValueTables","ecm_page,ecm_image_opinion,count(1),ecm_image_opinion.typeno = ecm_page.typeno and ecm_image_opinion.objectno = ecm_page.objectno and ecm_image_opinion.objecttype = ecm_page.objecttype and ecm_image_opinion.objecttype = 'BusinessLoan' and ecm_image_opinion.objectno = '"+sObjectNo+"' and ecm_image_opinion.checkopinion1 is null ");
		//var sNoSigned2 = RunMethod("公用方法","GetColValueTables","ecm_page,ecm_image_opinion,count(1),ecm_image_opinion.typeno = ecm_page.typeno and ecm_image_opinion.objectno = ecm_page.objectno and ecm_image_opinion.objecttype = ecm_page.objecttype and ecm_image_opinion.objecttype = 'BusinessLoan' and ecm_image_opinion.objectno = '"+sObjectNo+"' and ecm_image_opinion.checkopinion2 is null ");
		var sNoSigned2 = RunMethod("公用方法","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 <>'1' and checkopinion2 is null ");
		//检查状态
		var sReturn3 = RunMethod("公用方法","GetColValue","check_contract,CHECKSTATUS,ContractSerialNo='"+sObjectNo+"' ");
		if(sReturn3 == "4"){//第一次检查
		/* 	if(sReturn4==sReturn){
				alert("未填写意见！");
				return false;
			} */
			if(sNoSigned1 > 0){
				alert("还有文件未填写初审意见！");
				return false;
			}
			if(sReturn23 > 0){//有关键错误
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//补充资料
				RunMethod("公用方法","UpdateColValue","check_contract,checkresult,3,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为关键错误
			}else if(sReturn22 > 0){//有非关键错误
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//补充资料
				RunMethod("公用方法","UpdateColValue","check_contract,checkresult,2,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为非关键错误
			}else{// 都合格
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//检查通过
				RunMethod("公用方法","UpdateColValue","check_contract,checkresult,1,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为合格
			}
			alert("提交成功!");
			parent.reloadSelf();
			RunMethod("公用方法","UpdateColValue","check_contract,verifyLoanTime,"+sToday+",ContractSerialNo = '"+sObjectNo+"'");
			//贷后资料检查初审向PAD端发送通知消息
			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=3,sObjectNo="+sObjectNo+",sSureType="+sSureType);
		}else if(sReturn3 == "7"){//第二次检查
			if(sNoSigned2 > 0){
				alert("还有文件未填写复审意见！");
				return false;
			}
			if(sReturn63 > 0){//有关键错误
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//复审也不通过，结束
				RunMethod("公用方法","UpdateColValue","check_contract,CHECKRESULT2,3,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为关键错误
			}else if(sReturn62 > 0){//有非关键错误
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//复审也不通过，结束
				RunMethod("公用方法","UpdateColValue","check_contract,CHECKRESULT2,2,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为非关键错误
			}else{// 都合格
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//检查通过
				RunMethod("公用方法","UpdateColValue","check_contract,CHECKRESULT2,1,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为合格
			}
			alert("提交成功!");
			parent.reloadSelf();
			RunMethod("公用方法","UpdateColValue","check_contract,verifyLoanTime2,"+sToday+",ContractSerialNo = '"+sObjectNo+"'");
			//贷后资料检查复审向PAD端发送通知消息
			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=4,sObjectNo="+sObjectNo+",sSureType="+sSureType);
		}else if(sReturn3 == "5"){//补充资料中，管理员可以修改贷后资料检查的质量标注
			if(sNoSigned1 > 0){
				alert("还有文件未填写初审意见！");
				return false;
			}
			if(sReturn23 > 0){//有关键错误
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//补充资料
				RunMethod("公用方法","UpdateColValue","check_contract,checkresult,3,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为关键错误
				alert("提交成功!贷后资料质量等级初审变更至关键错误");
			}else if(sReturn22 > 0){//有非关键错误
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//补充资料
				RunMethod("公用方法","UpdateColValue","check_contract,checkresult,2,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为非关键错误
				alert("提交成功!贷后资料质量等级初审变更至非关键错误");
			}else{// 都合格
				RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//检查通过
				RunMethod("公用方法","UpdateColValue","check_contract,checkresult,1,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为合格
				alert("提交成功!贷后资料质量初审等级变更至合格");
			}
//			parent.reloadSelf();
		}else if(sReturn3 == "1"){//合格，管理员可以修改贷后资料检查的质量标注
			if(sCheckResult=="1" && sNoSigned1 > 0){
				alert("还有文件未填写初审意见！");
				return false;
			}
		
			var sCheckResult = RunMethod("公用方法","GetColValue","Check_Contract,checkResult,ContractSerialNo='"+sObjectNo+"'  ");
			if(sCheckResult=="1"){
				if(sReturn23 > 0){//有关键错误
					RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//补充资料
					RunMethod("公用方法","UpdateColValue","check_contract,checkresult,3,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为关键错误
					alert("提交成功!贷后资料质量等级初审变更至关键错误");
				}else if(sReturn22 > 0){ //有非关键错误
					RunMethod("公用方法","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//补充资料
					RunMethod("公用方法","UpdateColValue","check_contract,checkresult,2,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为非关键错误
					alert("提交成功!贷后资料质量等级初审变更至非关键错误");
				}else{
					RunMethod("公用方法","UpdateColValue","check_contract,checkresult,1,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为合格
					alert("提交成功!贷后资料质量等级初审变更至合格");
				}
			}else {
				if(sReturn63 > 0){//有关键错误
					RunMethod("公用方法","UpdateColValue","check_contract,checkresult2,3,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为关键错误
					alert("提交成功!贷后资料质量等级复审变更至关键错误");
				}else if(sReturn62 > 0){ //有非关键错误
					RunMethod("公用方法","UpdateColValue","check_contract,checkresult2,2,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为非关键错误
					alert("提交成功!贷后资料质量等级复审变更至非关键错误");
				}else{
					RunMethod("公用方法","UpdateColValue","check_contract,checkresult2,1,ContractSerialNo='"+sObjectNo+"' ");//更新合同状态为合格
					alert("提交成功!贷后资料质量等级复审变更至合格");
				}
			}
//			parent.reloadSelf();
		}
		
	}
	function checkImage(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //合同流水号
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//更新状态为已检查
//		RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,serialno = '"+sObjectNo+"'");
//	     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo+"&uploadPeriod=1";
//	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" ); 
		//往ECM_IMAGE_OPINION插入数据
		RunJavaMethodSqlca("com.amarsoft.proj.action.InitCheckDocEcmImageOpinion","InitOpinionAfterLoan","objectNo="+sObjectNo+",objectType=BusinessLoan");
		var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo+"&OperateMode=view";
		AsControl.OpenView("/ImageManage/ImageAfterLoanCheckList.jsp",param,"_blank","");
//	     parent.reloadSelf();
	}
	
	function updateDocOpinion(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //合同流水号
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo+"&OperateMode=view";
		AsControl.OpenView("/ImageManage/ImageAfterLoanCheckList.jsp",param,"_blank","");
	}
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab(){
		//获得申请类型、申请流水号
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=Business&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		//reloadSelf(); //update CCS-499 贷款申请菜单下合同状态列表数据超过一页的，查看某页合同的申请详情关闭后跳到了第一页  by rqiao 20150331
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