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
        String sBalance = null;//���
        Double dLine = null;//��Ƚ��
        Double dUsed = null;//��ʹ�ý��
        
        sSql = "select LineSum1 from CL_INFO where LineID = '"+sLineID+"'";
        dLine = Sqlca.getDouble(sSql);
        if(dLine == null) throw new Exception("ȡ��Ƚ�����û���ҵ����"+sLineID);
        
        sSql = "select sum(Balance*getERate(BusinessCurrency,'01','')) "+
        	 " from BUSINESS_CONTRACT where CreditAggreement = '"+sLineID+"' ";
        dUsed = Sqlca.getDouble(sSql);
        
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
