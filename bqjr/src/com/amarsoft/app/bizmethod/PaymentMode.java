package com.amarsoft.app.bizmethod;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author qfang 2011-6-8
 * @param objectType,objectNo,Sqlca
 * 
 * ���ݶ������͡������ţ���ȡ��ͬ�׶εġ�֧����ʽ���ֶ�ֵ
 */
public class PaymentMode {
	
	private String sSql = "";	//sql
	private ASResultSet rs = null;		//�����
	
	public PaymentMode(String objectType, String objectNo, Transaction Sqlca){
		
	}
	
	public String obtainPaymentMode(String objectType, String objectNo, Transaction Sqlca) throws Exception{
		
		String sPaymentMode = "";
		
		if(objectType.equals("PutOutApply")){	//�Ŵ�����׶�
			sSql = "select PaymentMode from BUSINESS_CONTRACT where ContractSerialNo=:ContractSerialNo";
		}else{
			return "FALSE";
		}
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ContractSerialNo", objectNo));
		if(rs.next()){
			sPaymentMode = rs.getString("PaymentMode");
		}
		rs.getStatement().close(); 
		rs = null;
		return sPaymentMode;
	}
}
