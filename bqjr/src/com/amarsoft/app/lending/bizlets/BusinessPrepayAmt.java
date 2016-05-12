package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BusinessPrepayAmt extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//获取合同号，提前还款可行日期
		String sContractSerialNo=(String)this.getAttribute("ContractSerialNo");
		String sPayDate=(String)this.getAttribute("PayDate");
		ASResultSet rs=null;
		
		//生成提前还款手续费还款记录
		double dPrepayAmt=0,dBusinessSum=0;
		String sBusinessType="",sTermId="",SLoanSerialno="";
		String sSql="	select bc.businesstype as businesstype,ptl.termid as termid,bc.businesssum,al.serialno as LoanSerialno from business_contract bc,product_term_library ptl,acct_loan al "+
			 "	where  bc.businesstype||'-V1.0'=ptl.objectno  "+
			 "	and ptl.subtermtype='A9' "+
			 "	and status='1' and al.putoutno=bc.serialno"+
			 "	and bc.serialno='"+sContractSerialNo+"'";
		
		rs=Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			sBusinessType=rs.getString("businesstype");
			sTermId=rs.getString("termid");
			dBusinessSum=rs.getDouble("businesssum");
			SLoanSerialno=rs.getString("LoanSerialno");
			
			//计算方式
			String CalType = ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeCalType","DefaultValue");
			if(CalType.equals("01")){//固定金额
				dPrepayAmt = Double.parseDouble(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeAmount","DefaultValue"));
			}else if(CalType.equals("02")){//贷款金额*费率
				String FeeRate = ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeRate","DefaultValue");
				dPrepayAmt = dBusinessSum * Double.parseDouble(FeeRate)*0.01;
			}
			
			double minAmt = Double.parseDouble(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeAmount","MinValue"));
			double maxAmt = Double.parseDouble(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeAmount","MaxValue"));
			
			if(dPrepayAmt > maxAmt){
				dPrepayAmt = maxAmt;
			}else if(dPrepayAmt < minAmt){
				dPrepayAmt = minAmt;
			}
		}
		rs.close();
		
		
		
		sSql="select seqid from acct_payment_schedule where objectno=:objectno and objecttype='jbo.app.ACCT_LOAN' and paydate=:paydate";
			
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("objectno", SLoanSerialno).setParameter("paydate", sPayDate));
		String sSeqID="";
		if(rs.next()){
			sSeqID=rs.getString("seqid");
		}
		rs.close();
		
		String sFeeSerialNo=DBKeyHelp.getSerialNo("ACCT_FEE", "SERIALNO","");
		sFeeSerialNo = "AF"+sFeeSerialNo;
		
		String sInsertSql=" insert into acct_fee (serialno,objecttype,objectno,feetype,feetermid,currency,amount,feeflag,totalamount,status,feepaydateflag) "+
						  "	values(?,'jbo.app.ACCT_LOAN',?,'A9',?,'01',?,'R',?,'1','01')";
		PreparedStatement ps = Sqlca.getConnection().prepareStatement(sInsertSql);
		
		if(dPrepayAmt>0){
			ps.setString(1, sFeeSerialNo);
			ps.setString(2, SLoanSerialno);
			ps.setString(3, sTermId);
			ps.setDouble(4, dPrepayAmt);
			ps.setDouble(5, dPrepayAmt);
			ps.executeUpdate();
		}

		
		String sSerialNo=DBKeyHelp.getSerialNo("ACCT_PAYMENT_SCHEDULE", "SERIALNO","");
	    sInsertSql=" insert into acct_payment_schedule (serialno,relativeobjecttype,relativeobjectno,seqid,paydate,paytype,payprincipalamt,autopayflag,objectno,objecttype) "+
						  " values(?,'jbo.app.ACCT_LOAN',?,?,?,'A9',?,'1',?,'jbo.app.ACCT_FEE')";
		ps = Sqlca.getConnection().prepareStatement(sInsertSql);
		
		if(dPrepayAmt>0){
			ps.setString(1, sSerialNo);
			ps.setString(2, SLoanSerialno);
			ps.setString(3, sSeqID);
			ps.setString(4, sPayDate);
			ps.setDouble(5, dPrepayAmt);
			ps.setString(6, sFeeSerialNo);
			ps.executeUpdate();
		}
		ps.close();
		
		return "SUCCESS";
	}
}
