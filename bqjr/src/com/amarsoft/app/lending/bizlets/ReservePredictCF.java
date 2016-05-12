package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.reserve.business.CashFlowDiscountFormula;
import com.amarsoft.biz.reserve.business.DateTools;
/**
 * 
 * 预测未来现金流折现计算。
 * @author pwang
 *
 */
public class ReservePredictCF extends Bizlet {
	/** 
	 * @param rate,cashflow
	 */
	public Object run(Transaction Sqlca) throws Exception{
		
		String sRate = (String)this.getAttribute("rate");				//利率：月利率
		String sCashFlow = (String)this.getAttribute("cashflow");		//未来现金流
		String sFutureDate = (String)this.getAttribute("futureDate");	//未来日期
		String sBaseDate = (String)this.getAttribute("baseDate");		//基准日期	
		
		double[] sCashFlowDouble= new double[1];
		double sRate1 = 0.0;	
		
		
		
		if(sRate == null) sRate = "";
		if(sCashFlow == null) sCashFlow = "";
		double ReturnValue =0.0;
		
		//定义变量
		sRate1 =Double.parseDouble(sRate);			//系统目前为月利率
		sCashFlowDouble[0] =Double.parseDouble(sCashFlow);

	
		//第1步：计算两个日期相差的天数
		int days = DateTools.getDateDistance(sBaseDate,sFutureDate);
		//期数=天数/30(按月)
		double time = days/30.0;
		
		ReturnValue = CashFlowDiscountFormula.getCashFlow(sRate1,Double.parseDouble(sCashFlow),time);
		ARE.getLog().debug("单次预测未来现金流折现："+ReturnValue);
		return ""+ReturnValue;
	}

}
