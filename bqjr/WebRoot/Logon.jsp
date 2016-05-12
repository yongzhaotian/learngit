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

//检验验证码
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


/********************验证用户类型是否配*******************************/

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

//锁定用户
private void lockUser(Transaction sqlca,String sUserId) throws Exception {
	String lockSQL = "update user_info set lockstatus=:lockstatus where userID =:UserID";
	SqlObject asql = new SqlObject(lockSQL);
	asql.setParameter("lockstatus","5");
	asql.setParameter("UserID", sUserId);
	sqlca.executeSQL(asql);
}

//解锁用户
private void unLockUser(Transaction sqlca,String sUserId) throws Exception {
	String lockSQL = "update user_info set lockstatus =:LockStatus where userID =:UserID";
	sqlca.executeSQL(new SqlObject(lockSQL).setParameter("LockStatus", "").setParameter("UserID",
			sUserId));
}
//检查当前用户是否存在
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

//检查当前用户是否存在
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

//获以最大的失败次数
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

//更新最后一次登陆时间
private void updateLockTime(Transaction sqlca,String sUserId,String lockTime)throws Exception{
	String updateSql="update t_login_check set locktime =:Locktime where userid=:UserID";
	sqlca.executeSQL(new SqlObject(updateSql).setParameter("Locktime", lockTime).setParameter("UserID", sUserId));
}

//取得最后一次登陆时间
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

// 用户登录检查与密码验证性检查
public boolean vaildUserPassword(HttpServletRequest request, Transaction Sqlca, 
					String sUserID, String sPassword, String userName, 
					boolean flag,String userstate) throws Exception {
	
    LogonUser user = new LogonUser(userName, sUserID, sPassword);
	SecurityAudit securityAudit = new SecurityAudit(user);
	String requestMessage = request.getRemoteAddr() + "," + request.getRemoteAddr() 
					+ "," + request.getServerName() + "," + request.getServerPort();	// 将request请求信息拼接一下，传进去
	
	if (!flag) {	// 当用户标志为2的时候，外网不可以登录
		return false;
	} else {
		if(securityAudit.isLogonSuccessful(Sqlca, null, requestMessage)){	// 目前这步不需要别的登录验证
			// 登录成功，还需进一步进行密码验证
			PasswordRuleManager pwm = new PasswordRuleManager();
			IsPasswordOverdueRule isPWDOverdueRule = new IsPasswordOverdueRule(sUserID, SecurityOptionManager.getPWDLimitDays(Sqlca), Sqlca);//该规则只是验证性规则，不是登录成功失败的必要条件
			ALSPWDRules alsRules = new ALSPWDRules(SecurityOptionManager.getRules(Sqlca));
			pwm.addRule(isPWDOverdueRule);	// 该规则比ALSPWDRules更重要，先添加进去
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
/******************查询系统是否在跑批*********************************/
public boolean verificationBatch(HttpServletRequest request, Transaction Sqlca,String sUserID, String sPassword) throws Exception { 
								
	/*************查询是否可以登录****************/

	String startcabp = Sqlca.getString(new SqlObject(" SELECT count(1) FROM system_setup t  WHERE t.loginFlag ='1'"));
	String userId = sUserID.toUpperCase();
	int amin = userId.indexOf("ADMIN");
	int test = userId.indexOf("TEST");
	if (amin == 0 || test == 0) {		// 检查账号是带admin或者test用户可以登录
		return true;
	} else {//非amin与test账号，系统在不能登录时提示，系统正在维护，请稍后再登录
		if ("0".equals(startcabp)) {//startcabp==1,则说明系统不可登录。startcabp==0，则说明系统可登录
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
		alert("登录失败,验证码检验错误。");
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
		// 获得传入的参数：用户登录账号、口令、界面风格
		String sUserID = request.getParameter("UserID");
		String sPassword = request.getParameter("Password");
		String sStyleModel = request.getParameter("StyleModel");
		String sScreenWidth = request.getParameter("ScreenWidth");
		String ipHost = request.getParameter("ipHost");
		// 下拉选框用户快速登陆，系统正式运行后可删除
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
		sResourcesPath = sResourcesPath + "/" + sStyleModel; //修正sResourcesPath
		Sqlca = new Transaction(CurConfig.getConfigure("DataSource"));
		isBatching = verificationBatch(request, Sqlca, sUserID, sPassword);
                /**********begin CCS-1041,增加系统跑批时不能登录系统  huzp 20150911**************/
		 if(!isBatching){
		 %>
				<script type="text/javascript">
					alert("系统锁定维护中，暂时无法登录。");
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
				 throw new Exception("账号已锁定，请5分钟后再试！");
		     }else{
		    	 recorderEroorTimes(Sqlca,sUserID,getCurrentTime(),0); 
		    	 unLockUser(Sqlca,sUserID);
		    	 waitflag=false;
		     }
	    }
	
	
	    if(vaildUserType(sUserID,Sqlca)){
			isflag=true;
			throw new Exception("用户["+sUserID+"]登录失败:用户类型不对");
			
		}
	
	
		if (!vaildUserPassword(request, Sqlca, sUserID, sPassword, userName, flag,userstate)) {
			throw new Exception("用户["+sUserID+"]登录失败:用户密码检验失败");
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
			throw new Exception("用户["+sUserID+"]登录失败:用户密码检验失败");
		}
		Sqlca.commit(); */
		// 用户校验通过并检查, 控制一个web server只允许一个用户登陆 add by tbzeng 2014/05/29
		
		// add by tbzeng end 
		
		//取当前用户和机构，并将其放入 Session
		ASUser CurUser = ASUser.getUser(SpecialTools.real2Amarsoft(sUserID), Sqlca);
		com.amarsoft.awe.res.model.SkinItem.reloadSkin(session.getServletContext(), CurUser.getSkin());

		//设置运行上下文参数 CurARC　在IncludeBegin.jsp中使用
		RuntimeContext CurARC = new RuntimeContext();
		CurARC.setAttribute("ResourcesPath", sResourcesPath);
		CurARC.setAttribute("WebRootPath", sWebRootPath);
		CurARC.setAttribute("ScreenWidth", sScreenWidth);
		CurARC.setUser(CurUser);
		CurARC.setPref(new ASPreference(CurUser.getUserID()));
		CurARC.setCompSession(new ComponentSession());

		session.setAttribute("CurARC", CurARC);
		
		//用户登陆成功，记录登陆信息
		session.setAttribute("CurUserId", sUserID); 
		
	    SessionListener sessionListener = new SessionListener(request, session, CurUser, CurConfig.getConfigure("DataSource"));
	    session.setAttribute("listener", sessionListener);
%><script type="text/javascript">
<%
		String sPasswordState = new UserMarkInfo(Sqlca, CurUser.getUserID()).getPasswordState();
		/* 正式使用时请将代码启用密码状态校验 */
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
					alert("系统正在维护，请稍后再登录。");
				}else if(sLogonFlag=="2"&&sCount<=0){
					alert("请使用内网地址登录系统!");
				}else if(userstate=="0"){//CCS-1041,当用户ID锁定时修改提示语 huzp 20150911
					alert("登录失败,您的ID处于锁定状态，无法登录 。");
	
				}else if(waitflag){
				       alert("密码输入"+loginerrors+"次错误，登陆失败，您的ID将被锁定5分钟，请5分钟后再登录！");
				}else if(isflag){
				       alert("用户登陆类型不对！");
				}else{
					alert("登录失败,请检查用户名和密码是否输入正确！\n如果您忘记了密码，请与系统管理员联系，恢复初始密码。");
				}
			
			window.open("index.html","_top");
		</script>			
<%
		return;
	} finally {
		if(Sqlca!=null) {
			//断掉当前数据连接
			Sqlca.commit();
			Sqlca.disConnect();
			Sqlca = null;
		}
	}
%>