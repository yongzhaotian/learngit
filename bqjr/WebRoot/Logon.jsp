<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
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

boolean isBatching=true;

//������֤��
public boolean vaildCheckCode(HttpServletRequest request) {
	String sCheckCode = request.getParameter("CheckCode");
	String sSaveCheckCode = (String)request.getSession().getAttribute("CheckCode");
	if (sSaveCheckCode==null || sCheckCode==null) {
		return true;
	} else if(sCheckCode.equalsIgnoreCase(sSaveCheckCode)){
		return true;
	} else {
		return false;
	}
}


/********************��֤�û������Ƿ���*******************************/

public boolean vaildUserType(String userId,Transaction Sqlca)throws Exception{
	boolean flag=false;
	String selectSQL = "select 1 from user_info where userId=:UserID and usertype=:usertype";
	SqlObject asql = new SqlObject(selectSQL);
	asql.setParameter("UserID", userId).setParameter("usertype", "03");
	ASResultSet rs = Sqlca.getASResultSet(asql);
	flag = rs.next();
	rs.close();
	return flag;
	
}

protected static String getCurrentTime() {
	return new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(Calendar
			.getInstance().getTime());
}

//�����û�
private void lockUser(Transaction sqlca,String sUserId) throws Exception {
	String lockSQL = "update user_info set lockstatus=:lockstatus where userID =:UserID";
	SqlObject asql = new SqlObject(lockSQL);
	asql.setParameter("lockstatus","5");
	asql.setParameter("UserID", sUserId);
	sqlca.executeSQL(asql);
}

//�����û�
private void unLockUser(Transaction sqlca,String sUserId) throws Exception {
	String lockSQL = "update user_info set lockstatus =:LockStatus where userID =:UserID";
	sqlca.executeSQL(new SqlObject(lockSQL).setParameter("LockStatus", "").setParameter("UserID",
			sUserId));
}
//��鵱ǰ�û��Ƿ����
private boolean checkExist(String userID, Transaction sqlca)
		throws Exception {
	boolean isExist = false;
	String checkSQL = "select 1 from t_login_check where userID=:UserID";
	ASResultSet rs = sqlca.getASResultSet(new SqlObject(checkSQL)
			.setParameter("UserID", userID));
	isExist = rs.next();
	rs.close();
	return isExist;
}

//��鵱ǰ�û��Ƿ����
private int findErrorTimes(String userID, Transaction sqlca)
		throws Exception {
	int errortimes=0;
	String checkSQL = "select errortimes  from t_login_check where userID=:UserID";
	ASResultSet rs = sqlca.getASResultSet(new SqlObject(checkSQL)
			.setParameter("UserID", userID));
	if(rs.next()){
		errortimes=rs.getInt("errortimes");
	}
	rs.close();
	return errortimes;
}

//��������ʧ�ܴ���
private  int getAllowFailedTimes(Transaction sqlca) throws Exception {
		int times = 0;
		String selectSQL = "select itemValue from Security_Audit where itemno='0601'";
		ASResultSet rs = sqlca.getASResultSet(new SqlObject(selectSQL));
		if (rs.next()){
			times = DataConvert.toInt(rs.getString(1));
		}
		rs.close();
		return times;
	}

private void recorderEroorTimes(Transaction sqlca,String sUserId,String lastlogintime,int errorTimes)throws Exception{
	String updateSql="update t_login_check set errortimes=:ErrorTimes,lastloginTime=:LastLoginTime where userid=:UserID";
	String insertSql="insert into t_login_check(errortimes,lastloginTime,userid)values(:ErrorTimes,:LastLoginTime,:UserID)";
    SqlObject asql = null;
		if (checkExist(sUserId, sqlca)){
			asql = new SqlObject(updateSql);
		}else{
			asql = new SqlObject(insertSql);
		}
		asql.setParameter("ErrorTimes", errorTimes);
		asql.setParameter("LastLoginTime", lastlogintime);
		asql.setParameter("UserID", sUserId);
		sqlca.executeSQL(asql);
}

//�������һ�ε�½ʱ��
private void updateLockTime(Transaction sqlca,String sUserId,String lockTime)throws Exception{
	String updateSql="update t_login_check set locktime =:Locktime where userid=:UserID";
	sqlca.executeSQL(new SqlObject(updateSql).setParameter("Locktime", lockTime).setParameter("UserID", sUserId));
}

//ȡ�����һ�ε�½ʱ��
private String getLockTime(Transaction sqlca,String sUserId)throws Exception{
	String selectSQL = "select locktime  from t_login_check where userid =:UserID";
	ASResultSet rs = sqlca.getASResultSet(new SqlObject(selectSQL).setParameter("UserID", sUserId));
	String locktime="0";
	if (rs.next()){
		locktime=rs.getString("locktime");
	}
	rs.close();
	return locktime;
}

// �û���¼�����������֤�Լ��
public boolean vaildUserPassword(HttpServletRequest request, Transaction Sqlca, 
					String sUserID, String sPassword, String userName, 
					boolean flag,String userstate) throws Exception {
	
    LogonUser user = new LogonUser(userName, sUserID, sPassword);
	SecurityAudit securityAudit = new SecurityAudit(user);
	String requestMessage = request.getRemoteAddr() + "," + request.getRemoteAddr() 
					+ "," + request.getServerName() + "," + request.getServerPort();	// ��request������Ϣƴ��һ�£�����ȥ
	
	if (!flag) {	// ���û���־Ϊ2��ʱ�����������Ե�¼
		return false;
	} else {
		if(securityAudit.isLogonSuccessful(Sqlca, null, requestMessage)){	// Ŀǰ�ⲽ����Ҫ��ĵ�¼��֤
			// ��¼�ɹ��������һ������������֤
			PasswordRuleManager pwm = new PasswordRuleManager();
			IsPasswordOverdueRule isPWDOverdueRule = new IsPasswordOverdueRule(sUserID, SecurityOptionManager.getPWDLimitDays(Sqlca), Sqlca);//�ù���ֻ����֤�Թ��򣬲��ǵ�¼�ɹ�ʧ�ܵı�Ҫ����
			ALSPWDRules alsRules = new ALSPWDRules(SecurityOptionManager.getRules(Sqlca));
			pwm.addRule(isPWDOverdueRule);	// �ù����ALSPWDRules����Ҫ������ӽ�ȥ
			pwm.addRule(alsRules);
			securityAudit.isValidateSuccessful(Sqlca, pwm);
			recorderEroorTimes(Sqlca,sUserID,getCurrentTime(),0); 
			return true;
		} else {
			int maxErrorTimes = getAllowFailedTimes(Sqlca);
			int logonErrorTimes=findErrorTimes(sUserID,Sqlca);
			logonErrorTimes=logonErrorTimes+1;
			if(logonErrorTimes==maxErrorTimes){
				 lockUser(Sqlca,sUserID); 
				 updateLockTime(Sqlca,sUserID,getCurrentTime());
				 recorderEroorTimes(Sqlca,sUserID,getCurrentTime(),logonErrorTimes); 
			}else{
				recorderEroorTimes(Sqlca,sUserID,getCurrentTime(),logonErrorTimes); 
			}
			 
			}
		       return false;
		}
}
/******************��ѯϵͳ�Ƿ�������*********************************/
public boolean verificationBatch(HttpServletRequest request, Transaction Sqlca,String sUserID, String sPassword) throws Exception { 
								
	/*************��ѯ�Ƿ���Ե�¼****************/

	String startcabp = Sqlca.getString(new SqlObject(" SELECT count(1) FROM system_setup t  WHERE t.loginFlag ='1'"));
	String userId = sUserID.toUpperCase();
	int amin = userId.indexOf("ADMIN");
	int test = userId.indexOf("TEST");
	if (amin == 0 || test == 0) {		// ����˺��Ǵ�admin����test�û����Ե�¼
		return true;
	} else {//��amin��test�˺ţ�ϵͳ�ڲ��ܵ�¼ʱ��ʾ��ϵͳ����ά�������Ժ��ٵ�¼
		if ("0".equals(startcabp)) {//startcabp==1,��˵��ϵͳ���ɵ�¼��startcabp==0����˵��ϵͳ�ɵ�¼
			return true;
		}
		else{
		        return false;
		}
	}
	  

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
	String userName = "";
	String sLogonFlag = "";
	String userstate=null;
	String lockstatus=null;
	double sCount = 0.0;
    boolean waitflag=false;
	boolean isflag=false;
	int loginerrors=0;
	try {
		// ��ô���Ĳ������û���¼�˺š����������
		String sUserID = request.getParameter("UserID");
		String sPassword = request.getParameter("Password");
		String sStyleModel = request.getParameter("StyleModel");
		String sScreenWidth = request.getParameter("ScreenWidth");
		String ipHost = request.getParameter("ipHost");
		// ����ѡ���û����ٵ�½��ϵͳ��ʽ���к��ɾ��
		String sUserIDSelected = "";
		if (sUserID == null || sUserID.equals("")) {
			sUserIDSelected = request.getParameter("UserIDSelected");
			sUserID = sUserIDSelected;
		}
		sStyleModel = request.getParameter("StyleModel");
		if (sStyleModel == null || sStyleModel.equals("")) {
			sStyleModel = "1";
		}

		Configure CurConfig = Configure.getInstance(application);
		String sWebRootPath = request.getContextPath();
		String sResourcesPath = sWebRootPath + CurConfig.getConfigure("ResourcesPath");
		sResourcesPath = sResourcesPath + "/" + sStyleModel; //����sResourcesPath
		Sqlca = new Transaction(CurConfig.getConfigure("DataSource"));
		isBatching = verificationBatch(request, Sqlca, sUserID, sPassword);
                /**********begin CCS-1041,����ϵͳ����ʱ���ܵ�¼ϵͳ  huzp 20150911**************/
		 if(!isBatching){
		 %>
				<script type="text/javascript">
					alert("ϵͳ����ά���У���ʱ�޷���¼��");
					window.open("index.html","_top");
				</script>
		 <%
		 return;
		 }
		/**********end **************/	
		ASResultSet rs = null;
		String sSql = "select userName,status,LogonFlag,lockstatus from user_info where userid = :userid";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("userid", sUserID));
		while(rs.next()){
			userName = rs.getString("userName");
			sLogonFlag = rs.getString("LogonFlag");
			userstate=rs.getString("status");
			lockstatus=rs.getString("lockstatus");
		}
		
		boolean flag = true;
		if (ipHost != null && !"".equals(ipHost) && "2".equals(sLogonFlag)) {
			ipHost = ipHost.split(":")[0];
			sCount = Sqlca.getDouble(new SqlObject("SELECT COUNT(1) FROM IP_INFO WHERE IP = :IP AND IP_STATUS = '1' AND IP_TYPE = '0'")
											.setParameter("IP", ipHost));
			if (sCount <= 0) {
				flag = false;
			}
		}
		
	
		if("5".equals(lockstatus)){
			 String lastlocktime=getLockTime(Sqlca,sUserID);
			 System.out.println("lastloginTime="+lastlocktime);
			 SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			 long l=sdf.parse(lastlocktime).getTime()+300000;
			 Calendar nowTime = Calendar.getInstance();
			 if(!(nowTime.getTime().getTime()>=l)){
				 waitflag=true;
				  loginerrors=getAllowFailedTimes(Sqlca);
				 throw new Exception("�˺�����������5���Ӻ����ԣ�");
		     }else{
		    	 recorderEroorTimes(Sqlca,sUserID,getCurrentTime(),0); 
		    	 unLockUser(Sqlca,sUserID);
		    	 waitflag=false;
		     }
	    }
	
	
	    if(vaildUserType(sUserID,Sqlca)){
			isflag=true;
			throw new Exception("�û�["+sUserID+"]��¼ʧ��:�û����Ͳ���");
			
		}
	
	
		if (!vaildUserPassword(request, Sqlca, sUserID, sPassword, userName, flag,userstate)) {
			throw new Exception("�û�["+sUserID+"]��¼ʧ��:�û��������ʧ��");
		}
		
		
		
	   
		Sqlca.commit();
		/* String sIp = request.getRemoteAddr();
		try{
			sIp = sIp.substring(0, sIp.lastIndexOf("."));
		}catch (Exception e) {
			sIp = "error";
		}
		sCount = Sqlca.getDouble(new SqlObject("select count(1) from ip_list where Address like '"+sIp+"%'"));
		if (!vaildUserPassword(request, Sqlca, sUserID, sPassword,userName,sLogonFlag,sCount)) {
			throw new Exception("�û�["+sUserID+"]��¼ʧ��:�û��������ʧ��");
		}
		Sqlca.commit(); */
		// �û�У��ͨ�������, ����һ��web serverֻ����һ���û���½ add by tbzeng 2014/05/29
		
		// add by tbzeng end 
		
		//ȡ��ǰ�û��ͻ�������������� Session
		ASUser CurUser = ASUser.getUser(SpecialTools.real2Amarsoft(sUserID), Sqlca);
		com.amarsoft.awe.res.model.SkinItem.reloadSkin(session.getServletContext(), CurUser.getSkin());

		//�������������Ĳ��� CurARC����IncludeBegin.jsp��ʹ��
		RuntimeContext CurARC = new RuntimeContext();
		CurARC.setAttribute("ResourcesPath", sResourcesPath);
		CurARC.setAttribute("WebRootPath", sWebRootPath);
		CurARC.setAttribute("ScreenWidth", sScreenWidth);
		CurARC.setUser(CurUser);
		CurARC.setPref(new ASPreference(CurUser.getUserID()));
		CurARC.setCompSession(new ComponentSession());

		session.setAttribute("CurARC", CurARC);
		
		//�û���½�ɹ�����¼��½��Ϣ
		session.setAttribute("CurUserId", sUserID); 
		
	    SessionListener sessionListener = new SessionListener(request, session, CurUser, CurConfig.getConfigure("DataSource"));
	    session.setAttribute("listener", sessionListener);
%><script type="text/javascript">
<%
		String sPasswordState = new UserMarkInfo(Sqlca, CurUser.getUserID()).getPasswordState();
		/* ��ʽʹ��ʱ�뽫������������״̬У�� */
		if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) 
					|| sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))
					|| Arrays.asList("CC479F435370A46C8EE5DDD65B3F4295").contains(CurUser.getPassword())) {
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
			var isBatching=<%=isBatching%>;
			var sLogonFlag = "<%=sLogonFlag%>";
			var sCount =<%=sCount%>;
			var waitflag =<%=waitflag%>;
			var userstate="<%=userstate%>";
			var isflag=<%=isflag%>;
			var loginerrors=<%=loginerrors%>;
			if(!isBatching){
					alert("ϵͳ����ά�������Ժ��ٵ�¼��");
				}else if(sLogonFlag=="2"&&sCount<=0){
					alert("��ʹ��������ַ��¼ϵͳ!");
				}else if(userstate=="0"){//CCS-1041,���û�ID����ʱ�޸���ʾ�� huzp 20150911
					alert("��¼ʧ��,����ID��������״̬���޷���¼ ��");
	
				}else if(waitflag){
				       alert("��������"+loginerrors+"�δ��󣬵�½ʧ�ܣ�����ID��������5���ӣ���5���Ӻ��ٵ�¼��");
				}else if(isflag){
				       alert("�û���½���Ͳ��ԣ�");
				}else{
					alert("��¼ʧ��,�����û����������Ƿ�������ȷ��\n��������������룬����ϵͳ����Ա��ϵ���ָ���ʼ���롣");
				}
			
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