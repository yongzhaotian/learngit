<%@page import="java.io.FileOutputStream"%>
<%@ page contentType="text/html; charset=GBK" import="com.amarsoft.awe.common.attachment.*,com.amarsoft.are.jbo.*"%><%@
include file="/Frame/resources/include/include_begin.jspf"
%><%
	String sAttachmentNo="";
    String sSerialNo=  "";
    String sFileName = "";
    
    String sErrorDesc="";
    String errorTitle="";
    String sDono="";
    String sUrl="";
    String sDomain="";
    
    
    AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	//java.lang.NegativeArraySizeException
	
	
	try{
		myAmarsoftUpload.upload();
		File rfile = myAmarsoftUpload.getFiles().getFile(0);
			
		sErrorDesc = myAmarsoftUpload.getRequest().getParameter("taError");
		sDono =  myAmarsoftUpload.getRequest().getParameter("dono");
		if(sDono==null)sDono="";
		sUrl = myAmarsoftUpload.getRequest().getParameter("url");
		if(sUrl==null)sUrl="";
		sDomain =  myAmarsoftUpload.getRequest().getParameter("domain");
		if(sDomain ==null)sDomain = "";
		
		String sBasePath = CurConfig.getConfigure("SnapShot");
		//不存在目录则创建
		java.io.File fileSS = new java.io.File(sBasePath);
		if(fileSS.exists()==false)fileSS.mkdirs();
		//根据当前日期创建文件夹
		String sToday = StringFunction.getToday();
		java.io.File file = new java.io.File(sBasePath+ "/" + sToday);
		if(file.exists()==false)file.mkdirs();
		if (!rfile.isMissing()){
			String sFileExt = rfile.getFileExt().toLowerCase();
			if(sFileExt==null || sFileExt.trim().length()==0)
				sFileExt= "gif";
			if(!rfile.getTypeMIME().equals("image")){
				out.println("无效的文件类型");
				return;
			}
			else{
				sFileName = sBasePath+ "/" + sToday + "/" + java.util.UUID.randomUUID().toString() + "." + sFileExt;
				rfile.saveAs(sFileName);
			}
		}
	}
	catch(java.lang.NegativeArraySizeException e){
		return;
	}
	
	
	//保存到数据库
	try{
		BizObjectManager manager = JBOFactory.getFactory().getManager("jbo.awe.AWE_ERROR_REPORT");
		BizObject bo = manager.newObject();
		bo.setAttributeValue("REPORTDESC",sErrorDesc);
		bo.setAttributeValue("REPORTPIC",sFileName);
		bo.setAttributeValue("INPUTTIME",StringFunction.getTodayNow());
		bo.setAttributeValue("INPUTUSER",CurUser.getUserID());
		bo.setAttributeValue("REPORTDOMAIN",sDomain);
		bo.setAttributeValue("DONO",sDono);
		bo.setAttributeValue("URL",sUrl);
		bo.setAttributeValue("status",0);
		manager.saveObject(bo);
%>
		<script>
			alert('提交成功！');
			parent.AsDebug.closeErrorWindow();
		</script>
<%
	}
	catch(Exception ex){
		ex.printStackTrace();
		ARE.getLog().error("提交错误报告出错："+ ex.toString());
		%>
		<script>
			alert('系统错误，提交失败，请联系管理员！');
		</script>
		<%
	}
%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>