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
 * �û��Զ��幤��̨����
 * @author syang
 * @date 2009/12/17
 */
public class WorkTipTabsManage extends Bizlet {

/**
 * ���	
 */
 public Object  run(Transaction Sqlca) throws Exception {
	 boolean r = false;
	 String operate = (String)this.getAttribute("Operate");		//������ʶ add��ӣ�delɾ��
	 String userID = (String)this.getAttribute("UserID");		//�û�ID
	 String tabID = (String)this.getAttribute("TabID");			//TAB���
	 String tabName = (String)this.getAttribute("TabName");		//TAB����
	 String script = (String)this.getAttribute("Script");		//ִ�нű�
	 String cache = (String)this.getAttribute("Cache");			//�Ƿ񻺴�
	 String close = (String)this.getAttribute("Close");			//�Ƿ�ɹر�
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
  * ���û����һ����TAB
  * @param userID �û�ID
  * @param tabID TAB���
  * @param tabName tab��ʾ����
  * @param script ִ�нű�
  * @param cache �Ƿ񻺴�
  * @param close �Ƿ���رհ�ť
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
	 script  = script.replaceAll("`", "&");//����ʱ��������ϵͳ���ų�ͻ�����������`�滻�˶���

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
			 	+"SerialNo,"			//010  ��ˮ�ţ�˳���)
			 	+"UserID,"				//020  �û�ID
			 	+"TabID,"				//030 Tab���
			 	+"TabName,"				//040  ��ʾ����
			 	+"Script,"				//050  ִ�нű�
			 	+"CacheFlag,"			//060  �����־
			 	+"CloseFlag,"			//070 �رհ�ť
			 	+"InputOrg,"			//080  �Ǽǻ���
			 	+"InputUser,"			//090  �Ǽ���
			 	+"InputTime,"			//100  �Ǽ�ʱ��
			 	+"UpdateOrg,"			//110  ���»���
			 	+"UpdateUser,"			//120  ������
			 	+"UpdateTime"			//130  ����ʱ��
			 	+")values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
	 
	 PreparedStatement ps = null;
	 try{
		 //����Ҫʹ��PreparedStatement,��ΪScript���е����ţ����������SQLƴ�Ӵ���
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
		 ARE.getLog().debug("�û���ID��"+userID+"����ӹ���̨������̨ID��"+tabID+"������������Ϣ"+e.getMessage(),e);
		 b = false;
	 }finally{
		if(ps != null){
			try {
				ps.close();
				ps = null;
			} catch (SQLException e) {
				ARE.getLog().debug("���ݿ�ر��쳣:" + e);
			}			
		}
	 }
	 return b;
 }
 /**
  * ɾ���û�TAB
  * @param userID �û�ID
  * @param tabID TAB���
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
		 ARE.getLog().debug("�û���ID��"+userID+"��ɾ������̨������̨ID��"+tabID+"������������Ϣ"+e.getMessage(),e);
		 b = false;
	 }
	 return b;
 }
 /**
  * ���ɹ���̨javascript
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
