package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ���๦��˵��
 * @author syang
 * @since 2009/09/15
 */
public class CustomerFSRecordCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		String sCustomerType = jboCustomer.getAttribute("CustomerType").getString();
		
		/** �������� **/
		String sAccMonth = "";//����·�
		String sMinAccMonth = "";//ǰ����
		String sCount = "";//��¼��			
		String sCurToday = StringFunction.getToday();//��ǰ����
		
		/** ������ **/
		if (sCustomerType == null) sCustomerType = "";	
		//��˾�ͻ�
		if (sCustomerType.substring(0,2).equals("01")) {
			sAccMonth = sCurToday.substring(0,7);//����·�
			sMinAccMonth = StringFunction.getRelativeAccountMonth(sAccMonth,"Month",-3);
			SqlObject so = new SqlObject("select count(RecordNo) from CUSTOMER_FSRECORD where CustomerID =:CustomerID And ReportDate >=:ReportDate");
			so.setParameter("CustomerID", sCustomerID);
			so.setParameter("ReportDate", sMinAccMonth);
			sCount = Sqlca.getString(so);
			if( sCount == null || Integer.parseInt(sCount) <= 0 ){
				putMsg("�ÿͻ��Ѿ���������û�еǼǲ��񱨱�");
			}
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
