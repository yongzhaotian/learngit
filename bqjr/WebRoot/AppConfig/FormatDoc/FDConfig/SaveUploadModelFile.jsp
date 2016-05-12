<%@page import="com.amarsoft.are.jbo.*"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<style>
.divupload{
	font-size:12px;
	text-align:center;
	padding:10px;
}
</style>
<%
AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
myAmarsoftUpload.initialize(pageContext);
myAmarsoftUpload.upload();
String sDocId = (String)myAmarsoftUpload.getRequest().getParameter("DOCID");
String sDirId = (String)myAmarsoftUpload.getRequest().getParameter("DIRID");
//获得文件名
BizObjectManager manager = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DEF");
BizObjectKey key = manager.getBizObjectKey();
key.setAttributeValue("DOCID",sDocId);
key.setAttributeValue("DIRID",sDirId);
BizObject obj = manager.getBizObject(key);
if(obj==null){
	out.println("<div class=\"divupload\">没有找到合适记录</div>");
	return;
}
String sTemplateFileName = obj.getAttribute("HTMLFILENAME").getString();
try{
	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
		String sPhisicalPath = request.getRealPath(sTemplateFileName);
		ARE.getLog().trace("sPhisicalPath=" + sPhisicalPath);
		myAmarsoftUpload.getFiles().getFile(0).saveAs(sPhisicalPath);
		%>
		<div class="divupload">成功上传到<%=sTemplateFileName %> 【<a href="javascript:void()" onclick="window.close()">关闭</a>】</div>
		<%
	}else{
		out.println("<div class=\"divupload\">未发现文件上传</div>");
		return;
	}
}catch(Exception e){
	e.printStackTrace();
	out.println("<div class=\"divupload\">模板文件上传失败："+ e.toString() + "</div>");
	ARE.getLog().error("模板文件上传失败："+ e.toString());
}
%>
<%@ include file="/IncludeEnd.jsp"%>