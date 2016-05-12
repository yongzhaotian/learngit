package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.finance.Report;

public class InitFinanceReport extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sReportDate = (String)this.getAttribute("ReportDate");
		String sReportScope = (String)this.getAttribute("ReportScope");
		String sRecordNo = (String)this.getAttribute("RecordNo");
		String sWhere = (String)this.getAttribute("Where");
		String sNewReportDate = (String)this.getAttribute("NewReportDate");
		String sActionType = (String)this.getAttribute("ActionType");
		String sOrgID = (String)this.getAttribute("OrgID");
		String sUserID = (String)this.getAttribute("UserID");				
		
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null)	sObjectType = "";
		if(sReportDate == null)	sReportDate = "";
		if(sReportScope == null) sReportScope = "";
		if(sRecordNo == null) sRecordNo = "";
		if(sWhere == null)	sWhere = "";
		if(sNewReportDate == null)	sNewReportDate = "";
		if(sActionType==null)	sActionType = "";	
		sWhere = StringFunction.replace(sWhere,"^","=");
		SqlObject so ;//��������
		String sSql = "";
		if(sActionType.equals("AddNew"))
		{
			// ����ָ��MODEL_CATALOG��where��������һ���±���		
			Report.newReports(sObjectType,sObjectNo,sReportScope,sWhere,sReportDate,sOrgID,sUserID,Sqlca);
		}else if(sActionType.equals("Delete"))
		{
			//ɾ���ñ�����ص���ҵӦ��Ӧ���ʿ���Ϣ��ENT_FOA�ļ�¼
			sSql = " delete from ENT_FOA " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			//ɾ���ñ�����ص���ҵ�����Ϣ��ENT_INVENTORY�ļ�¼
			sSql = " delete from ENT_INVENTORY " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			// ɾ���ñ�����صĹ̶��ʲ���Ϣ��ENT_FIXEDASSETS�ļ�¼
			sSql = " delete from ENT_FIXEDASSETS " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			//ɾ���ñ�����ص������ʲ���Ϣ��CUSTOMER_IMASSET�ļ�¼
			sSql = " delete from CUSTOMER_IMASSET " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			//ɾ���ñ�����ص���˰��Ϣ��CUSTOMER_TAXPAYING�ļ�¼
			sSql = " delete from CUSTOMER_TAXPAYING " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			// ɾ��ָ��������������ڵ�һ������ 
			Report.deleteReports(sObjectType,sObjectNo,sReportScope,sReportDate,Sqlca);	
			sSql = " delete from CUSTOMER_FSRECORD "+
			" where CustomerID =:CustomerID "+
			" and ReportDate =:ReportDate "+
			" and ReportScope =:ReportScope ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("ReportDate", sReportDate).setParameter("ReportScope", sReportScope);
			Sqlca.executeSQL(so);
		}else if(sActionType.equals("ModifyReportDate"))
		{
			// ����ָ������Ļ���·� 
			sSql = 	" update CUSTOMER_FSRECORD "+
			" set ReportDate=:ReportDateNew "+
			" where CustomerID=:CustomerID "+
			" and ReportDate=:ReportDate "+
			" and ReportScope =:ReportScope ";
			so = new SqlObject(sSql);
			so.setParameter("ReportDateNew", sNewReportDate).setParameter("CustomerID", sObjectNo).setParameter("ReportDate", sReportDate).setParameter("ReportScope", sReportScope);
			Sqlca.executeSQL(so);
			// ����ָ������Ļ���·�
			sSql = " update REPORT_RECORD "+
			" set ReportDate=:ReportDateNew "+
			" where ObjectNo=:ObjectNo "+
			" and ReportDate=:ReportDate"+
			" and ReportScope =:ReportScope ";    	
			so.setParameter("ReportDateNew", sNewReportDate).setParameter("ObjectNo", sObjectNo).setParameter("ReportDate", sReportDate).setParameter("ReportScope", sReportScope);
			Sqlca.executeSQL(so);
		}
				
		return "ok";
	}		
}
