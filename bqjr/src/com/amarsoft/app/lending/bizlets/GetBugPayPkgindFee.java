package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 判断计算每月随心还服务包费用
 * @author daihuafeng
 *
 */
public class GetBugPayPkgindFee {
	private String sBusinessSum_;//本金
	private String stypeno;//业务品种
	private String sTerm;//期限
	private String sBugPayPkgind;//是否购买随心还服务包
	
	public String getFee(Transaction Sqlca) throws Exception{
		//随心还服务费
		double sBusinessSum = Double.parseDouble(sBusinessSum_);
		int term = Integer.parseInt(sTerm);
		double SuiXinHuanFee = 0.0d;
		if("1".equals(sBugPayPkgind)){
			SuiXinHuanFee= getSuiXinHuanFee(stypeno,sBusinessSum,term,Sqlca);
		}
		return String.valueOf(Arith.round(SuiXinHuanFee,8));
	}

	public double getSuiXinHuanFee(String stypeno,double sBusinessSum, int term,Transaction Sqlca) throws Exception{
		String sSql = "";
		ASResultSet rs = null;
		String termID = "";
		double SuiXinHuan = 0.0d;
		String ObjectNo = stypeno+"-"+"V1.0";
		sSql = "select termid from product_term_library where subtermtype = 'A18' and status='1' and  ObjectNo = '"+ObjectNo+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			termID = rs.getString("termid");
		}else{
			return SuiXinHuan;
		}
		rs.getStatement().close();
		
		//计算方式
		String CalType = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeCalType","DefaultValue");
		if(CalType.equals("01")){//固定金额
			String FeeAmount = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeAmount","DefaultValue");
			SuiXinHuan = Double.parseDouble(FeeAmount);
		}else if(CalType.equals("02")){//贷款金额*费率
			String FeeRate = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeRate","DefaultValue");
			//每月费用
			SuiXinHuan = sBusinessSum * Double.parseDouble(FeeRate)*0.01;
		}else if(CalType.equals("15")){// 固定金额*合同期数
			String FeeAmount = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeAmount","DefaultValue");
			// 每月费用
			SuiXinHuan = Double.parseDouble(FeeAmount);
		}
			
		return SuiXinHuan;
	}

	public String getsBusinessSum_() {
		return sBusinessSum_;
	}

	public void setsBusinessSum_(String sBusinessSum_) {
		this.sBusinessSum_ = sBusinessSum_;
	}

	public String getStypeno() {
		return stypeno;
	}

	public void setStypeno(String stypeno) {
		this.stypeno = stypeno;
	}

	public String getsTerm() {
		return sTerm;
	}

	public void setsTerm(String sTerm) {
		this.sTerm = sTerm;
	}

	public String getsBugPayPkgind() {
		return sBugPayPkgind;
	}

	public void setsBugPayPkgind(String sBugPayPkgind) {
		this.sBugPayPkgind = sBugPayPkgind;
	}
	
}
