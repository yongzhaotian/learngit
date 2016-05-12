package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ����Ƿ��йؼ��˼��ɶ���Ϣ��Ϣ
 * @author syang 
 * @since 2009/09/15
 *
 */
public class CustomerKeyRelaCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/** �������� **/
		String sSql = "";
		ASResultSet rs = null;
		int iNum = 0;
		
		/** ������ **/
		
		//���ؼ�����Ϣ
	    sSql = " select Count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = :CustomerID "+
        " and RelationShip like '01%'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
		if(rs.next())
			iNum = rs.getInt(1);
		rs.getStatement().close();
		rs = null;
		if(iNum == 0){
			putMsg("û������ؼ�����Ϣ");
		}
		
		//���ɶ���Ϣ
		iNum = 0;
		sSql = 	" select Count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = :CustomerID "+
		" and RelationShip like '52%' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
		if(rs.next())
			iNum = rs.getInt(1);
		rs.getStatement().close();
		
		if(iNum == 0){
			putMsg("û������ɶ���Ϣ");
		}
		/** ���ؽ������ **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
