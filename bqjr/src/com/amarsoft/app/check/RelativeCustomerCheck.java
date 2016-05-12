package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �����ͻ����
 * @author jschen 
 * @since 2010/03/24
 *
 */
public class RelativeCustomerCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**ȡ����**/
		BizObject jboBCContract = (BizObject)this.getAttribute("BusinessContract");		//ȡ����ͬJBO����
		String sCustomerID = jboBCContract.getAttribute("CustomerID").getString();
		
		/**��������**/
		
		
		/**������**/
		if( sCustomerID == null || sCustomerID.length() == 0){				
			putMsg("��ҵ��û�й����ͻ�");
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
