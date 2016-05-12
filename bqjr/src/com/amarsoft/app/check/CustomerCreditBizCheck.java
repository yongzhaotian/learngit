package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �����˱�������ҵ����
 * @author syang
 * @since 2009/09/15
 */
public class CustomerCreditBizCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/** �������� **/
		String sSql="";
		ASResultSet rs=null;
		SqlObject so = null;//��������
		
		/** ������ **/
		//ȫ�з�Χ��	
		sSql = 	" select count(*) from BUSINESS_CONTRACT "+
				" where CustomerID =:CustomerID "+
				" and BusinessType not like '3%' "+
				" and (FinishDate is null "+
				" or FinishDate = ' ') ";	
		so = new SqlObject(sSql);
		so.setParameter("CustomerID", sCustomerID);
        String sCount = Sqlca.getString(so);
		if( sCount == null || Integer.parseInt(sCount,10) == 0 ){
			//����ʲôҲ����
		}else{
			putMsg("��ȫ�з�Χ��δ���������ҵ�������"+sCount);
			sSql = 	" select sum(BusinessSum*getERate(BusinessCurrency,'01','')) as BusinessSum, "+
					" sum(Balance*getERate(BusinessCurrency,'01','')) as BalanceSum "+
					" from BUSINESS_CONTRACT "+
					" where CustomerID =:CustomerID "+
					" and BusinessType not like '3%' "+
					" and (FinishDate is null "+
					" or FinishDate = ' ') ";
			so = new SqlObject(sSql);
			so.setParameter("CustomerID", sCustomerID);
	        rs = Sqlca.getResultSet(so);
			if(rs.next())
			{
				String sBusinessSum = rs.getString("BusinessSum");
				String sBalanceSum = rs.getString("BalanceSum");
				if(sBusinessSum == null) sBusinessSum = "0.00";
				if(sBalanceSum == null) sBalanceSum = "0.00";
				putMsg("��ȫ�з�Χ��δ���������ҵ�񷢷��ܽ�������ң���"+DataConvert.toMoney(sBusinessSum));
				putMsg("��ȫ�з�Χ��δ���������ҵ������������ң���"+DataConvert.toMoney(sBalanceSum));
			}
			rs.getStatement().close();
		}
		
		/** ���ؽ������ **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
