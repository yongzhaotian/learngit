<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html; charset=GBK"%><%@
page import="com.amarsoft.are.util.*"%><%@
page import="com.amarsoft.awe.util.*"%><%@
page import="com.amarsoft.context.*"%><%@
page import="com.amarsoft.web.*"%><%@
page import="com.amarsoft.web.dw.*"%><%@
page import="com.amarsoft.awe.*"%><%@
page import="com.amarsoft.awe.control.SessionListener"%><%@
page import="com.amarsoft.awe.control.model.*"%><%@
page import="com.amarsoft.awe.util.*"%><%@
page import="com.amarsoft.awe.Configure"%><%@
page import="com.amarsoft.awe.security.*"%><%@
page import="com.amarsoft.awe.security.pwdrule.*"%><%!
//������֤��
public boolean vaildCheckCode(HttpServletRequest request) {
	String sCheckCode = request.getParameter("CheckCode");
	String sSaveCheckCode = (String)request.getSession().getAttribute("CheckCode");
	if (sSaveCheckCode==null || sCheckCode==null) return true;
	else if (sCheckCode.equalsIgnoreCase(sSaveCheckCode)) return true;
	else return false;
}

//�û���¼�����������֤�Լ��
public boolean vaildUserPassword(HttpServletRequest request, Transaction Sqlca,String sUserID,String sPassword) throws Exception {
    String userName = Sqlca.getString(new SqlObject("select userName from user_info where userid=:userid").setParameter("userid", sUserID));
    LogonUser user = new LogonUser(userName, sUserID, sPassword);
	SecurityAudit securityAudit = new SecurityAudit(user);
	String requestMessage = request.getRemoteAddr() + "," + request.getRemoteHost() + "," + request.getServerName() + "," + request.getServerPort();//��request������Ϣƴ��һ�£�����ȥ
	if(securityAudit.isLogonSuccessful(Sqlca, null, requestMessage)){//Ŀǰ�ⲽ����Ҫ��ĵ�¼��֤
		//��¼�ɹ��������һ������������֤
		PasswordRuleManager pwm = new PasswordRuleManager();
		IsPasswordOverdueRule isPWDOverdueRule = new IsPasswordOverdueRule(sUserID, SecurityOptionManager.getPWDLimitDays(Sqlca), Sqlca);//�ù���ֻ����֤�Թ��򣬲��ǵ�¼�ɹ�ʧ�ܵı�Ҫ����
		ALSPWDRules alsRules = new ALSPWDRules(SecurityOptionManager.getRules(Sqlca));
		pwm.addRule(isPWDOverdueRule);//�ù����ALSPWDRules����Ҫ������ӽ�ȥ
		pwm.addRule(alsRules);
		securityAudit.isValidateSuccessful(Sqlca, pwm);
		return true;
	}
	else return false;
}
%><%
	if (!vaildCheckCode(request)) {
	%><script type="text/javascript">
		alert("��¼ʧ��,��֤��������");
		window.open("index.html","_top");
	</script><%
	return;
	}

	java.util.Enumeration<String> attrs = session.getAttributeNames();
	while (attrs.hasMoreElements()) {session.removeAttribute(attrs.nextElement());}
	
	Transaction Sqlca = null;
	try {
		//��ô���Ĳ������û���¼�˺š����������
		String sUserID = request.getParameter("UserID");
		String sPassword = request.getParameter("Password");
		String sStyleModel = request.getParameter("StyleModel");
		String sScreenWidth = request.getParameter("ScreenWidth");
		
		//����ѡ���û����ٵ�½��ϵͳ��ʽ���к��ɾ��
		String sUserIDSelected = "";
		if (sUserID == null || sUserID.equals("")) {
			sUserIDSelected = request.getParameter("UserIDSelected");
			sUserID = sUserIDSelected;
		}
		sStyleModel = request.getParameter("StyleModel");
		if (sStyleModel == null || sStyleModel.equals(""))
			sStyleModel = "1";

		Configure CurConfig = Configure.getInstance(application);
		String sWebRootPath = request.getContextPath();
		String sResourcesPath = sWebRootPath + CurConfig.getConfigure("ResourcesPath");
		sResourcesPath = sResourcesPath + "/" + sStyleModel; //����sResourcesPath
		Sqlca = new Transaction(CurConfig.getConfigure("DataSource"));
		if (!vaildUserPassword(request, Sqlca, sUserID, sPassword)) throw new Exception("�û�["+sUserID+"]��¼ʧ��:�û��������ʧ��");
		
		// �û�У��ͨ�������, ����һ��web serverֻ����һ���û���½ add by tbzeng 2014/05/29
		
		// add by tbzeng end 
		
		//ȡ��ǰ�û��ͻ�������������� Session
		ASUser CurUser = ASUser.getUser(SpecialTools.real2Amarsoft(sUserID),Sqlca);
		com.amarsoft.awe.res.model.SkinItem.reloadSkin(session.getServletContext(), CurUser.getSkin());

		//�������������Ĳ��� CurARC����IncludeBegin.jsp��ʹ��
		RuntimeContext CurARC = new RuntimeContext();
		CurARC.setAttribute("ResourcesPath",sResourcesPath);
		CurARC.setAttribute("WebRootPath",sWebRootPath);
		CurARC.setAttribute("ScreenWidth",sScreenWidth);
		CurARC.setUser(CurUser);
		CurARC.setPref(new ASPreference(CurUser.getUserID()));
		CurARC.setCompSession(new ComponentSession());

		session.setAttribute("CurARC",CurARC);
		
		//�û���½�ɹ�����¼��½��Ϣ
		session.setAttribute("CurUserId", sUserID); 
		
	    SessionListener sessionListener=new SessionListener(request,session,CurUser,CurConfig.getConfigure("DataSource"));
	    session.setAttribute("listener",sessionListener);
%><script type="text/javascript">
<%
		String sPasswordState =  new UserMarkInfo(Sqlca,CurUser.getUserID()).getPasswordState();
		System.out.println("Pasword  : " + CurUser.getPassword());
		/* ��ʽʹ��ʱ�뽫������������״̬У�� */
		if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))
					|| Arrays.asList("CC357616CC513B4896F8FED824B3E191","EF75FEA5AB184710C0689AEA1A5B817F").contains(CurUser.getPassword())){
		//if(false){
%>
			window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/AppMain/ModifyPassword.jsp","_top");
<%
		}else{
%>
			window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/Main.jsp","_top");
<%	  
		}
%></script>
<%
	} catch (Exception e) {
		e.printStackTrace();
		e.fillInStackTrace();
		e.printStackTrace(new java.io.PrintWriter(System.out));
%>
		<script type="text/javascript">
			alert("��¼ʧ��,�����û����������Ƿ�������ȷ��\n��������������룬����ϵͳ����Ա��ϵ���ָ���ʼ���롣");
			window.open("index.html","_top");
		</script>			
<%
		return;
	} finally {
		if(Sqlca!=null) {
			//�ϵ���ǰ��������
			Sqlca.commit();
			Sqlca.disConnect();
			Sqlca = null;
		}
	}
%>