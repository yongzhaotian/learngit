package com.amarsoft.app.als.rating.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 用于更新只进行一步测算的评级结果。
 * @author yzhan
 *
 */
public class UpdateOnceResult {
	private String ratingAppID;
	public void  updateResult(JBOTransaction tx)throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("ratingAppID=:RatingAppID");
		BizObject bo = bq.setParameter("RatingAppID",ratingAppID).getSingleResult(true);
		if(bo != null){
			bo.setAttributeValue("RATINGSCORE01",bo.getAttribute("att01").getString());
			bo.setAttributeValue("RatingGrade01",bo.getAttribute("att02").getString());
			bm.saveObject(bo);
		}
	}
	
	public String getRatingAppID() {
		return ratingAppID;
	}
	public void setRatingAppID(String ratingAppID) {
		this.ratingAppID = ratingAppID;
	}
	
}
