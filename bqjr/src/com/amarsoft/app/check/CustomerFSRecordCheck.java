package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 本类功能说明
 * @author syang
 * @since 2009/09/15
 */
public class CustomerFSRecordCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		String sCustomerType = jboCustomer.getAttribute("CustomerType").getString();
		
		/** 变量定义 **/
		String sAccMonth = "";//会计月份
		String sMinAccMonth = "";//前三月
		String sCount = "";//记录数			
		String sCurToday = StringFunction.getToday();//当前日期
		
		/** 程序体 **/
		if (sCustomerType == null) sCustomerType = "";	
		//公司客户
		if (sCustomerType.substring(0,2).equals("01")) {
			sAccMonth = sCurToday.substring(0,7);//会计月份
			sMinAccMonth = StringFunction.getRelativeAccountMonth(sAccMonth,"Month",-3);
			SqlObject so = new SqlObject("select count(RecordNo) from CUSTOMER_FSRECORD where CustomerID =:CustomerID And ReportDate >=:ReportDate");
			so.setParameter("CustomerID", sCustomerID);
			so.setParameter("ReportDate", sMinAccMonth);
			sCount = Sqlca.getString(so);
			if( sCount == null || Integer.parseInt(sCount) <= 0 ){
				putMsg("该客户已经有三个月没有登记财务报表");
			}
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
