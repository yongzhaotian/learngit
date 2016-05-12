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
        String sBalance = null;//���
        ASResultSet rs = null;
        Double dLine = null;//��Ƚ��
        Double dUsed = null;//��ʹ�ý��
        
        
        sSql = "select CustomerID,LineSum1 from CL_INFO where LineID = '"+sLineID+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next()){
        	dLine = new Double(rs.getDouble("LineSum1"));
        	sCustomerID = rs.getString("CustomerID");
        }
        rs.getStatement().close();
        if(dLine == null) throw new Exception("ȡ��Ƚ�����û���ҵ����"+sLineID);
        
        sSql = "select sum(Balance) from BUSINESS_CONTRACT where CreditAggreement = '"+sLineID+"' ";
        dUsed = Sqlca.getDouble(sSql);
        
        //�������뷵�۲��ֵ�ͬҵ���Ŷ��ռ��
        sSql = "select sum(Balance) from BUSINESS_CONTRACT " +
        		"where BusinessType='2100' and Describe2 = '"+sCustomerID+"' ";

        //��ռ�����Ű����� �������µĺ����뷵���дӶ�Ӧͬҵ�����ҵ��
        dUsed = new Double(dUsed.doubleValue() + Sqlca.getDouble(sSql).doubleValue());
        
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
