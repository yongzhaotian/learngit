package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ���޸Ŀͻ���Ϣ�в�����Ϣ�ı���ھ�ʱ��ͬʱ����REPORT_RECORD
 *@author jfeng 2011-05-30
 *
 */

public class SaveFinanceReport extends Bizlet{
	
	/**
	 * @param CustomerID �ͻ����
	 * @param RecordNo ��¼���
	 * @param ReportScope ����ھ�
	 * @param ReportDate ��������
	 */
	
	public Object run(Transaction Sqlca) throws Exception{
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sRecordNo = (String)this.getAttribute("RecordNo");
		String sReportScope = (String)this.getAttribute("ReportScope");
		String sReportDate = (String)this.getAttribute("ReportDate");
		
		//�������
		String sSql = "";
		ASResultSet rs = null;

		//����REPORT_RECORD 
		sSql =  " update REPORT_RECORD set ReportScope =:ReportScope " +
		" where ReportDate =:ReportDate and ObjectNo =:ObjectNo ";
		SqlObject so = new SqlObject(sSql).setParameter("ReportScope", sReportScope).setParameter("ReportDate", sReportDate).setParameter("ObjectNo", sCustomerID);
		Sqlca.executeSQL(so);
		return "success";
	}

}
