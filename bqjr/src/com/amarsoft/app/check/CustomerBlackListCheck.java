package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 黑名单客户检查
 * @author syang
 * @since 2009/09/15
 */
public class CustomerBlackListCheck extends AlarmBiz {
	

	public Object run(Transaction Sqlca) throws Exception {
		
		/*取参数*/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");	//取出客户JBO对象
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		String sCertType = jboCustomer.getAttribute("CertType").getString();
		String sCertID = jboCustomer.getAttribute("CertID").getString();
		
		/*变量定义 */
		String sCount = "";
		String sToday = StringFunction.getToday();
		
		
		/*程序体*/
		//1.根据客户号或者证件类型、证件号去黑名单中查找
		//2.当前日期必需在开始日期，结束日期之间（包括两端点）
		
		SqlObject so = new SqlObject("select count(SerialNo) from CUSTOMER_SPECIAL "
								+" where 1=1"
								+" and (CustomerID =:CustomerID  or (CertType =:CertType and CertID =:CertID)) "
								+" and SectionType = '40' "
								+" and InListStatus='1'"
								+" and (EndDate >=:EndDate or EndDate is null)" 
								+" and BeginDate<=:BeginDate ");
		so.setParameter("CustomerID", sCustomerID).setParameter("CertType", sCertType).setParameter("CertID", sCertID)
		.setParameter("EndDate", sToday).setParameter("BeginDate", sToday);
		sCount=Sqlca.getString(so);
		if( sCount != null && Integer.parseInt(sCount,10) > 0  ){
			putMsg( "属于黑名单客户");
		}
		
		/* 返回结果处理  */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
