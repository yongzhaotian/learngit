<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.util.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	
	String sTransSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransSerialNo"));//��������ˮ��
//	String sCorereTurnSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CorereTurnSerialNo"));//��������ˮ��
	//��ӡҵ��ƾ֤(����)
	double jie=0,dai=0;
	String sBusinessDate = SystemConfig.getBusinessDate();//��ǰϵͳ����
	String sYear = sBusinessDate.substring(0,4);//��ǰ��
	String sMonth = sBusinessDate.substring(5,7);//��ǰ��
	String sDay = sBusinessDate.substring(8,10);//��ǰ��
	int sCount = 1;
	
	//��������
	String transactionSerialNo = Sqlca.getString("Select SerialNo from Acct_Transaction where DocumentType='"+BUSINESSOBJECT_CONSTATNTS.back_bill+"'"+" and DocumentSerialNo='"+sTransSerialNo+"'");
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject transaction = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction, transactionSerialNo);
	BusinessObject loan = bom.loadObjectWithKey(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
	ASValuePool as = new ASValuePool();	
	String whereClauseSql =" TransSerialNo = :TransSerialNo and BookType = 'B' " ;
	as.setAttribute("TransSerialNo", transactionSerialNo); 
	List<BusinessObject> detailArrayList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subledger_detail, whereClauseSql,as);
	String LoanNo=Sqlca.getString("Select LoanNo from Business_Duebill where LoanSerialNo='"+loan.getObjectNo()+"'");
%><head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>

<table width="720" border="1">
  <tr>
    <td height="50" colspan="6" align="center"><h2>���ƾ֤</h2></td>
  </tr>
  <tr>
    <td height="32" colspan="6" align="right"><%=sYear%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sMonth%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDay%>&nbsp;</td>
  </tr>
  <tr>
    <td width="79" height="31" >ҵ�����ݣ�</td>
    <td colspan="2">&nbsp;<%=NameManager.getBusinessType(loan.getString("BusinessType"))%></td>
    <td width="92">������ˮ�ţ�</td>
    <td colspan="2"><%=transaction.getString("CoreReturnSerialNo") %></td>
  </tr>
  <tr>
    <td height="31">��ݺţ�</td>
    <td colspan="2">&nbsp;<%=LoanNo%></td>
    <td>�ͻ����ƣ�</td>
    <td colspan="2">&nbsp;<%=loan.getString("CustomerName") %></td>
  </tr>
  <tr>
    <td>�������ͣ�</td>
    <td colspan="5" height="31" >&nbsp;<%=transaction.getString("TransName") %></td>
  </tr>
  <tr>
    <td height="31" colspan="6">���ķ�¼��<%=transaction.getString("CoreReturnSerialNo") %></td>
  </tr>
  <tr>
    <td height="30" width="50">��������</td>
    <td width="70">�˺�</td>
    <td width="140">����</td>
    <td width="100">�������</td>
    <td width="75">����</td>
    <td width="120">����</td>
  </tr>
  <%
  for(BusinessObject detailArray:detailArrayList){
	  %>
	  <tr>
	 	<td height="30"><%= CodeManager.getItemName("Ctrldir",detailArray.getString("Direction"))%></td>
  		<td><%=detailArray.getString("SortNo") %></td>
	    <td><%=detailArray.getString("AccountCodeName") %></td>
	    <%
	    	if(detailArray.getString("Direction").equals("D")){
	    		jie=jie+(detailArray.getDouble("DebitAmt") - detailArray.getDouble("CreditAmt"));
    		%>
    			<td align="right"><%= DataConvert.toMoney(detailArray.getDouble("DebitAmt") - detailArray.getDouble("CreditAmt"))%></td>
    		<%
	    	}else{
	    		dai=dai+(detailArray.getDouble("CreditAmt")-detailArray.getDouble("DebitAmt"));
	    	%>
    			<td align="right"><%= DataConvert.toMoney(detailArray.getDouble("CreditAmt")-detailArray.getDouble("DebitAmt")) %></td>
    		<%
	    	}
	    %>
	    <td><%=CodeManager.getItemName("Currency",detailArray.getString("Currency"))%></td>
	    <td><%=NameManager.getOrgName(detailArray.getString("AccountingOrgID")) %></td>
	  </tr>
	  <%
	}
  %>
 <tr>
    <td colspan="3" height="25">�跽���ϼƣ�&nbsp;&nbsp;<%=DataConvert.toMoney(jie)%></td>
    <td colspan="3">�������ϼƣ�&nbsp;&nbsp;<%=DataConvert.toMoney(dai) %></td>
  </tr>
   <tr>
    <td height="31" colspan="2">�����Ա��<%=transaction.getString("InputUserID") %></td>
    <td>���˹�Ա��<%=transaction.getString("TransUserID") %></td>
    <td>���׻�����<%=transaction.getString("TransOrgID") %></td>
    <td> �����룺<%=transaction.getString("TransCode") %></td>
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