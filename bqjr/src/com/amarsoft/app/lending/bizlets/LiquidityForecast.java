
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * Author: --qfang 2011-06-03
 * Tester: 
 * Describe: --��ȡ����ָ��ֵ
 * Input Param:
		ObjectType: ��������(���롢��������ͬ)
		ObjectNo: ���롢��������ͬ��ˮ��
		SubjectNo�����񱨱��Ŀ���
		SubjectValueType:1:���ֵ,2:��ĩֵ
		AccountMonth������·�
		ReportScope������ھ�
   Output Param:
		dItemValue����Ŀֵ
 * HistoryLog: 
*/
public class LiquidityForecast extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//��ö�������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//��ö�����
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��ȡ���񱨱���
		String sSubjectNo = (String)this.getAttribute("SubjectNo");
		//��ȡ��Ŀֵ����
		String sSubjectValueType = (String)this.getAttribute("SubjectValueType");
		//��ȡ����·�
		String sAccountMonth = (String)this.getAttribute("AccountMonth");
		//��ȡ����ھ�
		String sReportScope = (String)this.getAttribute("ReportScope");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSubjectNo == null) sSubjectNo = "";
		if(sSubjectValueType == null) sSubjectValueType = "";
		if(sAccountMonth == null) sAccountMonth = "";
		if(sReportScope == null) sReportScope = "";
		
		//���������SQL���
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs = null;
		//��Ŀֵ
		double dItemValue = 0.0;
		
		//ȡ��Ŀֵ
		if(sSubjectValueType.equals("1")){//���ֵ
			sSql=" SELECT nvl(Col1Value,0) as ItemValue FROM REPORT_DATA where ReportNo in "+
			     "(select ReportNo from REPORT_RECORD where ObjectNo =:sObjectNo and ReportDate=:sAccountMonth and ReportScope = :sReportScope)"+
			     " and  RowSubject = :sSubjectNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo).setParameter("sAccountMonth", sAccountMonth)
					.setParameter("sReportScope", sReportScope).setParameter("sSubjectNo", sSubjectNo));
		}else{//��ĩ����ֵ
			sSql=" SELECT nvl(Col2Value,0) as ItemValue FROM REPORT_DATA where ReportNo in "+
			"(select ReportNo from REPORT_RECORD where ObjectNo =:sObjectNo and ReportDate=:sAccountMonth and ReportScope = :sReportScope)"+
			" and  RowSubject =:sSubjectNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo).setParameter("sAccountMonth", sAccountMonth)
					.setParameter("sReportScope", sReportScope).setParameter("sSubjectNo", sSubjectNo));
		}
		if(rs.next())
		{			
			dItemValue = rs.getDouble("ItemValue");
		}
		rs.getStatement().close();
		
		if(dItemValue==0){
			if("1".equals(sSubjectValueType)){
				ARE.getLog().debug("�ͻ�:"+sObjectNo+"���񱨱��쳣,��Ŀ"+sSubjectNo+"���ֵΪ0!");
			}else{
				ARE.getLog().debug("�ͻ�:"+sObjectNo+"���񱨱��쳣,��Ŀ"+sSubjectNo+"��ĩֵΪ0!");
			}
		}
		return dItemValue+"";
	}
	
}
