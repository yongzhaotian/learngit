package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 关联客户检查
 * @author jschen 
 * @since 2010/03/24
 *
 */
public class RelativeCustomerCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**取参数**/
		BizObject jboBCContract = (BizObject)this.getAttribute("BusinessContract");		//取出合同JBO对象
		String sCustomerID = jboBCContract.getAttribute("CustomerID").getString();
		
		/**变量定义**/
		
		
		/**程序体**/
		if( sCustomerID == null || sCustomerID.length() == 0){				
			putMsg("该业务没有关联客户");
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
