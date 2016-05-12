package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BusinessPayDateAndTotalAmt extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//获取合同号，计划提前还款日
		String sContractSerialNo=(String)this.getAttribute("ContractSerialNo");
		String sScheduleDate=(String)this.getAttribute("ScheduleDate");
		
		if(sContractSerialNo==null ) sContractSerialNo="";
		if(sScheduleDate==null) sScheduleDate="";
		
		String sSql="";
		ASResultSet rs=null;
		
		sSql="select nextduedate,serialno from acct_loan where contractSerialno=:contractSerialno";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("contractSerialno", sContractSerialNo));
		String nextDueDate=null;
		String sSerialno=null;
		if(rs.next()){
			nextDueDate=rs.getString("nextduedate");
			sSerialno=rs.getString("serialno");
		}
		rs.close();
		String sPayDate="";
		if(DateFunctions.getMonths(sScheduleDate,nextDueDate)>=1){
			sPayDate=nextDueDate;
		}else{
			sPayDate=DateFunctions.getRelativeDate(nextDueDate,DateFunctions.TERM_UNIT_MONTH, 1);
			sSql="select max(paydate) as paydate from acct_payment_schedule where objectno=:objectno and objecttype='jbo.app.ACCT_LOAN' ";
			rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("objectno", sSerialno));
			String sMaxPayDate="";
			if(rs.next()){
				sMaxPayDate=rs.getString("paydate");
				if(DateFunctions.getDays(sPayDate, sMaxPayDate)<0){
					sPayDate=sMaxPayDate;
				}
			}
			rs.getStatement().close();
		}
		
	
		
		return "success";
	}

}
