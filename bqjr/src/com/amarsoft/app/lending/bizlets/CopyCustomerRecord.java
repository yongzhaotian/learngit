/*
		Author: rqiao
		describe:记录每个合同的客户详情信息
		modify:20150129
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CopyCustomerRecord extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//获得合同流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(null == sSerialNo) sSerialNo = "";
		//获得客户编号
		String sCustomerID = (String)this.getAttribute("CustomerID");
		if(null == sCustomerID) sCustomerID = "";
		
		//删除原合同个人信息管理表中的客户记录
		String del_sql = " DELETE FROM IND_INFO_RECORD WHERE SERIALNO = :SERIALNO AND CUSTOMERID = :CUSTOMERID ";
		Sqlca.executeSQL(new SqlObject(del_sql).setParameter("SERIALNO", sSerialNo).setParameter("CUSTOMERID", sCustomerID));
		
		//拷贝最新客户个人信息到合同个人信息管理表中
		String insert_sql = " INSERT INTO IND_INFO_RECORD SELECT BC.SERIALNO,II.* FROM BUSINESS_CONTRACT BC,IND_INFO II WHERE BC.CUSTOMERID = II.CUSTOMERID AND BC.SERIALNO = :SERIALNO AND BC.CUSTOMERID = :CUSTOMERID ";
		Sqlca.executeSQL(new SqlObject(insert_sql).setParameter("SERIALNO", sSerialNo).setParameter("CUSTOMERID", sCustomerID));
		
		return "1";
	}	
}
