package com.amarsoft.app.als.finance.report;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

public class FSRecordOperate {

	private String customerID; //�ͻ����
	private String recordNo; //�Ʊ���¼���
	private String reportDate; //�Ʊ��·�
	private String reportScope; //�Ʊ��ھ�
	private String reportPeriod; //�Ʊ�����
	private String auditFlag; //�Ƿ����
	private String reportStatus; //�Ʊ�״̬
	private String financeBelong; //�Ʊ���𣨴��ࣩ
	
	public String getFinanceBelong() {
		return financeBelong;
	}

	public void setFinanceBelong(String financeBelong) {
		this.financeBelong = financeBelong;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getRecordNo() {
		return recordNo;
	}

	public void setRecordNo(String recordNo) {
		this.recordNo = recordNo;
	}

	public String getReportDate() {
		return reportDate;
	}

	public void setReportDate(String reportDate) {
		this.reportDate = reportDate;
	}

	public String getReportScope() {
		return reportScope;
	}

	public void setReportScope(String reportScope) {
		this.reportScope = reportScope;
	}

	public String getReportStatus() {
		return reportStatus;
	}

	public void setReportStatus(String reportStatus) {
		this.reportStatus = reportStatus;
	}
	
	public String getReportPeriod() {
		return reportPeriod;
	}

	public void setReportPeriod(String reportPeriod) {
		this.reportPeriod = reportPeriod;
	}
	
	public String getAuditFlag() {
		return auditFlag;
	}

	public void setAuditFlag(String auditFlag) {
		this.auditFlag = auditFlag;
	}
	
	/**
	 * ��⵱ǰ�·ݲ��񱨱��Ƿ��Ѵ���
	 * ��ԭ�����෽��!CustomerManage.CheckFSRecord�޸Ķ���
	 * @return
	 * @throws Exception
	 * logs: 1. modefied by hdguan at 2011-07-01 for �޸�У�鱨��Ψһ�Ե��߼����ͻ���ţ��ڴΡ��ھ������ڣ���Ʊ�־ȷ��Ψһһ�ڱ���    
	 */
	public String checkFSRecord() throws JBOException{
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
		BizObjectQuery q = bom.createQuery("CustomerID=:CustomerID and ReportDate=:ReportDate and ReportScope=:ReportScope and ReportPeriod=:ReportPeriod and AuditFlag=:AuditFlag");
		q.setParameter("CustomerID", customerID);
		q.setParameter("ReportDate", reportDate);
		q.setParameter("ReportScope", reportScope);
		q.setParameter("ReportPeriod", reportPeriod);
		q.setParameter("AuditFlag", auditFlag);
		
		return q.getResultList().size()>0?"EXIST":"NOTEXIST";
	}
	
	/**
	 * ���²��񱨱�״̬��־λ
	 * ��ԭ�����෽��!CustomerManage.UpdateFSStatus�޸Ķ���
	 * @return
	 * @throws Exception
	 */
	public String updateFSStatus(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
		tx.join(bom);
		BizObjectQuery q = bom.createQuery("update o set ReportStatus=:ReportStatus where CustomerID=:CustomerID and RecordNo=:RecordNo");

		q.setParameter("CustomerID", customerID);
		q.setParameter("RecordNo", recordNo);
		q.setParameter("ReportStatus", reportStatus);
		
		ARE.getLog().debug(customerID);
		ARE.getLog().debug(recordNo);
		ARE.getLog().debug(reportStatus);

		q.executeUpdate();
		
		return "SUCCESS";
	}
	
	/**
	 * ��鱨��״̬
	 * @return ReportStatus  1-������ 01-������02-��ɣ�03-�޸�
	 * @throws Exception
	 */
	public String checkFSLocked() throws Exception{
		String sReportStatus = "";
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
		BizObjectQuery q = bom.createQuery("CustomerID=:CustomerID and RecordNo=:RecordNo ");
		q.setParameter("CustomerID", customerID);
		q.setParameter("RecordNo", recordNo);

		BizObject bo = q.getSingleResult();
		if(bo != null){
			sReportStatus = bo.getAttribute("ReportStatus").getString();
		}
		return sReportStatus;
	}
	
	/**
	 * ���ݱ����ţ���ʼ������������
	 */
	public void setReportInfo() throws Exception{
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
		BizObjectQuery q = bom.createQuery("RecordNo=:RecordNo");
		q.setParameter("RecordNo", recordNo);
		
		BizObject bo = q.getSingleResult();
		if(bo!=null){
			this.setCustomerID(bo.getAttribute("CustomerID").getString());
			this.setReportDate(bo.getAttribute("ReportDate").getString());
			this.setReportScope(bo.getAttribute("ReportScope").getString());
			this.setReportPeriod(bo.getAttribute("ReportPeriod").getString());
			this.setAuditFlag(bo.getAttribute("AuditFlag").getString());
			this.setFinanceBelong(bo.getAttribute("FinanceBelong").getString());
		}
		else{
			throw new Exception("�Ҳ�����Ӧ����");
		}
	}

	/**
	 * ��ȡȥ���걨����Ƶ�λ
	 */
	public String getAuditOffice() throws Exception{
		String sReturn = "";
		String thisyear = StringFunction.getToday().substring(0, 4);
		String lastyear = String.valueOf(Integer.parseInt(thisyear)-1);
		lastyear = lastyear+"/12";
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
		BizObjectQuery q = bom.createQuery("SELECT AUDITOFFICE from o where CustomerID=:CustomerID and ReportDate=:ReportDate and AUDITFLAG = '1'");
		q.setParameter("CustomerID", customerID);
		q.setParameter("ReportDate", lastyear);
		BizObject bo = q.getSingleResult();
		if(bo!=null){
			sReturn = bo.getAttribute("AUDITOFFICE").getString();
		}
		else{
			sReturn = "";
		}
		return sReturn;
	}
}
