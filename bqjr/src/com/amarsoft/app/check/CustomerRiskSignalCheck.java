package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * Ԥ���ͻ����
 * @author syang
 * @since 2009/09/15
 */
public class CustomerRiskSignalCheck extends AlarmBiz {
	
	/** ��Ա�������� **/
	String sCount="";

	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/** �������� **/
		
		
		/** ������ **/
		//���ÿͻ��Ƿ��������Ч��Ԥ����Ϣ
		String sSql = " select count(RS1.SerialNo) from RISK_SIGNAL RS1  "+
					  " where RS1.SerialNo not in (select distinct RS2.RelativeSerialNo "+
					  " from RISK_SIGNAL RS2 "+
					  " where RS2.SignalType='02' "+
					  " and RS2.SignalStatus='30') "+
					  " and RS1.ObjectType = 'Customer' "+
					  " and RS1.ObjectNo =:ObjectNo "+
					  " and SignalType = '01' "+
					  " and RS1.SignalStatus='30' ";
		  SqlObject so = new SqlObject(sSql);
		  so.setParameter("ObjectNo", sCustomerID);
          sCount = Sqlca.getString(so);
		
		if( sCount != null && Integer.parseInt(sCount,10) > 0  ){
			putMsg( "������Ч��Ԥ���ź�");
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
