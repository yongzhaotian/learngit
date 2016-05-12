package com.amarsoft.app.lending.bizlets;

import org.jfree.util.Log;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


public class CancelOffList{
	private String Loan="";
	
	private String TransactionLoan="";

	public String updateLoanInfo(Transaction sqlca) throws Exception{
		String PayDate=SystemConfig.getBusinessDate();
		String [] LoanSerialno=Loan.split("@");
		String [] TransSerialno=TransactionLoan.split("@");
		for(int i=0;i<LoanSerialno.length;i++){	
			sqlca.executeSQL(new SqlObject("update acct_loan set autopayflag=2,loanstatus=5 where Serialno=:Serialno").setParameter("Serialno", LoanSerialno[i]));
			sqlca.executeSQL(new SqlObject("update acct_payment_schedule set autopayflag='2' where serialno in (select serialno from acct_payment_schedule where objectno=:Serialno and objecttype='jbo.app.ACCT_LOAN' and paydate>=:PayDate)").setParameter("Serialno", LoanSerialno[i]).setParameter("PayDate", PayDate));			
			sqlca.executeSQL(new SqlObject("update acct_Transaction set transstatus=1 where serialno=:TransactionSerialno").setParameter("TransactionSerialno", TransSerialno[i]));
			sqlca.executeSQL(new SqlObject("delete from  flow_task  where objectno=:TransactionSerialno").setParameter("TransactionSerialno", TransSerialno[i]));
			sqlca.executeSQL(new SqlObject("delete from  flow_object where objectno=:TransactionSerialno").setParameter("TransactionSerialno", TransSerialno[i]));
		}
		return "SUCCESS";
	}
	
	public String getLoan() {
		return Loan;
	}
	
	public void setLoan(String loan) {
		Loan = loan;
	}
	
	public String getTransactionLoan() {
		return TransactionLoan;
	}
	
	public void setTransactionLoan(String transactionLoan) {
		TransactionLoan = transactionLoan;
	}
}
