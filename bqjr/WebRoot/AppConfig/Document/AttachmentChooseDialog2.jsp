<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//获得页面参数	
	String sDocNo = CurPage.getParameter("DocNo"); //文档编号
%>
<head> 
<title>请输入附件信息</title>

<script type="text/javascript">
	function checkItems(){
		//检查代码合法性
		var o = document.forms["SelectAttachment"];
		var sFileName = o.AttachmentFileName.value;
		o.AttachmentFileName.value = sFileName;
		alert(sFileName);
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("请选择一个文件名!");
			return false;
		}
		var fileSize;
		if(typeof(ActiveXObject) == "function"){ // IE
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var f1 = fso.GetFile(sFileName);
			fileSize = f1.size;
		}else{
			fileSize = o.AttachmentFileName.files[0].size;
		}
		if(fileSize > 2*1024*1024){
			alert("文件大于2048k，不能上传！");
			return false;
		}
		
		return true;
	}
	
	function deleteAttachement(){
		var sDocNo = "<%=sDocNo%>";
		var sAttachmentNo = document.forms("SelectAttachment").AttachmentNo.value;
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
			alert("请选择一个文件！");
			return;
		}else{
			//alert("sDocNo="+sDocNo+";sAttachmentNo="+sAttachmentNo);
			if(confirm("您真的想删除该附件吗？")){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.config.document.action.AttachmentOperate","attachmentDelete","DocNo="+sDocNo+",AttachmentNo="+sAttachmentNo);
				if(sReturn =="SUCCEEDED"){
					alert("删除成功!");
					parent.openComponentInMe();
				}
			}
		}
	}

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#e3f5ff">
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/Document/AttachmentUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" align="center">
<table align="center">
	<tr>
   		<td class="black9pt" align="left" colspan="3">
   			<font size="2">附加文件的过程分两个步骤，若要附加多个文件，请您根据需要重复上述操作。当您完成后，请单击“确定”返回到您的任务。</font>
   		</td>
   	</tr>
   	<tr>
   		<td class="black9pt" align="left">
   			<font size="2">1.单击“浏览”选择文件，或在下面的框中键入文件的路径。</font>
   		</td>
   		<td></td>
   		<td class="black9pt" align="left">
   			<font size="2">2.通过单击“附加”，将文件移动到“附件”框。</font>
   		</td>
   	</tr>
	<tr>
   		<td class="black9pt" align="left">
   			<font size="2"><strong>查找文件：</strong></font>
   		</td>
   		<td></td>
   		<td class="black9pt" align="left">
   			<font size="2"><strong>附件：</strong></font>
   		</td>
   	</tr>
   	<tr>
   		<td align="left" valign="top">
   			<input type="file" size=45 name="AttachmentFileName">
   			<br>
   			<font size="2">注意：每个附件的大小不能超过2MB。&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>
   			<input type="button" style="width:50px" name="ok" value="确定" onclick="javascript:top.close(); ">
   		</td>
   		<td align="left" valign="top">
   			<input align="left" type="button" style="width:50px"  name="attach" value="附加" onclick="javascript:if(checkItems()) { self.SelectAttachment.submit();} ">
   			<input align="left" type="button" style="width:50px"  name="delete" value="删除" onclick="javascript:deleteAttachement(); ">
   			<input type=hidden name="DocNo" value="<%=sDocNo%>" >
   			<input type=hidden name="FileName" value="" >
   		</td>
   		<td align="left">
		    <select name='AttachmentNo' size='12' style='width:100%;hight:10%;max-height: 20%;overflow: auto' multiple='true'>
			<% 
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select * from doc_attachment where DocNo = :DocNo").setParameter("DocNo", sDocNo));
			while(rs.next()){
		    	java.io.File file = new java.io.File(rs.getString("FULLPATH"));
		    	//System.out.println("========================="+rs.getString("FULLPATH"));
				//if(file.exists() && file.isFile()){
	    			out.println("<option value='"+ rs.getString("ATTACHMENTNO") +"' >" + rs.getString("FILENAME") + "</option>");
	   			//}
			}%>
			</select>
   		</td>
   	</tr>
 </table>
</form>
</body>
<%@	include file="/IncludeEnd.jsp"%>