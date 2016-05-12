/**
 * Author: --jbye 2005-08-31 17:57            
 * Tester:                               
 * Describe: --ȡ�������������µĳ������  
 * Input Param:                          
 * 		LimitationSetID : ����������ID
 * 		LineID : ����ID
 *      WhereClause : ��ѯ��Χ
 * Output Param:                         
 * 		sBalance���������          
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
        String sBalance = null;//���
        Double dLine = null;//��Ƚ��
        Double dUsed = null;//��ʹ�ý��
        
        sSql = "select LineSum2 from CL_LIMITATION where LimitationID = '"+sLimitationID+"'";
        dLine = Sqlca.getDouble(sSql);
        if(dLine == null) throw new Exception("ȡ����������û���ҵ����"+sLimitationID);
        
        //����Flag4��Ϊ�Ƿ���ɷŴ��ı�־��1��ʾ��ɣ�0��ʾδ���
        //δ��ɷŴ���ȡBusinessSum,��ɵ�ȡBalance
        sSql = "select sum((BusinessSum*DeCode(Flag4,'0',1,0)+Balance*DeCode(Flag4,'1',1,0)-(case when BailSum is null then 0 else BailSum end))*getERate(BusinessCurrency,'01','')) from BUSINESS_CONTRACT " +
        	 " where CreditAggreement = '"+sLineID+"'" +sWhereClause;
        dUsed = Sqlca.getDouble(sSql);
        
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
