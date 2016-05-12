<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 合同信息快速查询
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;合同信息快速查询&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	//获得组件参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//利用sSql生成数据对象

	String sTempletNo = "ContractQueryList1"; //模版编号
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setKeyFilter("SerialNo");
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","代扣账号变更","代扣账号变更","withholdChange()",sResourcesPath},
			{"true","","Button","发起再次代扣","发起再次代扣","",sResourcesPath},
			{"true","","Button","退款查询","查询退款查询信息","RefundFind()",sResourcesPath},
			{"true","","Button","贷款结清证明申请","贷款结清证明申请","CreditSettle()",sResourcesPath},
			{"true","","Button","保险取消申请","保险取消申请","insureCancel()",sResourcesPath},
			{"true","","Button","保险金申请","保险金申请","insureApply()",sResourcesPath},
			{"true","","Button","电子合同调阅","电子合同调阅","viewApplyReport()",sResourcesPath},
			{"true","","Button","影像合同调阅","影像合同调阅","imageManage()",sResourcesPath},
			{"true","","Button","提前还款查询","查询提前还款信息","SelectPrepayment()",sResourcesPath},
			{"true","","Button","退款申请","退款申请","returnAmtApply()",sResourcesPath},
			{"true","","Button","确认退款","确认退款","affirm('0110','退款交易')",sResourcesPath},
			{"true","","Button","手工录入还款","手工录入还款","PayManualRecord()",sResourcesPath},
			{"true","","Button","确认手工录入还款","确认手工录入还款","affirm('0050','手工录入还款')",sResourcesPath},
			{"true","","Button","还款日变更","还款日变更申请","LoanAfterChange()",sResourcesPath},
			{"true","","Button","确认还款日变更","确认还款日变更","affirm('2012','还款日变更交易')",sResourcesPath},
			{"true","","Button","还款方式变更","还款方式变更申请","PaymentMethodChange()",sResourcesPath},
			{"true","","Button","确认还款方式变更","确认还款方式变更","affirm('2011','还款方式变更交易')",sResourcesPath},
			//{"true","","Button","退货申请","退货申请","returnApply()",sResourcesPath},
			//{"true","","Button","费用减免","费用减免申请","feeWaive()",sResourcesPath},
			{"true","","Button","新增事件","新增事件费用","newFeeEvent()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sExchangeType = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//检查出帐通知单是否已经生成
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //未生成出帐通知单
			//生成出帐通知单	
			PopPage("/FormatDoc/Report13/7001.jsp?DocID=7001&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//获得加密后的出帐流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
		
	}
 
    //退款查询
    function RefundFind(){
    	//申请编号
    	sSerialNo =getItemValue(0,getRow(),"SerialNo");
    	//合同标识
    	sCreditAttribute =getItemValue(0,getRow(),"CreditAttribute");
    	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		sCompID = "RefundApplyList";
		sCompURL = "/InfoManage/QuickSearch/RefundApplyList.jsp";
		sReturn = popComp(sCompID,sCompURL,"SerialNo="+sSerialNo+"&CreditAttribute="+sCreditAttribute,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    //代扣账号变更
    function withholdChange(){
    	//申请编号
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//客户名称
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	//身份证号
    	sCertID = getItemValue(0,getRow(),"CertID");
    	//手机号
    	sMobileTelephone = getItemValue(0,getRow(),"MobileTelephone");
    	//代扣账户户名
    	sReplaceName = getItemValue(0,getRow(),"ReplaceName");
    	//代扣账号
    	sReplaceAccount = getItemValue(0,getRow(),"ReplaceAccount");
    	//代扣账户开户行
    	sOpenBank = getItemValue(0,getRow(),"OpenBank");
    	
    	//alert("---11111--"+sSerialNo+"-----"+sCustomerName+"---"+sCertID+"----"+sMobileTelephone+"-----"+sReplaceName+"-----"+sReplaceAccount+"-----"+sOpenBank);
    	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		sCompID = "ChargeApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&CertID="+sCertID+"&MobileTelephone="+sMobileTelephone+"&ReplaceName="+sReplaceName+"&ReplaceAccount="+sReplaceAccount+"&OpenBank="+sOpenBank;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    
    }
    
    //保险取消申请
    function insureCancel(){
    	//申请编号
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//客户名称
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	//客户编号
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");
    	//身份证号
    	sCertID = getItemValue(0,getRow(),"CertID");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		sCompID = "InsureCancelApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/InsureCancelApplyInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&CustomerID="+sCustomerID+"&CertID="+sCertID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=500px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    //保险金申请
    function insureApply(){
    	//申请编号
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//客户名称
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	//客户编号
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");
    	//身份证号
    	sCertID = getItemValue(0,getRow(),"CertID");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		sCompID = "InsureApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/InsureApplyInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&CustomerID="+sCustomerID+"&CertID="+sCertID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=500px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    /*~[Describe= 查看电子合同;InputParam=无;OutPutParam=无;]~*/
    function viewApplyReport(){
    	//申请编号
    	var sObjectNO = getItemValue(0,getRow(),"SerialNo");
    	var sObjectType = getItemValue(0,getRow(),"BusinessType");
    	if (typeof(sObjectNO)=="undefined" || sObjectNO.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			var sSerialno = RunMethod("BusinessManage","getApplyReport",sObjectNO+","+sObjectType);
			if(typeof(sSerialno)=="undefined" || sSerialno.length==0 || sSerialno == "Null") {
				alert("电子合同未生成！");
				return;
			} 	
			OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+sSerialno,"_blank",OpenStyle);
		}
    	
    }
    
    /*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
     var param = "ObjectType=Business&ObjectNo="+sObjectNo+"&RightType=100";
     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
    }
    
    /*~[Describe=提前还款查询;InputParam=无;OutPutParam=SerialNo;]~*/
	function SelectPrepayment()
	{
		//获取合同号，身份证号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCertID =getItemValue(0,getRow(),"CertID");	
		alert(sSerialNo);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同还未放款,请放款之后在做该操作");
				return;
			}
			AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyDlog.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank","dialogWidth=650px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyDlog.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank",OpenStyle);
		}

	}
    
	/*~[Describe=贷后变更与交易确认;InputParam=无;OutPutParam=SerialNo;]~*/
	function affirm(transactionCode,messageError)
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		var transactionSerialNo=RunMethod("BusinessManage","TransactionSerialno",transactionCode+","+sSerialNo);
		if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
			alert("该合同项下暂无未生效的"+messageError);
			return;
		}else{
			//还款日变更与还款方式变更校验
			if (transactionCode=='2011' || transactionCode=='2012'){
				var sReturn=RunMethod("BusinessManage","getCheckReturn",transactionSerialNo);
				if(sReturn!='true'){
					alert("该合同项下暂无未生效的"+messageError);
					return;
				}
			}
			
			//手工录入还款和退款校验
			if (transactionCode=='0050' || transactionCode=='0110'){
				var sReturn=RunMethod("BusinessManage","getPayCheckReturn",transactionSerialNo);
				if(sReturn!='true'){
					alert("该合同项下暂无未生效的"+messageError);
					return;
				}
			}
			
			if(confirm("请确认是否进行生效处理！"))
			{
				var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
				if(typeof(returnValue)=="undefined"||returnValue.length==0){
					alert("系统处理异常！");
					return;
				}
				var message=returnValue.split("@")[1];
				alert(message);
				reloadSelf();
			}			
		}
	}	
	
	/*~[Describe= 新增费用事件;InputParam=无;OutPutParam=SerialNo;]~*/
	function newFeeEvent()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同还未放款,请放款之后在做该操作");
				return;
			}
			
			var sReturn=RunMethod("BusinessManage","SelectCarLoan",sSerialNo);
			if(sReturn==0){
				alert("该笔合同不是汽车贷，不能做该操作");
				return;
			}
			popComp("PaymentDateChange","/BusinessManage/QueryManage/BusinessFeeEvent.jsp","SerialNo="+sSerialNo,"dialogWidth=600px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}

	}	
	
	
	/*~[Describe= 手工录入还款;InputParam=无;OutPutParam=SerialNo;]~*/
	function PayManualRecord()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{	
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同还未放款,请放款之后在做该操作");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="0050";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
				

			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
				
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= 费用减免申请;InputParam=无;OutPutParam=SerialNo;]~*/
	function feeWaive()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCustomerName=getItemValue(0,getRow(),"CustomerName");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
		var s=setObjectValue("SelectFeeWaive","serialno,"+sLoanSerialno,"@"+sOrgID+"@0@"+sOrgName+"@1",0,0,"");
		
	}
	
	/*~[Describe= 退货流程;InputParam=无;OutPutParam=SerialNo;]~*/
	function returnApply()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			//是否消费贷
		   /*  var sResult=RunMethod("BusinessManage","LoanProductType",sSerialNo);
			if(sResult==0){
				alert("该笔合同不是消费贷产品，不能做退货操作");
				return;
			} 
			
			//是否在犹豫期内
			var sReturn=RunMethod("BusinessManage","HesitateDay",sSerialNo);
			if(sReturn==0){
				alert("该笔合同已超过犹豫期限,不能做退货操作");
				return;
			}  
			 */
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同还未放款,请放款之后在做该操作");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="0052";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
				

			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
					
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= 还款日变更;InputParam=无;OutPutParam=SerialNo;]~*/
	function LoanAfterChange()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同还未放款,请放款之后在做该操作");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="2012";
			
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;

			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
				
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= 还款方式变更;InputParam=无;OutPutParam=SerialNo;]~*/
	function PaymentMethodChange()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同还未放款,请放款之后在做该操作");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="2011";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
			
			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
				
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= 退款;InputParam=无;OutPutParam=SerialNo;]~*/
	function returnAmtApply()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同还未放款,请放款之后在做该操作");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="0110";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
				
			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
				
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
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