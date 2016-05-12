package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 申请人信用评级检查
 * @author syang
 * @since 2009/07/15
 */
public class CustomerEvalvateCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		String sCustomerType = jboCustomer.getAttribute("CustomerType").getString();
		
		/** 变量定义 **/
		String sCount = "";			//记录数	
		
		
		/** 程序体 **/
		// 以当前日期起向前一年内检查申请人的信用评级信息
		String sTodayMonth = StringFunction.getToday();
		String sBgMonth = String.valueOf(Integer.parseInt(sTodayMonth.substring(0,4),10)-1).concat(sTodayMonth.substring(4,7));
		
		SqlObject so = new SqlObject("select count(SerialNo) from EVALUATE_RECORD where ObjectType='Customer' And ObjectNo=:ObjectNo And AccountMonth >=:AccountMonth");
		so.setParameter("ObjectNo", sCustomerID);
		so.setParameter("AccountMonth", sBgMonth);
		sCount = Sqlca.getString(so);
		if( sCount == null || Integer.parseInt(sCount) <= 0 ){
			putMsg("该客户缺少一年内的信用评级");
		}
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
