package com.amarsoft.app.accounting.web.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author dxu
 * 设为最新版本时，将其他版本置为非最新版本
 */
public class SetVersionNewest extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sProductID = (String) this.getAttribute("ProductID");
		String sVID = (String) this.getAttribute("VID");
		String sIsNew = (String) this.getAttribute("IsNew");
		
		int i = 0;
		//设为最新版本时，将其他版本置为非最新版本
		if("1".equals(sIsNew)){
			i = Sqlca.executeSQL("update PRODUCT_VERSION set IsNew = '2' where ProductID = '"+sProductID+"' and VID <> '"+sVID+"'");
		}
		
		return i+"";
	}
}
