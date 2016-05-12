<%@page import="java.net.URLDecoder"%>
<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK "%>
<%@ include file="/IncludeBegin.jsp"%>
<%

	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	ARE.getLog().debug("上下文："+pageContext.toString());
	
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 

	//定义数据库操作变量
	SqlObject so = null;
	String sNewSql = "";
	
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //文件名称
	String sType = (String)myAmarsoftUpload.getRequest().getParameter("Type"); //文件名称
	String sObjectNo = (String)myAmarsoftUpload.getRequest().getParameter("ObjectNo"); //文件名称
	String company=(String)myAmarsoftUpload.getRequest().getParameter("company");//业务所属公司
	//-- add by tangyb CCS-992 20151224 --//
	String isNtfs = (String)myAmarsoftUpload.getRequest().getParameter("isNtfs"); //是否格式化名称
	if(isNtfs==null) isNtfs="";
	
	String sStoreName=""; //商品/门店名称
	String sItemName=""; //附件类型名称
	//是否格式化附件名称
	if("Y".equals(isNtfs)){
		String sItemNo = "";
		if("A0001".equals(sType)){
			sItemNo = "010";
		}else if("A0002".equals(sType)){
			sItemNo = "020";
		}else if("A0003".equals(sType)){
			sItemNo = "030";
		}else{
			sItemNo = "010";
		}
		
		sStoreName = Sqlca.getString("select sname from store_info where regcode='"+sObjectNo+"'");
		if(sStoreName==null || "".equals(sStoreName))
			sStoreName="";
		else
			sStoreName=sStoreName+"_";
		
		sItemName = Sqlca.getString("select itemname from code_library where codeno='StoreApplyFileView' and itemno='"+sItemNo+"'");
		if(sItemName==null || "".equals(sItemName))
			sItemName="";
		else
			sItemName=sItemName+"_";
	}
	
	sFileName  = URLDecoder.decode(sFileName,"UTF-8");
	//得到不带路径的文件名
	sFileName = StringFunction.getFileName(sFileName);
	
	String sFileNameReal = sStoreName+sItemName+sFileName;//真实路径名称 updae tangyb 
	
	ARE.getLog().info("参数：sType="+sType+",sObjectNo="+sObjectNo+",sFileNameReal="+sFileNameReal);
	//-- end --//
	
	String sDocNo=DBKeyHelp.getSerialNo("DOC_ATTACHMENT", "DocNo", "", Sqlca); 
	
	String sAttachmentNo = DBKeyHelp.getSerialNoFromDB("DOC_ATTACHMENT","AttachmentNo","DocNo='"+sDocNo+"'","","000",new java.util.Date(),Sqlca);   
	sNewSql = "insert into DOC_ATTACHMENT(DocNo,AttachmentNo,Type,ObjectNo,Company) values(:DocNo,:AttachmentNo,:Type,:ObjectNo,:company)";
	so = new SqlObject(sNewSql).setParameter("DocNo",sDocNo).setParameter("AttachmentNo",sAttachmentNo).setParameter("Type", sType).setParameter("ObjectNo", sObjectNo).setParameter("company", company);
	Sqlca.executeSQL(so);
	
	ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT.* FROM DOC_ATTACHMENT WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
	if(rs.next()){
      	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
     		try {
        		java.util.Date dateNow = new java.util.Date();
        		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        		String sBeginTime=sdfTemp.format(dateNow);

        		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
             	if(sFileSaveMode.equals("Disk")){ //存放文件服务器中
             		String sTempNo = sDocNo;
             		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
             		String sFileNameType = CurConfig.getConfigure("FileNameType");
					sFileName = String.valueOf(System.currentTimeMillis())+"_"+sFileName.substring(sFileName.lastIndexOf("."));	
             		String sFullPath = FileNameHelper.getFullPath(sDocNo, sTempNo.substring(sTempNo.length()-4),sFileName, sFileSavePath, sFileNameType, application);
             		//String sFullPath = FileNameHelper.getFullPath(sDocNo, sAttachmentNo,sFileName, sFileSavePath, sFileNameType, application);
					myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
              		//得到带相对路径的文件名
             		String sFilePath = FileNameHelper.getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
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

				if(sFileSaveMode.equals("Table")){ //存放数据表中
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
	              alert(getHtmlMessage(10));//上传文件失败！
	              parent.openComponentInMe();
	          </script>
<%
     		}
       	}
   	}
%>
<script type="text/javascript">
    alert(getHtmlMessage(13));//上传文件成功！
    parent.openComponentInMe();
</script>
<%@ include file="/IncludeEnd.jsp"%>