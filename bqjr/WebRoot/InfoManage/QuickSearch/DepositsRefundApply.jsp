<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 退款查询
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
	String PG_TITLE = "退款申请信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sBusinessDate=SystemConfig.getBusinessDate();

	//获得页面参数

	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
	String sDepositsamt = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Depositsamt"));
	
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sDepositsamt == null) sDepositsamt = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	     	
		String sTempletNo = "DepositsRefundApply"; //模版编号
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
		if(!setCheck()){
			return;
		}
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
		alert("保存成功!");
		self.close();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe= 退款金额校验;InputParam=无;OutPutParam=SerialNo;]~*/
	function setCheck(){
		
		var sDepositsamt= getItemValue(0, 0, "depositsamt");
		var sReturnAmt=getItemValue(0,0,"returnamt");
		if (typeof(sReturnAmt)=='undefined' || sReturnAmt.length==0) {
		setItemValue(0, 0, "returnamt", "0.0");
		}
		if(sReturnAmt<=0 || sReturnAmt>sDepositsamt){
			alert("退款金额不能大于预存款余额且必须大于0");
			setItemValue(0, 0, "returnamt", "0.0");
			return false;
		}
		return true;
	} 
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode() {
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		
		setItemValue(0, 0, "accountbankcity", retVal.split("@")[0]);
		setItemValue(0, 0, "accountbankcityname", retVal.split("@")[1]);

	}
	
	//商户账号开户支行
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"refundbankid");
		var sCity     = getItemValue(0,0,"accountbankcity");
		
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
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"refundbankorgid",sBankNo);
		setItemValue(0,0,"refundbankname",sBranch);
	}

	

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"inputtime","<%=sBusinessDate%>");
		bIsInsert = false;
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sSerialNo = getSerialNo("ACCT_FEE","SERIALNO","");
			setItemValue(0, 0, "serialno", sSerialNo);
			setItemValue(0, 0, "customerid", "<%=sCustomerID%>");
			setItemValue(0,0,"customername","<%=sCustomerName%>");
			setItemValue(0,0,"depositsamt","<%=sDepositsamt%>");
			setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
			setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputdate","<%=sBusinessDate%>");
	
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
