<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�����¿��ҳ��
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	if(sTemp==null) sTemp="";
%>
<script type="text/javascript">	
	AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyList.jsp","temp=<%=sTemp%>&SerialNo=<%=sSerialNo%>","rightup","");
</script>

<%@ include file="/IncludeEnd.jsp"%>
