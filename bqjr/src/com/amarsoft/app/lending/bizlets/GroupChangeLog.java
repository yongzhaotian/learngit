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
	 * @param ���Ŵ��룬�ͻ����룬�䶯���ͣ�ԭ�ͻ����ƣ��䶯���ڣ�����������������Ա������
	 */
	public void AddChangeLog(String sGroupNo,String sCustomerID,String sOperateFlag,String sOldName,String sInputDate,String sOrgID,String sUserID,String sCustomerName,String sCorp,Transaction Sqlca) throws Exception
	{
		//������ˮ��
		SqlObject so ;//��������
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
	 * ɾ��������ĳ����Աĳ�ֲ�����־�ı䶯��¼
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
	 * ɾ��������ĳ����Ա�ı䶯��¼
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
	 * ɾ�����ŵ����и��ļ�¼
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
