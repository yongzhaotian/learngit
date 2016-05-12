<%@ page import="java.io.File"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@ page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 

	//�������ݿ��������
	SqlObject so = null;
	String sNewSql = "";
	String sTypeNo = (String)myAmarsoftUpload.getRequest().getParameter("TypeNo");
	if (sTypeNo == null) sTypeNo = "";
	
	String sDocNo = (String)myAmarsoftUpload.getRequest().getParameter("DocNo"); //�ĵ����
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //�ļ�����
	String docno=sDocNo;
	System.out.println("---11111----"+sDocNo+"----22222---"+sTypeNo);
	//�õ�����·�����ļ���
	sFileName =  StringFunction.getFileName(sFileName);
	sFileName = URLDecoder.decode(sFileName, "UTF-8");
      	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
     		try {
     			
     			sNewSql = "insert into ECM_PAGE(ObjectType,ObjectNo,TypeNo,DocumentId,ModifyTime,ImageInfo,OperateUser,OperateOrg,PageNum) values(:ObjectType,:ObjectNo,:TypeNo,:DocumentId,:ModifyTime,:ImageInfo,:OperateUser,:OperateOrg,:PageNum)";
            	so = new SqlObject(sNewSql).setParameter("ObjectType","FlowModel").setParameter("ObjectNo",sDocNo).setParameter("TypeNo", sTypeNo)
            				.setParameter("ModifyTime", DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")).setParameter("ImageInfo", Sqlca.getString(new SqlObject("Select PhaseName from Flow_Model where PhaseNo=:TypeNo").setParameter("TypeNo", sTypeNo)))
            				.setParameter("OperateUser", CurUser.getUserID()).setParameter("OperateOrg", CurOrg.orgID).setParameter("PageNum", "2");
        		java.util.Date dateNow = new java.util.Date();
        		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyyMMdd");
        		String sBeginTime=sdfTemp.format(dateNow);

        		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
             	if(sFileSaveMode.equals("Disk")){ //����ļ���������
             		String sFileSavePath = CurConfig.getConfigure("ImageFolder");
             		String sFileNameType = CurConfig.getConfigure("FileNameType");
             		
             		String sTempNo = sDocNo;
             		sDocNo = sBeginTime;
             		sFileName = String.valueOf(System.currentTimeMillis())+"_"+sTypeNo+sFileName.substring(sFileName.lastIndexOf("."));
             		
             		String sFullPath = FileNameHelper.getFullPath(sDocNo, sTempNo.substring(sTempNo.length()-4),sFileName, sFileSavePath, sFileNameType, application);
             		System.out.println("---sFullPath---"+sFullPath);

             		
					myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
              		//�õ������·�����ļ���
             		String sFilePath = "Image"+sFullPath.substring(sFileSavePath.length());//FileNameHelper.getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
              		
             		System.out.println("---���·��---"+sFullPath);
              		
					if (sFilePath == null) so.setParameter("DocumentId", "");
					else so.setParameter("DocumentId", sFullPath);
				} 
             	
            	Sqlca.executeSQL(so);
            	
				myAmarsoftUpload = null;
			}catch(Exception e){
           	out.println("An error occurs : " + e.toString());
           	myAmarsoftUpload = null;
%>          
	          <script type="text/javascript">
	            alert(getHtmlMessage(10));//�ϴ��ļ�ʧ��
	        	AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelUploadFrame.jsp","DocNo=<%=docno%>&TypeNo=<%=sTypeNo%>","rightdown");
	          </script>
<%
     		}
       	}
  // 	}
%>
<script type="text/javascript">
    alert(getHtmlMessage(13));//�ϴ��ļ��ɹ���
	AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelUploadFrame.jsp","DocNo=<%=docno%>&TypeNo=<%=sTypeNo%>","rightdown");
    
</script>
<%@ include file="/IncludeEnd.jsp"%>