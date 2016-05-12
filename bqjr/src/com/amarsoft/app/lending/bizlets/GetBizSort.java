package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.bizmethod.BizSort;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * <p>
 * ��ȡ�ñʷŴ�ҵ���Ƿ����ڴ����¹淶Χ
 * </p>
 * @author smiao
 *
 */

public class GetBizSort extends Bizlet{
	
	boolean isBizSort ;
	String isbizSort ="";
	String sSql = "";
	
	public Object run(Transaction Sqlca) throws Exception{
		
		//�Զ���ô���Ĳ���ֵ
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
