package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * <p>
 * 获取支付表的流水号和格式化报告的DocID
 * </p>
 * @author smiao 2011.06.08
 *
 */

public class GetPaymentNo extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		//自动获得传入的参数值
		String sPutoutSerialNo = (String)this.getAttribute("ObjectNo");
		
		//定义变量
		String sSql = "";
		String sColValue = "";
		
		sSql = "select SerialNo,DocID from PAYMENT_INFO where PutoutSerialNo =  :PutoutSerialNo";
		
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("PutoutSerialNo", sPutoutSerialNo));
		
		if(rs.next()){
			
				sColValue = rs.getString(1) +"@"+ rs.getString(2);
		}
		rs.getStatement().close();
		return sColValue;
	}

}
