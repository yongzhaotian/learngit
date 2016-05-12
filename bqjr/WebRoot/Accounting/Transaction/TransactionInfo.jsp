<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  xjzhao 2012/03/28
		Tester:
		Content: 交易详情
		Input Param:
		Output param:
		History Log:
		
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "交易管理申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));//交易流水号
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));//TransApply
	
	
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction,objectNo);
	if(bo == null)  throw new Exception("交易不存在！");
	String transCode = bo.getString("TransCode");
	String transStatus = bo.getString("TransStatus");
	String relaObjectType = bo.getString("RelativeObjectType");
	String relaObjectNo = bo.getString("RelativeObjectNo");
	String documentSerialNo = bo.getString("DocumentSerialNo");
	String documentType = bo.getString("DocumentType");
	//模板，交易类型，关联主体使用名
	ASValuePool templete = com.amarsoft.app.accounting.config.loader.TransactionConfig.getTransactionDef(transCode);
	String templeteNo=templete.getString("ViewTempletNo");
	String tranType=templete.getString("Type");
	
	//获取贷款账号
	com.amarsoft.app.accounting.web.bizlets.GetTransactionRela gtr = new com.amarsoft.app.accounting.web.bizlets.GetTransactionRela();
	gtr.setAttribute("SerialNo",objectNo);
	gtr.setAttribute("Type",BUSINESSOBJECT_CONSTATNTS.loan);
	String loanSerialNo = (String)gtr.run(Sqlca);
	
	String productID = "";
	String productVersion ="";
	if(loanSerialNo!=null&&loanSerialNo.length()>0&&!loanSerialNo.equalsIgnoreCase("false")){
	BusinessObject loan = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan,loanSerialNo);
		productID = loan.getString("BusinessType");
		productVersion = loan.getString("ProductVersion");
	}
	
	String businessDate = SystemConfig.getBusinessDate();
	String Sql = "select (PayPrincipalAmt - nvl(ActualPayPrincipalAmt,0)) as PayPrincipalAmt,(PayInteAmt - nvl(ActualPayInteAmt,0)) as PayInteAmt from acct_payment_schedule where ObjectNo = '"+relaObjectNo+"' and ObjectType = '"+BUSINESSOBJECT_CONSTATNTS.loan+"' and PayDate = '"+businessDate+"' ";
	ASResultSet rs = Sqlca.getASResultSet(Sql);
	double PayPrincipalAmt = 0.0d;
	double PayInteAmt = 0.0d;
	if(rs.next()){
		PayPrincipalAmt = DataConvert.toDouble(rs.getString("PayPrincipalAmt"));
		PayInteAmt = DataConvert.toDouble(rs.getString("PayInteAmt"));
	}
	rs.getStatement().close();
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASDataObject doTemp = new ASDataObject(templeteNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//扩张datawindow功能
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", productID);
	valuePool.setAttribute("ProductVersion", productVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	
	dwTemp.setEvent("AfterUpdate","!LoanAccount.UpdateTransaction("+objectNo+",#TransDate)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo);
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
		{"true","All","Button","保存","保存申请信息","saveRecord('afterSave()')",sResourcesPath},
		{"false","","Button","还款计划测算","还款计划测算","viewConsult()",sResourcesPath},
		{"false","","Button","贴息计划测算","贴息计划测算","viewSPTConsult()",sResourcesPath}
	};
	if(("0055".equals(transCode) || "2011".equals(transCode) || "2012".equals(transCode) || "2013".equals(transCode) || "2017".equals(transCode)) && !"1".equals(transStatus)){
		sButtons[1][0] = "true";
	}
	if("2016".equals(transCode) &&  !"1".equals(transStatus)) {
		sButtons[2][0] = "true";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=数据保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
		//if( !confirm("确定保存该信息吗?")) return;
		if(!beforeSave()) return;  //公用校验添加
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=根据自定义小数位数四舍五入,参数object为传入的数值,参数decimal为保留小数位数;InputParam=基数，四舍五入位数;OutPutParam=四舍五入后的数据;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
	}
	
	/*~[Describe=设置空值;InputParam=后续事件;OutPutParam=无;]~*/
	function setValue(colName,Value)
	{
		var sColName = getItemValue(0,getRow(),colName);
		if(typeof(sColName) == "undefined" || sColName.length == 0)
		{
			setItemValue(0,getRow(),colName,Value);
		}
	}
	
	/*~[Describe=贴息计划测算;InputParam=无;OutPutParam=无;]~*/
	function viewSPTConsult()
	{
		var transactionSerialNo = "<%=objectNo%>";
		PopComp("ViewSPTConsult","/Accounting/Transaction/ViewSPTConsult.jsp","TransSerialNo="+transactionSerialNo,"");
	}
	
	</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<%
	String jsfile=com.amarsoft.app.accounting.config.loader.TransactionConfig.getTransactionDef(transCode, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
		String[] s=jsfile.split("@");
		for(String s1:s){
%>
<script type="text/javascript" src="<%=sWebRootPath+s1%>"> </script>
<%		}
	}
	else{
%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/transaction/transaction.js"> </script>
<%		
	}
	%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	
	var bCheckBeforeUnload = false;
	var businessDate = "<%=businessDate%>";
	var systemDate = "<%=SystemConfig.getSystemDate()%>";
	var curUserID = "<%=CurUser.getUserID()%>";
	var curUserName = "<%=CurUser.getUserName()%>";
	var curOrgID = "<%=CurOrg.getOrgID()%>";
	var curOrgName = "<%=CurOrg.getOrgName()%>";
	var documentType = "<%=documentType%>";
	var documentSerialNo = "<%=documentSerialNo%>";
	var transactionSerialNo = "<%=objectNo%>";
	var payPrincipalAmt = "<%=PayPrincipalAmt%>";
	var payInteAmt = "<%=PayInteAmt%>";
	var relaObjectNo = "<%=relaObjectNo%>";
	var relaObjectType = "<%=relaObjectType%>";
	initRow();
	setItemValue(0,getRow(),"CashOnlineFlag","1");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>