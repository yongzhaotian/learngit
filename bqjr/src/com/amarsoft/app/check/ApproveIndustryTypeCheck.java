package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 批复限制行业检查
 * @author syang 
 * @since 2009/11/12
 */
public class ApproveIndustryTypeCheck extends AlarmBiz {

	public Object run(Transaction Sqlca) throws Exception {
		
		/**取参数**/
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");		//取出批复JBO对象
		String sDirection = jboApprove.getAttribute("Direction").getString();
		
		/**变量定义**/
		String sCount="";
		
		/**程序体**/
		SqlObject so = new SqlObject("select count(CodeNo) from CODE_LIBRARY where CodeNo = 'IndustryType' and ItemNo =:ItemNo and ItemDescribe = '1'");
		so.setParameter("ItemNo", sDirection);
		sCount = Sqlca.getString(so);
		if( sCount != null && Integer.parseInt(sCount,10) > 0 ){				
			putMsg("该批复的行业投向为本行限制行业");
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
