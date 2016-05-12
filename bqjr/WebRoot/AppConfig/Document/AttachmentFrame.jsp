<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sDocNo = CurPage.getParameter("DocNo");
	boolean isReadOnly = "ReadOnly".equals(CurPage.getParameter("RightType"));
	if(sDocNo == null) sDocNo = "";
	
	String[][] sButtons = {
			{"true","All","Button","上传","","importRecord()","","","",""},
			{"true","","Button","查看内容","","viewFile()","","","",""},
			{"true","All","Button","删除","","delRecord()","","","",""},
			//{"true","All","Button","导出附件","","exportFile()","","","",""},
	};
%>
<body style="overflow:hidden;" onload="javascript:ready();" onresize="javascript:changeStyle();">
<div id="ButtonsDiv" style="margin-left:5px;">
<table><tr><%if(!isReadOnly){%>
	<td><form name="Attachment" style="margin-bottom:0px;" enctype="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/Document/AttachmentUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" method="post">
		<input type="file" name="File" />
		<input type=hidden name="DocNo" value="<%=sDocNo%>" >
		<input type="hidden" name="FileName" />
	</form></td><%}%>
	<td><%@ include file="/Resources/CodeParts/ButtonSet.jsp"%></td>
</tr></table>
</div>
<iframe name="AttachmentList" id="AttachmentList" style="width:100%;" frameborder="0"></iframe>
</body>
<script type="text/javascript">
	function importRecord(){
		var o = document.forms["Attachment"];
		var sFileName = o.File.value;
		o.FileName.value = encodeURI(sFileName);
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
			fileSize = o.File.files[0].size;
		}
		if(fileSize > 2*1024*1024){
			alert("文件大于2048k，不能上传！");
			return false;
		}
		return o.submit();
	}
	
	function exportFile(){
		window.frames["AttachmentList"].exportFile();
	}
	
	function delRecord(){
		window.frames["AttachmentList"].deleteRecord();
	}

	function ready(){
		changeStyle();
		AsControl.OpenView("/AppConfig/Document/AttachmentList.jsp", "DocNo=<%=sDocNo%>", "AttachmentList");
	}
	
	function changeStyle(){
		document.getElementById("AttachmentList").style.height = document.body.clientHeight - document.getElementById("ButtonsDiv").offsetHeight;
	}
	
	function viewFile(){
		window.frames["AttachmentList"].viewFile();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>