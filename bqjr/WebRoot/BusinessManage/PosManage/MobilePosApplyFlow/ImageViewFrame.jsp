<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�����¿��ҳ��
 */
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<%

	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	

	if (sSerialNo == null) sSerialNo = "";

%>

<script type="text/javascript">
	myleft.width=200;
	AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ImageView.jsp","SerialNo=<%=sSerialNo%>","frameleft","");
</script>

<%@ include file="/IncludeEnd.jsp"%>
