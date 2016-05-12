<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%

	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));//身份证号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//合同号
	
	if (sCertID == null) sCertID = "";
	if (sSerialNo == null) sSerialNo = "";

%>

<script type="text/javascript">
	//myleft.width=200;
	AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyDlog.jsp","SerialNo=<%=sSerialNo%>&CertID=<%=sCertID%>","rightup","");
	AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","","rightdown","");
</script>

<%@ include file="/IncludeEnd.jsp"%>
