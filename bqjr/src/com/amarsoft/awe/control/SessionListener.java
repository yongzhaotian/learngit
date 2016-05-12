package com.amarsoft.awe.control;

import java.io.Serializable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

public class SessionListener  implements HttpSessionBindingListener, Serializable
{
  private static final long serialVersionUID = 1L;
  private static int count = 0;
  private String sBeginTime;
  private String sEndTime;
  private String sSessionID;
  private String sRemoteAddr;
  private String sRemoteHost;
  private String sServerName;
  private String sServerPort;
  private String sUserID;
  private String sUserName;
  private String sOrgID;
  private String sOrgName;
  private String userAgent;
  private String sDataSource;

  public SessionListener(HttpServletRequest Req, HttpSession HS, ASUser curUser, String sDataSource)
  {
    this.sServerName = Req.getServerName();
    this.sServerPort = String.valueOf(Req.getServerPort());
    this.sSessionID = HS.getId();
    this.sRemoteAddr = Req.getRemoteAddr();
    this.sRemoteHost = Req.getRemoteAddr();
    this.sUserID = curUser.getUserID();
    this.sUserName = curUser.getUserName();
    this.sOrgID = curUser.getOrgID();
    this.sOrgName = curUser.getOrgName();
    this.sDataSource = sDataSource;
	this.userAgent = Req.getHeader("User-agent");//返回客户端浏览器的版本号、类型 
  }

  public SessionListener(HttpServletRequest Req, HttpSession HS, ASUser curUser, String sDataSource, String sClientIP)
  {
    this.sServerName = Req.getServerName();
    this.sServerPort = String.valueOf(Req.getServerPort());
    this.sSessionID = HS.getId();
    if (sClientIP != null) {
      this.sRemoteAddr = sClientIP;
      this.sRemoteHost = sClientIP;
    }
    else {
      this.sRemoteAddr = Req.getRemoteAddr();
      this.sRemoteHost = Req.getRemoteAddr();
    }
    this.sUserID = curUser.getUserID();
    this.sUserName = curUser.getUserName();
    this.sOrgID = curUser.getOrgID();
    this.sOrgName = curUser.getOrgName();
    this.sDataSource = sDataSource;
	this.userAgent = Req.getHeader("User-agent");//返回客户端浏览器的版本号、类型 
  }

  public static int getCount()
  {
    return count;
  }

  public void valueBound(HttpSessionBindingEvent event)
  {
    count += 1;
    Transaction Sqlca = null;
    try
    {
    	String sql = "insert into user_login_info(session_id, user_id, user_name, orgid, orgname, remoter_addr, remote_host, service_name, service_port, user_agent)"
				+ " values(:sessionid,:userid,:username,:orgid,:orgname,:remoteaddr,:remotehost,:servername,:serverport,:userAgent)";
		SqlObject sobj = new SqlObject(sql);
		sobj.setParameter("sessionid", this.sSessionID);
		sobj.setParameter("userid", this.sUserID);
		sobj.setParameter("username", this.sUserName);
		sobj.setParameter("orgid", this.sOrgID);
		sobj.setParameter("orgname", this.sOrgName);
		sobj.setParameter("servername", this.sServerName);
		sobj.setParameter("serverport", this.sServerPort);
		sobj.setParameter("remoteaddr", this.sRemoteAddr);
		sobj.setParameter("remotehost", this.sRemoteHost);
		sobj.setParameter("userAgent", this.getUserAgent());
		Sqlca = getSqlca();
		Sqlca.executeSQL(sobj);
		Sqlca.commit();
		Sqlca.disConnect();
		Sqlca = null;
      ARE.getLog().info("SessionListener:Logon Session[" + this.sSessionID + "] User[" + this.sUserID + "] UserName[" + this.sUserName + "]");
    }
    catch (Exception e)
    {
      ARE.getLog().info("SessionListener:valueBound():" + e);
      try
      {
        if (Sqlca != null)
        {
          Sqlca.disConnect();
          Sqlca = null;
        }
      }
      catch (Exception e1)
      {
      }
    }
  }

  public void valueUnbound(HttpSessionBindingEvent event)
  {
    count -= 1;
    if (count < 0) {
      count = 0;
    }
    Transaction Sqlca = null;
    try
    {
    	String sql = "insert into user_logout_info(session_id, user_id, user_name, orgid, orgname, remoter_addr, remote_host, service_name, service_port, user_agent)"
				+ " values(:sessionid,:userid,:username,:orgid,:orgname,:remoteaddr,:remotehost,:servername,:serverport,:userAgent)";
		SqlObject sobj = new SqlObject(sql);
		sobj.setParameter("sessionid", this.sSessionID);
		sobj.setParameter("userid", this.sUserID);
		sobj.setParameter("username", this.sUserName);
		sobj.setParameter("orgid", this.sOrgID);
		sobj.setParameter("orgname", this.sOrgName);
		sobj.setParameter("servername", this.sServerName);
		sobj.setParameter("serverport", this.sServerPort);
		sobj.setParameter("remoteaddr", this.sRemoteAddr);
		sobj.setParameter("remotehost", this.sRemoteHost);
		sobj.setParameter("userAgent", this.getUserAgent());
		Sqlca = getSqlca();
		Sqlca.executeSQL(sobj);
		Sqlca.commit();
		Sqlca.disConnect();
		Sqlca = null;
      ARE.getLog().info("SessionListener:Logout Session[" + this.sSessionID + "] User[" + this.sUserID + "] UserName[" + this.sUserName + "]");
    }
    catch (Exception e)
    {
      ARE.getLog().error("SessionListener:valueUnbound():" + e);
      try
      {
        if (Sqlca != null)
        {
          Sqlca.disConnect();
          Sqlca = null;
        }
      }
      catch (Exception e1)
      {
      }
    }
  }

  private Transaction getSqlca()
  {
    try
    {
      return new Transaction(this.sDataSource);
    }
    catch (Exception e)
    {
      ARE.getLog().error("SessionListener:getSqlca():" + e);
    }
    return null;
  }
public String getUserAgent() {
	return userAgent;
}

public void setUserAgent(String userAgent) {
	this.userAgent = userAgent;
}
}