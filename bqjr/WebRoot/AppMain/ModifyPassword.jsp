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
			showMessage("请输入原来的密码!");
			return;
		}
		if(sNewPassword=="" && sNewPassword2==""){
			showMessage("新密码不能为空!");
			return;
		}
		if(sNewPassword != sNewPassword2){
			showMessage("两次输入的密码不一致!");
			return;
		}
		if(sNewPassword.length <= 8||sNewPassword.length > 30){
			showMessage("密码长度必须9至30位!");
			return;
		}
		if(pattern.exec(sNewPassword)){
			showMessage("密码不能包含大小写字母、数字或者!@$*.之外的字符!");
			return;
		}
		if (!re.test(sNewPassword) || !re1.test(sNewPassword) || !re2.test(sNewPassword)) {
			showMessage("密码必须包含大小写字母、数字和!@$*. !");
			return;
		}
		
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.CheckPassword","checkPassword","OldPassword="+sOldPassword+",NewPassword="+sNewPassword+",UserID=<%=CurUser.getUserID()%>");
		if(sReturn != "SUCCEEDED"){
			showMessage(sReturn);
		}else{
			<%if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){
			%>
				showMessage("密码修改成功！请重新登录系统!");
				window.open("<%=sWebRootPath%>/index.html","_top");
			<%}else {
			%>
				showMessage("密码修改成功!");
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
<title>修改密码</title>
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
		      	<td><%=HTMLControls.generateButton("确定","确定","checkpassword()",sResourcesPath)%></td>
	<%if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){%>
		      	<td><%=HTMLControls.generateButton("重新登录","确定","window.open('" + sWebRootPath + "/index.html','_top')",sResourcesPath)%></td>
	<%}else{%>
		      	<td><%=HTMLControls.generateButton("关闭","关闭","self.close()",sResourcesPath)%></td>
	<%}%>
	      	</tr></table>
	    </div>
    </div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>