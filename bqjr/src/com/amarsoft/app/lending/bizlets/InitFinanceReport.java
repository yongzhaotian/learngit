package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.finance.Report;

public class InitFinanceReport extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
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
		
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null)	sObjectType = "";
		if(sReportDate == null)	sReportDate = "";
		if(sReportScope == null) sReportScope = "";
		if(sRecordNo == null) sRecordNo = "";
		if(sWhere == null)	sWhere = "";
		if(sNewReportDate == null)	sNewReportDate = "";
		if(sActionType==null)	sActionType = "";	
		sWhere = StringFunction.replace(sWhere,"^","=");
		SqlObject so ;//声明对象
		String sSql = "";
		if(sActionType.equals("AddNew"))
		{
			// 根据指定MODEL_CATALOG的where条件增加一批新报表		
			Report.newReports(sObjectType,sObjectNo,sReportScope,sWhere,sReportDate,sOrgID,sUserID,Sqlca);
		}else if(sActionType.equals("Delete"))
		{
			//删除该报表相关的企业应收应付帐款信息表ENT_FOA的记录
			sSql = " delete from ENT_FOA " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			//删除该报表相关的企业存货信息表ENT_INVENTORY的记录
			sSql = " delete from ENT_INVENTORY " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			// 删除该报表相关的固定资产信息表ENT_FIXEDASSETS的记录
			sSql = " delete from ENT_FIXEDASSETS " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			//删除该报表相关的无形资产信息表CUSTOMER_IMASSET的记录
			sSql = " delete from CUSTOMER_IMASSET " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			//删除该报表相关的纳税信息表CUSTOMER_TAXPAYING的记录
			sSql = " delete from CUSTOMER_TAXPAYING " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("RecordNo", sRecordNo);
			Sqlca.executeSQL(so);
			// 删除指定关联对象和日期的一批报表 
			Report.deleteReports(sObjectType,sObjectNo,sReportScope,sReportDate,Sqlca);	
			sSql = " delete from CUSTOMER_FSRECORD "+
			" where CustomerID =:CustomerID "+
			" and ReportDate =:ReportDate "+
			" and ReportScope =:ReportScope ";
			so = new SqlObject(sSql).setParameter("CustomerID", sObjectNo).setParameter("ReportDate", sReportDate).setParameter("ReportScope", sReportScope);
			Sqlca.executeSQL(so);
		}else if(sActionType.equals("ModifyReportDate"))
		{
			// 更新指定报表的会计月份 
			sSql = 	" update CUSTOMER_FSRECORD "+
			" set ReportDate=:ReportDateNew "+
			" where CustomerID=:CustomerID "+
			" and ReportDate=:ReportDate "+
			" and ReportScope =:ReportScope ";
			so = new SqlObject(sSql);
			so.setParameter("ReportDateNew", sNewReportDate).setParameter("CustomerID", sObjectNo).setParameter("ReportDate", sReportDate).setParameter("ReportScope", sReportScope);
			Sqlca.executeSQL(so);
			// 更新指定报表的会计月份
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
