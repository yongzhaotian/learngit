<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: CCS-637 PRM-293 审核过程中审核要点功能维护
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>
 
 <%
	String sDocNo = DataConvert.toString((String)CurComp.getParameter("DocNo")); //文档编号
	String sAttachmentNo = DataConvert.toString((String)CurComp.getParameter("AttachmentNo")); //附件编号
	String sViewType = DataConvert.toString((String)CurComp.getParameter("ViewType")); //附件编号
	if(sViewType=="" || sViewType==null) sViewType = "view"; //"view" or "save"
	String sqlString = sViewType+"@"+sDocNo+"@"+sAttachmentNo;
%>
<html>
<body>
<iframe name="MyAtt" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"正在下载附件，请稍候...")%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
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