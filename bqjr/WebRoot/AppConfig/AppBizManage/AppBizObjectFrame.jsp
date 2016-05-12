<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 业务对象左右框架页面
 */
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">
	myleft.width=650;//设置左边区域宽度
	AsControl.OpenView("/AppConfig/AppBizManage/AppBizObjectList.jsp","","frameleft","");
</script>
<%@ include file="/IncludeEnd.jsp"%>