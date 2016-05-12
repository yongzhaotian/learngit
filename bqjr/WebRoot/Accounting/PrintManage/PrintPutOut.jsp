<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.util.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	
	String sDocumentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentType"));
	String sDocumentSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentSerialNo"));
	
	//打印业务凭证(放款)
	
	String sBusinessDate = SystemConfig.getBusinessDate();//当前系统日期
	String sYear = sBusinessDate.substring(0,4);//当前年
	String sMonth = sBusinessDate.substring(5,7);//当前月
	String sDay = sBusinessDate.substring(8,10);//当前日
	int sCount = 1;
	
	//创建交易
	String transactionSerialNo = Sqlca.getString("Select SerialNo from Acct_Transaction where DocumentType='"+sDocumentType+"'"+" and DocumentSerialNo='"+sDocumentSerialNo+"'");
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject transaction = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction, transactionSerialNo);
	BusinessObject loan = bom.loadObjectWithKey(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
	BusinessObject businessPutout = bom.loadObjectWithKey(sDocumentType, sDocumentSerialNo);
	
	String sAccountNo1 = Sqlca.getString("Select AccountNo from ACCT_DEPOSIT_ACCOUNTS where ObjectType='"+sDocumentType+"' and ObjectNo='"+sDocumentSerialNo+"' and Accountindicator='01' ");
	String sAccountNo2 = Sqlca.getString("Select AccountNo from ACCT_DEPOSIT_ACCOUNTS where ObjectType='"+sDocumentType+"' and ObjectNo='"+sDocumentSerialNo+"' and Accountindicator='05' and PRI='1' ");
	
	String rateSerialno = Sqlca.getString("SELECT * FROM ACCT_RATE_SEGMENT WHERE OBJECTTYPE='"+loan.getObjectType()+"' AND OBJECTNO='"+loan.getObjectNo()+"' AND RATETERMID='RAT001' AND SEGFROMDATE<=(SELECT businessdate FROM system_setup)");
	BusinessObject rateSegment = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, rateSerialno);
	String LoanNo=Sqlca.getString("Select LoanNo from Business_Duebill where LoanSerialNo='"+loan.getObjectNo()+"'");
%>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>

<table width="621" height="330">
  <tr>
    <td colspan="3" align="right" style="padding-bottom:20px;"><%=sYear%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sMonth%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDay%>&nbsp;</td>
  </tr>
  <tr>
    <td width="263"> 业务内容：&nbsp;<%=NameManager.getBusinessType(loan.getString("BusinessType"))%></td>
    <td width="230"> 流水号：&nbsp;<%=transaction.getString("CoreReturnSerialNo") %></td>
    <td width="123">&nbsp;</td>
  </tr>
  <tr>
    <td >借据号：&nbsp;<%=LoanNo%></td>
    <td>贷款金额：&nbsp;<%=DataConvert.toMoney(loan.getDouble("BusinessSum"))%>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>交易类型：&nbsp;<%=transaction.getString("TransName") %></td>
    <td>贷款币种：&nbsp;<%=CodeManager.getItemName("Currency",loan.getString("Currency"))%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">还款方式：&nbsp;<%=CodeManager.getItemName("LoanPayMethod",loan.getString("RPTTERMID"))%></td>
  </tr>
  <tr>
    <td colspan="3">客户名称：&nbsp;<%=loan.getString("CustomerName") %></td>
  </tr>
  <tr>
    <td>放款账号：&nbsp;<%=sAccountNo1 %></td>
    <td>结算账号：&nbsp;<%=sAccountNo2 %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>发放日期：&nbsp;<%=loan.getString("PutoutDate") %></td>
    <td>到期日期：&nbsp;<%=loan.getString("MaturityDate") %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>期限(月)：&nbsp;<%=businessPutout.getString("TermMonth") %></td>
    <td>利率调整方式：&nbsp;<%=CodeManager.getItemName("RepriceType",loan.getString("REPRICETYPE"))%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>基准利率(年利率)：&nbsp;<%=rateSegment.getDouble("BaseRate") %>&nbsp;%</td>
    <td>执行利率(月利率)：&nbsp;<%=rateSegment.getDouble("BusinessRate") %>&nbsp;‰</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>浮动方式：&nbsp;<%=CodeManager.getItemName("RateFloatType",rateSegment.getString("RateFloatType")) %></td>
    <td>浮动值：&nbsp;<%=rateSegment.getDouble("RateFloat") %></td>
    <td>&nbsp;</td>
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
			RunMethod("LoanAccount","UpdatePrintCount","<%=sDocumentSerialNo%>"+","+"001"+","+sPrintCount);
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