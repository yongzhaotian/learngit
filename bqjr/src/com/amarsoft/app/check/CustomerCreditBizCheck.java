package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 申请人本行授信业务检查
 * @author syang
 * @since 2009/09/15
 */
public class CustomerCreditBizCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/** 变量定义 **/
		String sSql="";
		ASResultSet rs=null;
		SqlObject so = null;//声明对象
		
		/** 程序体 **/
		//全行范围内	
		sSql = 	" select count(*) from BUSINESS_CONTRACT "+
				" where CustomerID =:CustomerID "+
				" and BusinessType not like '3%' "+
				" and (FinishDate is null "+
				" or FinishDate = ' ') ";	
		so = new SqlObject(sSql);
		so.setParameter("CustomerID", sCustomerID);
        String sCount = Sqlca.getString(so);
		if( sCount == null || Integer.parseInt(sCount,10) == 0 ){
			//这里什么也不干
		}else{
			putMsg("在全行范围内未结清的授信业务笔数："+sCount);
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
				putMsg("在全行范围内未结清的授信业务发放总金额（折人民币）："+DataConvert.toMoney(sBusinessSum));
				putMsg("在全行范围内未结清的授信业务总余额（折人民币）："+DataConvert.toMoney(sBalanceSum));
			}
			rs.getStatement().close();
		}
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
