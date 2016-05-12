package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �����������������
 * @author syang
 * @since 2009/07/15
 */
public class CustomerEvalvateCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		String sCustomerType = jboCustomer.getAttribute("CustomerType").getString();
		
		/** �������� **/
		String sCount = "";			//��¼��	
		
		
		/** ������ **/
		// �Ե�ǰ��������ǰһ���ڼ�������˵�����������Ϣ
		String sTodayMonth = StringFunction.getToday();
		String sBgMonth = String.valueOf(Integer.parseInt(sTodayMonth.substring(0,4),10)-1).concat(sTodayMonth.substring(4,7));
		
		SqlObject so = new SqlObject("select count(SerialNo) from EVALUATE_RECORD where ObjectType='Customer' And ObjectNo=:ObjectNo And AccountMonth >=:AccountMonth");
		so.setParameter("ObjectNo", sCustomerID);
		so.setParameter("AccountMonth", sBgMonth);
		sCount = Sqlca.getString(so);
		if( sCount == null || Integer.parseInt(sCount) <= 0 ){
			putMsg("�ÿͻ�ȱ��һ���ڵ���������");
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
