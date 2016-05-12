package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CancelPrePaymentApply extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//交易流水号，借据号
		String sSerialno = (String)this.getAttribute("Serialno");
		String sLoanSerialNo = (String)this.getAttribute("LoanSerialNo");
		
	
		String sSql = "delete from acct_fee af where af.feetype='A9' and af.objectno=:LoanSerialNo and exists (select 1 from acct_payment_schedule aps where aps.paytype='A9' and af.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_FEE' and aps.finishdate is null)";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("LoanSerialNo", sLoanSerialNo));
		
		sSql = "delete from acct_payment_schedule where paytype='A9' and finishdate is null and relativeobjectno=:LoanSerialno and relativeobjecttype='jbo.app.ACCT_LOAN'";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("LoanSerialNo", sLoanSerialNo));
		
		sSql = "update acct_transaction set transstatus='4' where serialno=:Serialno";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", sSerialno));
		
		return "Success";
		
	}	
}
