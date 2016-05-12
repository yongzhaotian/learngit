<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.util.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	
	String sDocumentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentType"));
	String sDocumentSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentSerialNo"));
	
	//��ӡҵ��ƾ֤(�ſ�)
	
	String sBusinessDate = SystemConfig.getBusinessDate();//��ǰϵͳ����
	String sYear = sBusinessDate.substring(0,4);//��ǰ��
	String sMonth = sBusinessDate.substring(5,7);//��ǰ��
	String sDay = sBusinessDate.substring(8,10);//��ǰ��
	int sCount = 1;
	
	//��������
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
    <td width="263"> ҵ�����ݣ�&nbsp;<%=NameManager.getBusinessType(loan.getString("BusinessType"))%></td>
    <td width="230"> ��ˮ�ţ�&nbsp;<%=transaction.getString("CoreReturnSerialNo") %></td>
    <td width="123">&nbsp;</td>
  </tr>
  <tr>
    <td >��ݺţ�&nbsp;<%=LoanNo%></td>
    <td>�����&nbsp;<%=DataConvert.toMoney(loan.getDouble("BusinessSum"))%>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>�������ͣ�&nbsp;<%=transaction.getString("TransName") %></td>
    <td>������֣�&nbsp;<%=CodeManager.getItemName("Currency",loan.getString("Currency"))%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">���ʽ��&nbsp;<%=CodeManager.getItemName("LoanPayMethod",loan.getString("RPTTERMID"))%></td>
  </tr>
  <tr>
    <td colspan="3">�ͻ����ƣ�&nbsp;<%=loan.getString("CustomerName") %></td>
  </tr>
  <tr>
    <td>�ſ��˺ţ�&nbsp;<%=sAccountNo1 %></td>
    <td>�����˺ţ�&nbsp;<%=sAccountNo2 %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>�������ڣ�&nbsp;<%=loan.getString("PutoutDate") %></td>
    <td>�������ڣ�&nbsp;<%=loan.getString("MaturityDate") %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>����(��)��&nbsp;<%=businessPutout.getString("TermMonth") %></td>
    <td>���ʵ�����ʽ��&nbsp;<%=CodeManager.getItemName("RepriceType",loan.getString("REPRICETYPE"))%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>��׼����(������)��&nbsp;<%=rateSegment.getDouble("BaseRate") %>&nbsp;%</td>
    <td>ִ������(������)��&nbsp;<%=rateSegment.getDouble("BusinessRate") %>&nbsp;��</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>������ʽ��&nbsp;<%=CodeManager.getItemName("RateFloatType",rateSegment.getString("RateFloatType")) %></td>
    <td>����ֵ��&nbsp;<%=rateSegment.getDouble("RateFloat") %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>�����Ա��<%=transaction.getString("InputUserID") %> ���˹�Ա��<%=transaction.getString("TransUserID") %></td>
    <td>���׻�����<%=transaction.getString("TransOrgID") %> �����룺<%=transaction.getString("TransCode") %></td>
    <td>����ʱ�䣺<%=transaction.getString("TransDate") %></td>
  </tr>
</table>

<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right" id="print">
            <%=HTMLControls.generateButton("��ӡ","��ӡ����֪ͨ��","javascript: my_Print()",sResourcesPath)%>
        </td>
        <td align="left" id="back">
            <%=HTMLControls.generateButton("����","����","javascript: window.close();",sResourcesPath)%>
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