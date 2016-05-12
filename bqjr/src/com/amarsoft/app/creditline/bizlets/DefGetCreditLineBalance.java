/**
 * 
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author William
 *
 */
public class DefGetCreditLineBalance extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLineID = (String)this.getAttribute("LineID");
		
		String sSql = "";
        String sBalance = null;//余额
        Double dLine = null;//额度金额
        Double dUsed = null;//已使用金额
        
        sSql = "select LineSum1 from CL_INFO where LineID = '"+sLineID+"'";
        dLine = Sqlca.getDouble(sSql);
        if(dLine == null) throw new Exception("取额度金额错误：没有找到额度"+sLineID);
        
        sSql = "select sum(Balance*getERate(BusinessCurrency,'01','')) "+
        	 " from BUSINESS_CONTRACT where CreditAggreement = '"+sLineID+"' ";
        dUsed = Sqlca.getDouble(sSql);
        
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
