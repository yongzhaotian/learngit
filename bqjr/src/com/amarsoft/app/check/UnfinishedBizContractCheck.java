package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �����˶�ͷ������
 * @author syang 
 * @since 2009/09/15
 */
public class UnfinishedBizContractCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**ȡ����**/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");	//ȡ���ͻ�JBO����
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/**��������**/
		String sCount="";
		String sSql="";
		ASResultSet rs=null;
		SqlObject so = null;//��������
		/**������**/
	    so = new SqlObject("select count(SerialNo) from BUSINESS_CONTRACT where CustomerID =:CustomerID having count(distinct ManageOrgID)>1");
	    so.setParameter("CustomerID", sCustomerID);
	    sCount = Sqlca.getString(so);
		if( sCount != null && Integer.parseInt(sCount,10) > 0 ){			
			this.putMsg("���������ڱ��д��ڽ��������Ϣ");
			sSql = 	" select getOrgName(ManageOrgID) as ManageOrgName, "+
					" sum(BusinessSum*getERate(BusinessCurrency,'01','')) as BusinessSum, "+
					" sum(Balance*getERate(BusinessCurrency,'01','')) as BalanceSum "+
					" from BUSINESS_CONTRACT "+
					" where CustomerID =:CustomerID "+
					" and BusinessType not like '3%' "+
					" and (FinishDate is null "+
					" or FinishDate = ' ') "+
					" group by ManageOrgID ";
			so = new SqlObject(sSql);
		    so.setParameter("CustomerID", sCustomerID);
	        rs = Sqlca.getResultSet(so);
			while(rs.next()){
				String sManageOrgName = rs.getString("ManageOrgName");
				String sBusinessSum = rs.getString("BusinessSum");
				String sBalanceSum = rs.getString("BalanceSum");
				if(sManageOrgName == null) sManageOrgName = "";
				if(sBusinessSum == null) sBusinessSum = "0.00";
				if(sBalanceSum == null) sBalanceSum = "0.00";
				this.putMsg("��["+sManageOrgName+"]������δ���������ҵ�񷢷��ܽ�������ң���"+DataConvert.toMoney(sBusinessSum));
				this.putMsg("��["+sManageOrgName+"]������δ���������ҵ������������ң���"+DataConvert.toMoney(sBalanceSum));
			}
			rs.getStatement().close();
		}
		
		if(this.messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
