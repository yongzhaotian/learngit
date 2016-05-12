<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 发起再次代扣
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "再次代扣申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sBusinessDate=SystemConfig.getBusinessDate();

	//获得页面参数

	//获得组件参数
	String sPayAmount = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PayAmount")));
	String sLoanSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanSerialNo")));
	String sCustomerID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
	String sCustomerName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName")));
	String sPutOutNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutOutNo")));
	String sOutsourcingCollection=DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OutsourcingCollection")));
	
	if(sPayAmount == null) sPayAmount = "";
	if(sLoanSerialNo == null) sLoanSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sPutOutNo == null) sPutOutNo = "";
	if(sOutsourcingCollection == null) sOutsourcingCollection = "";

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	     	
		String sTempletNo = "SponsorAgainWithhold"; //模版编号
	    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

		//生成查询框
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		
		
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		dwTemp.setPageSize(16);  //服务器分页

		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; 
	
	/*~[Describe= 保存;InputParam=无;OutPutParam=SerialNo;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		
		if(!vI_all("myiframe0")) return;
		
		var payTotalAmount = getItemValue(0,getRow(),"payaccountname2");
		var payAmount = getItemValue(0,getRow(),"payamount");
		
		if(parseFloat(payAmount)<=0){
			alert("代扣金额必须大于0");
			return;
		}
		
		if(parseFloat(payTotalAmount)<parseFloat(payAmount)){
			alert("代扣金额不能大于到期应还总金额");
			setItemValue(0, 0, "payamount", "");
			return;
		}
		if(!confirm("申请成功后将无法取消，是否确认申请？")){
			return;
		}
		
		as_save("myiframe0",sPostEvents);
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	
	

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0, 0, "batchtranstype", "2");//PRM-728 取消退保审批和临时代扣审批的功能 '1','审批中','2','审批通过','3','已取消','4','客户发起'
		setItemValue(0, 0, "accountingorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"digest","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"payaccountorgid1","<%=SystemConfig.getBusinessTime()%>");
		bIsInsert = false;
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sTableName = "LS_BATCH_LAS_CORE";//表名
			var sColumnName = "SerialNo";//字段名
			var sPrefix = "";//前缀
		
			//获取流水号
			var sSerialNo = "<%=DBKeyUtils.getSerialNo("LS")%>"
			setItemValue(0, 0, "serialno", sSerialNo);
			setItemValue(0, 0, "inputdate", "<%=sBusinessDate%>");
			setItemValue(0, 0, "objectno", "<%=sLoanSerialNo%>");
			setItemValue(0, 0, "objecttype", "jbo.app.ACCT_LOAN");
			setItemValue(0, 0, "payaccountname3", "<%=sCustomerName%>");
			setItemValue(0, 0, "payaccountno3", "<%=sCustomerID%>");
			setItemValue(0, 0, "batchtranstype", "2");//PRM-728 取消退保审批和临时代扣审批的功能 '1','审批中','2','审批通过','3','已取消','4','客户发起'
			setItemValue(0, 0, "payaccountname2", "<%=sPayAmount%>");
			setItemValue(0, 0, "accountingorgid", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "digest", "<%=CurUser.getUserID()%>");
			setItemValue(0, 0, "payaccountorgid1", "<%=SystemConfig.getBusinessTime()%>");
			setItemValue(0, 0, "recieveaccountno", "<%=sPutOutNo %>");
			setItemValue(0, 0, "outsourcingcollection", "<%=sOutsourcingCollection %>");

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
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
