<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%

//定义变量                     
String sSql = "";   	
String sSerialNo=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
String sType=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));

String sObjectType = "MobilePosApply";
ARE.getLog().debug("RetailAttachmentList.jsp参数    sSerialNo="+sSerialNo+"Type="+sType);
%>

<script type="text/javascript">
	//myleft.width=200;
	AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosAttachmentList.jsp","SerialNo=<%=sSerialNo%>&Type=<%=sType%>","rightup","");
	AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ImageViewInfoPos.jsp","","rightdown","");
</script>

<%@ include file="/IncludeEnd.jsp"%>
