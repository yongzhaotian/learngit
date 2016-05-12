<%@ page language="java" import="com.amarsoft.are.jbo.*,java.io.*" contentType="text/html; charset=GBK" pageEncoding="GBK"%><%@
 include file="/IncludeBegin.jsp"%><%@
 page import="com.amarsoft.awe.common.attachment.*,com.amarsoft.awe.common.attachment.File,com.amarsoft.biz.formatdoc.model.*" %>
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
String sObjectType=myAmarsoftUpload.getRequest().getParameter("ObjectType");
String sObjectNo =myAmarsoftUpload.getRequest().getParameter("ObjectNo");
if(sObjectType==null)sObjectType="";
if(sObjectNo==null)sObjectNo="";

String sBasePath = CurConfig.getConfigure("WorkDocOfflineSavePath");
//不存在目录则创建
java.io.File fileSS = new java.io.File(sBasePath);
if(fileSS.exists()==false)fileSS.mkdirs();
String sFileName = java.util.UUID.randomUUID().toString() + ".amardoc";
try{
	File file = myAmarsoftUpload.getFiles().getFile(0);
	if (!file.isMissing()){
		//System.out.println("file.getFileExt()=" + file.getFileExt());
		if(!file.getFileExt().toLowerCase().equals("amardoc")){
			out.println("<div class=\"divupload\">无效的文件名! <a href='#' onclick='history.back()'>返回</a></div>");
			return;
		}
		file.saveAs(sBasePath +"/"+ sFileName);//保存临时文件
		System.out.println("保存临时文件" + sBasePath  +"/"+ sFileName);
		//文件解析
		AmarDocParser parser = new AmarDocParser(sObjectType,sObjectNo,CurUser);
		parser.unzip(sBasePath +"/"+ sFileName ,CurConfig.getConfigure("FileSavePath"),request.getScheme()+"://" + request.getServerName() + ":" + request.getServerPort() + sWebRootPath);
		//重定向文件存储位置
		/*
		IFormatTool formatTool = FormatToolManager.getFormatTool(parser.getDocID(),"");
		String sNewFileSavePath = formatTool.getOfflineFilePath(parser.getObjectType(),parser.getObjectNo(),parser.getDocID());
		if(sNewFileSavePath.length()>0){
			sNewFileSavePath = sNewFileSavePath + "/" + sFileName;
			file.saveAs(sNewFileSavePath);
			System.out.println("文件重定向到" + sNewFileSavePath);
		}
		*/
		//删除临时文件
		new java.io.File(sBasePath  +"/"+ sFileName).delete();
		System.out.println("删除临时文件" + sBasePath  +"/"+ sFileName);
		//新增FORMATDOC_OFFLINE记录
		/*
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_OFFLINE");
		//String sOfflineSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_OFFLINE","SERIALNO",new Transaction(bmFO.getDatabase()));
		BizObject boFO = bmFO.newObject();
		//boFO.setAttributeValue("SERIALNO", sOfflineSerialNo);
		boFO.setAttributeValue("OBJECTTYPE", sObjectType);
		boFO.setAttributeValue("OBJECTNO", sObjectNo);
		boFO.setAttributeValue("DOCID", parser.getDocID());
		boFO.setAttributeValue("SAVEPATH", sFileName);
		boFO.setAttributeValue("ORGID", CurUser.getOrgID());
		boFO.setAttributeValue("USERID", CurUser.getUserID());
		boFO.setAttributeValue("INPUTDATE", StringFunction.getToday());
		boFO.setAttributeValue("DIRECTION", "up");
		bmFO.saveObject(boFO);
		*/
		//更新数据库中的文档信息
		parser.updateDocument();
		%>
		<div class="divupload">文件导入成功 !<br>文档编号为：<%=parser.getDocID()%><br>业务对象分类：<%=parser.getObjectType()%><br>业务对象编号：<%=parser.getObjectNo()%><br>【<a href="javascript:void()" onclick="window.close()">关闭</a>】</div>
		<%
	}
	else{
		out.println("<div class=\"divupload\">未发现文件上传 <a href='javascript:history.back()'>返回</a></div>");
		return;
	}
}
catch(Exception e){
	e.printStackTrace();
	out.println("<div class=\"divupload\">文件导入失败："+ e.toString() + " <a href='javascript:history.back()'>返回</a></div>");
	ARE.getLog().error("文件导入失败："+ e.toString());
}

%>
<%@ include file="/IncludeEnd.jsp"%>