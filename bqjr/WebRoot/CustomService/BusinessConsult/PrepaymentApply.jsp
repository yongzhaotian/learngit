<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
/* 页面说明: 提前还款申请页面 */
String PG_TITLE = "提前还款申请页面";
// 获得页面参数
String constractSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
String sHeaders[][] = { 
		{"serialno","申请序列号"},
		{"certid","身份证号"},
		{"constractNo","合同号"},
		{"customerName","客户姓名"},
		{"prepayFactorageFlag","是否收取提前还款手续费"},
		{"planExecutableDate","计划提前还款日期"},
		{"nextduedate","下一还款日期"},
		{"executableDate","提前还款可执行日期"},
		{"payamt","总金额"},
		{"prepayprincipalAmt","提前还款本金金额"},
		{"prepayinteAmt","提前还款利息金额"},
		{"insuranceAmt","提前还款保险费"},
		{"prepayFactorageAmt","提前还款手续费"},
		{"financeAmt","提前还款财务管理费"},
		{"customerAmt","提前还款客户管理费"},
		{"stampDutyAmt","提前还款印花税"},
		{"bugpayamt","提前还款随心还服务费"},
		{"isbomtr","是否使用优惠提前还款"}
	};
String sql = "select pa.serialno as serialno,ci.certid as certid,ci.customername as customerName,pa.contract_serialno as constractNo, "
			 +" pa.prepay_factorage_flag as prepayFactorageFlag,pa.plan_executable_date as planExecutableDate,pa.nextduedate as nextduedate,"
			 +" pa.executable_date as executableDate,pa.payamt as payamt,pa.prepayprincipal_amt as prepayprincipalAmt, pa.is_bomtr as isbomtr, "
			 +" pa.prepayinte_amt as prepayinteAmt,pa.insurance_amt as insuranceAmt,pa.prepay_Factorage_Amt as prepayFactorageAmt,"
			 +" pa.finance_amt as financeAmt,pa.customer_amt as customerAmt,pa.stamp_duty_amt as stampDutyAmt,pa.bugpayamt as bugpayamt"
			 +" from prepayment_applay pa,customer_info ci"
			 +" where 1=2 ";
ASDataObject doTemp = new ASDataObject(sql);
doTemp.setHeader(sHeaders);
doTemp.setCheckFormat("planExecutableDate","3");
doTemp.setDDDWCodeTable("prepayFactorageFlag", "1,是,0,否");
doTemp.setDDDWCodeTable("isbomtr", "1,是,0,否");
doTemp.setDefaultValue("prepayFactorageFlag", "1");
doTemp.setDefaultValue("isbomtr", "0");
doTemp.setDefaultValue("planExecutableDate", SystemConfig.getBusinessDate());
doTemp.setHTMLStyle("planExecutableDate"," style={width:130px} onChange=\"javascript:parent.planExecutableDateChange()\"");
doTemp.setHTMLStyle("prepayFactorageFlag","onChange=\"javascript:parent.prepayFactorageFlagChange()\"");
doTemp.setRequired("prepayFactorageFlag,planExecutableDate,isbomtr", true);
doTemp.setEditStyle("prepayFactorageFlag", "2");
doTemp.setVisible("serialno", false);
doTemp.setReadOnly("certid,constractNo,customerName", true);
doTemp.setReadOnly("payamt,prepayprincipalAmt,prepayinteAmt,insuranceAmt,bugpayamt", true);
doTemp.setReadOnly("prepayFactorageAmt,financeAmt,customerAmt,stampDutyAmt,executableDate,nextduedate", true);
doTemp.setAlign("payamt,prepayprincipalAmt,prepayinteAmt,insuranceAmt,prepayFactorageAmt,financeAmt,customerAmt,stampDutyAmt,bugpayamt","3");
ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
Vector vTemp = dwTemp.genHTMLDataWindow("");
for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

String sButtons[][] = {
		{"true","","Button","提前还款申请保存","提前还款申请保存","PrePaymentApply()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>

<script type="text/javascript">	
    function PrePaymentApply(){
    	var date = getItemValue(0, 0, "planExecutableDate");
		if("<%=SystemConfig.getBusinessDate()%>">date){
			alert("申请日期不能小于当前系统日期");
			return;
		}
    	var sSerialNo ='<%= constractSerialNo%>';
    	var nextduedate = getItemValue(0, 0, "nextduedate");
    	if(!vI_all("myiframe0")) return;
		if(!confirm("是否确认提前还款申请,确认将可能产生相应费用！")) return;
    	var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			return;
		}
		
		var isbomtr = getItemValue(0, 0, "isbomtr");
		if (isbomtr == "1") {
			returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","checkBOMTRInfo","contractSerialNo=" + sSerialNo 
					+ ",userId=<%=CurUser.getUserID() %>,nextduedate=" + nextduedate);
			if(returnValue!="0"){
				alert(returnValue);
				return;
			}
		}
		
    	var date = getItemValue(0, 0, "planExecutableDate");
    	var isbomtr = getItemValue(0, 0, "isbomtr");
		var prepayFactorageFlag = getItemValue(0, 0, "prepayFactorageFlag");
    	var params = "contractNo=<%= constractSerialNo%>,orgid=<%=CurUser.getOrgID()%>,userId =<%=CurUser.getUserID()%>,planExecuteDate="+date
    				+",prepayFactorageFlag="+prepayFactorageFlag + ",isbomtr=" + isbomtr;
    	var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PaymentApply", "prePaymentApply", params);
    	if(result!=null){
    		alert(result.split("@")[1]);
    	}
    }
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			var date = getItemValue(0, 0, "planExecutableDate");
			var prepayFactorageFlag = getItemValue(0, 0, "prepayFactorageFlag");
			var params = "contractNo=<%= constractSerialNo%>,userId =<%=CurUser.getUserID()%>,planExecuteDate="+date+",prepayFactorageFlag="+prepayFactorageFlag;
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PaymentApply", "initPrepayMentApplay", params);
			if(result == "failure"){
				alert("查询提前还款金额出错");
				return;
			}
			setValues(result);
		}
	}
	
	function planExecutableDateChange(){
		var date = getItemValue(0, 0, "planExecutableDate");
		if("<%=SystemConfig.getBusinessDate()%>">date){
			alert("申请日期不能小于当前系统日期");
			return;
		}
		var prepayFactorageFlag = getItemValue(0, 0, "prepayFactorageFlag");
		var params = "contractNo=<%= constractSerialNo%>,userId =<%=CurUser.getUserID()%>,planExecuteDate="+date+",prepayFactorageFlag="+prepayFactorageFlag;
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PaymentApply", "initPrepayMentApplay", params);
		if(result == "failure"){
			alert("查询提前还款金额出错");
			return;
		}
		setValues(result);
	}
	
	function prepayFactorageFlagChange(){
		var prepayFactorageFlag = getItemValue(0, 0, "prepayFactorageFlag");
		if(prepayFactorageFlag != ""){
			var date = getItemValue(0, 0, "planExecutableDate");
			var params = "contractNo=<%= constractSerialNo%>,userId =<%=CurUser.getUserID()%>,planExecuteDate="+date+",prepayFactorageFlag="+prepayFactorageFlag;
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PaymentApply", "initPrepayMentApplay", params);
			if(result == "failure"){
				alert("查询提前还款金额出错");
				return;
			}
			setValues(result);
		}
		
	}
	function setValues(result){
		var obj = eval(result);
		if(obj!=null){
			setItemValue(0, 0, "certid", obj.certid);
			setItemValue(0, 0, "customerName", obj.customerName);
			setItemValue(0, 0, "constractNo", obj.constractNo);
			setItemValue(0, 0, "nextduedate", obj.nextduedate);
			setItemValue(0, 0, "executableDate", obj.executableDate);
			setItemValue(0, 0, "payamt", obj.payamt);
			setItemValue(0, 0, "prepayprincipalAmt", obj.prepayprincipalAmt);
			setItemValue(0, 0, "prepayinteAmt", obj.prepayinteAmt);
			setItemValue(0, 0, "insuranceAmt", obj.insuranceAmt);
			setItemValue(0, 0, "prepayFactorageAmt", obj.prepayFactorageAmt);
			setItemValue(0, 0, "financeAmt", obj.financeAmt);
			setItemValue(0, 0, "customerAmt", obj.customerAmt);
			setItemValue(0, 0, "stampDutyAmt", obj.stampDutyAmt);
			setItemValue(0, 0, "bugpayamt", obj.bugpayamt);
		}
	}
    
	AsOne.AsInit();
	init();
	my_load_show(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>