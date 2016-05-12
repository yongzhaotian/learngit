package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 在修改客户信息中财务信息的报表口径时，同时更新REPORT_RECORD
 *@author jfeng 2011-05-30
 *
 */

public class SaveFinanceReport extends Bizlet{
	
	/**
	 * @param CustomerID 客户编号
	 * @param RecordNo 记录编号
	 * @param ReportScope 报表口径
	 * @param ReportDate 报表日期
	 */
	
	public Object run(Transaction Sqlca) throws Exception{
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sRecordNo = (String)this.getAttribute("RecordNo");
		String sReportScope = (String)this.getAttribute("ReportScope");
		String sReportDate = (String)this.getAttribute("ReportDate");
		
		//定义变量
		String sSql = "";
		ASResultSet rs = null;

		//更新REPORT_RECORD 
		sSql =  " update REPORT_RECORD set ReportScope =:ReportScope " +
		" where ReportDate =:ReportDate and ObjectNo =:ObjectNo ";
		SqlObject so = new SqlObject(sSql).setParameter("ReportScope", sReportScope).setParameter("ReportDate", sReportDate).setParameter("ObjectNo", sCustomerID);
		Sqlca.executeSQL(so);
		return "success";
	}

}
