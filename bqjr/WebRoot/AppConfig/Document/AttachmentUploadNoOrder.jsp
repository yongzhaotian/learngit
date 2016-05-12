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

	//定义数据库操作变量
	SqlObject so = null;
	String sNewSql = "";
	String sTypeNo = (String)myAmarsoftUpload.getRequest().getParameter("TypeNo");
	if (sTypeNo == null) sTypeNo = "20002";
	
	String sDocNo = (String)myAmarsoftUpload.getRequest().getParameter("DocNo"); //文档编号
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //文件名称
	String docno=sDocNo;
	System.out.println("---11111----"+sDocNo+"----22222---"+sTypeNo);
	//得到不带路径的文件名
	sFileName =  StringFunction.getFileName(sFileName);
	sFileName = URLDecoder.decode(sFileName, "UTF-8");
	String sAttachmentNo = DBKeyHelp.getSerialNoFromDB("DOC_ATTACHMENT","AttachmentNo","DocNo='"+sTypeNo+"'","","000",new java.util.Date(),Sqlca);
	
	
	//sNewSql = "insert into DOC_ATTACHMENT(DocNo,AttachmentNo) values(:DocNo,:AttachmentNo)";
	/* sNewSql = "insert into ECM_PAGE(ObjectType,ObjectNo,TypeNo,DocumentId,ModifyTime,ImageInfo,OperateUser,OperateOrg,PageNum) values(:ObjectType,:ObjectNo,:TypeNo,:DocumentId,:ModifyTime,:ImageInfo,:OperateUser,:OperateOrg,:PageNum)";
	so = new SqlObject(sNewSql).setParameter("ObjectType","Business").setParameter("ObjectNo",sDocNo).setParameter("TypeNo", sTypeNo).setParameter("DocumentId", "url")
				.setParameter("ModifyTime", DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")).setParameter("ImageInfo", Sqlca.getString(new SqlObject("Select TypeName from Ecm_Image_Type where TypeNo=:TypeNo").setParameter("TypeNo", sTypeNo)))
				.setParameter("OperateUser", CurUser.getUserID()).setParameter("OperateOrg", CurOrg.orgID).setParameter("PageNum", "2");
	
	Sqlca.executeSQL(so);
 */	
	//ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT.* FROM DOC_ATTACHMENT WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
	//if(rs.next()){
      	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
     		try {
     			
     			sNewSql = "insert into ECM_PAGE(ObjectType,ObjectNo,TypeNo,DocumentId,ModifyTime,ImageInfo,OperateUser,OperateOrg,PageNum) values(:ObjectType,:ObjectNo,:TypeNo,:DocumentId,:ModifyTime,:ImageInfo,:OperateUser,:OperateOrg,:PageNum)";
            	so = new SqlObject(sNewSql).setParameter("ObjectType","Business").setParameter("ObjectNo",sDocNo).setParameter("TypeNo", sTypeNo)
            				.setParameter("ModifyTime", DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")).setParameter("ImageInfo", Sqlca.getString(new SqlObject("Select TypeName from Ecm_Image_Type where TypeNo=:TypeNo").setParameter("TypeNo", sTypeNo)))
            				.setParameter("OperateUser", CurUser.getUserID()).setParameter("OperateOrg", CurOrg.orgID).setParameter("PageNum", "2");
        		java.util.Date dateNow = new java.util.Date();
        		//SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
        		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyyMMdd");
        		String sBeginTime=sdfTemp.format(dateNow);

        		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
             	if(sFileSaveMode.equals("Disk")){ //存放文件服务器中
             		//String sFileSavePath = CurConfig.getConfigure("FileSavePath");
             		String sFileSavePath = CurConfig.getConfigure("ImageFolder");
             		String sFileNameType = CurConfig.getConfigure("FileNameType");
             		
             		String sTempNo = sDocNo;
             		sDocNo = sBeginTime;
             		sFileName = String.valueOf(System.currentTimeMillis())+"_"+sTypeNo+sFileName.substring(sFileName.lastIndexOf("."));
             		
             		String sFullPath = FileNameHelper.getFullPath(sDocNo, sTempNo.substring(sTempNo.length()-4),sFileName, sFileSavePath, sFileNameType, application);
             		//String sFullPath = FileNameHelper.getFullPath(sDocNo, sTempNo.substring(sTempNo.length()-4),sFileName, sFileSavePath, sFileNameType);
             		System.out.println("---sFullPath---"+sFullPath);

             		
             		//String sFullPath = sFileSavePath+File.separator+sBeginTime.substring(0,4)+File.separator+sBeginTime.substring(5,7)+File.separator+sBeginTime.substring(8);
             		//File dFile = new File(sFullPath);
             		//if (!dFile.exists()) dFile.mkdirs();
					myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
              		//得到带相对路径的文件名
             		String sFilePath = "Image"+sFullPath.substring(sFileSavePath.length());//FileNameHelper.getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
              		
             		System.out.println("---相对路径---"+sFullPath);
              		
					//rs.updateString("FilePath",sFilePath); 
					//rs.updateString("FullPath",sFullPath);
					if (sFilePath == null) so.setParameter("DocumentId", "");
					else so.setParameter("DocumentId", sFullPath);
				} 
             	
            	Sqlca.executeSQL(so);
            	
            	ASResultSet rs=null;
            	String sProductID="";
            	String busSql ="select t.productid as  from business_contract t where t.serialno='"+docno+"'";
            	rs=Sqlca.getASResultSet(busSql);
            	while(rs.next()){
            		sProductID = rs.getString("productid");
            	}
            	//操作上传状态start
            	String uploadSQl = "select a.isupload as isupload   from business_type a where "+
                    	"a.typeno = (select t.businesstype from business_contract t where t.serialno = '"+docno+"')";
                	rs=Sqlca.getASResultSet(uploadSQl);
                	String isupload = "";
                	while(rs.next()){
                		isupload = rs.getString("isupload");
                	}
                	if("1".equals(isupload)){
    	            	String flag = "1";
    	            	String updateSql = "update business_contract t set t.uploadFlag='"+flag+"',"+
    	        				"dayrange=(trunc(sysdate) - trunc(to_date(t.REGISTRATIONDATE, 'yyyy/mm/dd hh24:mi:ss'))),"+
    	        				"t.uploadtime=sysdate where t.serialno='"+docno+"'";
    	            	Sqlca.executeSQL(updateSql);
                	}
                	rs.getStatement().close();
            	//操作上传状态end 
				//dateNow = new java.util.Date();
				//String sEndTime=sdfTemp.format(dateNow);
	
				//rs.updateString("FileSaveMode",sFileSaveMode);  
				//rs.updateString("FileName",sFileName);  
				//rs.updateString("ContentType",DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
				//rs.updateString("ContentLength",DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
				//rs.updateString("BeginTime",sBeginTime);
				//rs.updateString("EndTime",sEndTime);
				//rs.updateString("InputUser",CurUser.getUserID());
				//rs.updateString("InputOrg",CurUser.getOrgID());
				//rs.updateRow();
				//rs.getStatement().close();

				/* if(sFileSaveMode.equals("Table")){ //存放数据表中
					myAmarsoftUpload.getFiles().getFile(0).fileToField(Sqlca,"update DOC_ATTACHMENT set DocContent=? where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
				} */
				myAmarsoftUpload = null;
			}catch(Exception e){
           	out.println("An error occurs : " + e.toString());
           	//sNewSql = "delete FROM doc_attachment WHERE DocNo=:DocNo and AttachmentNo=:AttachmentNo";
           	//so = new SqlObject(sNewSql).setParameter("DocNo",sDocNo).setParameter("AttachmentNo",sAttachmentNo);
           //	Sqlca.executeSQL(so);
           //	rs.getStatement().close();
           	myAmarsoftUpload = null;
%>          
	          <script type="text/javascript">
	            alert(getHtmlMessage(10));//上传文件失败
	        	AsControl.OpenView("/ImageManage/ImageNoOrderdcashFrame.jsp","DocNo="+<%=docno%>+"&TypeNo="+<%=sTypeNo%>,"right");
	              //parent.openComponentInMe();
	          </script>
<%
     		}
       	}
  // 	}
%>
<script type="text/javascript">
    alert(getHtmlMessage(13));//上传文件成功！
	AsControl.OpenView("/ImageManage/ImageNoOrderdcashFrame.jsp","DocNo="+<%=docno%>+"&TypeNo="+<%=sTypeNo%>,"right");
    //parent.openComponentInMe();
    
</script>
<%@ include file="/IncludeEnd.jsp"%>