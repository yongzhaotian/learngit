package com.amarsoft.app.als.rule.action;

import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.core.json.JSONObject;

public class AdjustAction {

	String modelID;     // 模型编号
	String serialNo;    // 流水号
	String ruleType;    // 规则类型
	String ruleID;      // 规则编号
	String adjustScore; // 调整分
	Double finalScore;  // 最终得分

	public String adjust(JBOTransaction tx) throws Exception {
		JSONObject jResult = new JSONObject();
		Log logger = ARE.getLog();

		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String score = null;
		String grade = null;
		String recordID = null;
		
		m = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		q = m.createQuery("RatingAppID =:SerialNo");
		q.setParameter("SerialNo",serialNo);
		bo = q.getSingleResult();
		if(bo!=null){
			score = bo.getAttribute("att01").toString();
			recordID = bo.getAttribute("RatingModRecordID").toString();
			if(bo.getAttribute("att01").isNull()) score="0"; 
		}
		
		m = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		tx.join(m);
		q = m.createQuery("update O set ATT03 =:Score where RatingAppID =:SerialNo");
		q.setParameter("SerialNo",serialNo);
		q.setParameter("Score",adjustScore);
		q.executeUpdate();
		finalScore = DataConvert.toDouble(score)+DataConvert.toDouble(adjustScore);
		
		RuleOpAction roa = new RuleOpAction("rating_service");
		try {
			String Result = roa.getResult(serialNo, recordID, modelID, "DecisionTable","","3");
			jResult = new JSONObject(Result);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("调用规则引擎失败！");
		}

		String sStatus = RuleOpProvider.getNodeValue(jResult,"RESULTS.STATUS", "");

		// 判断如果返回结果成功，更新调用记录
		if ("1".equals(sStatus)) {
			grade = RuleOpProvider.getNodeValue(jResult, "RESULTS.RETURNVALUE","");

			m = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
			tx.join(m);
			q = m.createQuery("update O set RatingScore01 =:Score,RatingGrade01=:Grade where RatingAppID =:SerialNo");
			q.setParameter("SerialNo",serialNo);
			q.setParameter("Score",finalScore.toString());
			q.setParameter("Grade",grade);
			q.executeUpdate();
		}
		
		return "success"+"@"+DataConvert.toMoney(finalScore)+"@"+grade;
	}

	public String getModelID() {
		return modelID;
	}

	public void setModelID(String modelID) {
		this.modelID = modelID;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getRuleType() {
		return ruleType;
	}

	public void setRuleType(String ruleType) {
		this.ruleType = ruleType;
	}

	public String getRuleID() {
		return ruleID;
	}

	public void setRuleID(String ruleID) {
		this.ruleID = ruleID;
	}

	public String getAdjustScore() {
		return adjustScore;
	}

	public void setAdjustScore(String adjustScore) {
		this.adjustScore = adjustScore;
	}
}