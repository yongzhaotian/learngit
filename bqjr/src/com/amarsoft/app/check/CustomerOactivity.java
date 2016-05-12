package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 申请人他行授信业务检查
 * @author syang 
 * @since 2009/09/15
 * @updatesuer:yhshan
 * @updatedate:2012/09/11
 */
public class CustomerOactivity extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/** 变量定义 **/
		String sSql="";
		ASResultSet rs=null;
		SqlObject so = null;
		
		/** 程序体 **/
		//他行范围内		
		sSql = 	" select count(*) from CUSTOMER_OACTIVITY "+
				" where CustomerID =:CustomerID "+					
				" and UptoDate <=:UptoDate ";
		so = new SqlObject(sSql);
		so.setParameter("CustomerID", sCustomerID).setParameter("UptoDate", StringFunction.getToday());
		String sCount = Sqlca.getString(so);
		if( sCount == null || Integer.parseInt(sCount,10) == 0 ){
			//这里什么也不干，从jsp移过来的程序，不知道原来人家是怎么想的
		}else{
			putMsg("在他行未结清的授信业务笔数："+sCount);
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
				putMsg("在他行未结清的授信业务发放总金额（折人民币）："+DataConvert.toMoney(sBusinessSum));
				putMsg("在他行未结清的授信业务总余额（折人民币）："+DataConvert.toMoney(sBalanceSum));
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
