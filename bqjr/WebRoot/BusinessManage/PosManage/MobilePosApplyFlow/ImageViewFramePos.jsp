<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�����¿��ҳ��
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%

//�������                     
String sSql = "";   	
String sSerialNo=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
String sType=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));

String sObjectType = "MobilePosApply";
ARE.getLog().debug("RetailAttachmentList.jsp����    sSerialNo="+sSerialNo+"Type="+sType);
%>

<script type="text/javascript">
	//myleft.width=200;
	AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosAttachmentList.jsp","SerialNo=<%=sSerialNo%>&Type=<%=sType%>","rightup","");
	AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ImageViewInfoPos.jsp","","rightdown","");
</script>

<%@ include file="/IncludeEnd.jsp"%>
