package com.amarsoft.proj.action;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class GetRelativeRateInfo {
	
	private String typeNo ;
	private String term;
	public String getTypeNo() {
		return typeNo;
	}
	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}
	public String getTerm() {
		return term;
	}
	public void setTerm(String term) {
		this.term = term;
	}
	

	//取人行基准利率
	public String getInterestRate(Transaction Sqlca) throws Exception{
		String yearsInterestRate = "";//（年利率）  
		String monthInterestRate = "";//（月利率）
		String sSql = "select yearsInterestRate,monthInterestRate  from Interest_Rate where term = :Term";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Term", term));
		if(rs.next()){
			yearsInterestRate = DataConvert.toString(rs.getString("yearsInterestRate"));
			monthInterestRate =  DataConvert.toString(rs.getString("monthInterestRate"));
		}
		rs.getStatement().close();
		return yearsInterestRate+"@"+monthInterestRate;
	}
	
	//获取产品参数的“是否贴现”、“利率类型”、“浮动类型”
	public String getRateInfo(Transaction Sqlca) throws Exception{
		String whetherDiscount = "";//是否贴现：TrueFalse 
		String rateType = "";//利率类型：		RateType1                    
		String floatingManner = "";//浮动类型:			RateFloatType
		String sSql = "select whetherDiscount,rateType,floatingManner from Business_Type where TypeNo = :TypeNo";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TypeNo", typeNo));
		if(rs.next()){
			whetherDiscount = DataConvert.toString(rs.getString("whetherDiscount"));
			rateType =  DataConvert.toString(rs.getString("rateType"));
			floatingManner =  DataConvert.toString(rs.getString("floatingManner"));
		}
		rs.getStatement().close();
		return whetherDiscount+"@"+rateType+"@"+floatingManner;
	}
	
	//	取期限参数中的“固定利率值”、“最高固定利率”、“浮动幅度”、贴息客户固定利率”
	public String getRateInfoFromTerm(Transaction Sqlca) throws Exception{
		String loanFixedRate=""; //固定利率值:			
		String highestFixedRate = "";//最高固定利率:      			
		String floatingRate = "";//浮动幅度:
		String discountFixedRate = "";//贴息客户固定利率
		String sSql = "select loanFixedRate,highestFixedRate,floatingRate,discountFixedRate  from Term where term = :Term and typeNo= :TypeNo";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TypeNo", typeNo).setParameter("Term", term));
		if(rs.next()){
			loanFixedRate = DataConvert.toString(rs.getString("loanFixedRate"));
			highestFixedRate =  DataConvert.toString(rs.getString("highestFixedRate"));
			floatingRate =  DataConvert.toString(rs.getString("floatingRate"));
			discountFixedRate = DataConvert.toString(rs.getString("discountFixedRate"));
		}
		rs.getStatement().close();
		return loanFixedRate+"@"+highestFixedRate+"@"+floatingRate+"@"+discountFixedRate;
		
	}
	
	
	
	

}
