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
//������Ŀ¼�򴴽�
java.io.File fileSS = new java.io.File(sBasePath);
if(fileSS.exists()==false)fileSS.mkdirs();
String sFileName = java.util.UUID.randomUUID().toString() + ".amardoc";
try{
	File file = myAmarsoftUpload.getFiles().getFile(0);
	if (!file.isMissing()){
		//System.out.println("file.getFileExt()=" + file.getFileExt());
		if(!file.getFileExt().toLowerCase().equals("amardoc")){
			out.println("<div class=\"divupload\">��Ч���ļ���! <a href='#' onclick='history.back()'>����</a></div>");
			return;
		}
		file.saveAs(sBasePath +"/"+ sFileName);//������ʱ�ļ�
		System.out.println("������ʱ�ļ�" + sBasePath  +"/"+ sFileName);
		//�ļ�����
		AmarDocParser parser = new AmarDocParser(sObjectType,sObjectNo,CurUser);
		parser.unzip(sBasePath +"/"+ sFileName ,CurConfig.getConfigure("FileSavePath"),request.getScheme()+"://" + request.getServerName() + ":" + request.getServerPort() + sWebRootPath);
		//�ض����ļ��洢λ��
		/*
		IFormatTool formatTool = FormatToolManager.getFormatTool(parser.getDocID(),"");
		String sNewFileSavePath = formatTool.getOfflineFilePath(parser.getObjectType(),parser.getObjectNo(),parser.getDocID());
		if(sNewFileSavePath.length()>0){
			sNewFileSavePath = sNewFileSavePath + "/" + sFileName;
			file.saveAs(sNewFileSavePath);
			System.out.println("�ļ��ض���" + sNewFileSavePath);
		}
		*/
		//ɾ����ʱ�ļ�
		new java.io.File(sBasePath  +"/"+ sFileName).delete();
		System.out.println("ɾ����ʱ�ļ�" + sBasePath  +"/"+ sFileName);
		//����FORMATDOC_OFFLINE��¼
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
		//�������ݿ��е��ĵ���Ϣ
		parser.updateDocument();
		%>
		<div class="divupload">�ļ�����ɹ� !<br>�ĵ����Ϊ��<%=parser.getDocID()%><br>ҵ�������ࣺ<%=parser.getObjectType()%><br>ҵ������ţ�<%=parser.getObjectNo()%><br>��<a href="javascript:void()" onclick="window.close()">�ر�</a>��</div>
		<%
	}
	else{
		out.println("<div class=\"divupload\">δ�����ļ��ϴ� <a href='javascript:history.back()'>����</a></div>");
		return;
	}
}
catch(Exception e){
	e.printStackTrace();
	out.println("<div class=\"divupload\">�ļ�����ʧ�ܣ�"+ e.toString() + " <a href='javascript:history.back()'>����</a></div>");
	ARE.getLog().error("�ļ�����ʧ�ܣ�"+ e.toString());
}

%>
<%@ include file="/IncludeEnd.jsp"%>