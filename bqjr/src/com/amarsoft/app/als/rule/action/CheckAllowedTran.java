package com.amarsoft.app.als.rule.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * �жϸÿͻ��Ƿ����㹻�ĲƱ��������������������ҵ����
 * ����������������걨.����ҵ�������ơ�
 * @author yzhan
 */
public class CheckAllowedTran {
	private String ratingAppID;
	
	public String  checkAllowedTran()throws JBOException{
		String sReturn ="";
		String customerID = "";
		String modelID = "";
		String reportDate="",reportPeriod="",reportScope="";
		
		//��ѯ���������Ϣ
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObjectQuery bq  = bm.createQuery("ratingAppID=:RatingAppID");
		BizObject bo = bq.setParameter("RatingAppID",ratingAppID).getSingleResult();
		customerID = bo.getAttribute("customerID").getString();
		modelID = bo.getAttribute("REFMODELID").getString();
		reportDate = bo.getAttribute("reportDate").getString();
		reportScope = bo.getAttribute("reportScope").getString();
		reportPeriod = bo.getAttribute("reportPeriod").getString();
		//�жϸ�����ʹ�õ�ģ���Ƿ�����Ҫ���ڱ����ģ�͡�
		BizObjectManager bm2 = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		BizObjectQuery bq2 = bm2.createQuery("codeNo='NeedTwoRecordModel' and ItemNo=:ItemNo");
		BizObject bo2 = bq2.setParameter("ItemNo",modelID).getSingleResult();
		if(bo2 != null){//����ģ����Ҫ���ڱ���
			reportDate = (Integer.parseInt(reportDate.substring(0,4))-1)+"/12";
			BizObjectManager bm1 = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
			BizObjectQuery bq1 = bm1.createQuery(" customerID=:customerID and  " +
											 		" reportDate=:reportDate and "+
											 		" reportScope=:reportScope and " +
											 		" reportPeriod=:reportPeriod and" +
											 		" reportStatus in ('02','1')");
			bq1.setParameter("customerID",customerID).setParameter("reportDate",reportDate)
						.setParameter("reportPeriod",reportPeriod).setParameter("reportScope",reportScope);
			if(bq1.getSingleResult() == null)
				sReturn = "No";
			else
				sReturn ="Yes";
		}
		else{
			sReturn = "Yes";
		}
		return sReturn ;
	}

	public String getRatingAppID() {
		return ratingAppID;
	}

	public void setRatingAppID(String ratingAppID) {
		this.ratingAppID = ratingAppID;
	}
	
	
}
