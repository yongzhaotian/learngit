package com.amarsoft.app.als.finance.analyse.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class FinanceReportOper {
	
	private String reportDate = "";
	private String customerID = "";
	private String reportScope = "";
	private String auditFlag = "";
	private String reportPeriod = "";
	private String modelClass = "";
	private String reportDescribe = "";
	private String recordNO = "";

	public String getReportDescribe() {
		return reportDescribe;
	}


	public void setReportDescribe(String reportDescribe) {
		this.reportDescribe = reportDescribe;
	}


	public String getReportDate() {
		return reportDate;
	}


	public void setReportDate(String reportDate) {
		this.reportDate = reportDate;
	}


	public String getCustomerID() {
		return customerID;
	}


	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}


	public String getReportScope() {
		return reportScope;
	}


	public void setReportScope(String reportScope) {
		this.reportScope = reportScope;
	}


	public String getAuditFlag() {
		return auditFlag;
	}


	public void setAuditFlag(String auditFlag) {
		this.auditFlag = auditFlag;
	}


	public String getReportPeriod() {
		return reportPeriod;
	}


	public void setReportPeriod(String reportPeriod) {
		this.reportPeriod = reportPeriod;
	}


	public String getModelClass() {
		return modelClass;
	}


	public void setModelClass(String modelClass) {
		this.modelClass = modelClass;
	}
	public String getRecordNO() {
		return recordNO;
	}


	public void setRecordNO(String recordNO) {
		this.recordNO = recordNO;
	}

	public String CheckReportFlag() throws JBOException{	
		StringBuffer sReportName = new StringBuffer();
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager Manager = factory.getManager("jbo.finasys.REPORT_RECORD");
		String sql = "select o.ReportName from o,jbo.finasys.REPORT_CATALOG RC where o.modelNO = RC.modelNO and RC.Attribute1 like '1%' and o.objectNO = :CustomerID and " +
				"o.reportDate = :ReportDate and o.reportPeriod = :ReportPeriod and o.reportScope = :ReportScope and o.auditFlag = :AuditFlag and (o.reportFlag <> '2' or o.ReportFlag is null)  and FSRECORDNO=:RecordNo";
		BizObjectQuery bq = Manager.createQuery(sql).setParameter("CustomerID", customerID).setParameter("ReportDate", reportDate).
		                      setParameter("ReportPeriod", reportPeriod).setParameter("ReportScope", reportScope).setParameter("AuditFlag", auditFlag)
		                      .setParameter("RecordNo",this.recordNO);
		List bolist = bq.getResultList();

		for(int i=0;i<bolist.size();i++){
			sReportName.append(",");
			BizObject bo = (BizObject) bolist.get(i);
			if(bo!=null){
				sReportName.append(bo.getAttribute("ReportName").getString());
				}
		}
		String reportName = "";
		if(sReportName.length()>0)
			reportName = sReportName.deleteCharAt(0).toString();
		else
			reportName = sReportName.toString();
		return reportName;
	}
	
	public String UpdateFSStatus(JBOTransaction tx) throws Exception{
		String sReturn = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager manager;
		manager = factory.getManager("jbo.finasys.CUSTOMER_FSRECORD");
		tx.join(manager);
		String sql = "update o set o.ReportStatus='02' where o.CustomerID=:CustomerID and o.RecordNo=:RecordNo";
		BizObjectQuery bq = manager.createQuery(sql).setParameter("CustomerID", customerID).setParameter("RecordNo", recordNO);
		bq.executeUpdate();
		sReturn = "true";
		return sReturn;
	}
}
