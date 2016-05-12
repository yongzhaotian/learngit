<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.awe.security.*"%>
<%
	String sPasswordState =  new UserMarkInfo(Sqlca,CurUser.getUserID()).getPasswordState();
	if(sPasswordState == null) sPasswordState = "";
%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
	function checkpassword(){
		sOldPassword  = document.getElementById("oldPassword").value;	
		sNewPassword  = document.getElementById("newPassword").value;	
		sNewPassword2  = document.getElementById("newPassword2").value;	

		var pattern = /^.*[^a-zA-Z0-9!@$*.]{1,}.*$/;
		var re = new RegExp("((?=[!@$*.]+)[^A-Za-z0-9])");
		var re1 = new RegExp("((?=[A-Za-z]+)[^!@$*.0-9])");
		var re2 = new RegExp("((?=[0-9]+)[^A-Za-z!@$*.])"); 
		
		if(sOldPassword==""){
			showMessage("������ԭ��������!");
			return;
		}
		if(sNewPassword=="" && sNewPassword2==""){
			showMessage("�����벻��Ϊ��!");
			return;
		}
		if(sNewPassword != sNewPassword2){
			showMessage("������������벻һ��!");
			return;
		}
		if(sNewPassword.length <= 8||sNewPassword.length > 30){
			showMessage("���볤�ȱ���9��30λ!");
			return;
		}
		if(pattern.exec(sNewPassword)){
			showMessage("���벻�ܰ�����Сд��ĸ�����ֻ���!@$*.֮����ַ�!");
			return;
		}
		if (!re.test(sNewPassword) || !re1.test(sNewPassword) || !re2.test(sNewPassword)) {
			showMessage("������������Сд��ĸ�����ֺ�!@$*. !");
			return;
		}
		
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.CheckPassword","checkPassword","OldPassword="+sOldPassword+",NewPassword="+sNewPassword+",UserID=<%=CurUser.getUserID()%>");
		if(sReturn != "SUCCEEDED"){
			showMessage(sReturn);
		}else{
			<%if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){
			%>
				showMessage("�����޸ĳɹ��������µ�¼ϵͳ!");
				window.open("<%=sWebRootPath%>/index.html","_top");
			<%}else {
			%>
				showMessage("�����޸ĳɹ�!");
			<%}%>
		}
	}

	function showMessage(src){
		var o = document.getElementById("message");
		if(o.flag) window.clearTimeout(o.flag);
		
		o.innerHTML = src;
		o.style.display = "block";
		var flag = setTimeout(function(){
			o.style.display = "none";
			o.flag = "";
		}, 10000);
		o.flag = flag;
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�޸�����</title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/AppMain/resources/css/page.css"/>
<link rel="stylesheet" type="text/css" href="<%=sSkinPath%>/css/page.css"/>
</head>
<body scroll="no" bgcolor="#f2f2f2">
	<div class="pwd_main" >
		<p id="message"></p>
		<form id="pass_word">
	        <input type="password" id="oldPassword" />
	        <input type="password" id="newPassword" />
	        <input type="password" id="newPassword2" />
	    </form>
	    <div class="nor_btnzone" >
	    	<table><tr>
		      	<td><%=HTMLControls.generateButton("ȷ��","ȷ��","checkpassword()",sResourcesPath)%></td>
	<%if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){%>
		      	<td><%=HTMLControls.generateButton("���µ�¼","ȷ��","window.open('" + sWebRootPath + "/index.html','_top')",sResourcesPath)%></td>
	<%}else{%>
		      	<td><%=HTMLControls.generateButton("�ر�","�ر�","self.close()",sResourcesPath)%></td>
	<%}%>
	      	</tr></table>
	    </div>
    </div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>