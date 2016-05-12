package com.amarsoft.app.check;

import com.amarsoft.amarscript.ASMethod;
import com.amarsoft.amarscript.Any;
import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * <p>
 * �Զ�����̽����������֧���ܽ����Ŵ�����Ƿ����
 * </p>
 * @author smiao,2011.06.08
 *
 */
public class PaymentSumCheck extends AlarmBiz{
	
	public Object run(Transaction Sqlca) throws Exception{
		
		//�Զ���ô���Ĳ���ֵ
		String sSerialNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sBusinessSum = (String)this.getAttribute("BusinessSum");//�Ŵ����
		String sBusinessCurrency = (String)this.getAttribute("BusinessCurrency");//�Ŵ�����	

		String sSql = "";
		double dExchangeValue = 0.0 ;
		double dBusinessSum = 0.0;
		
		//��ȡ�Ŵ�����Ӧ���ֵĻ���		
		sSql = "select ExchangeValue from ERATE_INFO where Currency = :Currency ";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Currency", sBusinessCurrency));
		
		if(rs.next()){
			dExchangeValue = rs.getDouble("ExchangeValue");
		}
		rs.getStatement().close();	
		
		dBusinessSum = Double.parseDouble(sBusinessSum);
		dBusinessSum = dBusinessSum*dExchangeValue;//ת��Ϊ����ҵķŴ����

		ASMethod asm = new ASMethod("BusinessManage","GetPaymentAmount",Sqlca);//���÷�����ȡ֧���ܽ��
			
		Any anyValue  = asm.execute(sSerialNo+","+sObjectType);
		
		String newPhaseNo = anyValue.toStringValue();
		
		double paymentsum =  Double.parseDouble(newPhaseNo);//֧���ܽ��		
		
		if(paymentsum == dBusinessSum){
			putMsg("֧���ܽ����Ŵ�������");
			setPass(true);
		}else{
			putMsg("֧���ܶ�Ӧ��Ŵ�������");
			setPass(false);
		}
		return "success";
	}
}
