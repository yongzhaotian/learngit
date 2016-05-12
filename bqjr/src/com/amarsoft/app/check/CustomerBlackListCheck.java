package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �������ͻ����
 * @author syang
 * @since 2009/09/15
 */
public class CustomerBlackListCheck extends AlarmBiz {
	

	public Object run(Transaction Sqlca) throws Exception {
		
		/*ȡ����*/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");	//ȡ���ͻ�JBO����
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		String sCertType = jboCustomer.getAttribute("CertType").getString();
		String sCertID = jboCustomer.getAttribute("CertID").getString();
		
		/*�������� */
		String sCount = "";
		String sToday = StringFunction.getToday();
		
		
		/*������*/
		//1.���ݿͻ��Ż���֤�����͡�֤����ȥ�������в���
		//2.��ǰ���ڱ����ڿ�ʼ���ڣ���������֮�䣨�������˵㣩
		
		SqlObject so = new SqlObject("select count(SerialNo) from CUSTOMER_SPECIAL "
								+" where 1=1"
								+" and (CustomerID =:CustomerID  or (CertType =:CertType and CertID =:CertID)) "
								+" and SectionType = '40' "
								+" and InListStatus='1'"
								+" and (EndDate >=:EndDate or EndDate is null)" 
								+" and BeginDate<=:BeginDate ");
		so.setParameter("CustomerID", sCustomerID).setParameter("CertType", sCertType).setParameter("CertID", sCertID)
		.setParameter("EndDate", sToday).setParameter("BeginDate", sToday);
		sCount=Sqlca.getString(so);
		if( sCount != null && Integer.parseInt(sCount,10) > 0  ){
			putMsg( "���ں������ͻ�");
		}
		
		/* ���ؽ������  */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
