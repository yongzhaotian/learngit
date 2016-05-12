<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xdhou 2004.03.24
 * Tester:
 * Content: 上传文件附件
 * Input Param:
 *                  SerialNo:流水号-目录号
 * Output param:
 * History Log:     
 */
%>
<%@page import="com.amarsoft.awe.common.attachment.AmarsoftUpload"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sAttachmentNo="";
	ASResultSet rs=null;
    String sSerialNo=  DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
    String sFileName = "",sFileExt = "";
		
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);              
	myAmarsoftUpload.upload();                             
                                                           
	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
		try{
			sFileName = DataConvert.toRealString(iPostChange,myAmarsoftUpload.getFiles().getFile(0).getFilePathName());
			System.out.println(sFileName);
			//sFileName = StringFunction.replace(sFileName," ","");
			//sFileName = "/FormatDoc/Upload/"+sSerialNo+"_"+StringFunction.getFileName(sFileName);
			int iPos = sFileName.lastIndexOf(".");
			if(iPos == -1) 
				sFileExt = ".gif";
			else
				sFileExt = sFileName.substring(iPos);
			String sRand = String.valueOf(Math.random());
			sFileName = "/FormatDoc/Upload/"+sSerialNo+"_"+sRand+sFileExt;
			System.out.println(sFileName);
			myAmarsoftUpload.getFiles().getFile(0).saveAs(sFileName);
			myAmarsoftUpload = null;			
		}catch(Exception e){
			System.out.println("An error occurs : " + e.toString());				
			myAmarsoftUpload = null;
%>			
			<script type="text/javascript">
				alert("上传失败！");
				self.close();
			</script>
<%
		}			
	}
%>
<script type="text/javascript">
	//alert("上传成功！");
	window.opener.HtmlEdit.document.body.innerHTML = window.opener.HtmlEdit.document.body.innerHTML+"<br><img width=600 src='<%=sWebRootPath%><%=sFileName%>'>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>