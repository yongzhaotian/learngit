<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 
 <p style=margin-left:10px;margin-top:5px;font-size:16px;color:#4169e1; >����ƻ���ϸ</p>
<%	
	ASObjectModel doTemp = new ASObjectModel("PaymentScheduleTemp");
	doTemp.setReadOnly("SEQID",true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0";//�༭ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {};
%> 
<table style="margin-left:10px;">
<tr>
	<td >�ϼƣ�</td>
	<td >�����ܶ</td><td><input type="text" size="10" value="" style="text-align:right;"/></td>
	<td >��Ϣ�ܶ</td><td><input type="text" size="10" value="" style="text-align:right;"/></td>
	<td >�����ܶ</td><td><input type="text" size="10" value="" style="text-align:right;"/></td>
</tr>
</table>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<%@include file="/Frame/resources/include/include_end.jspf"%>


<%-- <%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> --%>

<%-- <%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
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
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0";//�༭ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����","����","as_add(0)","","","",""},
		{"true","","Button","����","����","as_save(0)","","","",""},
		{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@
 include file="/Frame/resources/include/include_end.jspf"%> --%>
