package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �������ſͻ�ǰ�����¼��CUSTOMER_INFO
 * @author lyin 2012-12-13  
 */

public class AddGroupCustomerAction extends Bizlet {

	//�ͻ�ID
	private String sCustomerID = "";
	//�û�ID
	private String sUserID = "";
	//����ID
	private String sOrgID = "";
	//���ݿ����� 
	private Transaction Sqlca = null;
	
	/**
	 * @param ����˵��
	 * 		<p>CustomerID		:�ͻ�ID</p>
	 * 		<p>UserID			:�û�ID</p>
	 * 		<p>OrgID			:����ID</p>
	 * @return ����ֵ˵��
	 * 		����״̬ 1 �ɹ�,0 ʧ��
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{

		//��ȡ����
		sCustomerID 		= (String)this.getAttribute("CustomerID");	
		sOrgID 				= (String)this.getAttribute("OrgID");
		sUserID 			= (String)this.getAttribute("UserID");

		if(sCustomerID == null) sCustomerID = "";
		if(sOrgID == null) sOrgID = "";
		if(sUserID == null) sUserID = "";

		this.Sqlca = Sqlca;
		

		//��������
		String sReturn = "0";
		
        //�����¼��CUSTOMER_INFO
		insertCustomerInfo();
		
		return sReturn;
	}
	
	/**
	 * ����������CUSTOMER_INFO
	 * @param 
	 * @throws Exception 
	 */
  	private void insertCustomerInfo() throws Exception{
		StringBuffer sbSql = new StringBuffer();
		SqlObject so ;
		sbSql.append(" insert into CUSTOMER_INFO(") 
			.append(" CustomerID,")					//010.�ͻ����
			.append(" CustomerType,")				//020.�ͻ�����
			.append(" InputUserID,")				//030.�Ǽ��û�
			.append(" InputOrgID, ")				//040.�Ǽǻ���
			.append(" InputDate ")					//050.�Ǽ�����
			.append(" )values(:CustomerID, :CustomerType, :InputUserID, :InputOrgID, :InputDate )");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", sCustomerID).setParameter("CustomerType", "0210").setParameter("InputUserID", sUserID).setParameter("InputOrgID", sOrgID)
		.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		Sqlca.executeSQL(so);
  	}	
  	
  
}
