<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("type"));
if(sType==null || sType.equals("") || sType.equals("null")) sType = "export";
%>
<html>
<head><title>请稍候...</title></head>
<body>
<div align=center>
<br>
<font style="font-size:9pt;color:red">正在从服务器获取数据,请稍候...</font>
</div>
<iframe name="sp1" style="display:none" width=100% height=100% frameborder=0></iframe>
</body>
</html>
<script type="text/javascript">
	window.open(sPath+"GetDWDataAll3.jsp?type=<%=sType%>&dw=<%=sDWName%>&rand="+Math.abs(Math.sin((new Date()).getTime())),"sp1");
</script>
<%@ include file="/Resources/Include/IncludeTail.jspf"%>