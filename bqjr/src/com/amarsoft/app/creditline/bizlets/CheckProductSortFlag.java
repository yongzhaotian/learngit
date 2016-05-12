package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.app.bizmethod.BizSort;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 
 * @author qfang
 * @param typeNo
 * @decribe 根据产品编号判断是否属于贷款新规使用产品
 *
 */
public class CheckProductSortFlag extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception{
		//获取产品类型
		String typeNo = (String)this.getAttribute("TypeNo");
		if(typeNo == null) typeNo = ""; 
		
		BizSort bs = new BizSort(Sqlca,typeNo);
		return String.valueOf(bs.isBizSort());
		
	}
}
