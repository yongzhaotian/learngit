<script type="text/javascript">
<%	
	if(sMethod.equals("2"))  //2:save
	{
%>
	alert("保存成功！");
<%
	}
	if(sMethod.equals("2") || sMethod.equals("5"))  //2:save,5:autosave
    {
%>
    var objW;
    if(typeof(window.opener)=='undefined')
       objW=window.parent;     
    else
       objW=window.opener.top;
    objW.bEditHtmlChange = false;
<%
    }
%>
<%	
	if(sMethod.equals("3")) 
	{
	session.setAttribute(sPreviewContent,sReportInfo);
%>
	var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";
	OpenPage("/Resources/CodeParts/Preview01.jsp?sid=<%=sPreviewContent%>","_blank02",CurOpenStyle);
<%
	}
%>	

<%	
	if(sMethod.equals("4"))  //4:export
	{
		//cdeng 2009-02-12 修改文档存储路径，增加以当年年份命名的目录
		ASResultSet rs = null;
		String sSql99="",sSavePath="",sfSerialNo="",sSql1= "",sSql2="";
		if(sFirstSection.equals("1")){
			sSql99=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"'";
			//	  "' and ObjectType='PutOutApply' ";
			rs = Sqlca.getASResultSet(sSql99);
			if(rs.next())
			{
				sfSerialNo = rs.getString("SerialNo");
				sSavePath = rs.getString("SavePath");
			}
			rs.getStatement().close();
	
			if(sfSerialNo==null) sfSerialNo="";
			if(sSavePath==null) sSavePath="";
		}
	
		//export to file
	    String sSerialNoNew = MessageDigest.getDigestAsUpperHexString("MD5", sSerialNo);

	    //判断路径是否存在，如果不存在自动创建
		java.io.File dFile=null;
		String sBasePath = CurConfig.getConfigure("WorkDocSavePath");
		if(sBasePath == null || sBasePath.equals(""))
			sBasePath=application.getRealPath("/FormatDoc/WorkDoc");
			
		String sFileSavePath=sBasePath+"/"+StringFunction.getToday().substring(0,4);
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
		if(sFirstSection.equals("1")){
			if(sfSerialNo.equals(""))
			{
				sSql1 = "delete from formatdoc_record where serialno='"+sSerialNo+"'";
				sSql2=" insert into formatdoc_record values('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','','"+sFileName+"','','','','','')";
			}else if(!sfSerialNo.equals("") && !sSavePath.equals(sFileName)){
				sSql2=" update formatdoc_record set SavePath='"+sFileName+"'  where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"' ";
				
			}else sSql2="";
		}
		
	    java.io.File file = new java.io.File(sFileName);
	    java.io.FileOutputStream fileOut = null;
		
		if(sFirstSection.equals("1"))
			fileOut = new java.io.FileOutputStream(file,false);
		else
			fileOut = new java.io.FileOutputStream(file,true);
		
		if(sFirstSection.equals("1"))
		{	
	        String st0="<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\"><title>"+sSerialNo+".html</title>";
	        String st1="<STYLE>.table1 {  border: solid; border-width: 1px 1px 2px 2px; border-color: #000000 black #000000 #000000} .td1 {  border-color: #000000 #000000 black black; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 10pt; color: #000000} </STYLE>	";
	        String st2="<script type=\"text/javascript\">";
	        String st3="function mykd() {if(event.keyCode==114 || event.keyCode==116 || event.keyCode==122 || (event.keyCode==78 && event.ctrlKey) )  { event.keyCode=0; event.returnValue=false; return false; } } ";
	        String st4="function ExportToWord(){ var oWD = new ActiveXObject('word.Application'); oWD.Application.Visible = true; var oDC =oWD.Documents.Add('',0,1); var oRange =oDC.Range(0,1);  var sel=parent.document.body.createTextRange(); oTblExport = parent.document.getElementById('reportContent'); if (oTblExport != null) { sel.moveToElementText(oTblExport); sel.execCommand('Copy'); parent.document.body.blur(); oRange.Paste(); } } ";
	        String st5="</script>";
	        String st6="<style> @media print { INPUT  {display:none }} </style>";
	        String st7="<body style='word-break:break-all' > <div id=div1 style=\"display:none\" > <object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style=\"display:none\" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object> ";
	        String st8="<input type=button value='打印设置' onclick=\"WebBrowser1.ExecWB(8,1)\"> <input type=button value='打印预览' onclick=\"WebBrowser1.ExecWB(7,1)\"> <input type=button value='打印' onclick=\"WebBrowser1.ExecWB(6,1)\"> <input type=button value='另存为' onclick=\"WebBrowser1.ExecWB(4,1)\"> <!--<input type=button value='导出到word' onclick=\"ExportToWord()\">--> <input type=button value='关闭' onclick=\"WebBrowser1.ExecWB(45,1)\"><p></div></body>  ";
	        String st9="<script type=\"text/javascript\"> if(window.dialogArguments==\"myprint10\") div1.style.cssText=\"display:none\"; else div1.style.cssText=\"display:block\"; ";
	        String st10="try {	document.body.onkeydown=mykd; } catch(e) {var a=1;} try {	document.onkeydown=mykd; } catch(e) {var a=1;} try {	document.oncontextmenu=Function(\"return false;\"); } catch(e) {var a=1;}</script>";
	
	        fileOut.write(st0.getBytes("GBK"));    
	        fileOut.write(st1.getBytes("GBK"));    
	        fileOut.write(st2.getBytes("GBK"));    
	        fileOut.write(st3.getBytes("GBK"));    
	        fileOut.write(st4.getBytes("GBK")); //将ExportToWord函数也写入html
	        fileOut.write(st5.getBytes("GBK"));
	        fileOut.write(st6.getBytes("GBK"));    
	        fileOut.write(st7.getBytes("GBK"));    
	        fileOut.write(st8.getBytes("GBK"));    
	        fileOut.write(st9.getBytes("GBK"));    
	        fileOut.write(st10.getBytes("GBK"));
		}
    //将报告内容前添加div标签
    fileOut.write("<div id=reportContent style='margin-top:2%'>".getBytes("GBK"));
		fileOut.write(sReportInfo.getBytes("GBK"));
   	fileOut.write("</div>".getBytes("GBK"));
    //if(sFirstSection.equals("END")){
			//报告尾页添加div标签,目前一般出帐通知书都为一页，所以注释掉条件判断
    	//fileOut.write("</div>".getBytes("GBK"));
		//}
		fileOut.close();
		if(sFirstSection.equals("1")){
			if(!sSql1.equals("")){
				Sqlca.executeSQL(sSql1);
			}
			if(!sSql2.equals("")){
				Sqlca.executeSQL(sSql2);
			}
		}
%>
	self.close();
<%
	}
%>	
</script>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Report01;Describe=主体页面;]~*/%>	
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	<%@include file="/Resources/CodeParts/Report01.jsp"%>
<%
	}
%>	
<%/*~END~*/%>

<script type="text/javascript">
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//保存
	function my_save()
	{
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "2"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}	
	
	//预览
	function my_preview()
	{
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "3"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}		
	
	//导出
	function my_export()
	{
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "4"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}	
	
	//自动保存
    function my_autosave()
    {
        reportInfo.target = "mypost0";
        reportInfo.Method.value = "5"; 		//1:display;2:save;3:preview;4:export;5:autosave
        reportInfo.Rand.value = randomNumber();
        reportInfo.submit();                   
    }      
    if(bEditHtmlAutoSave) window.setInterval(my_autosave, 60000); //每1分钟自动保存	
<%
	}
%>	
</script>
