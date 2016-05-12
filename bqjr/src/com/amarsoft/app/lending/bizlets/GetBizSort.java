package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.bizmethod.BizSort;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * <p>
 * 获取该笔放贷业务是否属于贷款新规范围
 * </p>
 * @author smiao
 *
 */

public class GetBizSort extends Bizlet{
	
	boolean isBizSort ;
	String isbizSort ="";
	String sSql = "";
	
	public Object run(Transaction Sqlca) throws Exception{
		
		//自动获得传入的参数值
		String sBusinessType = (String)this.getAttribute("TypeNo");
		
		BizSort bizSort  = new BizSort(Sqlca,sBusinessType);
		isBizSort = bizSort.isBizSort();
		if(isBizSort){
			isbizSort = "1";
		}else{
			isbizSort = "0";
		}		
		return isbizSort;	
	}

}
