<%-- <%@page import="demo.HttpDemo"%> --%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@page import="com.amarsoft.app.als.rule.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%

	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload();

	//�������ݿ��������
	ASResultSet rs = null;
	SqlObject so = null;
	String sNewSql = "";
	
	String sDocNo = (String)myAmarsoftUpload.getRequest().getParameter("DocNo"); //�ĵ����
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //�ļ�����
	
	
	String sModelID = (String)myAmarsoftUpload.getRequest().getParameter("ModelID"); //����ģ��
	String sRuleType = (String)myAmarsoftUpload.getRequest().getParameter("RuleType"); //��������
	String sRuleID = (String)myAmarsoftUpload.getRequest().getParameter("RuleID"); //������
	String sVersionID = (String)myAmarsoftUpload.getRequest().getParameter("VersionID"); //�汾���
	
	if (sModelID == null) sModelID = "";
	if (sVersionID == null) sVersionID = "";
	
    //��ˮ��
	String sSerialNo=DBKeyHelp.getSerialNo("rule_engine_Info","SerialNo",Sqlca);
	String sFullPath = "";
	String sUserID=CurUser.getUserID();//�û�ID
	String sOrgID=CurOrg.orgID;//����ID
	String sInputDate=StringFunction.getToday();//����
	//System.out.println("----"+sSerialNo+"-----"+sUserID+"----"+sOrgID+"-----"+sInputDate+"---"+sFileName);
	
	sFileName = URLDecoder.decode(sFileName, "UTF-8");
	//�õ�����·�����ļ���
	sFileName = StringFunction.getFileName(sFileName);
	String sAttachmentNo = DBKeyHelp.getSerialNoFromDB("DOC_ATTACHMENT","AttachmentNo","DocNo='"+sDocNo+"'","","000",new java.util.Date(),Sqlca);   
	sNewSql = "insert into DOC_ATTACHMENT(DocNo,AttachmentNo) values(:DocNo,:AttachmentNo)";
	so = new SqlObject(sNewSql).setParameter("DocNo",sDocNo).setParameter("AttachmentNo",sAttachmentNo);
	Sqlca.executeSQL(so);
	
	rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT.* FROM DOC_ATTACHMENT WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
	if(rs.next()){
      	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
     		try {
        		java.util.Date dateNow = new java.util.Date();
        		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
        		String sBeginTime=sdfTemp.format(dateNow);

        		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
             	if(sFileSaveMode.equals("Disk")){ //����ļ���������
             		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
             		String sFileNameType = CurConfig.getConfigure("FileNameType");
             		sFullPath = FileNameHelper.getFullPath(sDocNo, sAttachmentNo,sFileName, sFileSavePath, sFileNameType, application);
					myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
              		//�õ������·�����ļ���
             		String sFilePath = FileNameHelper.getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
					rs.updateString("FilePath",sFilePath); 
					rs.updateString("FullPath",sFullPath);
				}
				dateNow = new java.util.Date();
				String sEndTime=sdfTemp.format(dateNow);
	
				rs.updateString("FileSaveMode",sFileSaveMode);  
				rs.updateString("FileName",sFileName);  
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
				
				System.out.println("sFullPath==="+sFullPath);
				
				//����
				/* DeployModel ruleDeploy = new DeployModel();
				String sResult = ruleDeploy.getRoleDeploy("update", sModelID,sFullPath,sVersionID);
				sNewSql = "insert into rule_engine_Info(SerialNo,ModelID,RuleType,RuleID,FileName,InputUserID,InputOrgID,InputDate,VersionID) values(:SerialNo,:ModelID,:RuleType,:RuleID,:FileName,:InputUserID,:InputOrgID,:InputDate,:VersionID)";
				so = new SqlObject(sNewSql);
				so.setParameter("SerialNo", sSerialNo).setParameter("ModelID", sModelID).setParameter("RuleType", sRuleType).setParameter("RuleID", sRuleID).setParameter("FileName", sFileName).setParameter("InputUserID", sUserID).setParameter("InputOrgID", sOrgID).setParameter("InputDate", sInputDate).setParameter("VersionID", sVersionID);
				Sqlca.executeSQL(so);	 */
				
				
			}catch(Exception e){
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
	              self.close();//�رմ���
	          </script>
<%
     		}
       	}
   	}
%>
<script type="text/javascript">
    alert(getHtmlMessage(13));//�ϴ��ļ��ɹ���
    parent.openComponentInMe();
    self.close();//�رմ���
</script>
<%@ include file="/IncludeEnd.jsp"%>