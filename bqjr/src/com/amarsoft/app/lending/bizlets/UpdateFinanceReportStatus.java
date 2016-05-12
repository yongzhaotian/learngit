package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.RunJavaMethodAssistant;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateFinanceReportStatus extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	    
		String customerId = (String)this.getAttribute("CustomerID");
		String reportStatus = (String)this.getAttribute("ReportStatus");
		String reportDate = (String)this.getAttribute("ReportDate");
		String reportScope = (String)this.getAttribute("ReportScope");
		String sSql="update CUSTOMER_FSRECORD set reportstatus=:reportstatus where CustomerID=:CustomerID and reportdate=:reportdate and reportscope=:reportscope";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("reportstatus", reportStatus).setParameter("CustomerID", customerId).setParameter("reportdate", reportDate).setParameter("reportscope", reportScope);
		Sqlca.executeSQL(so);
		/***************在此处调用生成财务报表预警信号程序,begin**************************/
		/***************在此处调用生成财务报表预警信号程序,end**************************/
		
		return RunJavaMethodAssistant.SUCCESS_MESSAGE;
	}

}
