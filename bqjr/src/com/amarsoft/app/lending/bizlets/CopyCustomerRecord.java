/*
		Author: rqiao
		describe:��¼ÿ����ͬ�Ŀͻ�������Ϣ
		modify:20150129
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CopyCustomerRecord extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//��ú�ͬ��ˮ��
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(null == sSerialNo) sSerialNo = "";
		//��ÿͻ����
		String sCustomerID = (String)this.getAttribute("CustomerID");
		if(null == sCustomerID) sCustomerID = "";
		
		//ɾ��ԭ��ͬ������Ϣ������еĿͻ���¼
		String del_sql = " DELETE FROM IND_INFO_RECORD WHERE SERIALNO = :SERIALNO AND CUSTOMERID = :CUSTOMERID ";
		Sqlca.executeSQL(new SqlObject(del_sql).setParameter("SERIALNO", sSerialNo).setParameter("CUSTOMERID", sCustomerID));
		
		//�������¿ͻ�������Ϣ����ͬ������Ϣ�������
		String insert_sql = " INSERT INTO IND_INFO_RECORD SELECT BC.SERIALNO,II.* FROM BUSINESS_CONTRACT BC,IND_INFO II WHERE BC.CUSTOMERID = II.CUSTOMERID AND BC.SERIALNO = :SERIALNO AND BC.CUSTOMERID = :CUSTOMERID ";
		Sqlca.executeSQL(new SqlObject(insert_sql).setParameter("SERIALNO", sSerialNo).setParameter("CUSTOMERID", sCustomerID));
		
		return "1";
	}	
}
