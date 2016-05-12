package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BusinessFeeEvent extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//获取费用流水号，事件费用，借据号，事件说明,录入日期,录入人,录入机构
		String sFeeSerialNo=(String)this.getAttribute("FeeSerialNo");
		String sEventFee=(String)this.getAttribute("EventFee");
		String sLoanSerialno=(String)this.getAttribute("LoanSerialno");
		String sEventExplain=(String)this.getAttribute("EventExplain");		
		String sInputTime=SystemConfig.getBusinessDate();;
		String sInputUserID=(String)this.getAttribute("InputUserID");	
		String sInputOrgID=(String)this.getAttribute("InputOrgID");			
		
		if(sFeeSerialNo==null) sFeeSerialNo="";
		if(sEventFee==null) sEventFee="";
		if(sLoanSerialno==null) sLoanSerialno="";
		if(sEventExplain==null) sEventExplain="";
		if(sInputTime==null) sInputTime="";
		if(sInputUserID==null) sInputUserID="";
		if(sInputOrgID==null) sInputOrgID="";
		
		String updateSql="update acct_fee set status=1,amount=:amount,TotalAmount=:TotalAmount,eventexplain=:eventexplain,inputtime=:inputtime,inputuser=:inputuser,inputorg=:inputorg where serialno=:serialno ";
		Sqlca.executeSQL(new SqlObject(updateSql).setParameter("amount", sEventFee).setParameter("TotalAmount", sEventFee).setParameter("eventexplain", sEventExplain)
				.setParameter("serialno", sFeeSerialNo).setParameter("inputtime", sInputTime).setParameter("inputuser", sInputUserID).setParameter("inputorg", sInputOrgID));
		
		String selectSql="select NEXTDUEDATE from acct_loan where Serialno=:Serialno";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(selectSql).setParameter("Serialno", sLoanSerialno));
		String nextDueDate=null;
		if(rs.next()){
			nextDueDate=rs.getString("NEXTDUEDATE");
		}
		rs.close();
		String sPayDate="";
		if(DateFunctions.getMonths(sInputTime,nextDueDate)>=1){
			sPayDate=nextDueDate;
		}else{
			sPayDate=DateFunctions.getRelativeDate(nextDueDate,DateFunctions.TERM_UNIT_MONTH, 1);
			String sql="select max(paydate) as paydate from acct_payment_schedule where objectno=:objectno and objecttype='jbo.app.ACCT_LOAN' ";
			rs=Sqlca.getASResultSet(new SqlObject(sql).setParameter("objectno", sLoanSerialno));
			String sMaxPayDate="";
			if(rs.next()){
				sMaxPayDate=rs.getString("paydate");
				if(DateFunctions.getDays(sPayDate, sMaxPayDate)<0){
					sPayDate=sMaxPayDate;
				}
			}
			rs.close();
		}
		
		String sSeqID=null;
		String selectSql1="select SeqID from acct_payment_schedule where objectno=:objectno and objecttype='jbo.app.ACCT_LOAN' and paydate=:paydate ";
		rs=Sqlca.getASResultSet(new SqlObject(selectSql1).setParameter("objectno", sLoanSerialno).setParameter("paydate", sPayDate));
		if(rs.next()){
			sSeqID=rs.getString("SeqID");
		}
		rs.getStatement().close();
		
		String PaymentSerialno=DBKeyHelp.getSerialNo("acct_payment_schedule","SerialNo","");
		String sInsertSql1="insert into acct_payment_schedule (serialno,objectno,seqid,paydate,paytype,payprincipalamt,objecttype,autopayflag,relativeobjectno,relativeobjecttype) "
				+" values(?,?,?,?,'A13',?,'jbo.app.ACCT_FEE','1',?,'jbo.app.ACCT_LOAN')";
		String sSerialno=DBKeyHelp.getSerialNo("ACCT_FEE_SCHEDULE", "SERIALNO", "");
		String sInsertSql2="insert into acct_fee_schedule (SERIALNO,FEESERIALNO,AMOUNT,CURRENCY,PAYDATE,OBJECTTYPE,OBJECTNO,FEETYPE,FEEFLAG) "+
                       " values(?,?,?,'01',?,'jbo.app.ACCT_LOAN',?,'A13','R') ";
		PreparedStatement  ps=null;
		PreparedStatement  pst=null;
		try {	
			pst=Sqlca.getConnection().prepareStatement(sInsertSql1);
			pst.setString(1,PaymentSerialno);
			pst.setString(2, sFeeSerialNo);
			pst.setString(3,sSeqID);
			pst.setString(4, sPayDate);
			pst.setString(5, sEventFee);
			pst.setString(6, sLoanSerialno);
			pst.executeUpdate();
			
			ps=Sqlca.getConnection().prepareStatement(sInsertSql2);
			ps.setString(1,sSerialno);
			ps.setString(2, sFeeSerialNo);
			ps.setString(3,sEventFee);
			ps.setString(4, sPayDate);
			ps.setString(5, sLoanSerialno);
			ps.executeUpdate();
			
			pst.close();
			ps.close();
		} catch (Exception e) {
			if(pst!=null) pst.close();
			if(ps!=null) ps.close();
			e.printStackTrace();
			return "false";
		}
		
		return "success";
	}

}
