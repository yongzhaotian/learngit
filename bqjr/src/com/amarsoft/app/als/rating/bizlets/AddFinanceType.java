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
		String reportCondition = "";//�Ʊ���Ϣ
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		String setupDate = "";//��ҵ����ʱ��
		
		//��øÿͻ���ҵ��������
		bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		bq = bm.createQuery("select Setupdate from O where CustomerID=:CustomerID");
		bo = bq.setParameter("CustomerID",customerID).getSingleResult();
		if(bo == null)reportCondition = "NOCUSTOMER";//�ͻ������ڣ�
		else{
			setupDate = bo.getAttribute("SetupDate").getString();
			if("".equals(setupDate)||setupDate == null){
				reportCondition="NOSETUPDATE";
			}else{
				String today = StringFunction.getToday();
				String setupFlag = "";//��ҵ�Ƿ��������һ�·�֮ǰ��������:Y �� :N
				today = today.substring(0,4);
				String beforeDate = (Integer.parseInt(today)-1)+"/12";//����ȡ��ȥ����걨
				today = (Integer.parseInt(today)-1)+"/01/01";//��ǰ����ǰһ��
				if(today.compareTo(setupDate)> 0)
					setupFlag="Y";//����ҵ
				else 
					setupFlag = "N";
				if("Y".equals(setupFlag) ){//������ҵ��ȡȥ���걨��
					bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
					bq = bm.createQuery("CustomerID=:CustomerID and ReportDate=:ReportDate and ReportPeriod='04' and ReportStatus in('02','1') order by AuditFlag asc");
					bq.setParameter("CustomerID",customerID);
					bq.setParameter("ReportDate",beforeDate);
					bo = bq.getSingleResult();
					if(bo == null)
						reportCondition="NOREPORT";//û�ҵ��Ʊ�
					else{
						String reportScope = bo.getAttribute("ReportScope").getString();
						String auditFlag = bo.getAttribute("AuditFlag").getString();
						if(reportScope == null) reportScope="";
						if(auditFlag == null) auditFlag="";
						reportCondition =beforeDate+"@04@"+reportScope+"@"+auditFlag;
					}
					
				}else{//�½���ҵ��ȡ����һ�ڲƱ���
					bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
					bq = bm.createQuery("CustomerID=:CustomerID and ReportStatus in('02','1') order by ReportDate desc,AuditFlag desc");
					bq.setParameter("CustomerID",customerID);
					bo = bq.getSingleResult();
					if(bo == null)
						reportCondition="NOREPORT";//û�ҵ��Ʊ�
					else
						reportCondition=bo.getAttribute("ReportDate").getString()+"@"+bo.getAttribute("ReportPeriod").getString()+"@"+bo.getAttribute("ReportScope").getString()+"@"+bo.getAttribute("AuditFlag").getString();
				}
			}
		}
		return reportCondition;
	}

}
