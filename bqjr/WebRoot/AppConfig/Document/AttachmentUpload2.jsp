<%@page import="java.io.File"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 
	
	//定义数据库操作变量
	SqlObject so = null;
	String sNewSql = "";
	
	String sDocNo = (String)myAmarsoftUpload.getRequest().getParameter("DocNo"); //文档编号
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //文件名称
	sFileName = URLDecoder.decode(sFileName, "UTF-8");
	sDocNo = String.valueOf(Math.abs(sFileName.hashCode()));
	
	String sFileSavePath = CurConfig.getConfigure("FileSavePath");
	// 如果不存在，则新建
	File dirFile = new File(sFileSavePath);
	if (!dirFile.exists()) dirFile.mkdirs();
	String absPath = dirFile.getAbsolutePath();
	
	//String sFullPath = sFileSavePath + "/" + sDocNo + sFileName.substring(sFileName.indexOf("."));
	String sFullPath = absPath + File.separator + sDocNo + sFileName.substring(sFileName.indexOf("."));
	
	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
		myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
	}
	
	sFullPath = sFullPath.replaceAll("\\\\", "/");
	
%>
<script type="text/javascript">
    //alert(getHtmlMessage(13));//上传文件成功！
    //parent.openComponentInMe();
    self.returnValue="<%=sFullPath %>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>