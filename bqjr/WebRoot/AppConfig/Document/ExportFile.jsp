<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sqlString = "select DocNo,AttachmentNo,FileName,FileSaveMode,ContentLength,DocContent,FilePath,FullPath from DOC_ATTACHMENT ";
	ASResultSet rs0 = Sqlca.getResultSet(new SqlObject(sqlString));
	while(rs0.next()){
		String sPath="";
		String sDocNo = rs0.getString("DocNo");
		String sAttachmentNo = rs0.getString("AttachmentNo");
		String sFileName = rs0.getString("FileName");
		String sFileSaveMode = rs0.getString("FileSaveMode");
		String sContentLength = rs0.getString("ContentLength");
		
		if(sContentLength != "" && !sContentLength.equals("0")){
			//查看是否有相关的目录
			sPath = request.getRealPath("/Upload/"+sDocNo.substring(0,4)+"/"+sDocNo.substring(4,6)+"/"+sDocNo.substring(6,8)); 
			java.io.File dFile = new java.io.File(sPath);
			if(!dFile.exists()) dFile.mkdirs();
			
			dFile = new java.io.File(sPath,sDocNo+"_"+sAttachmentNo+"_"+StringFunction.getFileName(sFileName));
			if(!dFile.exists()) dFile.createNewFile();
			java.io.FileOutputStream fileOut = new java.io.FileOutputStream(dFile);
			
			InputStream is0 = null;
			if("Disk".equals(sFileSaveMode)){ //存放文件服务器中
				is0 = new FileInputStream(rs0.getString("FullPath"));
			}else{								 //存放数据表中
				is0 = rs0.getBinaryStream("DocContent");
			}
			
			int iLen = rs0.getInt("ContentLength");
			byte abyte0[] = new byte[iLen];
			int k;
			while((k = is0.read(abyte0, 0, iLen)) != -1){
				//System.out.println(k);
				fileOut.write(abyte0, 0, k);
			}
			fileOut.close();
			is0.close();
		}
	}
	rs0.getStatement().close();
%>
<%@	include file="/IncludeEnd.jsp"%>