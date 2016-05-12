package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 客户基本信息检查
 * @author jschen 
 * @since 2010/03/24
 *
 */
public class IndCustomerCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**取参数**/
		BizObject jboCustomer = (BizObject)this.getAttribute("IndCustomerInfo");		//取出客户JBO对象
		String sTempSaveFlag = jboCustomer.getAttribute("TempSaveFlag").getString();
		
		/**变量定义**/
		
		
		/**程序体**/
		if( sTempSaveFlag == null || sTempSaveFlag.length() == 0 || "1".equalsIgnoreCase(sTempSaveFlag)){				
			putMsg("客户基本信息未补登完成");
		}

		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
