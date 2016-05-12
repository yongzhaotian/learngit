/**
 * 
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author jbye
 *
 */
public class FinGetCreditLineBalance extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLineID = (String)this.getAttribute("LineID");
		
		String sSql = "",sCustomerID = "";
        String sBalance = null;//余额
        ASResultSet rs = null;
        Double dLine = null;//额度金额
        Double dUsed = null;//已使用金额
        
        
        sSql = "select CustomerID,LineSum1 from CL_INFO where LineID = '"+sLineID+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next()){
        	dLine = new Double(rs.getDouble("LineSum1"));
        	sCustomerID = rs.getString("CustomerID");
        }
        rs.getStatement().close();
        if(dLine == null) throw new Exception("取额度金额错误：没有找到额度"+sLineID);
        
        sSql = "select sum(Balance) from BUSINESS_CONTRACT where CreditAggreement = '"+sLineID+"' ";
        dUsed = Sqlca.getDouble(sSql);
        
        //加入买入返售部分的同业授信额度占用
        sSql = "select sum(Balance) from BUSINESS_CONTRACT " +
        		"where BusinessType='2100' and Describe2 = '"+sCustomerID+"' ";

        //最占用授信包括： 授信项下的和买入返售中从对应同业购入的业务
        dUsed = new Double(dUsed.doubleValue() + Sqlca.getDouble(sSql).doubleValue());
        
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
