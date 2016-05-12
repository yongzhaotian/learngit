package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetBusinessContractPutOutDays extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		//合同流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		
		if(sSerialNo == null) sSerialNo = "";
		
		String sSql = "";
		String sSerialno = "";
		String sPutOutDate = "";	//发放日
		String sMaturity = "";		//贷款可执行日期
		ASResultSet rs = null;
		
		sSql =  "select bc.PutOutDate as PutOutDate from business_contract bc,acct_loan al where al.putoutno=bc.serialno and al.loanstatus in ('0') and bc.serialno='"+sSerialNo+"' ";
		
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			sPutOutDate = rs.getString("PutOutDate");
		  if(sPutOutDate==null){
			  sPutOutDate = "";
		  }
		}else{
			return "true1";
		}
		rs.getStatement().close();
		
		int sDays = DateFunctions.getDays(sPutOutDate, SystemConfig.getBusinessDate());
		if(sDays >= 15){
			return "false";
		}else
			return "true";
	}
}

