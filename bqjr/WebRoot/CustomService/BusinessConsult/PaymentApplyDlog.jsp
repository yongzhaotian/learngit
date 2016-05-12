<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Describe: 提前还款查询页面
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "提前还款查询页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));//身份证号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//合同号

	
	String BusinessDate=SystemConfig.getBusinessDate();
	if (sCertID==null) sCertID="";
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		String sHeaders[][] = { 
								{"CertID","客户身份证号"},
								{"ContractSerialno","合同号"},
								{"YesNo","是否收取提前还款手续费"},
								{"ScheduleDate","计划提前还款日期"},
								{"payDate","提前还款可行日期"},
								{"payAmt","总金额"}
								
							}; 

		  String sSql ="select '' as CertID,'' as ContractSerialno,'' as YesNo,'' as ScheduleDate,'' as payDate,'' as payAmt from SYSTEM_SETUP where 1=2";
		//设置DataObject				
		 ASDataObject doTemp = new ASDataObject(sSql);
		 doTemp.setHeader(sHeaders);
		
		doTemp.setReadOnly("CertID,ContractSerialno,payDate,payAmt", true);
		doTemp.setRequired("ContractSerialno,payDate,YesNo,ScheduleDate,payAmt", true);
		doTemp.setCheckFormat("ScheduleDate","3");
		doTemp.setAlign("ScheduleDate","1");
		doTemp.setHTMLStyle("ScheduleDate"," style={width:130px} onChange=\"javascript:parent.QueryPaymentConsult()\"");
		doTemp.setHTMLStyle("YesNo"," onClick=\"javascript:parent.SelectYesNo()\"");
		doTemp.setDDDWCode("YesNo", "YesNo");
		doTemp.setEditStyle("YesNo", "2");
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置为可写
		
		//生成datawindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","提前还款申请保存","提前还款申请保存","PrePaymentApply()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=选择是否收取提前还款手续费;InputParam=后续事件;OutPutParam=无;]~*/
	function SelectYesNo()
	{	
		setItemValue(0,getRow(),"ScheduleDate","");	
		setItemValue(0,getRow(),"payDate","");
		setItemValue(0,getRow(),"payAmt","");
		AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","","rightdown","");
		return;
	}	

	/*~[Describe=提前还款咨询;InputParam=后续事件;OutPutParam=无;]~*/
	var Flag = true;
	function QueryPaymentConsult()
	{	
		//if(!vI_all("myiframe0")) return;
		var sScheduleDate=getItemValue(0,getRow(),"ScheduleDate");
		var sContractSerialNo=getItemValue(0,getRow(),"ContractSerialno");
		var sYesNo=getItemValue(0,getRow(),"YesNo");
		if (typeof(sYesNo)=="undefined" || sYesNo.length==0){
			alert("请先选择是否收取提前还款手续费。。");
			AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","","rightdown","");
			return;
		}
		
		if("<%=BusinessDate%>">sScheduleDate){
			alert("申请日期不能小于当前系统日期");
			setItemValue(0,getRow(),"payDate","");
			setItemValue(0,getRow(),"payAmt","");
			AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","","rightdown","");
			return;
		}
		
		//获取提前还款可行日期与应还总金额
		var sReturn= RunMethod("BusinessManage","BusinessPayDateAmt",sContractSerialNo+","+sScheduleDate+","+sYesNo);
		var str=sReturn.split(",");
		
		setItemValue(0,getRow(),"payDate",str[0]);
		setItemValue(0,getRow(),"payAmt",str[1]);
		Flag = str[2];
		
		var transactionSerialNo = "";
		var transactionCode ="0055";
		var PrePrepayFeeAmt = str[3];
		var sYesNo=getItemValue(0,getRow(),"YesNo");
		sCompID = "CreditTab";
		sCompURL = "/CustomService/BusinessConsult/paymentLoanTrans.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&"+"&PayDate="+str[0]+"&"+"&ScheduleDate="+sScheduleDate+"&Flag=010&"+"&PrePrepayFeeAmt="+PrePrepayFeeAmt+"&ContractSerialNo="+sContractSerialNo+"&YesNo="+sYesNo;
		AsControl.OpenView(sCompURL,sParamString,"rightdown","");
	}	
	
	
	<%/*~[Describe=提前还款申请;] added by tbzeng 2014/02/19~*/%>
	function PrePaymentApply() {
		if(!vI_all("myiframe0")) return;
		if(!confirm("是否确认提前还款申请,确认将可能产生相应费用！")) return;
		var sPayDate=getItemValue(0,getRow(),"payDate");
		var sScheduleDate=getItemValue(0,getRow(),"ScheduleDate");
		var sYesNo=getItemValue(0,getRow(),"YesNo");
		
		//获得业务流水号
		sSerialNo ="<%=sSerialNo%>";	
		var transactionDate="";
		var transactionCode ="0055";
		
		var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
		var relativeObjectType = "jbo.app.ACCT_LOAN";
		var relativeObjectNo = sLoanSerialno;
		
		//CCS-953 提前还款、退货、费用减免相互判断是否有交易进行中
		var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			return;
		}//CCS-953 end
		
		var allowApplyFlag = RunMethod("LoanAccount","GetTransAllowApplyFlag",transactionCode+","+relativeObjectType+","+relativeObjectNo);
		
		if(allowApplyFlag != "true")
		{
		
			RunMethod("LoanAccount","DeleteAcctTransPayment",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			RunMethod("LoanAccount","DeleteAcctTransaction",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			RunMethod("LoanAccount","DeleteAcctPaymentSchedule",relativeObjectNo+","+relativeObjectType);
			RunMethod("LoanAccount","DeletePrepayFee",relativeObjectNo+","+relativeObjectType);
			
		}
		//modify end
		var objectType="TransactionApply";
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
		if(returnValue.substring(0,5) != "true@") {
			alert("创建交易失败！错误原因-"+returnValue);
			return;
		}
		returnValue = returnValue.split("@");
		var transactionSerialNo = returnValue[1];
		if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
			alert("创建交易失败！错误原因-"+returnValue);
			return;
		}
		RunMethod("BusinessManage","DeleteFlowObject",transactionSerialNo);
		RunMethod("BusinessManage","DeleteFlowTask",transactionSerialNo);
		/* //生成提前还款手续费还款记录
		if(Flag=="true" && sYesNo=="1")
		RunMethod("BusinessManage","BusinessPrepayAmt",sSerialNo+","+sPayDate); */
		
		//RunMethod("BusinessManage","UpdateTransPayment",transactionSerialNo+","+sPayDate+","+sPayAmt);
		var PrePrepayFeeAmt = "";
		if(Flag=="true" && sYesNo=="1"){
			var sparas = "sContractSerialNo="+sSerialNo;//+",periods="+Periods+",businessSum="+sBusinessSum+",ObjectNo="+sObjectNo+",CarStatus="+CarStatus
			var sReturnValuef = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PrePrepayFeeAmt", "runTransaction",sparas);
			PrePrepayFeeAmt = sReturnValuef;
		}else{
			PrePrepayFeeAmt = "0.00";
		}
		
		sCompID = "CreditTab";
		sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&"+"&PayDate="+sPayDate+"&"+"&ScheduleDate="+sScheduleDate+"&Flag=010&"+"&PrePrepayFeeAmt="+PrePrepayFeeAmt+"&ContractSerialNo="+sSerialNo+"&YesNo="+sYesNo;
		//OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		AsControl.OpenView(sCompURL,sParamString,"rightdown","");
		//reloadSelf();
		//self.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
		}
		setItemValue(0,getRow(),"ContractSerialno","<%=sSerialNo%>");
		setItemValue(0,getRow(),"CertID","<%=sCertID%>");
    }
	
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
