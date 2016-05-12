package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ҵ��Ʒ����Ϣ���
 * @author jschen 
 * @since 2010/03/24
 *
 */
public class BusinessTypeCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**ȡ����**/
		BizObject jboBCContract = (BizObject)this.getAttribute("BusinessContract");		//ȡ����ͬJBO����
		String sBusinessType = jboBCContract.getAttribute("BusinessType").getString();
		
		/**��������**/
		
		/**������**/
		if( sBusinessType == null || sBusinessType.length() == 0){				
			putMsg("��ҵ��û�й���ҵ��Ʒ��");
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
