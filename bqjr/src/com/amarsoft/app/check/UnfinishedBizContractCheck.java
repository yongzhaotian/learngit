package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 申请人多头贷款检查
 * @author syang 
 * @since 2009/09/15
 */
public class UnfinishedBizContractCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**取参数**/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");	//取出客户JBO对象
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/**变量定义**/
		String sCount="";
		String sSql="";
		ASResultSet rs=null;
		SqlObject so = null;//声明对象
		/**程序体**/
	    so = new SqlObject("select count(SerialNo) from BUSINESS_CONTRACT where CustomerID =:CustomerID having count(distinct ManageOrgID)>1");
	    so.setParameter("CustomerID", sCustomerID);
	    sCount = Sqlca.getString(so);
		if( sCount != null && Integer.parseInt(sCount,10) > 0 ){			
			this.putMsg("该申请人在本行存在交叉贷款信息");
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
				this.putMsg("在["+sManageOrgName+"]机构内未结清的授信业务发放总金额（折人民币）："+DataConvert.toMoney(sBusinessSum));
				this.putMsg("在["+sManageOrgName+"]机构内未结清的授信业务总余额（折人民币）："+DataConvert.toMoney(sBalanceSum));
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
