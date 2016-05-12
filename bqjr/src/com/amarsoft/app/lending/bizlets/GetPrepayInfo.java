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
		//定义变更
		String sReturnValue = "";//返回值
		String sSql = "";//SQL语句
		String sPrePayType = "";
		sSql= "select PrePayType from acct_trans_payment  atp,acct_transaction at where at.documentserialno=atp.serialno and at.documenttype='jbo.app.ACCT_TRANS_PAYMENT'  and at.serialno = :SerialNo ";
		sPrePayType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo", this.getTransSerialNo()));
		if("10".equals(sPrePayType)){//非异常还款数据
			sReturnValue = "false";
		}else{
			sReturnValue = "true";
		}
		return sReturnValue;
	}
	

}
