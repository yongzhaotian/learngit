<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.awe.security.*"%>
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: ��ҳ��
		Input Param:
			          
		Output param:
			      
		History Log: 2005/10/15 zywei �����û����밲ȫ��ƹ���
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
<title>Welcome ��ӭ����</title>
<link rel="stylesheet" href="Resources/ALS6/layout.css" type="text/css" />
</head>
<script language="javascript">
	window.onbeforeunload = onbeforeunload_handler; 
	function onbeforeunload_handler(){
	   //�û������������Ͻǹرհ�ť���ǰ�alt+F4�ر�
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
<span class="f14bo"><img src="Resources/ALS6/red_4X12.jpg" style="float:left" class="leftimg" /><%=DataConvert.toRealString(iPostChange,CurUser.getUserName())%>�����ã�</span><br /><br />
<%
		  	//ȡ��Ʒ���ơ��汾��
			String sProductName = CurConfig.getConfigure("ProductName");
			String sProductVersion = CurConfig.getConfigure("ProductVersion");
		  	%>
          	��������<%=iVisitTimes%>�ε�¼ &lt;<%=sProductName%> VER <%=sProductVersion%>&gt;<br><br>
			<%
			if(iVisitTimes<=1)
			{
			}else if(sLastSignOutTime != null && sLastSignOutTime.compareTo(sLastVisitTime)>0)
			{
			%>
				����һ�ε�¼��ϵͳ���� <%=sLastVisitTime%> ������  <%=sLastSignOutTime%>  �˳���<br><br>
			<%
			}else
			{
			%>
				����һ�ε�¼��ϵͳ���� <%=sLastVisitTime%> ��û�������˳���  <br><br>Ϊ�˱�֤�������ݰ�ȫ��ϵͳ�������ܣ�ǿ�ҽ�������������˳�ϵͳ��<br><br>
			<%}
			if(!sPasswordState.equals("0")){//״̬������ʱ�򣬲���ʾ��Ϣ
			%>
			<strong><font size="+1" face="����,Arial, Helvetica, sans-serif"><%=sPasswordMessage %></font></strong>
			<%} %>
</div>
</div>
</td></tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td class="menubg">
<span class="f14bc"><img src="Resources/ALS6/blue_4X12.jpg" style="float:left" class="leftimg" />����ǰ���Խ��еĲ���</span>
</td></tr>
<tr><td height="30"></td></tr>
<tr><td style="padding-left:100px;"><table>
			<tr>
				<%//�û��״ε�¼���������ʱ��ֻ�ܿ���"�޸�����"��"�˳�ϵͳ"��ť����������£������Կ���"������ҳ��"��ť
				if(!sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) && !sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){
				%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","������ҳ��","������ҳ��","javascript:goToMain()",sResourcesPath)%>
				</td>				
				<%}%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�޸�����","�޸�����","javascript:ModifyPassword()",sResourcesPath)%>
				</td>
				<%
				if(!sLastComp.equals("")){
				%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","������һ�������ʵ�ģ��","������һ�������ʵ�ģ��","javascript:goToLastVisit()",sResourcesPath)%>
				</td>
				<%
				}
				%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�˳�ϵͳ","�˳�ϵͳ","javascript:sessionOut()",sResourcesPath)%>
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
//���ý�����ҳ��ΪĬ�ϰ�ť
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
	if(confirm("ȷ���˳���ϵͳ��"))
		OpenComp("SignOut","/SignOut.jsp","","_top","");
}

/*
var sTestChinese = PopPage("/Frame/Test/TestChinese.jsp?TestChinese=���������ַ���&rand="+randomNumber(),"_blank","");
if(sTestChinese=="success"){
}else{
	alert("��һ̨�ͻ����޷���ȷ���������ַ�,��ᵼ��ϵͳ��������ϵͳ����Ա��ϵ��");
	window.open("index.html","_top");
}*/
</script>
<%@ include file="/IncludeEnd.jsp"%>
