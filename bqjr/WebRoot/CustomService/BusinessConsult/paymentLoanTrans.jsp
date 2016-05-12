<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 提前还款明细-- */
	String PG_TITLE = "提前还款明细";

	// 获得页面参数
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));//交易流水号
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));//TransApply
	String sScheduleDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScheduleDate")));//计划提前还款日
	String sPayDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PayDate")));//提前还款可行日期
	String sFlag = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag")));
	String sYesNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("YesNo")));//是否收取提前还款手续费
	String PrePrepayFeeAmt = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrePrepayFeeAmt")));//提前还款手续费
	String ContractSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractSerialNo")));//合同流水
	
	String sCustomername = Sqlca.getString("select customername from business_contract where serialno='"+ContractSerialNo+"'");
	String loanSerialNo = Sqlca.getString("select serialno from acct_loan where putoutno='"+ContractSerialNo+"'");
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "Transaction_0055";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"false","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
    //此方法用于避免对页面数据更新但不保存却弹出提示，此方法重要不允许删除  add  by phe
	function checkModified(){
	 return true;
	}
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			bIsInsert = true;
		}
		// 设置合同号和客户姓名
		
		setItemValue(0,getRow(),"LoanSerialNo","<%=loanSerialNo%>");
		var sScheduleDate="<%=sScheduleDate%>";
		var sTransDate = "<%=sPayDate%>";
		var sLoanSerialNo = "<%=loanSerialNo%>";
		var sContractSerialNo = "<%=ContractSerialNo%>";
		setItemValue(0, 0, "putoutno", sContractSerialNo);
		setItemValue(0, 0, "CustomerName", "<%=sCustomername%>");
		var sParaString=sTransDate+","+sLoanSerialNo+","+sScheduleDate;
		var sReturn = "";
		sReturn=RunMethod("BusinessManage","SelectPrepaymentAmount",sParaString);
		var str=sReturn.split(",");
		
		setItemValue(0,getRow(),"PayPrincipalAmt",str[0]);
		setItemValue(0,getRow(),"PayInteAmt",str[1]);
		setItemValue(0,getRow(),"PrePayPrincipalAmt",str[0]);
		setItemValue(0,getRow(),"PrePayInteAmt",str[1]);
		setItemValue(0,getRow(),"PayInsuranceFee",str[2]);
		/* setItemValue(0,getRow(),"PrepaymentFee",str[3]); */
		var sFee = str[3];//还款计划的提前还款手续费
		setItemValue(0,getRow(),"CustomerServeFee",str[4]);
		setItemValue(0,getRow(),"AccountManageFee",str[5]);
		setItemValue(0,getRow(),"StampTax",str[6]);
		setItemValue(0,getRow(),"PayAmt",str[7]);
		
		var sFlag=str[8];
		setItemValue(0,getRow(),"TransDate","<%=sPayDate%>");
		var PayAmt = getItemValue(0,getRow(),"PayAmt");
		var PrePrepayFeeAmt="<%=PrePrepayFeeAmt%>";

		setItemValue(0,getRow(),"PrepaymentFee",parseFloat(PrePrepayFeeAmt));
		if(parseFloat(sFee)==0.0){
			setItemValue(0,getRow(),"PayAmt",parseFloat(PrePrepayFeeAmt)+parseFloat(PayAmt));
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
<%@ include file="/IncludeEnd.jsp"%>
