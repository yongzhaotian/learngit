<script type="text/javascript">
<%	
	if(sMethod.equals("2")){  //2:save
%>
		alert("����ɹ���");
<%
	}
	if(sMethod.equals("2") || sMethod.equals("5")){  //2:save,5:autosave
%>
	    var objW;
	    if(typeof(window.opener)=='undefined')
	       objW=window.parent;     
	    else
	       objW=window.opener.top;
	    objW.bEditHtmlChange = false;
<%
    }
	if(sMethod.equals("3")){
		session.setAttribute(sPreviewContent,sReportInfo);
%>
		//alert("<%=sPreviewContent%>");
		var CurOpenStyle = "width=1200,height=600,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";
		OpenPage("/Resources/CodeParts/Preview01.jsp?sid=<%=sPreviewContent%>","_blank02",CurOpenStyle);
		//popComp("Preview01","/Resources/CodeParts/Preview01.jsp","sid="+"<%=sPreviewContent%>",CurOpenStyle);
<%
	}
	if(sMethod.equals("4")){  //4:export
		//cdeng 2009-02-12 �޸��ĵ��洢·���������Ե������������Ŀ¼
		ASResultSet rsPath = null;
		String sSql99="",sSavePath="",sfSerialNo="",sSql2="";
		if(sFirstSection.equals("1")){
			sSql99=" select SerialNo,SavePath from FORMATDOC_RECORD where ObjectType=:ObjectType and ObjectNo=:ObjectNo and DocID=:DocID ";
			rsPath = Sqlca.getASResultSet(new SqlObject(sSql99).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("DocID", sDocID));
			if(rsPath.next()){
				sfSerialNo = rsPath.getString("SerialNo");
				sSavePath = rsPath.getString("SavePath");
			}
			rsPath.getStatement().close();
	
			if(sfSerialNo==null) sfSerialNo="";
			if(sSavePath==null) sSavePath="";
		}
	
		//export to file
	    String sSerialNoNew = MessageDigest.getDigestAsUpperHexString("MD5", sDocID+sObjectNo+sObjectType);
	    
	    //�ж�·���Ƿ���ڣ�����������Զ�����
		java.io.File dFile=null;
		String sBasePath = CurConfig.getConfigure("WorkDocSavePath");
		if(sBasePath == null || sBasePath.equals(""))
			sBasePath=application.getRealPath("/FormatDoc/WorkDoc");
		
		//update CCS-505 ��ͬģ�����ڷ�������δ����/��/�շ�Ŀ¼��ţ������������  by rqiao 20150311
		//String sFileSavePath=sBasePath+"/"+StringFunction.getToday().substring(0,4);
		String sFileSavePath=sBasePath+"/"+StringFunction.getToday();
		//end
		
		try {
			dFile=new java.io.File(sFileSavePath);
			if(!dFile.exists()) {
				dFile.mkdirs();
			}
		}catch (Exception e) {
			 ARE.getLog().error(e.getMessage(),e);
		        throw e;
		}
		String sFileName = sFileSavePath+"/"+sSerialNoNew+".html";
		SqlObject asql = null;
		if(sFirstSection.equals("1")){
			if(sfSerialNo.equals("")){
				sSql2=" insert into FORMATDOC_RECORD(SerialNo,ObjectType,ObjectNo,DocID,SavePath) values(:SerialNo,:ObjectType,:ObjectNo,:DocID,:SavePath)";
				asql = new SqlObject(sSql2);
				asql.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("DocID", sDocID).setParameter("SavePath", sFileName);
			}else if(!sfSerialNo.equals("") && !sSavePath.equals(sFileName)){
				sSql2=" update FORMATDOC_RECORD set SavePath=:SavePath where ObjectType=:ObjectType and ObjectNo=:ObjectNo and DocID=:DocID";
				asql = new SqlObject(sSql2);
				asql.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("DocID", sDocID).setParameter("SavePath", sFileName);
			}
		}
		
	    java.io.File file = new java.io.File(sFileName);
	    java.io.FileOutputStream fileOut = null;
		
		if(sFirstSection.equals("1"))
			fileOut = new java.io.FileOutputStream(file,false);
		else
			fileOut = new java.io.FileOutputStream(file,true);
		
		if(sFirstSection.equals("1")){
	        String st0="<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\"><title>����</title>";
	        String st1="<STYLE>.table1 {  border: solid; border-width: 1px 1px 2px 2px; border-color: #000000 black #000000 #000000} .td1 {  border-color: #000000 #000000 black black; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 10pt; color: #000000} </STYLE>	";
	        String st2="<script type=\"text/javascript\">";
	        String st3="function mykd() {if(event.keyCode==114 || event.keyCode==116 || event.keyCode==122 || (event.keyCode==78 && event.ctrlKey) )  { event.keyCode=0; event.returnValue=false; return false; } } ";
	        String st4="function ExportToWord(){ var oWD = new ActiveXObject('word.Application'); oWD.Application.Visible = true; var oDC =oWD.Documents.Add('',0,1); var oRange =oDC.Range(0,1);  var sel=parent.document.body.createTextRange(); oTblExport = parent.document.getElementById('reportContent'); if (oTblExport != null) { sel.moveToElementText(oTblExport); sel.execCommand('Copy'); parent.document.body.blur(); oRange.Paste(); } } ";
	        String st5="</script>";
	        String st6="<style> @media print { INPUT  {display:none }} </style>";
	        String st7="<body style='word-break:break-all' > <div id=div1 style=\"display:none\" > <object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style=\"display:none\" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object> ";
	        String st8="<input type=button value='��ӡ����' onclick=\"WebBrowser1.ExecWB(8,1)\"> <input type=button value='��ӡԤ��' onclick=\"WebBrowser1.ExecWB(7,1)\"> <input type=button value='��ӡ' onclick=\"WebBrowser1.ExecWB(6,1)\"> <input type=button value='���Ϊ' onclick=\"WebBrowser1.ExecWB(4,1)\"> <!--<input type=button value='������word' onclick=\"ExportToWord()\">--> <input type=button value='�ر�' onclick=\"WebBrowser1.ExecWB(45,1)\"><p></div></body>  ";
	        String st9="<script type=\"text/javascript\"> if(window.dialogArguments==\"myprint10\") div1.style.cssText=\"display:none\"; else div1.style.cssText=\"display:block\"; ";
	        String st10="try {	document.body.onkeydown=mykd; } catch(e) {var a=1;} try {	document.onkeydown=mykd; } catch(e) {var a=1;} try {	document.oncontextmenu=Function(\"return false;\"); } catch(e) {var a=1;}</script>";
	
	        fileOut.write(st0.getBytes("GBK"));    
	        fileOut.write(st1.getBytes("GBK"));    
	        fileOut.write(st2.getBytes("GBK"));    
	        fileOut.write(st3.getBytes("GBK"));    
	        fileOut.write(st4.getBytes("GBK")); //��ExportToWord����Ҳд��html
	        fileOut.write(st5.getBytes("GBK"));
	        fileOut.write(st6.getBytes("GBK"));    
	        fileOut.write(st7.getBytes("GBK"));    
	        fileOut.write(st8.getBytes("GBK"));    
	        fileOut.write(st9.getBytes("GBK"));    
	        fileOut.write(st10.getBytes("GBK"));
	        
	        //����������ǰ���div��ǩ
	        fileOut.write("<div id=reportContent>".getBytes("GBK"));
		}
		
		fileOut.write(sReportInfo.getBytes("GBK"));
		if(sFirstSection.equals("END")){
			//����βҳ���div��ǩ
		    fileOut.write("</div>".getBytes("GBK"));
		}
		fileOut.close();
		if(sFirstSection.equals("1")&&!sSql2.equals("")){
			Sqlca.executeSQL(asql);
		}
%>
	self.close();
<%
	}
%>	
</script>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Report01;Describe=����ҳ��;]~*/%>	
<%	
	if(sMethod.equals("1")){  //1:display
%>
	<%@include file="/Resources/CodeParts/Report01.jsp"%>
	<script type="text/javascript">
	//����
	function my_save(){
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "2"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}
	
	//Ԥ��
	function my_preview(){
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "3"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}		
	
	//����
	function my_export(){
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "4"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}	
	
	//���
	function my_finish(){
		if(confirm("���������ɸñ�����")){
			sReturn=PopPage("/CreditManage/CreditCheck/FinishInspectAction.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","","");
			if(sReturn=="Inspectunfinish")
				alert("�ô����鱨���޷���ɣ�������ɷ��շ��࣡");
			if(sReturn=="Purposeunfinish")
				alert("�ô�����;�����޷���ɣ�������������¼���ÿ��¼��");
			if(sReturn=="finished"){
				alert("�ñ�������ɣ�");
			}
		}
	}
	
	//�Զ�����
    function my_autosave(){
        reportInfo.target = "mypost0";
        reportInfo.Method.value = "5"; 		//1:display;2:save;3:preview;4:export;5:autosave
        reportInfo.Rand.value = randomNumber();
        reportInfo.submit();                   
    }
    if(bEditHtmlAutoSave) window.setInterval(my_autosave, 60000); //ÿ1�����Զ�����	
</script>
<%
	}
%>	
<%/*~END~*/%>