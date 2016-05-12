package com.amarsoft.app.util;


import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

/**
 * 用户自定义工作台管理
 * @author syang
 * @date 2009/12/17
 */
public class WorkTipTabsManage extends Bizlet {

/**
 * 入口	
 */
 public Object  run(Transaction Sqlca) throws Exception {
	 boolean r = false;
	 String operate = (String)this.getAttribute("Operate");		//操作标识 add添加，del删除
	 String userID = (String)this.getAttribute("UserID");		//用户ID
	 String tabID = (String)this.getAttribute("TabID");			//TAB编号
	 String tabName = (String)this.getAttribute("TabName");		//TAB名称
	 String script = (String)this.getAttribute("Script");		//执行脚本
	 String cache = (String)this.getAttribute("Cache");			//是否缓存
	 String close = (String)this.getAttribute("Close");			//是否可关闭
	 if(operate == null) operate= "";
	 if(userID == null) userID= "";
	 if(tabID == null) tabID= "";
	 if(tabName == null) tabName= "";
	 if(script == null) script= "";
	 if(cache == null) cache= "1";
	 if(close == null) close= "1";
	 if(operate.equalsIgnoreCase("add")){
		 r = addUserTab(userID,tabID,tabName,script,cache,close,Sqlca);
	 }else if(operate.equalsIgnoreCase("del")){
		 r = deleteUserTab(userID,tabID,Sqlca);
	 }
	 if(r){
		 return "true";
	 }else{
		 return "false";
	 }
 }
 
 /**
  * 给用户添加一个新TAB
  * @param userID 用户ID
  * @param tabID TAB编号
  * @param tabName tab显示名称
  * @param script 执行脚本
  * @param cache 是否缓存
  * @param close 是否带关闭按钮
  * @return
 * @throws Exception 
  */
 public boolean addUserTab(String userID,String tabID,String tabName,String script,String cache,String close,Transaction Sqlca) throws Exception{
	 boolean b = true;
	 ASUser CurUser = ASUser.getUser(userID,Sqlca);
	 SqlObject so;
	 String serialno = DBKeyHelp.getSerialNo("USER_WORKTIPS","SerialNo",Sqlca);
	 String curTime = StringFunction.getToday()+" "+StringFunction.getNow();
	 if(cache.equalsIgnoreCase("true")){
		 cache = "1";
	 }else{
		 cache = "0";
	 }
	 if(close.equalsIgnoreCase("true")){
		 close = "1";
	 }else{
		 close = "0";
	 }
	 script  = script.replaceAll("`", "&");//传输时，逗号与系统逗号冲突，因此这里用`替换了逗号

	 String sql = "select serialno USER_WORKTIPS from USER_WORKTIPS where UserID=:UserID and TabID =:TabID";
	 so = new SqlObject(sql).setParameter("UserID", userID).setParameter("TabID", tabID);
	 ASResultSet rs = Sqlca.getASResultSet(so);
	 if(rs.next()){
		 b = false;
	 }
	 rs.getStatement().close();
	 rs = null;
	 if(b == false){
		 return b;
	 }
	 sql = "insert into USER_WORKTIPS("
			 	+"SerialNo,"			//010  流水号（顺序号)
			 	+"UserID,"				//020  用户ID
			 	+"TabID,"				//030 Tab编号
			 	+"TabName,"				//040  显示名称
			 	+"Script,"				//050  执行脚本
			 	+"CacheFlag,"			//060  缓存标志
			 	+"CloseFlag,"			//070 关闭按钮
			 	+"InputOrg,"			//080  登记机构
			 	+"InputUser,"			//090  登记人
			 	+"InputTime,"			//100  登记时间
			 	+"UpdateOrg,"			//110  更新机构
			 	+"UpdateUser,"			//120  更新人
			 	+"UpdateTime"			//130  更新时间
			 	+")values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
	 
	 PreparedStatement ps = null;
	 try{
		 //必需要使用PreparedStatement,因为Script中有单引号，否则会引起SQL拼接错误
		 ps = Sqlca.getConnection().prepareStatement(sql);
		 ps.setString(1,serialno);
		 ps.setString(2,userID);
		 ps.setString(3,tabID);
		 ps.setString(4,tabName);
		 ps.setString(5,script);
		 ps.setString(6,cache);
		 ps.setString(7,close);
		 ps.setString(8,CurUser.getOrgID());
		 ps.setString(9,CurUser.getUserID());
		 ps.setString(10,curTime);
		 ps.setString(11,CurUser.getOrgID());
		 ps.setString(12,CurUser.getUserID());
		 ps.setString(13,curTime);
	 
		 ps.addBatch();
		 ps.execute();
		 
		 ps.close();
		 ps = null;
	 }catch(Exception e){
		 ARE.getLog().debug("用户（ID："+userID+"）添加工作台（工作台ID："+tabID+"）出错，出错消息"+e.getMessage(),e);
		 b = false;
	 }finally{
		if(ps != null){
			try {
				ps.close();
				ps = null;
			} catch (SQLException e) {
				ARE.getLog().debug("数据库关闭异常:" + e);
			}			
		}
	 }
	 return b;
 }
 /**
  * 删除用户TAB
  * @param userID 用户ID
  * @param tabID TAB编号
  * @return
  */
 public boolean deleteUserTab(String userID,String tabID,Transaction Sqlca){
	 boolean b = true;
	 String sql = "delete from USER_WORKTIPS where UserID=:UserID and TabID=:TabID ";
	 SqlObject  so;
	 try{
		 so = new SqlObject(sql).setParameter("UserID", userID).setParameter("TabID", tabID);
		 Sqlca.executeSQL(so);
	 }catch(Exception e){
		 ARE.getLog().debug("用户（ID："+userID+"）删除工作台（工作台ID："+tabID+"）出错，出错消息"+e.getMessage(),e);
		 b = false;
	 }
	 return b;
 }
 /**
  * 生成工作台javascript
  * @param Sqlca
  * @return
 * @throws Exception 
  */
 public static String genTabScript(String userID,Transaction Sqlca) throws Exception{
	 String sql = "select TabID,TabName,Script,CacheFlag,CloseFlag from USER_WORKTIPS where UserID=:UserID order by SerialNo asc";
	SqlObject so = new SqlObject(sql).setParameter("UserID", userID);
	 ASResultSet rs = Sqlca.getASResultSet(so);
	 String rScript = "";
	 while(rs.next()){
		 String tabID = rs.getString("TabID");
		 String tabName = rs.getString("TabName");
		 String script = rs.getString("Script");
		 String cache = rs.getString("CacheFlag");
		 String close = rs.getString("CloseFlag");
		 if(tabID == null || tabName == null){
			 continue;
		 }
		 if(script == null) script = "";
		 if(cache == null) cache = "true";
		 if(close == null) close = "true";
		 if(cache.equals("1")){
			 cache = "true";
		 }else{
			 cache = "false";
		 }
		 if(close.equals("1")){
			 close = "true";
		 }else{
			 close = "false";
		 }
		 String addScript = "tabCompent.addDataItem('"+tabID+"','"+tabName+"','\""+script+"\"',"+cache+","+close+");";
		 rScript += ("\n"+addScript);
	 }
	 rs.getStatement().close();
	 rs = null;
	 return rScript;
 }
}
