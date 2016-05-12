package com.amarsoft.app.bizmethod;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author qfang 2011-6-8
 * @param objectType,objectNo,Sqlca
 * 
 * 根据对象类型、对象编号，获取合同阶段的“支付方式”字段值
 */
public class PaymentMode {
	
	private String sSql = "";	//sql
	private ASResultSet rs = null;		//结果集
	
	public PaymentMode(String objectType, String objectNo, Transaction Sqlca){
		
	}
	
	public String obtainPaymentMode(String objectType, String objectNo, Transaction Sqlca) throws Exception{
		
		String sPaymentMode = "";
		
		if(objectType.equals("PutOutApply")){	//放贷申请阶段
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
