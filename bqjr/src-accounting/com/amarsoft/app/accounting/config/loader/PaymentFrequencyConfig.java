package com.amarsoft.app.accounting.config.loader;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;


public class PaymentFrequencyConfig extends AbstractCache{
	private static ASValuePool paymentFrequencySet;
	private static ASValuePool feeAmortizeTypeSet;
	

	public static ASValuePool getPaymentFrequencySet() throws Exception{
		return paymentFrequencySet;
	}

	public static ASValuePool getFeeAmortizeTypeSet() {
		return feeAmortizeTypeSet;
	}
	
	/*
	 * 清空缓存对象
	 * @see com.amarsoft.dict.als.cache.AbstractCache#clear()
	 */
	public void clear() throws Exception {
		
	}

	/*
	 * 加载还款周期、递延周期定义信息
	 * @see com.amarsoft.dict.als.cache.AbstractCache#load(com.amarsoft.awe.util.Transaction)
	 */
	public synchronized boolean load(Transaction transaction) throws Exception {
		try
		{
			ASValuePool paymentFrequencySet=new ASValuePool();
			ASResultSet rs=transaction.getASResultSet("select * from CODE_LIBRARY where CodeNo='PaymentFrequencyType' and IsInUse in ('0','1')");
			while(rs.next()){
				ASValuePool paymentFrequency=new ASValuePool();
				paymentFrequency.setAttribute("ID", rs.getString("ItemNo"));
				paymentFrequency.setAttribute("NAME", rs.getString("ItemName"));
				paymentFrequency.setAttribute("TERM", rs.getString("RelativeCode"));
				paymentFrequency.setAttribute("TERMUNIT", rs.getString("ItemAttribute"));
				paymentFrequencySet.setAttribute(rs.getString("ItemNo").toUpperCase(), new BusinessObject(paymentFrequency));
			}
			rs.close();
			PaymentFrequencyConfig.paymentFrequencySet = paymentFrequencySet;
			
			ASValuePool feeAmortizeTypeSet = new ASValuePool();
			rs=transaction.getASResultSet("select * from CODE_LIBRARY where CodeNo='FeeAmortizeType' and IsInUse in ('0','1')");
			while(rs.next()){
				ASValuePool feeAmortizeType=new ASValuePool();
				feeAmortizeType.setAttribute("ID", rs.getString("ItemNo"));
				feeAmortizeType.setAttribute("NAME", rs.getString("ItemName"));
				feeAmortizeType.setAttribute("TERM", rs.getString("RelativeCode"));
				feeAmortizeType.setAttribute("TERMUNIT", rs.getString("ItemAttribute"));
				feeAmortizeTypeSet.setAttribute(rs.getString("ItemNo").toUpperCase(), new BusinessObject(feeAmortizeType));
			}
			rs.close();
			PaymentFrequencyConfig.feeAmortizeTypeSet=feeAmortizeTypeSet;
	        return true;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
	}
}