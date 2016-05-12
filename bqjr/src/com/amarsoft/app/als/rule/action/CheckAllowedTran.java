package com.amarsoft.app.als.rule.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 判断该客户是否有足够的财报用于评级，如果是老企业至少
 * 有连续最近的两期年报.新企业不做控制。
 * @author yzhan
 */
public class CheckAllowedTran {
	private String ratingAppID;
	
	public String  checkAllowedTran()throws JBOException{
		String sReturn ="";
		String customerID = "";
		String modelID = "";
		String reportDate="",reportPeriod="",reportScope="";
		
		//查询该申请的信息
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObjectQuery bq  = bm.createQuery("ratingAppID=:RatingAppID");
		BizObject bo = bq.setParameter("RatingAppID",ratingAppID).getSingleResult();
		customerID = bo.getAttribute("customerID").getString();
		modelID = bo.getAttribute("REFMODELID").getString();
		reportDate = bo.getAttribute("reportDate").getString();
		reportScope = bo.getAttribute("reportScope").getString();
		reportPeriod = bo.getAttribute("reportPeriod").getString();
		//判断该申请使用的模型是否在需要两期报表的模型。
		BizObjectManager bm2 = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		BizObjectQuery bq2 = bm2.createQuery("codeNo='NeedTwoRecordModel' and ItemNo=:ItemNo");
		BizObject bo2 = bq2.setParameter("ItemNo",modelID).getSingleResult();
		if(bo2 != null){//该种模型需要两期报表。
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
