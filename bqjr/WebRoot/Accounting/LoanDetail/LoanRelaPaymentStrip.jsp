<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectNo==null) sObjectNo = "";
	if(sObjectType==null) sObjectType = "";
	
	String sStrips[][] = {
		{"true","还款计划" ,"500","PaymentScheduleList","/Accounting/LoanDetail/PaymentScheduleList.jsp","PayType=1&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&ToInheritObj=y",""},
		{"true","费用计划" ,"500","PaymentScheduleFeedList","/Accounting/LoanDetail/PaymentScheduleFeedList.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&ToInheritObj=y",""},
		{"true","还款记录" ,"500","PaymentRecordList","/Accounting/LoanDetail/PaymentRecordList.jsp","ObjectNo="+sObjectNo,""},
		{"true","费用记录" ,"500","ObjectTypeObjectNoTempletNo","/Accounting/LoanDetail/ObjectTypeObjectNoTempletNo.jsp","TempletNo=FeeRecordList1&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,""},
		{"true","费用摊销记录" ,"500","feeamortizeRecordList","/Accounting/LoanDetail/feeamortizeRecordList.jsp","ObjectNo="+sObjectNo,""},
	};
	
%>

<%@include file="/Resources/CodeParts/Strip05.jsp"%>
<script language="JavaScript">
	
</script>


<script language="javascript">	
	
</script>
<%@ include file="/IncludeEnd.jsp"%>
