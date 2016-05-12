package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SelectReturnAmount extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//获取交易流水号,借据号,申请退款日期,下一还款日
		String sTransSerialNo = (String)this.getAttribute("TransSerialNo");
		String sSerialno = (String)this.getAttribute("Serialno");
		String sInputTime = (String)this.getAttribute("InputTime");
		String sNextDueDate = (String)this.getAttribute("NextDueDate");
		
		double dMayquitAmt = 0.00;
		
		if(sTransSerialNo == null) sTransSerialNo="";
		if(sSerialno == null) sSerialno="";
		if(sInputTime == null || sInputTime.equals("")) return String.valueOf(dMayquitAmt);
		if(sNextDueDate == null  || sNextDueDate.equals("")) return String.valueOf(dMayquitAmt);
		
		ASResultSet rs=null;
		
		//到下一期的应还款总额 
		double dNextPayTotalAmt=0;
		String sNextPaySql="(select nvl(sum(nvl(aps.payprincipalamt,0)+nvl(aps.payinteamt,0)+nvl(aps.payfineamt,0)),0) as NextPayTotalAmt"+
				" from acct_payment_schedule aps,acct_loan al where al.serialno='"+sSerialno+"' and ((aps.objectno=al.serialno "+
				" and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjecttype=al.serialno and aps.relativeobjectno='jbo.app.ACCT_LOAN')) and aps.paydate<=al.NextDueDate) ";
		
		rs=Sqlca.getASResultSet(new SqlObject(sNextPaySql));
		if(rs.next()){
			dNextPayTotalAmt=rs.getDouble("NextPayTotalAmt");
		}
		rs.close();
		
		//合同到账总还款额,实还金额,预存款 
		double dActualPayTotalAmt=0,dActualPayAmt=0,DebitBalance=0;
		String sActualPaySql="(select nvl(sum(nvl(aps.actualpayprincipalamt,0)+nvl(aps.actualpayinteamt,0)+nvl(aps.actualpayfineamt,0)),0) as ActualPayAmt"+
				" from acct_payment_schedule aps,acct_loan al where al.serialno='"+sSerialno+"' and ((aps.objectno=al.serialno and aps.objecttype='jbo.app.ACCT_LOAN') or "+
				" (aps.relativeobjecttype=al.serialno and aps.relativeobjectno='jbo.app.ACCT_LOAN')) and aps.paydate<=al.LastDueDate) ";
		
		rs=Sqlca.getASResultSet(new SqlObject(sActualPaySql));
		if(rs.next()){
			dActualPayAmt=rs.getDouble("ActualPayAmt");
		}
		rs.close();
		String sDebitSql="(select nvl(debitbalance,0) as DebitBalance from acct_subsidiary_ledger asl "+
				" where asl.accountcodeno = 'Customer21' and asl.objectno ='"+sSerialno+"' and asl.objecttype = 'jbo.app.ACCT_LOAN')";
		
		rs=Sqlca.getASResultSet(new SqlObject(sDebitSql));
		if(rs.next()){
			DebitBalance=rs.getDouble("DebitBalance");
		}
		rs.close();
		dActualPayTotalAmt=dActualPayAmt+DebitBalance;
		
		//应还总金额 
		double dPayTotalAmt=0;
		String sPaySql="(select nvl(sum(nvl(aps.payprincipalamt,0)+nvl(aps.payinteamt,0)+nvl(aps.payfineamt,0)),0) as PayTotalAmt"+
				" from acct_payment_schedule aps,acct_loan al where al.serialno='"+sSerialno+"' and ((aps.objectno=al.serialno "+
				" and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjecttype=al.serialno and aps.relativeobjectno='jbo.app.ACCT_LOAN')) and aps.paydate<=al.LastDueDate) ";
		
		rs=Sqlca.getASResultSet(new SqlObject(sPaySql));
		if(rs.next()){
			dPayTotalAmt=rs.getDouble("PayTotalAmt");
		}
		rs.getStatement().close();
		
		
		
		if(DateFunctions.getDays(sNextDueDate, sInputTime)>=10){
			dMayquitAmt = dActualPayTotalAmt-dPayTotalAmt;
		}else{
			dMayquitAmt = dActualPayTotalAmt-dNextPayTotalAmt;
		}
		if(dMayquitAmt < 0) dMayquitAmt = 0.00;
		
		return String.valueOf(dMayquitAmt)+","+String.valueOf(dNextPayTotalAmt)+","+String.valueOf(dActualPayTotalAmt)+","+String.valueOf(dPayTotalAmt);
	}

}
