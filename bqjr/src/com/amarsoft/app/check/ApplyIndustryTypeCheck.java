package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ����������ҵ���
 * @author syang 
 * @since 2009/09/15
 */
public class ApplyIndustryTypeCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**ȡ����**/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//ȡ������JBO����
		String sDirection = jboApply.getAttribute("Direction").getString();
		
		/**��������**/
		String sCount="";
		
		/**������**/
		SqlObject so = new SqlObject("select count(CodeNo) from CODE_LIBRARY where CodeNo = 'IndustryType' and ItemNo =:ItemNo and ItemDescribe = '1'");
		so.setParameter("ItemNo", sDirection);
		sCount = Sqlca.getString(so);
		
		if( sCount != null && Integer.parseInt(sCount,10) > 0 ){				
			putMsg("���������ҵͶ��Ϊ����������ҵ");
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
