package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 业务品种信息检查
 * @author jschen 
 * @since 2010/03/24
 *
 */
public class BusinessTypeCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/**取参数**/
		BizObject jboBCContract = (BizObject)this.getAttribute("BusinessContract");		//取出合同JBO对象
		String sBusinessType = jboBCContract.getAttribute("BusinessType").getString();
		
		/**变量定义**/
		
		/**程序体**/
		if( sBusinessType == null || sBusinessType.length() == 0){				
			putMsg("该业务没有关联业务品种");
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
