
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * Author: --qfang 2011-06-03
 * Tester: 
 * Describe: --获取财务指标值
 * Input Param:
		ObjectType: 对象类型(申请、审批、合同)
		ObjectNo: 申请、批复、合同流水号
		SubjectNo：财务报表科目编号
		SubjectValueType:1:年初值,2:期末值
		AccountMonth：会计月份
		ReportScope：报表口径
   Output Param:
		dItemValue：科目值
 * HistoryLog: 
*/
public class LiquidityForecast extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//获得对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//获得对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获取财务报表编号
		String sSubjectNo = (String)this.getAttribute("SubjectNo");
		//获取科目值类型
		String sSubjectValueType = (String)this.getAttribute("SubjectValueType");
		//获取会计月份
		String sAccountMonth = (String)this.getAttribute("AccountMonth");
		//获取报表口径
		String sReportScope = (String)this.getAttribute("ReportScope");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSubjectNo == null) sSubjectNo = "";
		if(sSubjectValueType == null) sSubjectValueType = "";
		if(sAccountMonth == null) sAccountMonth = "";
		if(sReportScope == null) sReportScope = "";
		
		//定义变量：SQL语句
		String sSql = "";
		//定义变量：查询结果集
		ASResultSet rs = null;
		//科目值
		double dItemValue = 0.0;
		
		//取科目值
		if(sSubjectValueType.equals("1")){//年初值
			sSql=" SELECT nvl(Col1Value,0) as ItemValue FROM REPORT_DATA where ReportNo in "+
			     "(select ReportNo from REPORT_RECORD where ObjectNo =:sObjectNo and ReportDate=:sAccountMonth and ReportScope = :sReportScope)"+
			     " and  RowSubject = :sSubjectNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo).setParameter("sAccountMonth", sAccountMonth)
					.setParameter("sReportScope", sReportScope).setParameter("sSubjectNo", sSubjectNo));
		}else{//期末调整值
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
				ARE.getLog().debug("客户:"+sObjectNo+"财务报表异常,科目"+sSubjectNo+"年初值为0!");
			}else{
				ARE.getLog().debug("客户:"+sObjectNo+"财务报表异常,科目"+sSubjectNo+"期末值为0!");
			}
		}
		return dItemValue+"";
	}
	
}
