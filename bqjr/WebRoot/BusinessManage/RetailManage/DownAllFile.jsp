<%@page import="com.amarsoft.app.billions.ZipUtil"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import ="java.io.*" %>
<%@
 include file="/IncludeBegin.jsp"%>
<%
	/*
			Author:   clhuang 2015/05/26
			Tester:
			Content: �����ļ�����������
			Input Param:
			Output param:
			History Log: 
			JTAR: CCS-432 �����̡��ŵ�׼��������&��������
		 */
%>
<%
	    String sSerialNo = DataConvert.toString((String) CurComp.getParameter("SerialNo")); //��ͬ���
		String sType = DataConvert.toString((String) CurComp.getParameter("Type")); //�����б������
		
		//-- add by tangyb CCS-992 20151224 --//
		String sSerialNoString = "";
		if (sSerialNo == null){
			sSerialNo = "";
		}else{
			sSerialNoString = sSerialNo.replace(",", "','");
		}
		
		if (sType == null)
			sType = "";
		
		String sNtfs = DataConvert.toString((String) CurComp.getParameter("Ntfs")); //�ļ�����ʽ��
		if(sNtfs == null) sNtfs="";
		
		String sName = "";//�������ļ����󲿷�
		String rname = ""; //����������
		
		//�ļ�����ʽ����""�Ǹ�ʽ����
		if(!"".equals(sNtfs)){
			if("R".equals(sNtfs)){ //��������������
				rname = Sqlca.getString(new SqlObject("SELECT t.rname FROM RETAIL_INFO t WHERE t.regcode = :reqcode").setParameter("reqcode", sSerialNo));
			}else if("S".equals(sNtfs)){//�ŵ���������
				rname = Sqlca.getString(new SqlObject("SELECT b.rname, a.regcode FROM store_info a, retail_info b WHERE a.rserialno=b.serialno AND a.regcode = :regcode").setParameter("regcode", sSerialNo));
			}
		}
		
		if(rname!=null && !"".equals(rname)){
			sName = "������["+rname+"]�������ظ�����";
		} else {
			sName = "�������ظ�����";
		}

		ARE.getLog().debug("========sSerialNo=" + sSerialNo + ",sDownType=" + sType + ",sName=" + sName + ",sNtfs="+sNtfs);
		//-- end --//
		
		String sViewType = "save";
		
		ASResultSet rsT = Sqlca.getASResultSet(new SqlObject("select DocNo,AttachmentNo,ContentType,ContentLength,FileSaveMode,FileName,FilePath,FullPath,DocContent,beginTime from DOC_ATTACHMENT where ObjectNo in ('"+sSerialNoString+"')"));
		String sFullPath = "";
		String sFileName = "";
		String sContentType = "";
		String sBeginTime = "";
		String sFileRealName = ""; //���غ����ʵ����
		// 	 List<File> fileList = new ArrayList<File>();//�ļ�����
		Map<File, String> fileMap = new HashMap<File, String>();

		int i = 0;
		while (rsT.next()) {
			sFullPath = DataConvert.toString(rsT.getString("FullPath"));
			sFileName = DataConvert.toString(rsT.getString("FileName"));
			sContentType = DataConvert.toString(rsT.getString("ContentType"));
			sBeginTime = DataConvert.toString(rsT.getString("beginTime"));
			sFileRealName = "(" + sBeginTime.replace("/", "-") + ")"+ sFileName;

			fileMap.put(new File(sFullPath), sFileRealName);
			ARE.getLog().info(sFileRealName + "========================�ļ�����");
			ARE.getLog().info(sFullPath + "========================ȫ·��");
			// 		 fileList.add(new File(sFullPath));
		}
		rsT.getStatement().close();

		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
		String sZipFileName = sName;
		String sZipFullPath = sFileSavePath + "/" + sZipFileName
				+ ".zip";//���ɵ�zipѹ����
		String url = "";
		ZipUtil.toZipFile(sZipFullPath, fileMap);

		ARE.getLog().debug("=zip�ļ�·��===" + sZipFullPath);
%>
<html>
<!-- �����Զ��ر� ������ɺ��Զ��ر� -->
<body onload='setTimeout("self.close()",1)'>
<!-- <body> -->
<iframe name="MyAtt" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(
						sWebRootPath, "�������ظ��������Ժ�...")%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
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