/**
 * Author: --jbye 2005-08-31 17:57            
 * Tester:                               
 * Describe: --取得授信条件项下的敞口余额  
 * Input Param:                          
 * 		LimitationSetID : 授信限制组ID
 * 		LineID : 授信ID
 *      WhereClause : 查询余额范围
 * Output Param:                         
 * 		sBalance：可用余额          
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCreditLine2Balance_Sub extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLimitationID = (String)this.getAttribute("LimitationID");
        String sLineID = (String)this.getAttribute("LineID");
        String sWhereClause = (String)this.getAttribute("WhereClause");
		
		String sSql = "";
        String sBalance = null;//余额
        Double dLine = null;//额度金额
        Double dUsed = null;//已使用金额
        
        sSql = "select LineSum2 from CL_LIMITATION where LimitationID = '"+sLimitationID+"'";
        dLine = Sqlca.getDouble(sSql);
        if(dLine == null) throw new Exception("取条件金额错误：没有找到额度"+sLimitationID);
        
        //增加Flag4作为是否完成放贷的标志，1表示完成，0表示未完成
        //未完成放贷的取BusinessSum,完成的取Balance
        sSql = "select sum((BusinessSum*DeCode(Flag4,'0',1,0)+Balance*DeCode(Flag4,'1',1,0)-(case when BailSum is null then 0 else BailSum end))*getERate(BusinessCurrency,'01','')) from BUSINESS_CONTRACT " +
        	 " where CreditAggreement = '"+sLineID+"'" +sWhereClause;
        dUsed = Sqlca.getDouble(sSql);
        
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
