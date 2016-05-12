package com.amarsoft.app.als.rating.bizlets;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddFinanceType extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String customerID = (String) this.getAttribute("CustomerID");
		String reportCondition = "";//财报信息
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		String setupDate = "";//企业成立时间
		
		//获得该客户企业成立日期
		bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		bq = bm.createQuery("select Setupdate from O where CustomerID=:CustomerID");
		bo = bq.setParameter("CustomerID",customerID).getSingleResult();
		if(bo == null)reportCondition = "NOCUSTOMER";//客户不存在！
		else{
			setupDate = bo.getAttribute("SetupDate").getString();
			if("".equals(setupDate)||setupDate == null){
				reportCondition="NOSETUPDATE";
			}else{
				String today = StringFunction.getToday();
				String setupFlag = "";//企业是否是上年度一月份之前成立，是:Y 否 :N
				today = today.substring(0,4);
				String beforeDate = (Integer.parseInt(today)-1)+"/12";//用于取得去年的年报
				today = (Integer.parseInt(today)-1)+"/01/01";//当前日期前一年
				if(today.compareTo(setupDate)> 0)
					setupFlag="Y";//老企业
				else 
					setupFlag = "N";
				if("Y".equals(setupFlag) ){//是老企业，取去年年报。
					bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
					bq = bm.createQuery("CustomerID=:CustomerID and ReportDate=:ReportDate and ReportPeriod='04' and ReportStatus in('02','1') order by AuditFlag asc");
					bq.setParameter("CustomerID",customerID);
					bq.setParameter("ReportDate",beforeDate);
					bo = bq.getSingleResult();
					if(bo == null)
						reportCondition="NOREPORT";//没找到财报
					else{
						String reportScope = bo.getAttribute("ReportScope").getString();
						String auditFlag = bo.getAttribute("AuditFlag").getString();
						if(reportScope == null) reportScope="";
						if(auditFlag == null) auditFlag="";
						reportCondition =beforeDate+"@04@"+reportScope+"@"+auditFlag;
					}
					
				}else{//新建企业，取最新一期财报。
					bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
					bq = bm.createQuery("CustomerID=:CustomerID and ReportStatus in('02','1') order by ReportDate desc,AuditFlag desc");
					bq.setParameter("CustomerID",customerID);
					bo = bq.getSingleResult();
					if(bo == null)
						reportCondition="NOREPORT";//没找到财报
					else
						reportCondition=bo.getAttribute("ReportDate").getString()+"@"+bo.getAttribute("ReportPeriod").getString()+"@"+bo.getAttribute("ReportScope").getString()+"@"+bo.getAttribute("AuditFlag").getString();
				}
			}
		}
		return reportCondition;
	}

}
