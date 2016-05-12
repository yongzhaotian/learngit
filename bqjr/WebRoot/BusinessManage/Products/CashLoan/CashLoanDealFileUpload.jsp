<%@page import="java.net.URLDecoder"%>
<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.awe.util.*"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@page import="com.amarsoft.app.als.rule.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<body style="overflow:hidden;" onload="javascript:ready();" onresize="javascript:changeStyle();">
<div id="Buttons" style="width:450px;height=350px;color:red">
<div id="ButtonsDivtable" style="margin-left:15px;margin-top:20px;width:450px;height=350px;display=None">
</div>
<div id="ButtonsDiv" style="margin-left:15px;margin-top:20px;width:450px;height=350px;">
<table><tr>
	<td><form  name="Attachment" style="margin-bottom:10px;" enctype="multipart/form-data" action="<%=request.getContextPath() %>/BusinessManage/CollectionManage/TransferDealFileUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" method="post">
		<input id = "FileID" class="buttonback" valign=top style='width:250px;height:24px;' type="file" name="File" />
		<input type="hidden" name="FileName" />
		<input type="hidden" name="DocNo" />
	</form></td>
	<td>
</tr></table>
</div>
</div>
</body>
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
	String sApplySerialNo = (String)myAmarsoftUpload.getRequest().getParameter("SerialNo"); //Э����
	sFileName = URLDecoder.decode(sFileName, "UTF-8");
	System.out.println("sFileName==="+sFileName);		
	System.out.println("sApplySerialNo==="+sApplySerialNo);		
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
			}catch(Exception e){
           	out.println("An error occurs : " + e.toString());
           	sNewSql = "delete FROM doc_attachment WHERE DocNo=:DocNo and AttachmentNo=:AttachmentNo";
           	so = new SqlObject(sNewSql).setParameter("DocNo",sDocNo).setParameter("AttachmentNo",sAttachmentNo);
           	Sqlca.executeSQL(so);
           	rs.getStatement().close();
           	myAmarsoftUpload = null;
%>          
	          <script type="text/javascript">
	              alert("�ļ�����ʧ��");//�ϴ��ļ�ʧ�ܣ�
	              self.close();//�رմ���
	          </script>
<%
     		}
       	}
   	}
%>

<script type="text/javascript">
	document.getElementById("ButtonsDivtable").style.display = "";	
	document.getElementById("Buttons").style.background = "rgb(240,245,240)";
	document.getElementById("ButtonsDivtable").innerHTML = " ϵͳ�������...";
	document.getElementById("ButtonsDiv").style.display = "None";	
	var serialNo = "<%=sApplySerialNo%>";
	var sFullPath = "<%=sFullPath%>";
	var sUserID = "<%=sUserID%>";
	var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddCashLoanRelative","dealExpFile","FilePath="+sFullPath+",ObjectNo="+serialNo+",UserID="+sUserID);
	var sValue = sReturn.split("@");
	//alert("sReturn="+sReturn+",sValue.length="+sValue.length);
	if(sValue[0] == "success"){
		if(sValue.length>1){
			if(confirm("�ļ�����ɹ�,"+ sValue[1])){
				sCompID = "FileCustRepetitionList";
				sCompURL = "/BusinessManage/Products/CashLoan/FileCustRepetitionList.jsp";
				sCompParam = "eventserialno="+serialNo; //����
				
				var left = (window.screen.availWidth-800)/2;
				var top = (window.screen.availHeight-400)/2;
				var features ='left='+left+',top='+top+',width=800,height=400';
				var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
				popComp(sCompID, sCompURL, sCompParam , style);
				//AsControl.PopPage(sCompURL,sCompParam,style);
			}
		}else{
			alert("�ļ�����ɹ�");
		}
	}else{
		alert(sValue[1]);
	}
    self.close();//�رմ���
</script>
<%@ include file="/IncludeEnd.jsp"%>