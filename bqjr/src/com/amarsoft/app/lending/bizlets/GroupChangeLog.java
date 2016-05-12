package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
/**
 * @author mfhu 
 *
 */
public class GroupChangeLog {
	/**
	 * @param sGroupNo,sCustomerID,sOperateFlag,sUserID,sOrgID,sInputDate
	 * @param 集团代码，客户代码，变动类型，原客户名称，变动日期，操作机构，操作人员，事务
	 */
	public void AddChangeLog(String sGroupNo,String sCustomerID,String sOperateFlag,String sOldName,String sInputDate,String sOrgID,String sUserID,String sCustomerName,String sCorp,Transaction Sqlca) throws Exception
	{
		//生成流水号
		SqlObject so ;//声明对象
		try{
			String sSerialNo = DBKeyHelp.getSerialNo("GROUP_CHANGE","SerialNo","",Sqlca);
			String sSql="";
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
			   " values(:SerialNo,:GroupNo,:CustomerID,:ChangeType,:OldName,:UpdateDate,:UpdateOrgid,:UpdateUserid,:CustomerName,:Corp)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sGroupNo).setParameter("CustomerID", sCustomerID).setParameter("ChangeType", sOperateFlag)
			.setParameter("OldName", sOldName).setParameter("UpdateDate", sInputDate).setParameter("UpdateOrgid", sOrgID).setParameter("UpdateUserid", sUserID)
			.setParameter("CustomerName", sCustomerName).setParameter("Corp", sCorp);
			Sqlca.executeSQL(so);
		}catch (Exception e){			
			throw new Exception("AddChangeLog"+e.toString());			
		}
	}
	/**
	 *@param sGroupNo,sCustomerID,sOperateFlag 
	 * 删除集团下某个成员某种操作标志的变动记录
	 */
	public void DelChangeLog(String sGroupNo,String sCustomerID,String sOperateFlag,Transaction Sqlca)throws Exception
	{
		try{
			String sSql = "delete from GROUP_CHANGE where GroupNo=:GroupNo and CustomerID=:CustomerID and ChangeType=:ChangeType ";
			SqlObject so = new SqlObject(sSql).setParameter("GroupNo", sGroupNo).setParameter("CustomerID", sCustomerID).setParameter("ChangeType", sOperateFlag);
			Sqlca.executeSQL(so);
			
		}catch (Exception e){
			throw new Exception("DelChangeLog"+e.toString());			
		}
	}
	
	/**
	 * @param sGroupNo,sCustomerID
	 * 删除集团下某个成员的变动记录
	 */
	public void DelChangeLog(String sGroupNo,String sCustomerID,Transaction Sqlca)throws Exception
	{
		try{
			String sSql = "delete from GROUP_CHANGE where GroupNo=:GroupNo and CustomerID=:CustomerID ";
			SqlObject so = new SqlObject(sSql).setParameter("GroupNo", sGroupNo).setParameter("CustomerID", sCustomerID);
			Sqlca.executeSQL(so);
		}catch (Exception e){
			throw new Exception("DelChangeLog"+e.toString());
		}
	}
	/**
	 *@param  sAggregateNo
	 * 删除集团的所有更改记录
	 */	  
	public void DelChangeLog(String sGroupNo,Transaction Sqlca) throws Exception
	{
		 try{
			 String sSql = "delete from GROUP_CHANGE where GroupNo=:GroupNo ";
			 SqlObject so = new SqlObject(sSql).setParameter("GroupNo", sGroupNo);
			 Sqlca.executeSQL(so);
		 }catch (Exception e){
			 throw new Exception("DelChangeLog"+e.toString());
		 }
	}
	
	public static void main(String[] args) {

	}

}
