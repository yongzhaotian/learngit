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
	String PG_TITLE = "合同状态查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;合同状态查询&nbsp;&nbsp;";
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

	String sTempletNo = "ContractQueryList2"; //模版编号
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	/**update tangyb 20150430 销售代表录单界面合同状态查询增加查询条件，优化查询界面  start**/
	doTemp.setKeyFilter("bu.SerialNo"); //主键 SerialNo ==> bu.SerialNo
	//设置申请时间为日历控件
	doTemp.setCheckFormat("inputdate", "3");
	
	Map<String, String> roleClauseMap = new HashMap<String, String>();
	//门店表中城市经理不维护，从销售经理的上级取。 edit by Dahl 2015-3-20
	//roleClauseMap.put("1003", " stores in (SELECT SNO FROM STORE_INFO SI, WHERE CITYMANAGER IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	//roleClauseMap.put("1003", " stores in (SELECT sno FROM store_info si ,user_info ui WHERE si.salesmanager=ui.userId AND ui.superid IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	roleClauseMap.put("1003", " bu.stores in (SELECT sno FROM store_info si ,user_info ui WHERE si.salesmanager=ui.userId AND ui.superid IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	//roleClauseMap.put("1004", " stores in (select sno from store_info where citymanager='"+CurUser.getUserID()+"') ");
	//roleClauseMap.put("1004", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1004", " bu.stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+CurUser.getUserID()+"') ");
	//roleClauseMap.put("1005", " stores in (select sno from store_info where salesmanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1005", " bu.stores in (select sno from store_info where salesmanager='"+CurUser.getUserID()+"') ");
	//roleClauseMap.put("1006", " SALESEXECUTIVE='"+ CurUser.getUserID() +"' ");
	roleClauseMap.put("1006", " bu.SALESEXECUTIVE='"+ CurUser.getUserID() +"' ");
	/**update tangyb 20150430 销售代表录单界面合同状态查询增加查询条件，优化查询界面  end**/
	List roleList = CurUser.getRoleTable();
	String sRoleWhereClause = "";
	boolean isBaimingdan = false;
	for (int i=0; i<roleList.size(); i++) {
		String sAndOr = "".equals(sRoleWhereClause)? " and ( ": " or ";
		if (roleClauseMap.containsKey(roleList.get(i))) {
			sRoleWhereClause += sAndOr + roleClauseMap.get(roleList.get(i));
		}
		if("1005".equals(roleList.get(i))){
			isBaimingdan = true;
		}
	}
	if(isBaimingdan){
		doTemp.WhereClause +=   " and (bu.isbaimingdan <> '1' or bu.isbaimingdan is null) ";
	}
	
	if (!"".equals(sRoleWhereClause)) {
		doTemp.WhereClause += sRoleWhereClause + ")";
	}
	
	//生成查询框
	doTemp.setDDDWSql("contractStatus", "select itemno,itemname from code_library where codeno='ContractStatus' and itemno in ('010','020','050','060','070','080','090','100','110','160','210') and IsInUse = '1' ");
	doTemp.setFilter(Sqlca, "0011", "contractStatus", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0020", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0050", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0070", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0080", "CertID", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0100", "SNO", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0060", "inputdate", "Operators=EqualsString,BeginsWith;");
	//doTemp.generateFilters(Sqlca);
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
			/**add tangyb 20150430 添加“详情”页面按钮 start**/
			{"true","","Button","合同详情","合同详情","detailButtOnclick()",sResourcesPath},
			/**add tangyb 20150430 添加“详情”页面按钮 end**/
			
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","代扣账号变更","代扣账号变更","withholdChange()",sResourcesPath},
			//{((CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","发起再次代扣","发起再次代扣","",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","退款查询","查询退款查询信息","RefundFind()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","贷款结清证明申请","贷款结清证明申请","CreditSettle()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","保险取消申请","保险取消申请","insureCancel()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","保险金申请","保险金申请","insureApply()",sResourcesPath},
			//{"true","","Button","电子合同调阅","电子合同调阅","viewApplyReport()",sResourcesPath},
			//{"true","","Button","第三方协议调阅","第三方协议调阅","creatThirdTable()",sResourcesPath},
			//{"true","","Button","影像合同调阅","影像合同调阅","imageManage()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","提前还款查询","查询提前还款信息","SelectPrepayment()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036"))?"true":"false"),"","Button","手工录入还款","手工录入还款","PayManualRecord()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036"))?"true":"false"),"","Button","确认手工录入还款","确认手工录入还款","affirm('0050','手工录入还款')",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036"))?"true":"false"),"","Button","还款日变更","还款日变更申请","LoanAfterChange()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036"))?"true":"false"),"","Button","确认还款日变更","确认还款日变更","affirm('2012','还款日变更交易')",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","还款方式变更","还款方式变更申请","PaymentMethodChange()",sResourcesPath},
			//{"true","","Button","确认还款方式变更","确认还款方式变更","affirm('2011','还款方式变更交易')",sResourcesPath},
			//{"true","","Button","退货申请","退货申请","returnApply()",sResourcesPath},
			//{"true","","Button","费用减免","费用减免申请","feeWaive()",sResourcesPath},
			//{"true","","Button","新增事件","新增事件费用","newFeeEvent()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","打印还款小贴士","打印还款小贴士","printRemind()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","打印批复函","打印批复函","printApprove()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=打印第三方;InputParam=无;OutPutParam=无;]~*/
	function creatThirdTable(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		var sObjectType = "ThirdSettle";
		//var sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		var xx = RunMethod("PublicMethod","GetColValue","TempSaveFlag,business_contract,String@SerialNo@"+sObjectNo);
		var sTempSaveFlag = xx.split("@")[1];
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
	    var sProductID =getItemValue(0,getRow(),"ProductID");
		 if(null == sProductID) sProductID = "";
		var sCTempSaveFlag = RunMethod("BusinessManage","TempSaveFlag",sCustomerID);
		 if (typeof(sTempSaveFlag)=="undefined" || sTempSaveFlag.length==0 || sTempSaveFlag == "1" || typeof(sCTempSaveFlag)=="undefined" || sCTempSaveFlag.length==0 || sCTempSaveFlag == "1"){
			alert("客户或申请信息未保存，请保c存信息后再打印申请表！");
			return;
		}else{ 
			//检查出帐通知单是否已经生成
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //未生成出帐通知单
				if(sProductID=='020'){
					PopPage("/FormatDoc/CashLoanReport/04.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
				}else{
				//生成出帐通知单	
					PopPage("/FormatDoc/Report17/04.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
				}
				}
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}
	}

	/*~[Describe=查看合同详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function detailButtOnclick()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
    		sCompURL = "/Common/WorkFlow/ContractDetailInfo.jsp";
    		sParamString = "ObjectNo="+sSerialNo;
    		
    		var left = (window.screen.availWidth-800)/2;
    		var top = (window.screen.availHeight-400)/2;
    		var features ='left='+left+',top='+top+',width=800,height=400';
    		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
    		
    		AsControl.PopPage(sCompURL,sParamString,style);
		}

	}
	
	
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
		sContractStatus = getItemValue(0,getRow(),"ContractStatus");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(sContractStatus!='160'){
			alert("该笔合同未结清！");
			return;
		} 
		sCompID = "CreditSettleApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/CreditSettleApplyInfo.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sObjectNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
	}
 
    //退款查询
    function RefundFind(){
    	//申请编号
    	sCustomerID =getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
    	var sReturn=RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
		if(sReturn<=0 || sReturn=="Null"){
			alert("该客户项下没预存款,不能退款");
			return;
		}		
		
		sCompID = "RefundApplyList";
		sCompURL = "/InfoManage/QuickSearch/RefundApplyList.jsp";
		popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    //代扣账号变更
    function withholdChange(){
    	//申请编号
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//客户名称
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户号
    	//身份证号
    	sCertID = getItemValue(0,getRow(),"CertID");
    	//手机号
    	sMobilePhone = getItemValue(0,getRow(),"MobilePhone");
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
		}else if (confirm("确认已经收到客户授权的更改或新增代扣账户授权书？"))
    	{			
			 var count = RunMethod("BusinessManage","CheckChangeBusiness",sSerialNo);
			if(count > 0){
				alert("当前客户合同已有在途的代扣账户变更审批，不能再次发起变更申请！");
				return;
			}else{
				sReturn = RunMethod("BusinessManage","InsertChangeInfo",sSerialNo+","+sMobilePhone);
				if( sReturn == "success"){
					alert("变更申请已发起，请到客户信息查询中进行代扣账户变更审批！");
				}
			}		 
		} 
		/*  sCompID = "ChargeApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&CustomerID="+sCustomerID+"&CustomerName="+sCustomerName+"&CertID="+sCertID+"&MobileTelephone="+sMobileTelephone+"&ReplaceName="+sReplaceName+"&ReplaceAccount="+sReplaceAccount+"&OpenBank="+sOpenBank;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
     */
     
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
    	var sObjectNo = getItemValue(0,getRow(),"SerialNo");
    	var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
    	//var sObjectType = getItemValue(0,getRow(),"ProductID");
    	var sObjectType = "ApplySettle";
    	
    	/*if (typeof(sObjectNO)=="undefined" || sObjectNO.length==0)
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
		}*/

    	//检查出帐通知单是否已经生成
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
	
		if (sReturn == "false"){ //未生成出帐通知单
			//生成出帐通知单	
			PopPage("/FormatDoc/Report17/03.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		    //alert("未生成电子合同,请检查!");
		    //return;
		}
		//获得加密后的出帐流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
    	
    }
    
    /*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
     //var param = "ObjectType=Business&ObjectNo="+sObjectNo+"&RightType=100";
     //AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
     
   var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
   AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
    }
    
    /*~[Describe=提前还款查询;InputParam=无;OutPutParam=SerialNo;]~*/
	function SelectPrepayment()
	{
		//获取合同号，身份证号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCertID =getItemValue(0,getRow(),"CertID");	
		sCustomerID =getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			 var sReturn=RunMethod("BusinessManage","PrepaymentLoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同不能做提前还款");
				return;
			}
			
			 var sReturn=RunMethod("BusinessManage","PrepaymentLoanCount1",sCustomerID);
				if(sReturn>0){
					alert("该客户项下有逾期合同,不能做提前还款");
					return;
				}
			AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyDlog.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank","dialogWidth=200px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
				alert("该笔合同不能新增费用");
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
			var sReturn=RunMethod("BusinessManage","CarLoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同不能做手工录入还款");
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
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			//是否消费贷
		   var sResult=RunMethod("BusinessManage","LoanProductType",sSerialNo);
			if(sResult==0){
				alert("该笔合同不是消费贷产品，不能做退货操作");
				return;
			} 
			
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同不能做退货操作");
				return;
			}
			//是否在犹豫期内
			var sReturn=RunMethod("BusinessManage","HesitateDay",sSerialNo);
			if(sReturn==0){
				alert("该笔合同已超过犹豫期限,不能做退货操作");
				return;
			}  
			
			var sLoanSerialNo = RunMethod("PublicMethod","GetColValue","SerialNo,ACCT_LOAN,String@PutOutNo@"+sSerialNo);
			
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			//校验是否存在未完成的交易
			var allowApplyFlag = RunMethod("LoanAccount","GetAllowApplyFlag","00,"+relativeObjectType+","+sLoanSerialNo);
			if(allowApplyFlag != "true"){
				return "该业务已经存在一笔未生效的交易记录，不允许同时申请！";
			}
			 
			sCompID = "BusinessRefundCargo";
			sCompURL = "/InfoManage/QuickSearch/BusinessRefundCargo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&BusinessSum="+sBusinessSum+"&";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
					
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
				alert("该笔合同不能做还款日变更");
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
	
	/*~[Describe= 打印还款小贴士;InputParam=无;OutPutParam=SerialNo;]~*/
	function printRemind(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		//add CCS-291 现金贷－审核意见书、还款小贴士、风险提示函
		var sProductID = getItemValue(0,getRow(),"ProductID");
		var sDocID = "7005";
		var sUrl="/FormatDoc/Report17/01.jsp";
		if("020"==sProductID)
		{
			sDocID = "L005";
			sUrl="/FormatDoc/CashLoanReport/01.jsp";
		}
		//end
		sObjectType = "CreditSettle";
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "CS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			//检查出帐通知单是否已经生成
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //未生成出帐通知单
				//生成出帐通知单	
				PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			}
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}	
	}
	
	/*~[Describe=打印审批意见书;InputParam=无;OutPutParam=无;]~*/
	function printApprove(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		//add CCS-291 现金贷－审核意见书、还款小贴士、风险提示函
		var sProductID = getItemValue(0,getRow(),"ProductID");
		var sDocID = "7003";
		var sUrl="/FormatDoc/Report14/ApproveReport.jsp";
		if("020"==sProductID)
		{
			sDocID = "L003";
			sUrl="/FormatDoc/CashLoanReport/02.jsp";
		}
		//end
		sObjectType = "ApproveSettle";
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			//检查出帐通知单是否已经生成
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //未生成出帐通知单
				//生成出帐通知单	
				PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			}
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}
	}
	
	/*~[Describe= 还款方式变更;InputParam=无;OutPutParam=SerialNo;]~*/
	function PaymentMethodChange()
	{
		//合同编号
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		//合同状态
    	sContractStatus = getItemValue(0,getRow(),"ContractStatus");
    	//合同状态为已否决、已结清、已核销时，不能做还款方式变更
    	if(sContractStatus=="010" || sContractStatus=="110" || sContractStatus=="150"){
    		alert("该合同不能做还款方式变更");
    		return;
    	}
		
		var sReturn=RunMethod("BusinessManage","getCarLoanStatus",sSerialNo);
		if(sReturn!="true"){
			alert("该合同不能做还款方式变更");
			return;
		}
		
		sCompID = "RepaymentChangeInfo";
		sCompURL = "/InfoManage/QuickSearch/RepaymentChangeInfo.jsp";
		sParamString = "SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    
		//AsControl.OpenView("/InfoManage/QuickSearch/RepaymentChangeInfo.jsp","SerialNo="+sSerialNo,"_blank","dialogWidth=650px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		<%-- //获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同不能做还款方式变更");
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
		} --%>

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