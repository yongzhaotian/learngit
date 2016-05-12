package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.app.bizmethod.BizSort;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 
 * @author qfang
 * @param typeNo
 * @decribe ���ݲ�Ʒ����ж��Ƿ����ڴ����¹�ʹ�ò�Ʒ
 *
 */
public class CheckProductSortFlag extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception{
		//��ȡ��Ʒ����
		String typeNo = (String)this.getAttribute("TypeNo");
		if(typeNo == null) typeNo = ""; 
		
		BizSort bs = new BizSort(Sqlca,typeNo);
		return String.valueOf(bs.isBizSort());
		
	}
}
