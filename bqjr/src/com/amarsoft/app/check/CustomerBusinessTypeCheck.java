package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 客户类型与业务品种是否匹配检查
 * 
 * @author ccxie
 * @since 2010/04/02
 */
public class CustomerBusinessTypeCheck extends AlarmBiz {

	public Object run(Transaction Sqlca) throws Exception {

		BizObject jboContract = (BizObject) this
				.getAttribute("BusinessContract"); // 取出合同JBO对象
		String sCustomerID = jboContract.getAttribute("CustomerID").getString();
		if (sCustomerID == null)
			sCustomerID = "";
		String sBusinessType = jboContract.getAttribute("BusinessType")
				.getString();
		if (sBusinessType == null)
			sBusinessType = "";

		String sReturn = "1";
		String sCustomerType = "";
		String sSql = "";
		SqlObject so = null;//声明对象
		
		so = new SqlObject("select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID ");
		so.setParameter("CustomerID", sCustomerID);
	    sCustomerType = Sqlca.getString(so);
		
		if (sCustomerType.startsWith("03")) {
			// 验证个人客户类型与业务品种是否匹配
			so = new SqlObject("select count(*) from BUSINESS_TYPE where TypeNo =:TypeNo and TypeNo like '1110%'");
			so.setParameter("TypeNo", sBusinessType);
			sReturn = Sqlca.getString(so);
		} else if (sCustomerType.startsWith("01")) {
			// 验证公司客户类型与业务品种是否匹配
			so = new SqlObject(" select count(*) from BUSINESS_TYPE where TypeNo =:TypeNo and TypeNo not like '1110%'");
			so.setParameter("TypeNo", sBusinessType);
			sReturn = Sqlca.getString(so);
		}

		if (sReturn.equals("0")) {
			putMsg("客户类型与业务品种不一致");
			this.setPass(false);
		} else {
			this.setPass(true);
		}
		return null;
	}
}
