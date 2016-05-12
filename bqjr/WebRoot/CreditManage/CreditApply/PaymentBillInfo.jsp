<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: smiao 2011.06.01
		Tester:
		Describe: 相关支付清单信息
		Input Param:
			ObjectType: 对象类型
			ObjectNo:   对象编号
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "相关支付清单信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数
	String sPutoutSerialNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sPurpose = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Purpose"));
	String sBusinessSum = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessSum"));
	String sPaymentMode    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PaymentMode"));
	String sBusinessCurrency    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessCurrency"));
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	String customerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String customerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
	if(sSerialNo == null ) sSerialNo = ""; 
	if(sObjectType == null) sObjectType = "";
    if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sPaymentMode == null) sPaymentMode = ""; 
    if(sPurpose == null) sPurpose = ""; 
    
    if(customerID == null) customerID = "";
    if(customerName == null) customerName = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "PaymentBillInfo";

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		if (!ValidityCheck()){
			return;
		}else{
			if(bIsInsert){
				beforeInsert();
			}else
				beforeUpdate();		
			as_save("myiframe0");
		}
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/PaymentBillList.jsp","_self","");
	}

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//当前支付流水号
		var sPICurrency = getItemValue(0,getRow(),"Currency");//当前支付页面的币种
		var sBPCurrency = "<%=sBusinessCurrency%>";//当前放贷页面的币种

		var currentPaymentSum = getItemValue(0,getRow(),"PaymentSum");//获取当前页面的支付金额
		var sReturn = RunMethod("BusinessManage","ChangeToRMB",currentPaymentSum+","+sPICurrency);
		currentPaymentSum = parseFloat(sReturn);
		
		paymentSum1 = RunMethod("BusinessManage","GetCurrentPaymentSum",sSerialNo);//获取当前支付流水号对应的支付金额
		if(paymentSum1>0){
			paymentSum1 = paymentSum1;//详情页面
		}else{
			paymentSum1 = 0;//新增页面
		}
				
		sParaString = "<%=sPutoutSerialNo%>"+","+"<%=sObjectType%>";		
		sReturn = RunMethod("BusinessManage","GetPaymentAmount",sParaString);//获取已经申请的支付金额
		var paymentSum = parseFloat(sReturn);//
		
		sReturn = RunMethod("BusinessManage","ChangeToRMB","<%=sBusinessSum%>"+","+sBPCurrency);
		var putoutSum = parseFloat(sReturn);//获取放贷金额
		if((paymentSum+currentPaymentSum-paymentSum1)<= putoutSum)
		{
			return true;
		}else 
		{
			alert("支付总金额大于放款金额!");
			return false;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"PutoutSerialNo","<%=sPutoutSerialNo%>");
			setItemValue(0,0,"PaymentMode","<%=sPaymentMode%>");
			setItemValue(0,0,"CapitalUse","<%=sPurpose%>");
			setItemValue(0,0,"CustomerID","<%=customerID%>");
			setItemValue(0,0,"CustomerName","<%=customerName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
			initSerialNo();
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "Payment_Info";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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