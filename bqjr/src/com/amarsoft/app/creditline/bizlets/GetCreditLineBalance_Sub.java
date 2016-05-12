/**
 * Author: --jbye 2005-08-31 17:57            
 * Tester:                               
 * Describe: --ȡ�������������µ��������  
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


public class GetCreditLineBalance_Sub extends Bizlet {

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
        
        sSql = "select LineSum1 from CL_LIMITATION where LimitationID = '"+sLimitationID+"'";
        dLine = Sqlca.getDouble(sSql);
        if(dLine == null) throw new Exception("ȡ��Ƚ�����û���ҵ����"+sLimitationID);
        
        //ȡ�ö�Ӧ�Ĵ������
        sSql = "select sum((Balance)*getERate(BusinessCurrency,'01','')) from BUSINESS_CONTRACT where " +
		"CreditAggreement = '"+sLineID+"'" +sWhereClause;
        dUsed = Sqlca.getDouble(sSql);

        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
