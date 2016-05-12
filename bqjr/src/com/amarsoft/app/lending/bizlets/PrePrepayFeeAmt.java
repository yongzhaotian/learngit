package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class PrePrepayFeeAmt{

	private String sContractSerialNo; //合同流水
	
	public String getSContractSerialNo() {
		return sContractSerialNo;
	}

	public void setSContractSerialNo(String sContractSerialNo) {
		this.sContractSerialNo = sContractSerialNo;
	}

	public String runTransaction(Transaction Sqlca) throws Exception {
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
		rs.getStatement().close();
		return String.valueOf(dPrepayAmt);
	}
}
