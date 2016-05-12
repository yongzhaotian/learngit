<%@page import="com.amarsoft.awe.common.attachment.AmarsoftUpload"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.awe.common.*,java.text.*"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
<%
	/*
									Author:   fmwu  2008/01/08
									Tester: 
									Content: �ϴ������ĵ���ʽģ�弰���ݶ���ģ��
									Input Param:
										TypeNo:ҵ��Ʒ�ֱ��	    
									Output param:
									History Log:
																															
		 */
%>
<%
	/*~END~*/
%>

<%!//������ز����õ������ļ���ʵ��·��
	String getFullPath(String sDocNo, String sFileName, String sFileSavePath, ServletContext sc) {
		java.io.File dFile = null;
		String sBasePath = sFileSavePath;
		if (!sFileSavePath.equals("")) {
			try {
				dFile = new java.io.File(sBasePath);
				if (!dFile.exists()) {
					dFile.mkdirs();
					System.out.println("�������渽���ļ�·��[" + sFileSavePath + "]�����ɹ�����");
				}
			} catch (Exception e) {
				sBasePath = sc.getRealPath("/WEB-INF/Upload");
				System.out.println("�������渽���ļ�·��[" + sFileSavePath + "]�޷�����,�ļ�������ȱʡĿ¼[" + sBasePath + "]��");
			}
		} else {
			sBasePath = sc.getRealPath("/WEB-INF/Upload");
			System.out.println("�������渽���ļ�·��û�ж���,�ļ�������ȱʡĿ¼[" + sBasePath + "]��");
		}

		String sFullPath = sBasePath + getMidPath(sDocNo);
		try {
			dFile = new java.io.File(sFullPath);
			if (!dFile.exists()) {
				dFile.mkdirs();
			}
		} catch (Exception e) {   
			System.out.println("�������渽���ļ�����·��[" + sFullPath + "]�޷�������");
		}

		String sFullName = sBasePath + getFilePath(sDocNo, sFileName);
		return sFullName;
	}

	//������ز����õ��м䲿�ֵ�·��
	String getMidPath(String sDocNo) {
		return "/Template/EDoc";
	}

	//������ز����õ������ļ���
	String getFilePath(String sDocNo, String sShortFileName) {
		String sFileName;
		sFileName = getMidPath(sDocNo);
		sFileName = sFileName + "/" + sDocNo + "_" + sShortFileName;
		return sFileName;
	}
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
<%
	String sAttachmentNo = "";
		ASResultSet rs = null;

		AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
		myAmarsoftUpload.initialize(pageContext);
		myAmarsoftUpload.upload();

		String sEDocNo = (String) myAmarsoftUpload.getRequest().getParameter("EDocNo");
		String sDocType = (String) myAmarsoftUpload.getRequest().getParameter("DocType");
		String sFileName = (String) myAmarsoftUpload.getRequest().getParameter("FileName");

		//�õ�����·�����ļ���
		sFileName = StringFunction.getFileName(sFileName);

		rs = Sqlca.getASResultSetForUpdate("SELECT EDOC_DEFINE.* FROM EDOC_DEFINE WHERE EDocNo='" + sEDocNo + "'");
		if (rs.next()) {
			if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()) {
				try {
					java.util.Date dateNow = new java.util.Date();
					SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
					String sUpdateTime = sdfTemp.format(dateNow);

					String sFileSavePath = CurConfig.getConfigure("FileSavePath");
					String sFullPath = getFullPath(sEDocNo, sFileName, sFileSavePath, application);
					myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
					rs.updateString("FullPath"+sDocType, sFullPath);
					rs.updateString("FileName"+sDocType, sFileName);
					rs.updateString("ContentType"+sDocType, DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
					rs.updateString("ContentLength"+sDocType, DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
					rs.updateString("UpdateUser", CurUser.getUserID());
					rs.updateString("UpdateOrg", CurUser.getOrgID());
					rs.updateString("UpdateTime", sUpdateTime);
					rs.updateRow();
					rs.getStatement().close();

					myAmarsoftUpload = null;
				} catch (Exception e) {
					out.println("An error occurs : " + e.toString());
					rs.getStatement().close();
					myAmarsoftUpload = null;
%>
<script language=javascript>
                    alert(getHtmlMessage(10));//�ϴ��ļ�ʧ�ܣ�
                    self.close();
                </script>
<%
	}
			}
		}
%>

<script language=javascript>
    alert(getHtmlMessage(13));//�ϴ��ļ��ɹ���
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>