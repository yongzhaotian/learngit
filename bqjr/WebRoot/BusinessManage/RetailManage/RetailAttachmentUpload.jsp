<%@page import="java.net.URLDecoder"%>
<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK "%>
<%@ include file="/IncludeBegin.jsp"%>
<%

	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	ARE.getLog().debug("�����ģ�"+pageContext.toString());
	
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 

	//�������ݿ��������
	SqlObject so = null;
	String sNewSql = "";
	
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //�ļ�����
	String sType = (String)myAmarsoftUpload.getRequest().getParameter("Type"); //�ļ�����
	String sObjectNo = (String)myAmarsoftUpload.getRequest().getParameter("ObjectNo"); //�ļ�����
	String company = (String)myAmarsoftUpload.getRequest().getParameter("company"); //�ļ�����
	
	//-- add by �������ŵ�׼�����������Ż� tangyb 20151223 --//
	String isNtfs = (String)myAmarsoftUpload.getRequest().getParameter("isNtfs"); //�Ƿ��ʽ������
	if(isNtfs==null) isNtfs="";
	if(company==null) company="";
	
	String sRetailName=""; //��Ʒ/�ŵ�����
	String sItemName=""; //������������
	
	//�Ƿ��ʽ����������
	if("Y".equals(isNtfs)){
		String sItemNo = "";
		if("A0001".equals(sType)){
			sItemNo = "010";
		}else if("A0002".equals(sType)){
			sItemNo = "020";
		}else if("A0003".equals(sType)){
			sItemNo = "030";
		}else if("A0004".equals(sType)){
			sItemNo = "040";
		}else if("A0005".equals(sType)){
			sItemNo = "050";
		}else if("A0006".equals(sType)){
			sItemNo = "060";
		}else if("A0007".equals(sType)){
			sItemNo = "070";
		}else{
			sItemNo = "010";
		}
		
		sRetailName = Sqlca.getString("select rname from retail_info where regcode='"+sObjectNo+"'");
		if(sRetailName==null || "".equals(sRetailName))
			sRetailName="";
		else
			sRetailName=sRetailName+"_";
		
		sItemName = Sqlca.getString("select itemname from code_library where codeno='RetailApplyFileView' and itemno='"+sItemNo+"'");
		if(sItemName==null || "".equals(sItemName))
			sItemName="";
		else
			sItemName=sItemName+"_";
	}
	
	sFileName  = URLDecoder.decode(sFileName,"UTF-8");
	//�õ�����·�����ļ���
	sFileName = StringFunction.getFileName(sFileName);
	
	String sFileNameReal = sRetailName+sItemName+sFileName;//��ʵ·������ update tangyb 20151223
	
	ARE.getLog().info("������sType="+sType+",sFileNameReal="+sFileNameReal+",sObjectNo="+sObjectNo+".sFileName=" +sFileName);
	//-- end --//
	
	String sDocNo=DBKeyHelp.getSerialNo("DOC_ATTACHMENT", "DocNo", "", Sqlca); 
	
	
	String sAttachmentNo = DBKeyHelp.getSerialNoFromDB("DOC_ATTACHMENT","AttachmentNo","DocNo='"+sDocNo+"'","","000",new java.util.Date(),Sqlca);   
	sNewSql = "insert into DOC_ATTACHMENT(DocNo,AttachmentNo,Type,ObjectNo,company) values(:DocNo,:AttachmentNo,:Type,:ObjectNo,:company)";
	so = new SqlObject(sNewSql).setParameter("DocNo",sDocNo).setParameter("AttachmentNo",sAttachmentNo).setParameter("Type", sType)
			.setParameter("ObjectNo", sObjectNo).setParameter("company", company);
	Sqlca.executeSQL(so);
	
	ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT.* FROM DOC_ATTACHMENT WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
	if(rs.next()){
      	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
     		try {
        		java.util.Date dateNow = new java.util.Date();
        		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        		String sBeginTime=sdfTemp.format(dateNow);

        		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
             	if(sFileSaveMode.equals("Disk")){ //����ļ���������
             		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
             		String sFileNameType = CurConfig.getConfigure("FileNameType");
             		
             		String sTempNo = sDocNo;
					sFileName = String.valueOf(System.currentTimeMillis())+"_"+sFileName.substring(sFileName.lastIndexOf("."));
             		
             		String sFullPath = FileNameHelper.getFullPath(sDocNo, sTempNo.substring(sTempNo.length()-4),sFileName, sFileSavePath, sFileNameType, application);
             		
             		//String sFullPath = FileNameHelper.getFullPath(sDocNo, sAttachmentNo,sFileName, sFileSavePath, sFileNameType, application);
					myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
              		//�õ������·�����ļ���
             		String sFilePath = FileNameHelper.getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
              		System.out.println("-----------"+sFilePath);
					rs.updateString("FilePath",sFilePath); 
					rs.updateString("FullPath",sFullPath);
				}
				dateNow = new java.util.Date();
				
				String sEndTime=sdfTemp.format(dateNow);
	
				rs.updateString("FileSaveMode",sFileSaveMode);  
				rs.updateString("FileName",sFileNameReal);  
				ARE.getLog().debug("=============ContentType============="+DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
				
				rs.updateString("ContentType",DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
				rs.updateString("ContentLength",DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
				rs.updateString("BeginTime",sBeginTime);
				rs.updateString("EndTime",sEndTime);
				rs.updateString("InputUser",CurUser.getUserID());
				rs.updateString("InputOrg",CurUser.getOrgID());
				rs.updateRow();
				rs.getStatement().close();

				if(sFileSaveMode.equals("Table")){ //������ݱ���
					myAmarsoftUpload.getFiles().getFile(0).fileToField(Sqlca,"update DOC_ATTACHMENT set DocContent=? where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
				}
				myAmarsoftUpload = null;
			}catch(Exception e){
				e.printStackTrace();
           	out.println("An error occurs : " + e.toString());
           	sNewSql = "delete FROM doc_attachment WHERE DocNo=:DocNo and AttachmentNo=:AttachmentNo";
           	so = new SqlObject(sNewSql).setParameter("DocNo",sDocNo).setParameter("AttachmentNo",sAttachmentNo);
           	Sqlca.executeSQL(so);
           	rs.getStatement().close();
           	myAmarsoftUpload = null;
%>          
	          <script type="text/javascript">
	              alert(getHtmlMessage(10));//�ϴ��ļ�ʧ�ܣ�
	              parent.openComponentInMe();
	          </script>
<%
     		}
       	}
   	}
%>
<script type="text/javascript">
    alert(getHtmlMessage(13));//�ϴ��ļ��ɹ���
    parent.openComponentInMe();
</script>
<%@ include file="/IncludeEnd.jsp"%>