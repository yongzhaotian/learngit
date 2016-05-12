package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 检查是否有关键人及股东信息信息
 * @author syang 
 * @since 2009/09/15
 *
 */
public class CustomerKeyRelaCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/** 变量定义 **/
		String sSql = "";
		ASResultSet rs = null;
		int iNum = 0;
		
		/** 程序体 **/
		
		//检查关键人信息
	    sSql = " select Count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = :CustomerID "+
        " and RelationShip like '01%'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
		if(rs.next())
			iNum = rs.getInt(1);
		rs.getStatement().close();
		rs = null;
		if(iNum == 0){
			putMsg("没有输入关键人信息");
		}
		
		//检查股东信息
		iNum = 0;
		sSql = 	" select Count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = :CustomerID "+
		" and RelationShip like '52%' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
		if(rs.next())
			iNum = rs.getInt(1);
		rs.getStatement().close();
		
		if(iNum == 0){
			putMsg("没有输入股东信息");
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
