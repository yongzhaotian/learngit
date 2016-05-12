<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Describe: 还款计划查询页面
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "还款计划查询页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";

	String customerID = Sqlca.getString(new SqlObject("select customerid from business_contract where serialno =:ObjectNo ").setParameter("ObjectNo", sContractSerialNo));
	String loanSerialNo = Sqlca.getString(new SqlObject("select serialno from acct_loan where putoutno =:ObjectNo").setParameter("ObjectNo", sContractSerialNo));
	String stypeNo = Sqlca.getString(new SqlObject("select BusinessType from acct_loan where putoutno =:ObjectNo").setParameter("ObjectNo", sContractSerialNo));
	String preBalance = Sqlca.getString(new SqlObject("select debitbalance from acct_subsidiary_ledger where accountcodeno='Customer21' and objectno=:customerID").setParameter("customerID", customerID));
 	if(loanSerialNo == null) loanSerialNo = "";
 	if(stypeNo == null) stypeNo = "";
 	if(customerID == null) customerID = "";
 	if(preBalance == null) preBalance = "";
 	
	String BusinessDate=SystemConfig.getBusinessDate();
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		String sHeaders[][] = { 
								{"SeqID","期次"},
								{"PayDate","应还日期"},
								//{"FinishDate","最后一次到账时间"},
								{"TotalAmt","应还期款总金额(元)"},
								{"ActualTotalAmt","实还期款总金额(元)"},
								{"PayprincipalAmt","本金金额(元)"},
								{"ActualPayPrincipalAmt","本金金额(元)"},
								{"InteAmt","利息金额(元)"},
								{"ActualPayInteAmt","利息金额(元)"},
								{"CustomerServeFee","客户服务费(元)"},
								{"ActualCustomerServeFee","客户服务费(元)"},
								{"AccountManageFee","财务管理费(元)"},
								{"ActualAccountManageFee","财务管理费(元)"},
								{"StampTax","印花税(元)"},
								{"ActualStampTax","印花税(元)"},
								//{"PayInsuranceFee","保险费(元)"},
								{"PayInsuranceFee","增值服务费(元)"},
								//{"ActualPayInsuranceFee","保险费(元)"},
								{"ActualPayInsuranceFee","增值服务费(元)"},
								{"OverDueAmt","滞纳金(元)"},
								{"ActualOverDueAmt","滞纳金(元)"},
								{"AdvanceFee","提前还款手续费(元)"},
								{"ActualAdvanceFee","提前还款手续费(元)"},
								{"PayOutSourceSum","应还催收委外费用(元)"},
								{"ActualPayOutSourceSum","实还催收委外费用(元)"},
								{"BugPayPkgindSum","随心还服务费(元)"},
								{"tiQianWWSum","应还提前委外费用(元)"},
								{"segfromdate","滞纳金创建日期"}
							}; 

		 String sSql ="SELECT aps.seqid as SeqID,aps.paydate as PayDate, af.segfromdate as segfromdate, "+//max(apl.actualpaydate) as FinishDate,
				   "sum(nvl(aps.payprincipalamt,0)+nvl(aps.payinteamt,0)) as TotalAmt, "+//--应还总金额
	               "sum(nvl(aps.actualpayprincipalamt,0)+nvl(aps.actualpayinteamt,0)) as ActualTotalAmt, "+//--实还总金额
			       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.payprincipalamt,0) else 0 end) as PayprincipalAmt, "+//--应还本金
			       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualPayPrincipalAmt, "+//--实还本金
			       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.payinteamt,0) else 0 end) as InteAmt, "+//--应还利息
			       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.actualpayinteamt,0) else 0 end) as ActualPayInteAmt, "+//--实还利息
			       "sum(case when aps.paytype='A2' then nvl(aps.payprincipalamt,0) else 0 end) as CustomerServeFee, "+//--应还客户服务费
			       "sum(case when aps.paytype='A2' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualCustomerServeFee, "+//--实还客户服务费
			       "sum(case when aps.paytype='A7' then nvl(aps.payprincipalamt,0) else 0 end) as AccountManageFee, "+//--应还财务管理费
			       "sum(case when aps.paytype='A7' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualAccountManageFee, "+//--实还财务管理费
			       "sum(case when aps.paytype='A11' then nvl(aps.payprincipalamt,0) else 0 end) as StampTax, "+//--印花税
			       "sum(case when aps.paytype='A11' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualStampTax, "+//--实还印花税
			       "sum(case when aps.paytype='A12' then nvl(aps.payprincipalamt,0) else 0 end) as PayInsuranceFee, "+//--保险费
			       "sum(case when aps.paytype='A12' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualPayInsuranceFee, "+//--实还保险费
			       "sum(case when aps.paytype='A10' then nvl(aps.payprincipalamt,0) else 0 end) as OverDueAmt, "+//--滞纳金
			       "sum(case when aps.paytype='A10' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualOverDueAmt, "+//--实还滞纳金
			       "sum(case when aps.paytype='A9' then nvl(aps.payprincipalamt,0) else 0 end) as AdvanceFee, "+//--应还提前还款手续费
			       "sum(case when aps.paytype='A9' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualAdvanceFee, "+//--实收提前还款手续费			     
			       "sum(case when aps.paytype='A17' then nvl(aps.payprincipalamt,0) else 0 end) as PayOutSourceSum, "+//--应催收费用
			       "sum(case when aps.paytype='A17' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualPayOutSourceSum, "+//--实收催收费用
				   "sum(case when aps.paytype='A18' then nvl(aps.payprincipalamt,0) else 0 end) as BugPayPkgindSum, "+//--应随心还服务费
				   "sum(case when aps.paytype='A19' then nvl(aps.payprincipalamt,0) else 0 end) as tiQianWWSum "+//--提前委外费用 add by zhangdachun 20151218
				   "FROM acct_payment_schedule aps "+
				   //"left join acct_payment_log apl on apl.psserialno = aps.serialno "+
				   "left join acct_fee af on aps.objectno=af.serialno and af.feetype='A10' "+
				   "where (aps.objectno='"+loanSerialNo+"' and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjectno='"+loanSerialNo+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN') "+// 关联的借据
				   "group by SeqID,aps.PayDate,segfromdate order by SeqID,aps.PayDate ";

	 //设置DataObject				
	 ASDataObject doTemp = new ASDataObject(sSql);
	 doTemp.setCheckFormat("PayDate","3");
	 doTemp.setVisible("ActualPayPrincipalAmt,ActualPayInteAmt,ActualCustomerServeFee,ActualAccountManageFee,ActualStampTax,ActualPayInsuranceFee,ActualOverDueAmt,ActualAdvanceFee,ActualPayOutSourceSum", false);
	
	 doTemp.setHeader(sHeaders);
	 doTemp.setAlign("TotalAmt,ActualTotalAmt,PayprincipalAmt,ActualPayPrincipalAmt,InteAmt,ActualPayInteAmt,AccountManageFee,CustomerServeFee,ActualAccountManageFee,ActualPayOutSourceSum,BugPayPkgindSum,tiQianWWSum","3");
	 doTemp.setAlign("ActualCustomerServeFee,StampTax,ActualStampTax,PayInsuranceFee,ActualPayInsuranceFee,OverDueAmt,ActualOverDueAmt,AdvanceFee,PayOutSourceSum,ActualAdvanceFee","3");
	 doTemp.setAlign("SeqID,PayDate","2");
	 doTemp.setCheckFormat("TotalAmt,ActualTotalAmt,PayprincipalAmt,ActualPayPrincipalAmt,InteAmt,ActualPayInteAmt,CustomerServeFee,ActualCustomerServeFee,AccountManageFee,ActualAccountManageFee,PayOutSourceSum,ActualPayOutSourceSum,BugPayPkgindSum,tiQianWWSum","2");
	 doTemp.setCheckFormat("StampTax,ActualStampTax,PayInsuranceFee,ActualPayInsuranceFee,OverDueAmt,ActualOverDueAmt,AdvanceFee,ActualAdvanceFee","2");
	
	 doTemp.setColumnType("TotalAmt,ActualTotalAmt,PayprincipalAmt,ActualPayPrincipalAmt,InteAmt,ActualPayInteAmt,AccountManageFee,CustomerServeFee,ActualCustomerServeFee,StampTax,ActualStampTax,PayInsuranceFee,ActualPayInsuranceFee,OverDueAmt,ActualOverDueAmt,AdvanceFee,PayOutSourceSum,ActualPayOutSourceSum,BugPayPkgindSum,tiQianWWSum","2");
	 doTemp.setHTMLStyle("PayDate","style={width:80px}");
	 //doTemp.setHTMLStyle("FinishDate","style={width:80px}");
	 doTemp.setHTMLStyle("SeqID","style={width:30px}");
	 
	 
	 ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	 //dwTemp.setPageSize(24);//设置分页
	 dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	 dwTemp.ReadOnly = "1"; //设置为可写
	 dwTemp.ShowSummary = "1";//设置汇总
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
		{!loanSerialNo.equals("")?"true":"false","","Button","合同费用减免信息","费用减免记录","FeeWaiveView()",sResourcesPath},
		{loanSerialNo.equals("")?"true":"false","","Button","合同还款计划试算","还款计划试算","RepaymentList()",sResourcesPath},
		{"true","","Button","导出Excel","导出Excel","exportAll()",sResourcesPath},
		//{"true","","Button","预存款余额："+preBalance+"","预存款金额","",sResourcesPath}
		//{(!preBalance.equals("")?"true":"false"),"","Button","预存款还款测算","还款测算","prePlan()",sResourcesPath},
		{(!preBalance.equals("")?"true":"false"),"","PlainText","预存款余额："+preBalance+"元","预存余额","style={color:red}",sResourcesPath},
		{"true","","Button","退款详情","退款详情","RefundPrepayAmtDetails()",sResourcesPath}
	
	};
	
	
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	 /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function FeeWaiveView()
	{
		var loanSerialNo="<%=loanSerialNo%>";
		var ContractSerialNo="<%=sContractSerialNo%>";
		var stypeNo = "<%=stypeNo%>";
		if (typeof(loanSerialNo)=="undefined" || loanSerialNo.length==0)
		{
			alert("无费用减免信息");
			return;
		}
		popComp("ContractFeeWaiveList","/BusinessManage/QueryManage/ContractFeeWaiveList.jsp","ObjectNo="+ContractSerialNo,"dialogWidth=650px;dialogHeight=430px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*~[Describe还款计划试算;InputParam=无;OutPutParam=无;]~*/
	function RepaymentList()
	{
		var sContractSerialNo="<%=sContractSerialNo%>";
		popComp("BusinessRepaymentList","BusinessManage/QueryManage/BusinessRepaymentList.jsp","ObjectNo="+sContractSerialNo,"dialogWidth=900px;dialogHeight=1020px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe预存款还款试算;InputParam=无;OutPutParam=无;]~*/
	function prePlan()
	{
		var sContractSerialNo="<%=sContractSerialNo%>";
		var loanSerialNo="<%=loanSerialNo%>";
		var preBalance="<%=preBalance%>";
		popComp("XFDPayMentSchedule_pre","BusinessManage/QueryManage/XFDPayMentSchedule_pre.jsp","loanSerialNo="+loanSerialNo+"&preBalance"+preBalance,"dialogWidth=900px;dialogHeight=1020px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe退款详情;InputParam=无;OutPutParam=无;]~*/
	function RefundPrepayAmtDetails()
	{
		var sContractSerialNo="<%=sContractSerialNo%>";
		
		sCompID = "RefundPrepayAmtDetails";
		sCompURL = "/InfoManage/QuickSearch/RefundPrepayAmtDetails.jsp";
		popComp(sCompID,sCompURL,"ContractSerialNo="+sContractSerialNo,"dialogWidth=800px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init_show();
	my_load_show(2,0,'myiframe0');
	//initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
