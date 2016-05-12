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
	

	//ȡ���л�׼����
	public String getInterestRate(Transaction Sqlca) throws Exception{
		String yearsInterestRate = "";//�������ʣ�  
		String monthInterestRate = "";//�������ʣ�
		String sSql = "select yearsInterestRate,monthInterestRate  from Interest_Rate where term = :Term";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Term", term));
		if(rs.next()){
			yearsInterestRate = DataConvert.toString(rs.getString("yearsInterestRate"));
			monthInterestRate =  DataConvert.toString(rs.getString("monthInterestRate"));
		}
		rs.getStatement().close();
		return yearsInterestRate+"@"+monthInterestRate;
	}
	
	//��ȡ��Ʒ�����ġ��Ƿ����֡������������͡������������͡�
	public String getRateInfo(Transaction Sqlca) throws Exception{
		String whetherDiscount = "";//�Ƿ����֣�TrueFalse 
		String rateType = "";//�������ͣ�		RateType1                    
		String floatingManner = "";//��������:			RateFloatType
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
	
	//	ȡ���޲����еġ��̶�����ֵ��������߹̶����ʡ������������ȡ�����Ϣ�ͻ��̶����ʡ�
	public String getRateInfoFromTerm(Transaction Sqlca) throws Exception{
		String loanFixedRate=""; //�̶�����ֵ:			
		String highestFixedRate = "";//��߹̶�����:      			
		String floatingRate = "";//��������:
		String discountFixedRate = "";//��Ϣ�ͻ��̶�����
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
