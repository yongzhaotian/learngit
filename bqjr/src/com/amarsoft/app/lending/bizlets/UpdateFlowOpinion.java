package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateFlowOpinion extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");
	
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "" ;
		
		String sSql = "";
		ASResultSet rs = null;
		SqlObject so;
		//根据sSerialNo查出申请详情中的信息，将这些信息更新到流程意见表中
		sSql = "select CustomerName,BusinessCurrency,BusinessSum,TermYear,TermMonth,TermDay,BaseRate,RateFloat,BusinessRate,  RateFloatType ,BailSum,BailRatio,PdgRatio,PdgSum from business_apply where serialno=:serialno";
		so = new SqlObject(sSql).setParameter("serialno", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()) 
		{
			String CustomerName=rs.getString("CustomerName");
			String BusinessCurrency=rs.getString("BusinessCurrency");
			String BusinessSum=rs.getString("BusinessSum");
			String TermYear=rs.getString("TermYear");
			String TermMonth=rs.getString("TermMonth");
			String TermDay=rs.getString("TermDay");
			String BaseRate=rs.getString("BaseRate");
			String RateFloat=rs.getString("RateFloat");
			String BusinessRate=rs.getString("BusinessRate");
			String RateFloatType=rs.getString("RateFloatType");
			String BailSum=rs.getString("BailSum");
			String BailRatio=rs.getString("BailRatio");
			String PdgRatio=rs.getString("PdgRatio");
			String PdgSum=rs.getString("PdgSum");
		
			if(CustomerName == null) CustomerName = "";
			if(BusinessCurrency == null) BusinessCurrency = "0";
			if(BusinessSum == null) BusinessSum = "0";
			if(TermYear == null) TermYear = "0";
			if(TermMonth == null) TermMonth = "0";
			if(TermDay == null) TermDay = "0";
			if(BaseRate == null) BaseRate = "0";
			if(RateFloat == null) RateFloat = "0";
			if(BusinessRate == null) BusinessRate = "0";
			if(RateFloatType == null) RateFloatType = "0";
			if(BailSum == null) BailSum = "0";
			if(BailRatio == null) BailRatio = "0";
			if(PdgRatio == null) PdgRatio = "0";
			if(PdgSum == null) PdgSum = "0";

			sSql="update flow_opinion set CustomerName=:CustomerName,BusinessCurrency=:BusinessCurrency,BusinessSum=:BusinessSum,TermYear=:TermYear,TermMonth=:TermMonth,TermDay=:TermDay,BaseRate=:BaseRate,RateFloat=:RateFloat,BusinessRate=:BusinessRate," +
					"RateFloatType=:RateFloatType,BailSum=:BailSum,BailRatio=:BailRatio,PdgRatio=:PdgRatio,PdgSum=:PdgSum where serialno=:serialno";
			so = new SqlObject(sSql);
			so.setParameter("CustomerName", CustomerName).setParameter("BusinessCurrency", BusinessCurrency).setParameter("BusinessSum", BusinessSum).setParameter("TermYear", TermYear)
			.setParameter("TermMonth", TermMonth).setParameter("TermDay", TermDay).setParameter("BaseRate", BaseRate).setParameter("RateFloat", RateFloat).setParameter("BusinessRate", BusinessRate)
			.setParameter("RateFloatType", RateFloatType).setParameter("BailSum", BailSum).setParameter("BailRatio", BailRatio).setParameter("PdgRatio", PdgRatio)
			.setParameter("PdgSum", PdgSum).setParameter("serialno", sSerialNo);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();

		return "1";
	}	

}
