package com.amarsoft.app.als.rating.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 获取评级申请相关信息
 * @author  zszhang
 */
public class GetRatingApplyInfo {
	private String ratingAppID;

	private String customerType;
	private String customerID;
	private String CustomerName;
	private String reportDate;
	private String reportScope;
	private String reportPeriod;
	private String auditFlag;
	private String modelID;
	private String modelName;
	private String recordID;
	private String grade;
	private String score;
	private String att01;
	private String att02;
	private String att03;
	private String att04;
	
    /**
     * 获取模型评定申请记录信息
     * @param  ratingAppID 评级申请流水号
     * @return 获取到数据返回<code>true</code>,其他情况返回<code>false</code>
     * @throws JBOException
     */
	public boolean getApplyInfo() throws JBOException {
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		bq = bm.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID", ratingAppID);
		bo = bq.getSingleResult();
		if (bo != null) {
			this.customerType = bo.getAttribute("CUSTOMERTYPE").toString();
			this.customerID = bo.getAttribute("CUSTOMERID").toString();
			this.reportDate = bo.getAttribute("REPORTDATE").toString();
			this.reportScope = bo.getAttribute("REPORTSCOPE").toString();
			this.reportPeriod = bo.getAttribute("REPORTPERIOD").toString();
			this.auditFlag = bo.getAttribute("AUDITFLAG").toString();
			this.modelID = bo.getAttribute("REFMODELID").toString();
			this.recordID = bo.getAttribute("RATINGMODRECORDID").toString();
			this.score = bo.getAttribute("RATINGSCORE01").toString();
			this.grade = bo.getAttribute("RatingGrade01").toString();
			this.att01 = bo.getAttribute("att01").getString();
			this.att02 = bo.getAttribute("att02").getString();
			this.att03 = bo.getAttribute("att03").getString();
			this.att04 = bo.getAttribute("att04").getString();
			this.modelID = bo.getAttribute("RefModelID").getString();
			bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
			bq = bm.createQuery("select CustomerName from O where CustomerID=:CustomerID");
			bq.setParameter("CustomerID", customerID);
			bo = bq.getSingleResult();
			this.CustomerName = bo.getAttribute("CustomerName").toString();

			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL");
			bq = bm.createQuery("ModelID=:ModelID");
			bq.setParameter("ModelID", modelID);
			bo = bq.getSingleResult();
			this.modelName = bo.getAttribute("ModelName").toString();
			return true;
		}
		return false;
	}
	
    /**
     * 获取最终的评级结果
     * @param  ratingAppID 评级申请流水号
     * @return 评级等级<p>Examples:AAA
     * @throws JBOException
     */
	public String getFinalResult() throws JBOException {
		BizObjectManager bm = null;
		BizObject bo = null;
		BizObjectQuery query = null;

		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		query = bm.createQuery("RatingAppID=:serialNo");
		query.setParameter("serialNo", ratingAppID);
		bo = query.getSingleResult();
		if (bo != null) {
			this.grade = bo.getAttribute("ratingGrade01").toString();
		}
		return this.grade;
	}

	public String getRatingAppID() {
		return ratingAppID;
	}

	public void setRatingAppID(String ratingAppID) {
		this.ratingAppID = ratingAppID;
	}

	public String getGrade() {
		return grade;
	}

	public String getCustomerType() {
		return customerType;
	}

	public String getCustomerID() {
		return customerID;
	}

	public String getReportDate() {
		return reportDate;
	}

	public String getReportScope() {
		return reportScope;
	}

	public String getReportPeriod() {
		return reportPeriod;
	}

	public String getAuditFlag() {
		return auditFlag;
	}

	public String getCustomerName() {
		return CustomerName;
	}

	public String getModelName() {
		return modelName;
	}

	public String getRecordID() {
		return recordID;
	}

	public String getScore() {
		return score;
	}

	public String getAtt01() {
		return att01;
	}

	public String getAtt02() {
		return att02;
	}

	public String getAtt03() {
		return att03;
	}

	public String getAtt04() {
		return att04;
	}

	public String getModelID() {
		return modelID;
	}
	
}
