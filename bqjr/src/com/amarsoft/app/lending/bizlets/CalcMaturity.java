package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 根据起始日和期限计算到期日
 * @author rant
 *
 */

public class CalcMaturity extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		//期限标志
		String sLoanTermFlag = (String)this.getAttribute("LoanTermFlag");
		//贷款期限
		String sLoanTerm = (String)this.getAttribute("LoanTerm");
		//业务起始日
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		
		//将空值转化为空字符串
		if(sLoanTermFlag == null) sLoanTermFlag = "";
		if(sLoanTerm == null) sLoanTerm = "";
		if(sPutOutDate == null) sPutOutDate = "";
		
		//定义变量
		int iLoanTerm = Integer.parseInt(sLoanTerm);
		String sMaturity = DateFunctions.getRelativeDate(sPutOutDate, sLoanTermFlag, iLoanTerm);
		if(sMaturity == null) sMaturity = "";
		
		return sMaturity;
	}

}
