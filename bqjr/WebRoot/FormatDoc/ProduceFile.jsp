<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.25
		Tester:
		Content: 从FORMATDOC_DATA生成文件
		Input Param:
			DocID:    formatdoc_catalog中的文档类别（调查报告，贷后检查报告，...)
			ObjectNo：业务流水号

		Output param:
		History Log: cdeng 2009-02-12 修改文档存储路径，增加以当年年份命名的目录
	 */
	%>
<%/*~END~*/%>

<%!
	//获得机构所在的分行
	String getBranchOrgID(String sOrgID,Transaction Sqlca) throws Exception {
		String sUpperOrgID = sOrgID;
		int sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		while (sLevel > 3) {
			sUpperOrgID = Sqlca.getString("select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"'");
			if (sUpperOrgID == null) break;
			sOrgID = sUpperOrgID;
			sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		}
				
		return sOrgID;
	}
%>

<% 	
	//获得组件参数	
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sDocID      = DataConvert.toRealString(iPostChange,(String)request.getParameter("DocID"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
	String sAttribute = DataConvert.toRealString(iPostChange,(String)request.getParameter("Attribute"));
	String sOrgID = getBranchOrgID(CurOrg.getOrgID(),Sqlca);
	
%>
<html>
<head>
	<title>调查报告</title>		
	<script type="text/javascript">
		function mykd1()
		{
			//F3:F5:F11:FullScreen
			if(event.keyCode==114 || event.keyCode==116 || event.keyCode==122 || (event.keyCode==78 && event.ctrlKey) ) 	 
			{
				event.keyCode=0; 
				event.returnValue=false; 
				return false;
			}
		}
		function mykd2()
		{
			if(myprint10.event.keyCode==114 || myprint10.event.keyCode==116 || myprint10.event.keyCode==122 || (myprint10.event.keyCode==78 && myprint10.event.ctrlKey) ) 	 //F3:F11:FullScreen
			{
				myprint10.event.keyCode=0; 
				myprint10.event.returnValue=false; 
				return false;
			}
		}		
	</script>	
</head>
<body onkeydown=mykd1 >
	<font color=red style="font-size: 16pt;FONT-FAMILY:'宋体';color:red;background-color:#FFFFFF">
	 正在打开报告，请稍候......</font><BR>

	<iframe name="myprint10" width=0% height=0% style="display:none" frameborder=1></iframe>
</body>
</html>
<script type="text/javascript">
	try {	document.body.onkeydown=mykd1; } catch(e) {var a=1;}
	try {	document.onkeydown=mykd1; } catch(e) {var a=1;}
	try {	myprint10.document.body.onkeydown=mykd2; } catch(e) {var a=1;}
	try {	myprint10.document.onkeydown=mykd2; } catch(e) {var a=1;}
</script>	
<%
    ASResultSet rs  = null; 
   	StringTokenizer st = null;
    String sDirID = "";
	String sSql = "",sSerialNo=""; 
	String Produce="Yes";
	int i=0; //已完成报告页数
	
	st = new StringTokenizer(sAttribute,",");
	while(st.hasMoreTokens()){
		sDirID += "'"+st.nextToken()+"',";
	}
	
	if(sDirID.length()>=1)
		sDirID = sDirID.substring(0,sDirID.length()-1);
	else{
		Produce="No";
	}

	if(Produce.equals("Yes")){
    sSql =	" select serialno,objectno,f1.docid,f1.dirid,f1.dirname,jspfilename " +
			" from formatdoc_data f1,formatdoc_def f2" +
			" where f2.docid=f1.docid and f2.dirid =f1.dirid and f1.dirid in ("+sDirID+")"+
			" and objectno='"+sObjectNo+"' and objecttype='"+sObjectType+"' and f1.docid='"+sDocID+"' "+
			" and JspFileName is not null and JspFileName <>'NULL'"+
			" order by treeno ";
	//out.println(sSql);
    rs = Sqlca.getASResultSet(sSql);
    String sFirstSection = "1";
    while(rs.next()){
    	sSerialNo = rs.getString("serialno");
    	String sJspFileName = DataConvert.toString(rs.getString("jspfilename"));
    	String sDirName = DataConvert.toString(rs.getString("dirname"));
    	out.println("*************"+sDirName+"***********************完成"+"<br>");
		  
    	if(!sJspFileName.trim().equals("")){
    		i++;
    		if(i==rs.getRowCount()){
				//尾页
				sFirstSection = "END";
			}else if(i>1){	
				sFirstSection = "0";
			}
%>
	<script type="text/javascript">
		PopPageAjax("<%=sJspFileName%>?DocID=<%=sDocID%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SerialNo=<%=sSerialNo%>&CustomerID=<%=sCustomerID%>&Method=4&FirstSection=<%=sFirstSection%>&Attribute=<%=sAttribute%>&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	</script>
<%    
		}else{ //如果没有jsp,仅为一个标题
	        String sSerialNoNew = MessageDigest.getDigestAsUpperHexString("MD5", sDocID+sObjectNo+sObjectType);
	        //判断路径是否存在，如果不存在自动创建;文档存储路径中增加以当年年份命名的目录 cdeng 2009-02-12
	    	java.io.File dFile=null;
	    	String sBasePath = CurConfig.getConfigure("WorkDocSavePath");
	    	if(sBasePath ==null || sBasePath.equals(""))
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

	        java.io.File file = new java.io.File(sFileName);
	        java.io.FileOutputStream fileOut = null;
			
	       
	    	String sSql1="",sSavePath="",sfSerialNo="",sSql2="";
	    	if(sFirstSection.equals("1")){
		    	sSql1=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+
		    		  "' and DocID='"+sDocID+"'";
		    	rs = Sqlca.getASResultSet(sSql1);
		    	if(rs.next()){
		    		sfSerialNo = rs.getString("SerialNo");
		    		sSavePath = rs.getString("SavePath");
		    	}
		    	rs.getStatement().close();
	
	    		if(sfSerialNo==null) sfSerialNo="";
	    		if(sSavePath==null) sSavePath="";
	    		
		    	if(sfSerialNo.equals("")){
		    		sSql2=" insert into formatdoc_record values('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sDocID+"','"+sFileName+"','','','','','')";
		    	}else if(!sfSerialNo.equals("") && !sSavePath.equals(sFileName)){
		    		sSql2=" update formatdoc_record set SavePath='"+sFileName+"'  where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"' and DocID='"+sDocID+"'";
		    		
		    	}else sSql2="";
	    	}
			if(sFirstSection.equals("1")){
				fileOut = new java.io.FileOutputStream(file,false);
				sFirstSection = "0";
			}else{
				fileOut = new java.io.FileOutputStream(file,true);
			}
			String sContent = rs.getString(5)+"<br>";
	        fileOut.write(sContent.getBytes());
			fileOut.close();
			if(sFirstSection.equals("1")&&!sSql2.equals("")){
				Sqlca.executeSQL(sSql2);
			}
		}
    }
    rs.getStatement().close();
    }
%> 
<script type="text/javascript">
	if("<%=Produce%>"=='Yes'){
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID=<%=sDocID%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self");
	}else{
		alert("无打印节点，请选择打印节点！");
		self.close();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>