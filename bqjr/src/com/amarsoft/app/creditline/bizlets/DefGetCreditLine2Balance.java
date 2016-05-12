/**
 * 
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author William
 * @updatesuer:yhshan
 * @updatedate:2012/09/12
 */
public class DefGetCreditLine2Balance extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLineID = (String)this.getAttribute("LineID");
		
		String sSql = "";
		String sCreditAggreement = "";
        String sBalance = null;//余额
        Double dLine = null;//额度金额
        Double dUsed = null;//已使用金额
		SqlObject so = null;//声明对象
                
        //获取额度金额
		sSql = "select LineSum1 from CL_INFO where LineID =:LineID ";
		so = new SqlObject(sSql);
		so.setParameter("LineID", sLineID);
		dLine = Sqlca.getDouble(so);  
		 
        if(dLine == null) throw new Exception("取额度金额错误：没有找到额度"+sLineID);
       
        //获取授信协议流水号
        sSql = "select BCSerialNo from CL_INFO where LineID =:LineID ";
        so = new SqlObject(sSql);
		so.setParameter("LineID", sLineID);
		sCreditAggreement = Sqlca.getString(so);  
        
		sSql = "select sum(((case when balance is null then 0 else balance end)-(case when BailSum is null then 0 else BailSum end))*getERate(BusinessCurrency,'01','')) "+
    	 	" from BUSINESS_CONTRACT where CreditAggreement =:CreditAggreement ";
		so = new SqlObject(sSql);
	    so.setParameter("CreditAggreement", sCreditAggreement);
	    dUsed = Sqlca.getDouble(so);
		
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
