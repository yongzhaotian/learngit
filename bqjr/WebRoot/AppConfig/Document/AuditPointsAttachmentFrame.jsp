<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String sDocNo = CurPage.getParameter("FlowNo"+"PhaseNo");
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	boolean isReadOnly = "ReadOnly".equals(CurPage.getParameter("RightType"));
	if(sDocNo == null) sDocNo = "";
	
	String[][] sButtons = {
			{"true","All","Button","�ϴ�","","importRecord()","","","",""},
			{"true","","Button","�鿴����","","viewFile()","","","",""},
			{"true","All","Button","ɾ��","","delRecord()","","","",""},
	};
%>
<body style="overflow:hidden;" onload="javascript:ready();" onresize="javascript:changeStyle();">
<div id="ButtonsDiv" style="margin-left:5px;">
<table><tr><%if(!isReadOnly){%>
	<td><form name="AuditPointsAttachment" style="margin-bottom:0px;" enctype="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/Document/AuditPointsAttachmentUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" method="post">
		<input type="file" name="File" />
		<%-- <input type=hidden name="DocNo" value="<%=sDocNo%>" > --%>
		<input type="hidden" name="FileName" />
	</form></td><%}%>
	<td><%@ include file="/Resources/CodeParts/ButtonSet.jsp"%></td>
</tr></table>
</div>
<iframe name="AuditPointsAttachmentList" id="AuditPointsAttachmentList" style="width:100%;" frameborder="0"></iframe>
</body>
<script type="text/javascript">
	function importRecord(){
		var o = document.forms["AuditPointsAttachment"];
		var sFileName = o.File.value;
		o.FileName.value = encodeURI(sFileName);
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("��ѡ��һ���ļ���!");
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
			alert("�ļ�����2048k�������ϴ���");
			return false;
		}
		var sFlowNo="<%=sFlowNo%>";
		var sPhaseNo="<%=sPhaseNo%>";
		RunMethod("���÷���","DelByWhereClause","DOC_ATTACHMENT,FlowNo='"+sFlowNo+sPhaseNo+"' and PhaseNo='"+sPhaseNo+"'");
		return o.submit();
	}
	
	function delRecord(){
		window.frames["AuditPointsAttachmentList"].deleteRecord();
	}

	function ready(){
		changeStyle();
		AsControl.OpenView("/AppConfig/Document/AuditPointsAttachmentList.jsp", "DocNo=<%=sDocNo%>", "AuditPointsAttachmentList");
	}
	
	function changeStyle(){
		document.getElementById("AuditPointsAttachmentList").style.height = document.body.clientHeight - document.getElementById("ButtonsDiv").offsetHeight;
	}
	
	function viewFile(){
		window.frames["AuditPointsAttachmentList"].viewFile();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>