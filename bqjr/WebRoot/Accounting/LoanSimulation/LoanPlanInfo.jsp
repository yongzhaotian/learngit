<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 
 <p style=margin-left:10px;margin-top:5px;font-size:16px;color:#4169e1; >还款计划明细</p>
<%	
	ASObjectModel doTemp = new ASObjectModel("PaymentScheduleTemp");
	doTemp.setReadOnly("SEQID",true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//编辑模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {};
%> 
<table style="margin-left:10px;">
<tr>
	<td >合计：</td>
	<td >本金总额：</td><td><input type="text" size="10" value="" style="text-align:right;"/></td>
	<td >利息总额：</td><td><input type="text" size="10" value="" style="text-align:right;"/></td>
	<td >还款总额：</td><td><input type="text" size="10" value="" style="text-align:right;"/></td>
</tr>
</table>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<%@include file="/Frame/resources/include/include_end.jspf"%>


<%-- <%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> --%>

<%-- <%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<% 
	 String sBusinessSum =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessSum")));
	 String sRateYear =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RateYear")));
	 String sRepayFrequency =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RepayFrequency")));
	 String sPutOutDate =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutOutDate")));
	 String sTermMonth =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermMonth")));
	 String sFirstRepaymentDate =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FirstRepaymentDate")));
	 if (sBusinessSum == null) sBusinessSum = "";
	 if (sRateYear == null) sRateYear = "";
	 if (sRepayFrequency == null) sRepayFrequency = "";
	 if (sPutOutDate == null) sPutOutDate = "";
	 if (sTermMonth == null) sTermMonth = "";
	 if (sFirstRepaymentDate == null) sFirstRepaymentDate = "";
%>
<%/*~END~*/%>  
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	doTemp.setReadOnly("SERIALNO",true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//编辑模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","as_add(0)","","","",""},
		{"true","","Button","保存","保存","as_save(0)","","","",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@
 include file="/Frame/resources/include/include_end.jspf"%> --%>
