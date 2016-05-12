<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDocNo = DataConvert.toString((String)CurComp.getParameter("DocNo")); //ÎÄµµ±àºÅ
	String sAttachmentNo = DataConvert.toString((String)CurComp.getParameter("AttachmentNo")); //¸½¼ş±àºÅ
	String sViewType = DataConvert.toString((String)CurComp.getParameter("ViewType")); //¸½¼ş±àºÅ
	if(sViewType=="" || sViewType==null) sViewType = "view"; //"view" or "save"
	String sqlString = sViewType+"@"+sDocNo+"@"+sAttachmentNo;
%>
<html>
<body>
<iframe name="MyAtt" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"ÕıÔÚÏÂÔØ¸½¼ş£¬ÇëÉÔºò...")%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%	if(sViewType.equals("view")){%>
<form name=form1 method=post action="<%=sWebRootPath%>/servlet/view/attachment">
	<div style="display:none">
		<input name=sqlString value="<%=sqlString%>">
	</div>
</form>
<script type="text/javascript">
	form1.submit();
</script>
<%	}else{%>	
<form name=form1 method=post action="<%=sWebRootPath%>/servlet/view/attachment" target=MyAtt>
	<div style="display:none">
		<input name=sqlString value="<%=sqlString%>">
	</div>
</form>
<script type="text/javascript">
	form1.submit();
</script>
<%	}%>	
<%@ include file="/IncludeEnd.jsp"%>