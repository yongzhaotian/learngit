<%@page import="com.amarsoft.awe.common.attachment.FileNameHelper"%>
<%@page import="java.io.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* http形式的下载文件
	*/
	String sDocNo = CurPage.getParameter("DocNo");
	String sAttachmentNo = CurPage.getParameter("AttachmentNo");

	ASResultSet rs = null;
	InputStream is = null;
	FileOutputStream fos = null;
	try{
		SqlObject asql = new SqlObject("select * from doc_attachment where DocNo = :DocNo and AttachmentNo = :AttachmentNo");
		asql.setParameter("DocNo", sDocNo).setParameter("AttachmentNo", sAttachmentNo);
		rs = Sqlca.getASResultSet(asql);
		if(rs.next()){
			String sFileName = rs.getString("FileName");
			String sFileSaveMode = rs.getString("FileSaveMode");
			String sFullPath;
			int iLen = rs.getInt("ContentLength");
			System.out.println(sFileName +" "+sFileSaveMode);
			if("Disk".equals(sFileSaveMode)){
				sFullPath = rs.getString("FullPath");
				is = new FileInputStream(sFullPath);
			}else{
				is = rs.getBinaryStream("DocContent");
			}
			String sFilePath = "/Upload/"+sDocNo.substring(0,4)+"/"+sDocNo.substring(4,6)+"/"+sDocNo.substring(6,8);
			//查看是否有相关的目录
			sFullPath = request.getRealPath(sFilePath);
			java.io.File dFile = new java.io.File(sFullPath);
			if(!dFile.exists()) dFile.mkdirs();
			
			sFilePath += "/" + sDocNo+"_"+sAttachmentNo+"_"+StringFunction.getFileName(sFileName);
			dFile = new java.io.File(request.getRealPath(sFilePath));
			if(!dFile.exists()) dFile.createNewFile();
			fos = new java.io.FileOutputStream(dFile);
			
			byte abyte0[] = new byte[iLen];
            int k;
            while((k = is.read(abyte0, 0, iLen)) != -1){
            	fos.write(abyte0, 0, k);
			}
%>
<script type="text/javascript">
	window.open("<%=sWebRootPath + sFilePath%>","_blank");
	top.close();
</script>
<%
			// out.print("<a href="+sWebRootPath + sFilePath + ">"+sFileName+"</a>");
		}else{
			out.print("文件不存在！");
		}
	}finally{
		if(rs != null){
			rs.getStatement().close();
			rs = null;
		}
		if(is != null){
			is.close();
		}
		if(fos != null){
			fos.close();
		}
	}
%>
<%@ include file="/IncludeEnd.jsp"%>