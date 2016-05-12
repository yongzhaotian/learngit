package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ��������������ҵ����
 * @author syang 
 * @since 2009/09/15
 * @updatesuer:yhshan
 * @updatedate:2012/09/11
 */
public class CustomerOactivity extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/** �������� **/
		String sSql="";
		ASResultSet rs=null;
		SqlObject so = null;
		
		/** ������ **/
		//���з�Χ��		
		sSql = 	" select count(*) from CUSTOMER_OACTIVITY "+
				" where CustomerID =:CustomerID "+					
				" and UptoDate <=:UptoDate ";
		so = new SqlObject(sSql);
		so.setParameter("CustomerID", sCustomerID).setParameter("UptoDate", StringFunction.getToday());
		String sCount = Sqlca.getString(so);
		if( sCount == null || Integer.parseInt(sCount,10) == 0 ){
			//����ʲôҲ���ɣ���jsp�ƹ����ĳ��򣬲�֪��ԭ���˼�����ô���
		}else{
			putMsg("������δ���������ҵ�������"+sCount);
			sSql = 	" select sum(BusinessSum*getERate(Currency,'01','')) as BusinessSum, "+
					" sum(Balance*getERate(Currency,'01','')) as BalanceSum "+
					" from CUSTOMER_OACTIVITY "+
					" where CustomerID =:CustomerID "+
					" and UptoDate <=:UptoDate ";
			so = new SqlObject(sSql);
			so.setParameter("CustomerID", sCustomerID).setParameter("UptoDate", StringFunction.getToday());
	        rs = Sqlca.getResultSet(so);
			if(rs.next())
			{
				String sBusinessSum = rs.getString("BusinessSum");
				String sBalanceSum = rs.getString("BalanceSum");
				if(sBusinessSum == null) sBusinessSum = "0.00";
				if(sBalanceSum == null) sBalanceSum = "0.00";
				putMsg("������δ���������ҵ�񷢷��ܽ�������ң���"+DataConvert.toMoney(sBusinessSum));
				putMsg("������δ���������ҵ������������ң���"+DataConvert.toMoney(sBalanceSum));
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
