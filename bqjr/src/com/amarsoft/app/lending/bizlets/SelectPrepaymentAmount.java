package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SelectPrepaymentAmount extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//借据号,提前还款可行日期,计划提前还款日
		String sLoanSerialNo = (String)this.getAttribute("LoanSerialNo");
		String sPayDate = (String)this.getAttribute("TransDate");
		String sScheduleDate = (String)this.getAttribute("ScheduleDate");

		if(sLoanSerialNo == null) sLoanSerialNo="";
		if(sPayDate == null) sPayDate="";
		if(sScheduleDate == null) sScheduleDate="";
			
		//应还总金额,应还本金,应还利息
		double dPayAmt = 0.00,dPayprincipalAmt = 0.00,dPayInteAmt = 0.00;
		
		//提前还款保险费,提前还款手续费,提前还款客户服务费,提前还款财务管理费,提前还款印花税
		double dPayInsuranceFee = 0.00,dPrepaymentFee = 0.00,dCustomerServeFee = 0.00,dAccountManageFee = 0.00,dStampTax = 0.00;
		
		ASResultSet rs=null;
		//获取审批通过日期
		String selectSql="select bc.putoutdate from business_contract bc,acct_loan al  where al.serialno=:serialno and bc.serialno=al.putoutno";
		 rs=Sqlca.getASResultSet(new SqlObject(selectSql).setParameter("serialno", sLoanSerialNo));
		String PutoutDate=null;
		if(rs.next()){
			PutoutDate=rs.getString("putoutdate");
		}
		rs.close();
		
		String sSql="";
		//获取犹豫期天数
		sSql="	select bc.businesstype as businesstype,ptl.termid as termid from business_contract bc,product_term_library ptl,acct_loan al "+
				 "	where  bc.businesstype||'-V1.0'=ptl.objectno  "+
				 "	and ptl.subtermtype='A9' "+
				 "	and status='1' and bc.serialno=al.putoutno "+
				 "	and al.serialno='"+sLoanSerialNo+"'";
			
		rs=Sqlca.getASResultSet(new SqlObject(sSql));
		String sBusinessType="",sTermId="";
		int sAdvanceHesitateDate = 0;
		if(rs.next()){
			sBusinessType=rs.getString("businesstype");
			sTermId=rs.getString("termid");
			//计算方式
			sAdvanceHesitateDate = Integer.parseInt(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "AdvancehesitateDate","DefaultValue"));
			
		}
		rs.close();
        
		if(PutoutDate==null || PutoutDate.length()==0) throw new Exception("该合同的putoutdate不存在，请检查");
		if(DateFunctions.getDays(PutoutDate,sScheduleDate)<sAdvanceHesitateDate){
			selectSql=" select round(sum(nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0)),2) as payAmt" +
					 " from acct_payment_schedule aps,acct_loan al "+ 
					 " where al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN' "+
					 " 	and (aps.finishdate is null or aps.finishdate =' ') "+
					 " 	and al.serialno=:serialno and al.loanstatus='0' ";
			
			rs=Sqlca.getASResultSet(new SqlObject(selectSql).setParameter("serialno", sLoanSerialNo));
			if(rs.next()){
				dPayprincipalAmt=rs.getDouble("payAmt");
			}
			rs.close();
			
			dPayAmt = dPayprincipalAmt+dPayInteAmt+dPayInsuranceFee+dPrepaymentFee+dCustomerServeFee+dAccountManageFee+dStampTax;

			BigDecimal bigDecimal = new BigDecimal(dPayAmt);
			bigDecimal = bigDecimal.setScale(2,BigDecimal.ROUND_HALF_UP);
			dPayAmt = bigDecimal.doubleValue();  
			
			return String.valueOf(dPayprincipalAmt)+","+String.valueOf(dPayInteAmt)+","+String.valueOf(dPayInsuranceFee)+","+String.valueOf(dPrepaymentFee)+","+String.valueOf(dCustomerServeFee)+","+String.valueOf(dAccountManageFee)+","+String.valueOf(dStampTax)+","+String.valueOf(dPayAmt)+",true";
		}
		
		//获取下一还款日,借据号
		selectSql="select nextduedate,serialno from acct_loan where serialno=:serialno";
		rs=Sqlca.getASResultSet(new SqlObject(selectSql).setParameter("serialno", sLoanSerialNo));
		String nextDueDate="";
		if(rs.next()){
			nextDueDate=rs.getString("nextduedate");
		}
		rs.close();
		
		//应还本金,应还财务管理费,提前还款手续费,印花税
		if(nextDueDate.equals(sPayDate)){
			sSql=" select 	round(sum(case when paytype='1' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dPayprincipalAmt,"+
			     "  		round(sum(case when paytype='A9' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dPrepaymentFee,"+
			     "  		round(sum(case when paytype='A11' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dStampTax "+
			     " from acct_payment_schedule aps,acct_loan al "+
			     " where ((al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN') or "+
			     "       (al.serialno=aps.relativeobjectno and aps.relativeobjecttype='jbo.app.ACCT_LOAN' and aps.paytype in ('A9','A11'))) "+
			     "       and (aps.finishdate is null or aps.finishdate =' ')"+
			     "       and al.serialno=:serialno and al.loanstatus='0'";	      
		}else{
			sSql=" select 	round(sum(case when paytype='1' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dPayprincipalAmt,"+
				     "  		round(sum(case when paytype='A9' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dPrepaymentFee,"+
				     "  		round(sum(case when paytype='A11' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dStampTax "+
				     " from acct_payment_schedule aps,acct_loan al "+
				     " where ((al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN') or "+
				     "       (al.serialno=aps.relativeobjectno and aps.relativeobjecttype='jbo.app.ACCT_LOAN' and aps.paytype in ('A9','A11'))) "+
				     "       and (aps.finishdate is null or aps.finishdate =' ')  and aps.paydate>nextDueDate "+
				     "       and al.serialno=:serialno  and al.loanstatus='0'";     
		}
		
		
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno", sLoanSerialNo));
		if(rs.next()){
			dPayprincipalAmt = rs.getDouble("dPayprincipalAmt");
			dPrepaymentFee = rs.getDouble("dPrepaymentFee");
			dStampTax = rs.getDouble("dStampTax");
		}
		rs.close();
		
		//应还利息,提前还款保险费,提前还款客户服务费
		sSql="	select round(sum(case when paytype='1' then nvl(aps.payinteamt,0)-nvl(aps.actualpayinteamt,0) end),2) as dPayInteAmt,"+
			 "  	   round(sum(case when paytype='A7' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dAccountManageFee,"+
			 "	       round(sum(case when paytype='A12' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dPayInsuranceFee,"+
			 "         round(sum(case when paytype='A2' then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) end),2) as dCustomerServeFee    "+     
			 					  
			 "	    from acct_payment_schedule aps,acct_loan al "+
			 "		where ((al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN') or "+
			 "	          (al.serialno=aps.relativeobjectno and aps.relativeobjecttype='jbo.app.ACCT_LOAN' and aps.paytype not in ('A9','A11'))) "+
			 "			  and (aps.finishdate is null or aps.finishdate =' ') "+
			 "			  and aps.paydate=:paydate "+
			 "			  and al.serialno=:serialno  and al.loanstatus='0'";
		
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("paydate", sPayDate).setParameter("serialno", sLoanSerialNo));
		if(rs.next()){
			dPayInteAmt = rs.getDouble("dPayInteAmt");
			dAccountManageFee = rs.getDouble("dAccountManageFee");
			dPayInsuranceFee = rs.getDouble("dPayInsuranceFee");
			dCustomerServeFee = rs.getDouble("dCustomerServeFee");
		}
		rs.getStatement().close();

		dPayAmt = dPayprincipalAmt+dPayInteAmt+dPayInsuranceFee+dPrepaymentFee+dCustomerServeFee+dAccountManageFee+dStampTax;

		BigDecimal bigDecimal = new BigDecimal(dPayAmt);
		bigDecimal = bigDecimal.setScale(2,BigDecimal.ROUND_HALF_UP);
		dPayAmt = bigDecimal.doubleValue();  
		
		return String.valueOf(dPayprincipalAmt)+","+String.valueOf(dPayInteAmt)+","+String.valueOf(dPayInsuranceFee)+","+String.valueOf(dPrepaymentFee)+","+String.valueOf(dCustomerServeFee)+","+String.valueOf(dAccountManageFee)+","+String.valueOf(dStampTax)+","+String.valueOf(dPayAmt)+",false";
	
	}

}
