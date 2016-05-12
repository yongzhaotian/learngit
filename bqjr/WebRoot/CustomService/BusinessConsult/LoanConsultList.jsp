<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	String sPrevUrl =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrevUrl"));
	String flag = CurPage.getParameter("flag");
	if(sExampleId==null) sExampleId="";
	if(sPrevUrl==null) sPrevUrl="";
	if(flag==null) flag = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BusinessConsultQuery";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//doTemp.setHTMLStyle("TotalSum","onblur=\"javascript:parent.chkTotalSumValue()\"");
	doTemp.setHTMLStyle("TotalSum","onblur=\"javascript:parent.inputTotalSumValue()\"");
	doTemp.setHTMLStyle("TotalSum","onfocus=\"javascript:parent.inputTotalOnfocus()\"");
	//,DownPay,DpsMnt
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
	 	{"true","","Button","查询","查询每月期款","queryMonthlyPay()",sResourcesPath},
		{"true","","Button","重置","重置","resetAll()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	var sPrevUrl = "<%=sPrevUrl%>";
	
	<%/*~[Describe=查询值是否为正数;] added by tbzeng 2014/02/21~*/%>
	function chkTotalSumValue() {
		var sTotalSum = ''+getItemValue(0,getRow(),"TotalSum");
		
		if (sTotalSum.length<=0) {
			alert("请输入商品总价格！");
			return "false";
		}
		
		if (parseFloat(sTotalSum)<0.0) {
			alert("商品总价格应为正数，请确认！"); 
			setItemValue(0,0,"MonthPay",""); return "false";
		}
		return "true";
	}
	
	
	/*~[Describe=设置首付比例;InputParam=无;OutPutParam=无;]~*/
	function inputDpsMnt(){
		var sTotalSum_ = '0'+getItemValue(0,getRow(),"TotalSum");//商品总价格
		var nLoanTerm = getItemValue(0,getRow(),"LoanTerm");//贷款期限
		var sDpsMnt_ = '0'+getItemValue(0,getRow(),"DpsMnt");//首付款额
		var sDownPay = '0'+getItemValue(0,getRow(),"DownPay");//首付比例
		var nMonthRate = ''+getItemValue(0,getRow(),"MonthRate");//月利率
		var nMonthPay = 0.0;
		
		var sTotalSum=parseFloat(sTotalSum_);
		var sDpsMnt=parseFloat(sDpsMnt_);
		
		/* 佰仟默认月利率 */
		var nMonthRate = 4.58;
		
		// 校验商品总价格输入是否正确
		if(chkTotalSumValue()!="true") {
			setItemValue(0,0,"MonthPay","");
			return;
		}
		
		if(sDpsMnt<0.0) {
			alert("请输入大于等于0的首付款额！");
			setItemValue(0,0,"MonthPay","");
			return;
		}else if(sDpsMnt==0.0){
			setItemValue(0,0,"MonthPay","0");
		}else if(sDpsMnt>sTotalSum){
			alert("首付额不能大商品总价格！");
			setItemValue(0,0,"MonthPay","");
			return;
		}
		setItemValue(0, 0, "DownPay", (sDpsMnt/sTotalSum*100).toFixed(2));//首付比例
		setItemValue(0, 0, "DpsMnt", sDpsMnt);//首付金额
		setItemValue(0,0,"MonthPay","");	
	}
	/*~[Describe=设置首付金额;InputParam=无;OutPutParam=无;]~*/
	function inputDownPay(){
		var sTotalSum_ = '0'+getItemValue(0,getRow(),"TotalSum");//商品总价格
		var nLoanTerm = getItemValue(0,getRow(),"LoanTerm");//贷款期限
		var sDpsMnt_ = '0'+getItemValue(0,getRow(),"DpsMnt");//首付款额
		var sDownPay = '0'+getItemValue(0,getRow(),"DownPay");//首付比例
		var nMonthRate = ''+getItemValue(0,getRow(),"MonthRate");//月利率
		var nMonthPay = 0.0;
		
		var sTotalSum=parseFloat(sTotalSum_);
		var sDpsMnt=parseFloat(sDpsMnt_);
		
		/* 佰仟默认月利率 */
		var nMonthRate = 4.58;
		
		// 校验商品总价格输入是否正确
		if(chkTotalSumValue()!="true") {
			setItemValue(0,0,"MonthPay","");
			return;
		}
		
		if(parseFloat(sDownPay)<0.0) {
			alert("请输入大于等于0的首付比例！");
			setItemValue(0,0,"MonthPay","");
			return;
		}else if(parseFloat(sDownPay)>100.0){
			alert("首付比例不能大于100！");
			setItemValue(0,0,"MonthPay","");
			return;
		}
		
		setItemValue(0, 0, "DpsMnt", (sTotalSum*parseFloat(sDownPay)*0.01).toFixed(0));//首付金额
		setItemValue(0,0,"MonthPay","");
	}
	/*~[Describe=输入商品总价格;InputParam=无;OutPutParam=无;]~*/
	function inputTotalSumValue(){
		setItemValue(0,0,"LoanTerm",12);
		setItemValue(0,0,"DpsMnt","");
		setItemValue(0,0,"DownPay","");
		setItemValue(0,0,"MonthPay","");
	}
	
	<%/*~[Describe=查询每月期款;] added by tbzeng 2014/02/19~*/%>
	function queryMonthlyPay() {
		
		var sTotalSum_ = ''+getItemValue(0,getRow(),"TotalSum");//商品总价格
		var nLoanTerm = getItemValue(0,getRow(),"LoanTerm");//贷款期限
		var sDpsMnt_ = ''+getItemValue(0,getRow(),"DpsMnt");//首付款额
		var sDownPay = ''+getItemValue(0,getRow(),"DownPay");//首付比例
		var nMonthRate = ''+getItemValue(0,getRow(),"MonthRate");//月利率
		var nMonthPay = 0.0;
		
		var sTotalSum=parseFloat(sTotalSum_);
		var sDpsMnt=parseFloat(sDpsMnt_);
		
		if(parseFloat(sDownPay)<10.0){
			alert("首付比例不能小10%");
			
			return;
		}
		
		if (typeof(sTotalSum_)=="undefined" || sTotalSum_=="_CLEAR_" || sTotalSum_.length==0) {
			alert("请先输入商品总价格！");
			return;
		}
		if (typeof(sDpsMnt_)=="undefined" || sDpsMnt_.length==0) {
			alert("请输入首付款额！");
			return;
		} 
		if(nLoanTerm.length==0){
			alert("请选择贷款期限！");	
			return;
		}
		
		
		/* 佰仟默认月利率 */
		var nMonthRate = 4.58;
		
		// 校验商品总价格输入是否正确
		if(chkTotalSumValue()!="true") {
			setItemValue(0,0,"MonthPay","");
			return;
		}
		nMonthPay = ((sTotalSum-sDpsMnt)*(nMonthRate/100)*(Math.pow((1+nMonthRate/100),nLoanTerm)))/(Math.pow((1+nMonthRate/100),nLoanTerm)-1);
		
		
		/* 
		if (sDpsMnt_.length>0 && sDownPay.length<=0) {
			// 只输入了首付款额
			setItemValue(0, 0, "DownPay",sDpsMnt/sTotalSum*100);
			nMonthPay = ((sTotalSum-sDpsMnt)*(nMonthRate/100)*(Math.pow((1+nMonthRate/100),nLoanTerm)))/(Math.pow((1+nMonthRate/100),nLoanTerm)-1);
			//nMonthPay = (parseFloat(sTotalSum)-parseFloat(sDpsMnt))/nLoanTerm;
		} else if(sDpsMnt_.length<=0 && sDownPay.length>0) {
			// 只输入了首付比例
			setItemValue(0, 0, "DpsMnt",sTotalSum*sDownPay*100);
			nMonthPay = ((sTotalSum*sDownPay/100)*(nMonthRate/100)*(Math.pow((1+nMonthRate/100),nLoanTerm)))/(Math.pow((1+nMonthRate/100),nLoanTerm)-1);
			//nMonthPay = (parseFloat(sTotalSum)*(1-parseFloat(sDownPay)/100.0))/nLoanTerm;
		}else {
			alert("首付额和首付比例必须且只能填一项 ！");
			setItemValue(0,0,"MonthPay","");
			setItemValue(0,0,"DpsMnt","");
			return ;
		} */
		setItemValue(0,0,"MonthPay",nMonthPay.toFixed(0));
	}
	
	<%/*~[Describe=总金额得到焦点;] added by jiangyuanlin 2015/5/21~*/%>
	function inputTotalOnfocus(){
		var sTotalSum_ = +getItemValue(0,getRow(),"TotalSum");//商品总价格
		if(sTotalSum_==0){
			setItemValue(0,0,"TotalSum","");
		}
		
	}
	<%/*~[Describe=重置;] added by tbzeng 2014/02/19~*/%>
	function resetAll() {
		
		setItemValue(0,0,"TotalSum","");
		setItemValue(0,0,"LoanTerm",12);
		setItemValue(0,0,"DpsMnt","");
		setItemValue(0,0,"DownPay","");
		setItemValue(0,0,"MonthPay","");
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		if(sPrevUrl){
			AsControl.OpenView(sPrevUrl,"","_self");
			return;
		}
		
		if("<%=flag%>"=="02"){
			AsControl.OpenView("/FrameCase/ExampleList02.jsp","","_self");
		}else{
			AsControl.OpenView("/FrameCase/ExampleList.jsp","","_self");
		}
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// 获取流水号
		setItemValue(0,getRow(),"ExampleId",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			bIsInsert = true;
		}
		setItemValue(0,0,"LoanTerm",12);
		setItemValue(0,0,"DownPay","");
		setItemValue(0,0,"DpsMnt","");
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
		
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
