<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//�ĵ����
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));

    if(sDocNo == null) sDocNo = "";

%>
<html>
<head> 
<title>�����븽����Ϣ</title>
<script type="text/javascript">
	function checkItems(){
		var o = document.forms["SelectAttachment"];
		var sFileName = o.AttachmentFileName.value;
		
		var sModelID = o.ModelID.value;
		var sRuleType = o.RuleType.value;
		var sRuleID = o.RuleID.value;
		var sVersionID = o.VersionID.value;

		o.FileName.value=sFileName;
		
		if(typeof(sModelID) == "undefined" || sModelID==""){
			alert("���������ģ��!");
			return false;
		}
		
		if(typeof(sRuleType) == "undefined" || sRuleType==""){
			alert("�������������!");
			return false;
		}
		
		if(typeof(sRuleID) == "undefined" || sRuleID==""){
			alert("�����������!");
			return false;
		}
		
		if(typeof(sVersionID) == "undefined" || sVersionID==""){
			alert("������汾���!");
			return false;
		}
		
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("��ѡ��һ���ļ���!");
			return false;
		}
		
		//�ж��Ƿ���.ZIP��β��
		var str=sFileName.split(".");
		var ss=str[1];
		if(ss !="zip"){
			alert("�ļ���������.zip��β��");
			return false;
		}
		
		return true;
	}

</script>

<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#D3D3D3">
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/Document/AttachmentUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" align="center">

<table align="center">
	<tr>
		<td class="black9pt"  align="left">����ģ�ͣ�&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="ModelID"></td>
	</tr>
	<tr>
		<td class="black9pt"  align="left">�������ͣ�&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="RuleType"></td>
	</tr>
	<tr>
		<td class="black9pt"  align="left">�����ţ�&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="RuleID"></td>
	</tr>
	<tr>
		<td class="black9pt"  align="left">�汾��ţ�&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="VersionID"></td>
	</tr>
	<tr>
		<td class="black9pt"  align="left"></td>
	</tr>
	<tr>
    		<td class="black9pt"  align="left">
    			<font size="2">��ѡ��һ���ļ���Ϊ�����ϴ�:</font>
    		</td> 
    	</tr>
    	<tr>
    		<td>   
    			<input type="file" size=60  name="AttachmentFileName"> 
    		</td>
    	</tr>
      	<tr>
      		<td>
      			&nbsp;&nbsp;
    			<input type=hidden name="CompClientID" value="<%=CurComp.getClientID()%>" >
    			<input type=hidden name="DocNo" value="<%=sDocNo%>" >
    			<input type=hidden name="FileName" value="" >
    		</td> 
    	</tr>
    	<tr>
      		<td>
      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="ok" value="ȷ��" onclick="javascript:if(checkItems()) { SelectAttachment.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="Cancel" value="ȡ��" onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
	</tr>
 </table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>