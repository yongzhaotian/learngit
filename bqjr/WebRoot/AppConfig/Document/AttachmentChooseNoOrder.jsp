<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//文档编号
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if (sTypeNo == null) sTypeNo = "";
	if (sDocNo == null) sDocNo = "";

	System.out.println("+++++++++++++++++++++++++++++++++++ClientID:"+CurComp.getClientID());
	System.out.println("+++++++++++++++++++++++++++++++++++sDocNo:"+sDocNo);
	System.out.println("+++++++++++++++++++++++++++++++++++sTypeNo:"+sTypeNo);
	System.out.println("+++++++++++++++++++++++++++++++++++sRightType:"+sRightType);
%>
<html>
<head> 
<title>请输入附件信息</title>
<script type="text/javascript">
	function checkItems(){
		var o = document.forms["SelectAttachment"];
		var sFileName = o.AttachmentFileName.value;
		o.FileName.value=sFileName;
		
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("请选择一个文件名!");
			return false;
		}

		return true;
	}

	/*~[Describe=打印个人征信查询授权书;InputParam=无;OutPutParam=无;]~ by 2015-04-09 linhai */
	function printContract(){
		var sObjectNo = <%=sDocNo%>;
		sObjectType = "AuthorizeSettle";
		var sDocID = "W010";
		var sUrl = "/FormatDoc/Report18/CreditAuthorization.jsp";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			//检查出帐通知单是否已经生成
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //未生成出帐通知单
				if(typeof(sDocID)=="undefined" ||sDocID.length==0||sDocID=="Failure"){
					alert("请联系系统管理员检查合同模板配置");
					return;
				}else{
					if(typeof(sUrl)=="undefined" ||sUrl.length==0||sUrl=="Failure"){
						alert("请联系系统管理员检查合同模板配置");
						return;
					}else{
						//生成出帐通知单	
						PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");						
						//记录生成动作
						RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=produce");						
					}
				}
			}
			//记录查看动作
			RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=view");
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}
	}
	
	//删除按钮是否隐藏
	function myfun(){
		if('<%=sRightType%>' == 'ReadOnly'){
			jQuery('#subButt').hide();//隐藏按钮
		}
	}
	/*用window.onload调用myfun()*/
	window.onload=myfun;//不要括号
	
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#D3D3D3">
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/Document/AttachmentUploadNoOrder.jsp?CompClientID=<%=CurComp.getClientID()%>" align="center">
<table align="center"  style="margin-top: 20px;">
	<tr>
    		<td class="black9pt"  align="left">
    			<font size="2">请选择一个文件作为附件上传:</font>
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
    			<input type=hidden name="TypeNo" value="<%=sTypeNo%>"/>
    			<input type=hidden name="FileName" value="" >
    		</td> 
    	</tr>
    	<tr>
      		<td align='center'>
				<input type="button" style="width:145px"  name="Cancel" value="打印个人征信查询授权书" onclick="printContract()">
				&nbsp;&nbsp;
				<input id="subButt" type="button" style="width:60px"  name="ok" value="确&nbsp;&nbsp;认" onclick="javascript:if(checkItems()) { SelectAttachment.submit();}">
				<!-- 
				&nbsp;&nbsp;
				<input type="button" style="width:60px"  name="Cancel" value="取&nbsp;&nbsp;消" onclick="javascript:self.returnValue='_none_';self.close()">
				 -->
			</td>
		</tr>
 </table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>