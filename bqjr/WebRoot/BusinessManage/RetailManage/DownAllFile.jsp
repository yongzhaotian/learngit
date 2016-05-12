<%@page import="com.amarsoft.app.billions.ZipUtil"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import ="java.io.*" %>
<%@
 include file="/IncludeBegin.jsp"%>
<%
	/*
			Author:   clhuang 2015/05/26
			Tester:
			Content: 审批文件的批量下载
			Input Param:
			Output param:
			History Log: 
			JTAR: CCS-432 零售商、门店准入需求变更&批量下载
		 */
%>
<%
	    String sSerialNo = DataConvert.toString((String) CurComp.getParameter("SerialNo")); //合同编号
		String sType = DataConvert.toString((String) CurComp.getParameter("Type")); //下载列表的类型
		
		//-- add by tangyb CCS-992 20151224 --//
		String sSerialNoString = "";
		if (sSerialNo == null){
			sSerialNo = "";
		}else{
			sSerialNoString = sSerialNo.replace(",", "','");
		}
		
		if (sType == null)
			sType = "";
		
		String sNtfs = DataConvert.toString((String) CurComp.getParameter("Ntfs")); //文件名格式化
		if(sNtfs == null) sNtfs="";
		
		String sName = "";//生产的文件名后部分
		String rname = ""; //零售商名称
		
		//文件名格式化（""非格式化）
		if(!"".equals(sNtfs)){
			if("R".equals(sNtfs)){ //零售商批量下载
				rname = Sqlca.getString(new SqlObject("SELECT t.rname FROM RETAIL_INFO t WHERE t.regcode = :reqcode").setParameter("reqcode", sSerialNo));
			}else if("S".equals(sNtfs)){//门店批量下载
				rname = Sqlca.getString(new SqlObject("SELECT b.rname, a.regcode FROM store_info a, retail_info b WHERE a.rserialno=b.serialno AND a.regcode = :regcode").setParameter("regcode", sSerialNo));
			}
		}
		
		if(rname!=null && !"".equals(rname)){
			sName = "零售商["+rname+"]批量下载附件包";
		} else {
			sName = "批量下载附件包";
		}

		ARE.getLog().debug("========sSerialNo=" + sSerialNo + ",sDownType=" + sType + ",sName=" + sName + ",sNtfs="+sNtfs);
		//-- end --//
		
		String sViewType = "save";
		
		ASResultSet rsT = Sqlca.getASResultSet(new SqlObject("select DocNo,AttachmentNo,ContentType,ContentLength,FileSaveMode,FileName,FilePath,FullPath,DocContent,beginTime from DOC_ATTACHMENT where ObjectNo in ('"+sSerialNoString+"')"));
		String sFullPath = "";
		String sFileName = "";
		String sContentType = "";
		String sBeginTime = "";
		String sFileRealName = ""; //下载后的真实名称
		// 	 List<File> fileList = new ArrayList<File>();//文件集合
		Map<File, String> fileMap = new HashMap<File, String>();

		int i = 0;
		while (rsT.next()) {
			sFullPath = DataConvert.toString(rsT.getString("FullPath"));
			sFileName = DataConvert.toString(rsT.getString("FileName"));
			sContentType = DataConvert.toString(rsT.getString("ContentType"));
			sBeginTime = DataConvert.toString(rsT.getString("beginTime"));
			sFileRealName = "(" + sBeginTime.replace("/", "-") + ")"+ sFileName;

			fileMap.put(new File(sFullPath), sFileRealName);
			ARE.getLog().info(sFileRealName + "========================文件名称");
			ARE.getLog().info(sFullPath + "========================全路径");
			// 		 fileList.add(new File(sFullPath));
		}
		rsT.getStatement().close();

		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
		String sZipFileName = sName;
		String sZipFullPath = sFileSavePath + "/" + sZipFileName
				+ ".zip";//生成的zip压缩包
		String url = "";
		ZipUtil.toZipFile(sZipFullPath, fileMap);

		ARE.getLog().debug("=zip文件路径===" + sZipFullPath);
%>
<html>
<!-- 增加自动关闭 下载完成后自动关闭 -->
<body onload='setTimeout("self.close()",1)'>
<!-- <body> -->
<iframe name="MyAtt" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(
						sWebRootPath, "正在下载附件，请稍候...")%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<form name=form1 method=post action="<%=sWebRootPath%>/servlet/view/file" target=MyAtt>
	<div style="display:none">
				<input name=filename value="<%=sZipFullPath%>">
		<input name=contenttype value="<%=sContentType%>">
		<input name=viewtype value="<%=sViewType%>">
	</div>
</form>

<script type="text/javascript">
	form1.submit();
</script>


<%@ include file="/IncludeEnd.jsp"%>