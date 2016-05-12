<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%


	String sOperateType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
 	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
 	if(sOperateType == null) sOperateType = "";
 	if(sSerialNo == null) sSerialNo = "";
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript"> 

AsControl.OpenView("/CustomService/BusinessConsult/RepaymentChannelBasics.jsp","SerialNo=<%=sSerialNo%>&OperateType=<%=sOperateType%>","rightup","");
AsControl.OpenView("/CustomService/BusinessConsult/RepaymentChannelDetails.jsp","SerialNo=<%=sSerialNo%>&OperateType=<%=sOperateType%>","rightdown","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
