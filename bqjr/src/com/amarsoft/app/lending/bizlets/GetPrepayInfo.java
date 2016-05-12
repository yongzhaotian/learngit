package com.amarsoft.app.lending.bizlets;

import java.util.StringTokenizer;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetPrepayInfo {

	private  String  transSerialNo;
	
	public String getTransSerialNo() {
		return transSerialNo;
	}

	public void setTransSerialNo(String transSerialNo) {
		this.transSerialNo = transSerialNo;
	}

	public String getPrepayFlag(Transaction Sqlca) throws Exception{
		//������
		String sReturnValue = "";//����ֵ
		String sSql = "";//SQL���
		String sPrePayType = "";
		sSql= "select PrePayType from acct_trans_payment  atp,acct_transaction at where at.documentserialno=atp.serialno and at.documenttype='jbo.app.ACCT_TRANS_PAYMENT'  and at.serialno = :SerialNo ";
		sPrePayType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo", this.getTransSerialNo()));
		if("10".equals(sPrePayType)){//���쳣��������
			sReturnValue = "false";
		}else{
			sReturnValue = "true";
		}
		return sReturnValue;
	}
	

}
