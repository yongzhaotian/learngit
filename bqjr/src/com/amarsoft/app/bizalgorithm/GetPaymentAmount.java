package com.amarsoft.app.bizalgorithm;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetPaymentAmount extends Bizlet{
	
	double paymentsum = 0.0;//֧���ܶ�
	String sSql = "";
	
	public Object run(Transaction Sqlca) throws Exception{
		
		//�Զ���ô���Ĳ���ֵ
		String sPutoutSerialNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		
		/**��PAYMENT_INFO����ȡ��֧���ܽ��**/
		
		if(sObjectType.trim().equals("PutOutApply"))//��������Ϊ�Ŵ�ʱ�����Ŵ���֧�� ���̰�
		{
			sSql = "select sum(PaymentSum*GetErate(Currency,'01','')) as PaymentSum from PAYMENT_INFO where PutoutSerialNo = :PutoutSerialNo";
			paymentsum=Sqlca.getDouble(new SqlObject(sSql).setParameter("PutoutSerialNo", sPutoutSerialNo));
		
		}else if (sObjectType.equals("PaymentApply"))//��������Ϊ֧������֧������Ϊһ�������Ĺ���
		{
			sSql = "select sum(PI.PaymentSum*GetErate(PI.Currency,'01','')) as PaymentSum from PAYMENT_INFO PI , FLOW_OBJECT FO where FO.ObjectType =  :ObjectType  and  PI.PutoutSerialNo = :PutoutSerialNo and FO.ObjectNo = PI.SerialNo and (FO.PhaseType != '1050') ";
			paymentsum=Sqlca.getDouble(new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("PutoutSerialNo", sPutoutSerialNo));
		}
		
		return String.valueOf(paymentsum);
	}

}
