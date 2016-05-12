<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.util.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	
	String sDocumentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentType"));
	String sDocumentSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentSerialNo"));
	
	//打印业务凭证还款(保证金返回)
	
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
	
	
	BusinessObject bailInfo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.bail_info, sDocumentSerialNo);//保证金信息
%>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>
<table width="627" height="330">
  <tr>
    <td colspan="3" align="right" style="padding-bottom:20px;"><%=sYear%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sMonth%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDay%>&nbsp;</td>
  </tr>
  <tr>
    <td width="266"> 业务内容：&nbsp;<%=NameManager.getBusinessType(loan.getString("BusinessType"))%></td>
    <td width="231"> 流水号：&nbsp;<%=transaction.getString("CoreReturnSerialNo") %></td>
    <td width="108">&nbsp;</td>
  </tr>
  <tr>
    <td >借据号：&nbsp;<%=loan.getObjectNo()%></td>
    <td>保证金金额：&nbsp;<%=loan.getDouble("BusinessSum") %>&nbsp;元</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>币种：&nbsp;<%=CodeManager.getItemName("Currency",loan.getString("Currency"))%></td>
    <td>交易类型：&nbsp;<%=transaction.getString("TransName") %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">客户名称：&nbsp;<%=loan.getString("CustomerName") %></td>
  </tr>
  <tr>
    <td colspan="3">保证金账号：&nbsp;<%=bailInfo.getString("BailAccout") %></td>
  </tr>
  <tr>
    <td colspan="3">保证金退回账号：&nbsp;<%=bailInfo.getString("BailBackAccountBankID") %></td>
  </tr>
  <tr>
    <td colspan="3">保证金退回账户名称：&nbsp;<%=bailInfo.getString("BailBackAccountBankName") %></td>
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