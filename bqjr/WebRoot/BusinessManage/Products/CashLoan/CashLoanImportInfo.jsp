<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%

	String ObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(ObjectNo == null) ObjectNo = "";

%>

<%
	String[][] sButtons = {
			{"true","All","Button","���ݵ���","","importRecord()",sResourcesPath,"",""},
	};
%>
<body style="overflow:hidden;" onload="javascript:ready();" onresize="javascript:changeStyle();">
<div id="Buttons" style="width:450px;height=350px;color:red">
<div id="ButtonsDivtable" style="margin-left:15px;margin-top:20px;width:450px;height=350px;display=none">
</div>
<div id="ButtonsDiv" style="margin-left:15px;margin-top:20px;width:450px;height=350px;">
<table><tr>
	<td><form  name="Attachment" style="margin-bottom:10px;" enctype="multipart/form-data" action="<%=request.getContextPath() %>/BusinessManage/Products/CashLoan/CashLoanDealFileUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" method="post">
		<input id = "FileID" style='width:250px;height:24px;' type="file" name="File" />
		<input type="hidden" name="FileName" />
		<input type="hidden" name="DocNo" />
		<input type="hidden" name="SerialNo" value="<%=ObjectNo%>" />
	</form></td>
	<td><%@ include file="/Resources/CodeParts/ButtonSet.jsp"%></td>
</tr></table>
</div>
</div>
</body>
<script type="text/javascript">

//�ļ�����
function importRecord(){
	var o = document.forms["Attachment"];
	var filePath = document.getElementById("FileID").value;
	var serialNo = getSerialNo("DOC_LIBRARY","DocNo","");
	if(typeof(filePath)=="undefined"||filePath==""||filePath==null){
		alert("��ѡ�����ļ���");
		return;
	}
	if(filePath.indexOf(".txt")<0){
		alert("�ļ���ʽ����ȷ����ѡ���ı��ļ�!");
		return;
	}

	o.FileName.value=filePath;
	o.DocNo.value=serialNo;
	initPage();
	
    o.submit();	
	reloadSelf();
}

function initPage(){
	document.getElementById("ButtonsDivtable").style.display = "";	
	document.getElementById("Buttons").style.background = "rgb(240,245,240)";
	document.getElementById("ButtonsDivtable").innerHTML = " ϵͳ���ڴ���! ���Ժ�...";
	document.getElementById("ButtonsDiv").style.display = "None";
}
</script>
<%@ include file="/IncludeEnd.jsp"%>