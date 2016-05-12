package com.amarsoft.app.lending.bizlets;

/**
 * 对输入的金额通过所对应的币种转化为人民币所对应的金额
 * @author smiao 2011.06.20
 */

import com.amarsoft.app.als.sadre.util.DecimalUtil;
import com.amarsoft.app.util.GetCompareERate;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ChangeToRMB extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception {
		
		//自动获得传入的参数值
		String sBusinessSum = (String)this.getAttribute("BusinessSum");
		String sCurrency = (String)this.getAttribute("Currency");
		double dBusinessSum = DecimalUtil.multiply(Double.parseDouble(sBusinessSum), GetCompareERate.getConvertToRMBERate(sCurrency));
		sBusinessSum = String.valueOf(dBusinessSum);
		
		return sBusinessSum;		
	}
}
