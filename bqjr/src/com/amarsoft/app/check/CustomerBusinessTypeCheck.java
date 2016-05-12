package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �ͻ�������ҵ��Ʒ���Ƿ�ƥ����
 * 
 * @author ccxie
 * @since 2010/04/02
 */
public class CustomerBusinessTypeCheck extends AlarmBiz {

	public Object run(Transaction Sqlca) throws Exception {

		BizObject jboContract = (BizObject) this
				.getAttribute("BusinessContract"); // ȡ����ͬJBO����
		String sCustomerID = jboContract.getAttribute("CustomerID").getString();
		if (sCustomerID == null)
			sCustomerID = "";
		String sBusinessType = jboContract.getAttribute("BusinessType")
				.getString();
		if (sBusinessType == null)
			sBusinessType = "";

		String sReturn = "1";
		String sCustomerType = "";
		String sSql = "";
		SqlObject so = null;//��������
		
		so = new SqlObject("select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID ");
		so.setParameter("CustomerID", sCustomerID);
	    sCustomerType = Sqlca.getString(so);
		
		if (sCustomerType.startsWith("03")) {
			// ��֤���˿ͻ�������ҵ��Ʒ���Ƿ�ƥ��
			so = new SqlObject("select count(*) from BUSINESS_TYPE where TypeNo =:TypeNo and TypeNo like '1110%'");
			so.setParameter("TypeNo", sBusinessType);
			sReturn = Sqlca.getString(so);
		} else if (sCustomerType.startsWith("01")) {
			// ��֤��˾�ͻ�������ҵ��Ʒ���Ƿ�ƥ��
			so = new SqlObject(" select count(*) from BUSINESS_TYPE where TypeNo =:TypeNo and TypeNo not like '1110%'");
			so.setParameter("TypeNo", sBusinessType);
			sReturn = Sqlca.getString(so);
		}

		if (sReturn.equals("0")) {
			putMsg("�ͻ�������ҵ��Ʒ�ֲ�һ��");
			this.setPass(false);
		} else {
			this.setPass(true);
		}
		return null;
	}
}
