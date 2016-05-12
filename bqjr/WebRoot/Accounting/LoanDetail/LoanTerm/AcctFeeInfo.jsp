<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "费用详细信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获取参数
	String feeSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FeeSerialNo")));//费用流水号
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject fee = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee,feeSerialNo);
	String feeFrequency = fee.getString("FeeFrequency");
	String objectType = fee.getString("ObjectType");
	String objectNo = fee.getString("ObjectNo");

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AcctFeeInfo";
	String sTempletFilter = "(ColAttribute like '%"+objectType+"%' or ColAttribute is null)"; 
	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	//收付频率一次的，不显示减免的起始日期和结束日期
	if("3".equals(feeFrequency)){
		doTemp.setVisible("SEGBEGINSTAGE,SEGENDSTAGE", false);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	//泊位
	dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(sTempletNo,"1=1", Sqlca));
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(feeSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	

	//依次为：
	//0.是否显示
	//1.注册目标组件号(为空则自动取当前组件)
	//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.按钮文字
	//4.说明文字
	//5.事件
	//6.资源图片路径
	String sButtons[][] = {
	{"true", "", "Button", "保存","保存记录","saveRecord()",sResourcesPath},
	};
%>

<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	function saveRecord(){
		bSavePrompt=true;
		var amount = getItemValue(0,0,"Amount");
		var waiveAmount = getItemValue(0,0,"WaiveAmount");
		var waivePercent = getItemValue(0,0,"WaivePercent");
		if(amount == "")
		{
			amount = 0;
		}
		if(waiveAmount == "")
		{
			waiveAmount = 0;
		}
		if(waivePercent == "")
		{
			waivePercent = 0;
		}
		if(waivePercent>0 && waiveAmount >0){
			alert("减免比例和减免金额不能同时有值！");
			return;
		}
		calFeeAmount_T();
		as_save("myiframe0","afterLoad()"); 
	}
	
	function calFeeAmount_T(){
		var feeAmount = RunMethod("LoanAccount","CalFeeAmount","<%=feeSerialNo%>");
		if(typeof(feeAmount) == "undefined" || feeAmount == ""){
			feeAmount = "0.0";
		}
		setItemValue(0,0,"Amount",feeAmount);
		
		feeAmount = getItemValue(0,0,"Amount");
		var waivePercent = getItemValue(0,0,"WaivePercent");
		var waiveAmount = getItemValue(0,0,"WaiveAmount");
		if(typeof(waivePercent) == "undefined" || waivePercent == ""){
			waivePercent = "0.0";
		}
		if(typeof(waiveAmount) == "undefined" || waiveAmount == ""){
			waiveAmount = "0.0";
		}
		
		if(waiveAmount>0){
			setItemValue(0,0,"FeeActualAmount",amarMoney(parseFloat(feeAmount)-parseFloat(waiveAmount),2));
			//setItemValue(0,0,"WaivePercent",parseFloat(waiveAmount/feeAmount));
		}
		else {
			setItemValue(0,0,"FeeActualAmount",amarMoney(parseFloat(feeAmount)-parseFloat(waivePercent*feeAmount/100),2));
			//setItemValue(0,0,"WaiveAmount",parseFloat(waivePercent*feeAmount/100));
		} 
	}
	
	function calFeeAmount(){
		bSavePrompt=false;
		var waivePercent = getItemValue(0,0,"WaivePercent");
		var waiveAmount = getItemValue(0,0,"WaiveAmount");
		if(typeof(waivePercent) == "undefined" || waivePercent == ""){
			waivePercent = "0.0";
		}
		if(typeof(waiveAmount) == "undefined" || waiveAmount == ""){
			waiveAmount = "0.0";
		}
		if(waivePercent>0 && waiveAmount >0){
			alert("减免比例和减免金额不能同时有值！");
			return;
		}
		as_save("myiframe0","calFeeAmount_T()");
	}
	
	/*~[Describe=支付信息;InputParam=无;OutPutParam=无;]~*/
	function viewAccountInfo(){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_FeeAccountsPart');
		if(typeof(obj) == "undefined" || obj == null) return;
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		AsControl.OpenView("/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp","Status=0@1&ObjectNo="+sObjectNo+"&ObjectType=<%=fee.getObjectType()%>","FeeAccountsPart","");
	}
	
	/*~[Describe=费用减免信息;InputParam=无;OutPutParam=无;]~*/
	function viewFEEWaiveInfo(){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_FeeWaivePart');
		if(typeof(obj) == "undefined" || obj == null) return;
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		AsControl.OpenView("/Accounting/LoanDetail/LoanTerm/AcctFeeWaiveList.jsp","Status=0@1&ObjectNo="+sObjectNo+"&ObjectType=<%=fee.getObjectType()%>","FeeWaivePart","");
	}
	
	/*~[Describe=后续事件;InputParam=无;OutPutParam=无;]~*/
	function afterLoad(){
		viewAccountInfo();
		viewFEEWaiveInfo();
	}
	//初始化
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	setItemValue(0,getRow(),"CashonlineFlag","1");
	afterLoad();
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>