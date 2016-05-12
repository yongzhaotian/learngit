<%@ page contentType="text/html; charset=GBK"%>
<%@page import ="java.io.*" %>
<%@
 include file="/IncludeBegin.jsp"%><%
	String sDocNo = DataConvert.toString((String)CurComp.getParameter("DocNo")); //文档编号
	String sAttachmentNo = DataConvert.toString((String)CurComp.getParameter("AttachmentNo")); //附件编号
	String sViewType = DataConvert.toString((String)CurComp.getParameter("ViewType")); //附件编号
	if(sViewType=="" || sViewType==null) sViewType = "view"; //"view" or "save"
	String sqlString = sViewType+"@"+sDocNo+"@"+sAttachmentNo;
	
	//判断文件是否存在
	 SqlObject sql = (new SqlObject("select DocNo,AttachmentNo,ContentType,ContentLength,FileSaveMode,FileName,FilePath,FullPath,DocContent from DOC_ATTACHMENT where DocNo=:DocNo and AttachmentNo=:AttachmentNo")).setParameter("DocNo", sDocNo).setParameter("AttachmentNo", sAttachmentNo);
	 String sFullPath = "";
	 String sFileName = "";
	 String sContentType = "";
	 ASResultSet  rs = Sqlca.getASResultSet(sql);
	 if(rs.next()){
		 sFullPath = DataConvert.toString(rs.getString("FullPath"));
		 sFileName = DataConvert.toString(rs.getString("FileName"));
		 sContentType = DataConvert.toString(rs.getString("ContentType"));
		 
	 }
	 rs.getStatement().close();
	 ARE.getLog().debug("全路径"+sFullPath);
	 File file = new File(sFullPath);
	 String sTextToShow ="文件["+sFileName+"]不存在!";
	 
%>
<html>
<!-- 增加自动关闭 下载完成后自动关闭 -->
<body onload='setTimeout("self.close()",1)'>
<%if(!file.exists()){ %>
<table><tr><td><span style="font-size:20px;color: red"><%=sTextToShow%></span></td></tr></table>
</body>
</html>
<%}else{ %>
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
<%} %>
<%@ include file="/IncludeEnd.jsp"%>