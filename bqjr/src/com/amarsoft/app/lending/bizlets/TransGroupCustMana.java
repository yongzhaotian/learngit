package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


/**
 * ת�Ƽ��ſͻ��ܻ�Ȩ<br/>
 * 1.�ѵ�ǰ�ͻ������û�֮�����ȨȨ�Ƴ�����ֻ������Ϣ�鿴Ȩ������ԭCustomer_Belong��<br/>
 * 2.���¿ͻ���������Ȩ��ϵ��������;Customer_Belong��<br/>
 * @author syang 2009/11/11
 *
 */
public class TransGroupCustMana extends Bizlet {

	private String sCustomerID = "";
	private String sUserID = "";
	private String sOrgID = "";
	/**  ���ݿ����� */
	private Transaction Sqlca = null;
	/** �������� */
	private String sToday = "";

	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * ��ȡ����
		 */
		sCustomerID = (String)this.getAttribute("CustomerID");
		sUserID = (String)this.getAttribute("UserID");
		this.Sqlca = Sqlca;
		/*�ֲ�����*/
		String sReturn = "1";
		
		/*�����߼�*/
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		sToday = StringFunction.getToday();
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		sOrgID = CurUser.getOrgID();
		
		//���ԭ�ܻ�Ȩ
		clearManage();
		//�����¹ܻ�Ȩ
		newManage();
		
		return sReturn;
  	}
	/**
	 * ����ͻ�������Ȩ��ֻ������Ϣ�鿴Ȩ
	 * @throws Exception 
	 */
	public void clearManage() throws Exception{
		String sbSql = "update CUSTOMER_BELONG set BelongAttribute='2',BelongAttribute1='1',BelongAttribute2='2'," +
				" BelongAttribute3='2',BelongAttribute4='2' where CustomerID =:CustomerID and BelongAttribute='1'"; 
		SqlObject so = new SqlObject(sbSql).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	}
	/**
	 * ��������Ȩ
	 * @throws Exception 
	 */
	public void newManage() throws Exception{
		String sbSql = "insert into CUSTOMER_BELONG (CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)values" +
				"(:CustomerID,:OrgID,:UserID,'1','1','1','1','1',:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
		SqlObject so = new SqlObject(sbSql);
		so.setParameter("CustomerID", sCustomerID).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("InputOrgID", sOrgID)
		.setParameter("InputUserID", sUserID).setParameter("InputDate", sToday).setParameter("UpdateDate", sToday);
		Sqlca.executeSQL(so);
	}
}
