<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.awe.security.*"%>
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: 2005/10/15 zywei 增加用户密码安全审计功能
	 */
	%>
<%/*~END~*/%>
<%
UserMarkInfo userMarkInfo = new UserMarkInfo(Sqlca, CurUser.getUserID());
int iVisitTimes = userMarkInfo.getVisitTimes();
String sLastVisitTime = userMarkInfo.getLastSignInTime();
String sLastSignOutTime = userMarkInfo.getLastSignOutTime();
String sPasswordState = userMarkInfo.getPasswordState();
String sPasswordMessage = userMarkInfo.getPasswordMessage();

String sLastApp = CurPref.getUserPreference(Sqlca,"LastVisitApp");
String sLastComp = CurPref.getUserPreference(Sqlca,"LastVisitComp");
String sLastCompName = CurPref.getUserPreference(Sqlca,"LastVisitCompName");
String sLastCompPara = CurPref.getUserPreference(Sqlca,"LastVisitCompPara");
String sLastCompURL = CurPref.getUserPreference(Sqlca,"LastVisitCompURL");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>Welcome 欢迎界面</title>
<link rel="stylesheet" href="Resources/ALS6/layout.css" type="text/css" />
</head>
<script language="javascript">
	window.onbeforeunload = onbeforeunload_handler; 
	function onbeforeunload_handler(){
	   //用户点击浏览器右上角关闭按钮或是按alt+F4关闭
        if(event.clientX>document.body.clientWidth&&event.clientY<0||event.altKey)  {
        	OpenComp("SignOut","/SignOut.jsp","","_top","");
        }else if(event.clientY > document.body.clientHeight || event.altKey){
        	OpenComp("SignOut","/SignOut.jsp","","_top","");
        }
	} 
</script>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="login001bg">
<tr><td>
<div id="login001">
<div class="login001">
<span class="f14bo"><img src="Resources/ALS6/red_4X12.jpg" style="float:left" class="leftimg" /><%=DataConvert.toRealString(iPostChange,CurUser.getUserName())%>，您好！</span><br /><br />
<%
		  	//取产品名称、版本号
			String sProductName = CurConfig.getConfigure("ProductName");
			String sProductVersion = CurConfig.getConfigure("ProductVersion");
		  	%>
          	这是您第<%=iVisitTimes%>次登录 &lt;<%=sProductName%> VER <%=sProductVersion%>&gt;<br><br>
			<%
			if(iVisitTimes<=1)
			{
			}else if(sLastSignOutTime != null && sLastSignOutTime.compareTo(sLastVisitTime)>0)
			{
			%>
				您上一次登录本系统是在 <%=sLastVisitTime%> ，并在  <%=sLastSignOutTime%>  退出。<br><br>
			<%
			}else
			{
			%>
				您上一次登录本系统是在 <%=sLastVisitTime%> ，没有正常退出。  <br><br>为了保证您的数据安全和系统运行性能，强烈建议您今后正常退出系统。<br><br>
			<%}
			if(!sPasswordState.equals("0")){//状态正常的时候，不显示信息
			%>
			<strong><font size="+1" face="宋体,Arial, Helvetica, sans-serif"><%=sPasswordMessage %></font></strong>
			<%} %>
</div>
</div>
</td></tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td class="menubg">
<span class="f14bc"><img src="Resources/ALS6/blue_4X12.jpg" style="float:left" class="leftimg" />您当前可以进行的操作</span>
</td></tr>
<tr><td height="30"></td></tr>
<tr><td style="padding-left:100px;"><table>
			<tr>
				<%//用户首次登录、密码过期时，只能看到"修改密码"、"退出系统"按钮，其他情况下，还可以看到"进入主页面"按钮
				if(!sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) && !sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){
				%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","进入主页面","进入主页面","javascript:goToMain()",sResourcesPath)%>
				</td>				
				<%}%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","修改密码","修改密码","javascript:ModifyPassword()",sResourcesPath)%>
				</td>
				<%
				if(!sLastComp.equals("")){
				%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","进入上一次最后访问的模块","进入上一次最后访问的模块","javascript:goToLastVisit()",sResourcesPath)%>
				</td>
				<%
				}
				%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","退出系统","退出系统","javascript:sessionOut()",sResourcesPath)%>
				</td>
			</tr>
            </table></td></tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="bottom" height="23">
<tr align="center"><td width="36%"></td><td>Powered By </td><td><a href="http://www.amarsoft.com"><strong>Amarsoft</strong></a></td><td> | Amarsoft Lending Suite</td><td width="36%"></td>
</tr>
</table>


</body>
</html>
<script type="text/javascript">
//设置进入主页面为默认按钮
//function document.onkeydown(){
	//if(event.keyCode == 13)
		//goToMain();
//}
function goToMain(){
	OpenComp("Main","/Main.jsp","","_self","");
}
function ModifyPassword(){
	var sReturn=PopPage("/DeskTop/ModifyPassword.jsp","","dialogWidth=24;dialogHeight=17;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if (typeof(sReturn)=="undefined" || sReturn.length==0)
		return;
	if (sReturn=="SUCCESS")
		self.open("<%=sWebRootPath%>/Frame/page/sys/SessionOut.jsp","_top","");
}
function goToLastVisit(){
	OpenComp("<%=sLastComp%>","<%=sLastCompURL%>","<%=sLastCompPara%>","_self","");
}

function sessionOut(){
	if(confirm("确认退出本系统吗？"))
		OpenComp("SignOut","/SignOut.jsp","","_top","");
}

/*
var sTestChinese = PopPage("/Frame/Test/TestChinese.jsp?TestChinese=测试中文字符集&rand="+randomNumber(),"_blank","");
if(sTestChinese=="success"){
}else{
	alert("这一台客户端无法正确传递中文字符,这会导致系统错误。请与系统管理员联系。");
	window.open("index.html","_top");
}*/
</script>
<%@ include file="/IncludeEnd.jsp"%>
