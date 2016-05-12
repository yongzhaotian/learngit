<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//获得组件参数
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
	    //如果产品为授信额度时，那么进入授信额度详情界面
		if(sBusinessType.startsWith("3")) 
		{	
			if(sObjectType.equalsIgnoreCase("ReinforceContract")){
				%>
				//额度补登用ReinforceCreditLineView来实现
				OpenPage("/InfoManage/DataInput/InputCreditLineView.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
				<%
			}else{
				%>
				//授信额度的申请、批复、合同统一用CreditLineView来实现
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
