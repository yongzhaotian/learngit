<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	ASResultSet rs=null;
	String sSql = "";
	String sBusinessType = "";
		
	sSql = " select BusinessType from BUSINESS_CONTRACT where SerialNo =:SerialNo";
	sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));	
	if(sBusinessType == null) sBusinessType = "";
%>


<script type="text/javascript">
	<%
	    //�����ƷΪ���Ŷ��ʱ����ô�������Ŷ���������
		if(sBusinessType.startsWith("3")) 
		{	
			if(sObjectType.equalsIgnoreCase("ReinforceContract")){
				%>
				//��Ȳ�����ReinforceCreditLineView��ʵ��
				OpenPage("/InfoManage/DataInput/InputCreditLineView.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
				<%
			}else{
				%>
				//���Ŷ�ȵ����롢��������ͬͳһ��CreditLineView��ʵ��
				OpenPage("/CreditManage/CreditApply/CreditView.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
				<%	
			}
		}else
		{
			if(sObjectType.equalsIgnoreCase("ContractLoan")){
				%>
				OpenPage("/Accounting/LoanDetail/LoanDetailTab.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
				<%
			}
			else if(sObjectType.equalsIgnoreCase("Loan")){
				%>
				OpenPage("/Accounting/LoanDetail/AcctLoanView.jsp?ObjectNo=<%=sObjectNo%>","_self","");
				<%
			}
			else if(sObjectType.equalsIgnoreCase("Fee")){
				%>
				OpenPage("/Accounting/LoanDetail/LoanTerm/AcctFeeInfo.jsp?FeeSerialNo=<%=sObjectNo%>","_self","");
				<%
			}
			else if(sObjectType.equalsIgnoreCase("Transaction")){
				%>
				OpenPage("/Accounting/Transaction/TransactionInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
				<%
			}
			else{
				%>
				OpenPage("/CreditManage/CreditApply/CreditView.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
			<%
			}
		}
	%>
</script>
<%@ include file="/IncludeEnd.jsp"%>
