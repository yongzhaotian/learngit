<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.util.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	
	String sDocumentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentType"));
	String sDocumentSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentSerialNo"));
	
	//打印业务凭证还款(收费)
	
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
	
	BusinessObject transFer = bom.loadObjectWithKey(sDocumentType, sDocumentSerialNo);
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
    <td width="258"> 业务内容：&nbsp;<%=NameManager.getBusinessType(loan.getString("BusinessType"))%></td>
    <td width="228"> 流水号：&nbsp;<%=transaction.getString("CoreReturnSerialNo") %></td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr>
    <td >借据号：&nbsp;<%=LoanNo%></td>
    <td>交费金额：&nbsp;<%=transFer.getDouble("ACTUALFEEAMOUNT") %>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>费用类型：&nbsp;<%=transFer.getString("FEETYPE") %></td>
    <td>币种：&nbsp;<%=CodeManager.getItemName("Currency",transFer.getString("Currency"))%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">客户名称：&nbsp;<%=loan.getString("CustomerName") %></td>
  </tr>
  <tr>
    <td colspan="3">交费账号：&nbsp;<%=transFer.getString("RECIEVEACCOUNTNO") %></td>
  </tr>
  <tr>
    <td colspan="3">交费人名称：&nbsp;<%=transFer.getString("RECIEVEACCOUNTNAME") %></td>
  </tr>
  <tr>
    <td>经办柜员：<%=transaction.getString("InputUserID") %> 复核柜员：<%=transaction.getString("TransUserID") %></td>
    <td>交易机构：<%=transaction.getString("TransOrgID") %>交易码：<%=transaction.getString("TransCode") %></td>
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