package com.amarsoft.app.bizalgorithm;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetPaymentAmount extends Bizlet{
	
	double paymentsum = 0.0;//支付总额
	String sSql = "";
	
	public Object run(Transaction Sqlca) throws Exception{
		
		//自动获得传入的参数值
		String sPutoutSerialNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		
		/**从PAYMENT_INFO表中取出支付总金额**/
		
		if(sObjectType.trim().equals("PutOutApply"))//申请类型为放贷时，即放贷与支付 过程绑定
		{
			sSql = "select sum(PaymentSum*GetErate(Currency,'01','')) as PaymentSum from PAYMENT_INFO where PutoutSerialNo = :PutoutSerialNo";
			paymentsum=Sqlca.getDouble(new SqlObject(sSql).setParameter("PutoutSerialNo", sPutoutSerialNo));
		
		}else if (sObjectType.equals("PaymentApply"))//申请类型为支付，即支付申请为一个独立的过程
		{
			sSql = "select sum(PI.PaymentSum*GetErate(PI.Currency,'01','')) as PaymentSum from PAYMENT_INFO PI , FLOW_OBJECT FO where FO.ObjectType =  :ObjectType  and  PI.PutoutSerialNo = :PutoutSerialNo and FO.ObjectNo = PI.SerialNo and (FO.PhaseType != '1050') ";
			paymentsum=Sqlca.getDouble(new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("PutoutSerialNo", sPutoutSerialNo));
		}
		
		return String.valueOf(paymentsum);
	}

}
