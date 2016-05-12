package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 合同信息完整性检查
 * @author jschen 
 * @since 2010/03/24
 *
 */
public class ContractCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**取参数**/
		BizObject jboCustomer = (BizObject)this.getAttribute("BusinessContract");		//取出客户JBO对象
		String sTempSaveFlag = jboCustomer.getAttribute("TempSaveFlag").getString();
		
		/**变量定义**/
		
		
		/**程序体**/
		if( sTempSaveFlag == null || sTempSaveFlag.length() == 0 || sTempSaveFlag.equalsIgnoreCase("1")){				
			putMsg("合同基本信息未补登完成");
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
