package com.amarsoft.app.accounting.web.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author dxu
 * ��Ϊ���°汾ʱ���������汾��Ϊ�����°汾
 */
public class SetVersionNewest extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sProductID = (String) this.getAttribute("ProductID");
		String sVID = (String) this.getAttribute("VID");
		String sIsNew = (String) this.getAttribute("IsNew");
		
		int i = 0;
		//��Ϊ���°汾ʱ���������汾��Ϊ�����°汾
		if("1".equals(sIsNew)){
			i = Sqlca.executeSQL("update PRODUCT_VERSION set IsNew = '2' where ProductID = '"+sProductID+"' and VID <> '"+sVID+"'");
		}
		
		return i+"";
	}
}
