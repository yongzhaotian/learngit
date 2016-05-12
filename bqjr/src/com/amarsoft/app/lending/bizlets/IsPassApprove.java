package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/*
 * Author: ccxie 2010/04/09
 * Tester:
 * Describe: 判断一笔合同是否经过批复流程
 * Input Param:
 * 			ObjectNo: 合同号
 * Output Param:
 * 			false:未经过  
 * 			true :经过
 * HistoryLog:
 */
public class IsPassApprove extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			

		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		String sSql = "",approveCount = "",applyCount="";
		SqlObject so;
		sSql = "select count(*) from BUSINESS_CONTRACT BC ,BUSINESS_APPROVE BA where BC.RelativeSerialNo = BA.SerialNo and BC.CustomerID = BA.CustomerID and BC.BusinessType = BA.BusinessType and BC.SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		approveCount = Sqlca.getString(so);
		sSql = "select count(*) from BUSINESS_CONTRACT BC ,BUSINESS_APPLY BA where BC.RelativeSerialNo = BA.SerialNo and BC.CustomerID = BA.CustomerID and BC.BusinessType = BA.BusinessType and BC.SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		applyCount = Sqlca.getString(so);
		
		return !applyCount.equals("0") && approveCount.equals("0")?"false":"true";
	}
}

