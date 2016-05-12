<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.util.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	
	String sTransSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransSerialNo"));//还款拆分流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//还款拆分流水号
	String sPSSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PSSerialNo"));//还款拆分流水号
	String sLoanSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanSerialNo"));//还款拆分流水号
	
	//打印业务凭证(还款)
	
	String sBusinessDate = SystemConfig.getBusinessDate();//当前系统日期
	String sYear = sBusinessDate.substring(0,4);//当前年
	String sMonth = sBusinessDate.substring(5,7);//当前月
	String sDay = sBusinessDate.substring(8,10);//当前日
	int sCount = 1;
	
	//创建交易
	String transactionSerialNo = Sqlca.getString("Select SerialNo from Acct_Transaction where DocumentType='"+BUSINESSOBJECT_CONSTATNTS.back_bill+"'"+" and DocumentSerialNo='"+sTransSerialNo+"'");
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject transaction = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction, transactionSerialNo);
	BusinessObject loan = bom.loadObjectWithKey(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
	BusinessObject paymentLog = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.PaymentLog, sSerialNo);
	BusinessObject transPayment = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.back_bill, sTransSerialNo);
	BusinessObject paymentSchedule = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.payment_schedule, sPSSerialNo);
	String LoanNo=Sqlca.getString("Select LoanNo from Business_Duebill where LoanSerialNo='"+loan.getObjectNo()+"'");
%>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>

<table width="621" height="330">
  <tr>
    <td colspan="3" align="right" style="padding-bottom:20px;"><%=sYear%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sMonth%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDay%>&nbsp;</td>
  </tr>
  <tr>
    <td width="258"> 业务内容：&nbsp;<%=NameManager.getBusinessType(loan.getString("BusinessType"))%></td>
    <td width="228"> 流水号：&nbsp;<%=transaction.getString("CoreReturnSerialNo") %></td>
    <td width="123">&nbsp;</td>
  </tr>
  <tr>
    <td >借据号：&nbsp;<%=LoanNo%></td>
    <td>还款金额：&nbsp;<%=paymentLog.getDouble("ACTUALPAYPRINCIPALAMT")+paymentLog.getDouble("ACTUALPAYINTEAMT")+paymentLog.getDouble("ACTUALPAYFINEAMT")+paymentLog.getDouble("ACTUALPAYCOMPDINTEAMT") %>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">交易类型：&nbsp;<%=transaction.getString("TransName") %></td>
  </tr>
  <tr>
    <td>还本金额：&nbsp;<%=paymentLog.getDouble("ACTUALPAYPRINCIPALAMT") %></td>
    <td>还息金额：&nbsp;<%=paymentLog.getDouble("ACTUALPAYINTEAMT")+paymentLog.getDouble("ACTUALPAYFINEAMT")+paymentLog.getDouble("ACTUALPAYCOMPDINTEAMT") %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>贷款币种：&nbsp;<%=CodeManager.getItemName("Currency",loan.getString("Currency"))%></td>
    <td>贷款余额：&nbsp;<%=paymentLog.getDouble("BALANCE") %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">客户名称：&nbsp;<%=loan.getString("CustomerName") %></td>
  </tr>
  <tr>
    <td>计息起日：&nbsp;<%=paymentSchedule.getString("INTERESTDATE") %></td>
    <td>计息止日：&nbsp;<%=paymentSchedule.getString("PAYDATE") %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">还款账号：&nbsp;<%=transPayment.getString("PAYACCOUNTNO") %></td>
  </tr>
  <tr>
    <td colspan="3">还款人名称：&nbsp;<%=transPayment.getString("PAYACCOUNTNAME") %>&nbsp;</td>
  </tr>
  <tr>
    <td>经办柜员：<%=transaction.getString("InputUserID") %> 复核柜员：<%=transaction.getString("TransUserID") %></td>
    <td>交易机构：<%=transaction.getString("TransOrgID") %> 交易码：<%=transaction.getString("TransCode") %></td>
    <td>交易时间：<%=transaction.getString("TransDate") %></td>
  </tr>
</table>

<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right" id="print">
            <%=HTMLControls.generateButton("打印","打印审批通知书","javascript: my_Print()",sResourcesPath)%>
        </td>
        <td align="left" id="back">
            <%=HTMLControls.generateButton("返回","返回","javascript: window.close();",sResourcesPath)%>
        </td>
    </tr>
</table>
</div>
<script language=javascript>
		
		function my_Print()
		{
			var print=document.getElementById("PrintButton").innerHTML;
			document.getElementById("PrintButton").innerHTML="";
			window.print();
			var sPrintCount=<%=sCount%>+1;
			RunMethod("LoanAccount","UpdatePrintCount","<%=sTransSerialNo%>"+","+"001"+","+sPrintCount);
			document.getElementById("PrintButton").innerHTML=print;
		}
		
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.all('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.all('PrintButton').style.display="";
		}
</script>

<%@	include file="/IncludeEnd.jsp"%>