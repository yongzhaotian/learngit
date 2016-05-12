package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ��ͬ��Ϣ�����Լ��
 * @author jschen 
 * @since 2010/03/24
 *
 */
public class ContractCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**ȡ����**/
		BizObject jboCustomer = (BizObject)this.getAttribute("BusinessContract");		//ȡ���ͻ�JBO����
		String sTempSaveFlag = jboCustomer.getAttribute("TempSaveFlag").getString();
		
		/**��������**/
		
		
		/**������**/
		if( sTempSaveFlag == null || sTempSaveFlag.length() == 0 || sTempSaveFlag.equalsIgnoreCase("1")){				
			putMsg("��ͬ������Ϣδ�������");
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
