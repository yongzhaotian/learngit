<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�����¿��ҳ��
 */
%>
<%
	String sBoxID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("boxID"));
	if(sBoxID == null) sBoxID = "";
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/AppConfig/Document/ContractFileDJList.jsp","temp=1&boxID=<%=sBoxID%>","rightup","");
	AsControl.OpenView("/AppConfig/Document/ContractFileDJList.jsp","temp=2","rightdown","");
</script>

<%@ include file="/IncludeEnd.jsp"%>
