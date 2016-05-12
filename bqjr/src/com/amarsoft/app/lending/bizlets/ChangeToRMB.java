package com.amarsoft.app.lending.bizlets;

/**
 * ������Ľ��ͨ������Ӧ�ı���ת��Ϊ���������Ӧ�Ľ��
 * @author smiao 2011.06.20
 */

import com.amarsoft.app.als.sadre.util.DecimalUtil;
import com.amarsoft.app.util.GetCompareERate;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ChangeToRMB extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception {
		
		//�Զ���ô���Ĳ���ֵ
		String sBusinessSum = (String)this.getAttribute("BusinessSum");
		String sCurrency = (String)this.getAttribute("Currency");
		double dBusinessSum = DecimalUtil.multiply(Double.parseDouble(sBusinessSum), GetCompareERate.getConvertToRMBERate(sCurrency));
		sBusinessSum = String.valueOf(dBusinessSum);
		
		return sBusinessSum;		
	}
}
