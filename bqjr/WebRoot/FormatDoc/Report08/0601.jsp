<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//获得组件参数
	//必须的参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sDocID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sAttribute = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Attribute"));
	if(sAttribute == null) sAttribute = " ";
	
	//获得调查报告数据
	String sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//担保客户ID号
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	//获得保证人客户类型
	sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = '"+sGuarangtorID+"'";
	String sCustomerType = "";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sCustomerType = rs2.getString(1);
	rs2.getStatement().close();
	if(sCustomerType==null) sCustomerType="";
	sCustomerType=sCustomerType.substring(0,2);
	
	
	
%>


<script type="text/javascript">
	<%
		if(sCustomerType.equals("01")) //
		{
	%>		
		OpenPage("/FormatDoc/Report02/060101.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&DocID=<%=sDocID%>&SerialNo=<%=sSerialNo%>&Attribute=<%=sAttribute%>","_self","");
	<%
		}else
		{
	%>
		OpenPage("/FormatDoc/Report02/060108.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&DocID=<%=sDocID%>&SerialNo=<%=sSerialNo%>&Attribute=<%=sAttribute%>","_self","");
	<%
		}
	%>
</script>
<%@ include file="/IncludeEnd.jsp"%>
