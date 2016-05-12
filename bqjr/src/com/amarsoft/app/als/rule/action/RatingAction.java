package com.amarsoft.app.als.rule.action;

import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.core.json.JSONObject;

/*************************************************************
 * author:ALS
 * changed: DXS 20111006 方便以该类为父类继承
 * 
 *************************************************************/
public class RatingAction {

	protected String modelID;  	 // 模型编号
	protected String serialNo; 	 // 流水号
	protected String recordID;     // 模型记录编号
	protected String ruleType; 	 // 规则类型
	protected String ruleID; 		 // 规则编号
	protected String customerType; //	客户类型
	protected String testFlag;     // 试算标志
	protected String doTranStage; //测算阶段
	protected String ratingAppID ;

	public RatingAction(String serialNo,String recordID,String modelID,String ruleType,String customerType,String testFlag){
		this.modelID = modelID;
		this.serialNo = serialNo;
		this.recordID = recordID;
		this.ruleType = ruleType;
		this.customerType = customerType;
		this.testFlag = testFlag;
	}
	
	public RatingAction(){  }
	
	
	public String rating(JBOTransaction tx) throws Exception {
		JSONObject jResult = new JSONObject();
		Log logger = ARE.getLog();

		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String score = null;
		String grade = null;
		String Result = null;
		
		RuleOpAction roa = new RuleOpAction("rating_service");
		try {
			Result = roa.getResult(serialNo,recordID,modelID,ruleType,"",doTranStage);
			jResult = new JSONObject(Result);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("调用规则引擎失败！");
		}

		String sStatus = RuleOpProvider.getNodeValue(jResult,"RESULTS.STATUS", "");

		// 判断如果返回结果成功，更新调用记录
		if ("1".equals(sStatus)) {
			score = RuleOpProvider.getNodeValue(jResult,"RETURNS.结果.得分", "");
			grade = RuleOpProvider.getNodeValue(jResult,"RETURNS.结果.评级", "");
			score = DataConvert.toMoney(score);
			if(score.startsWith("-"))score="0";
			
			if(!"1".equals(testFlag)){
					String att1 = "",att2="";
					if("1".equals(doTranStage)){
						att1 = " att01";
						att2 = " att02";
					}
					if("2".equals(doTranStage)){
						att1=" att03";
						att2=" att04";
					}
					m = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
					tx.join(m);
					q = m.createQuery("update O set "+att1+"=:Score, "+att2+"=:Grade where RatingAppID =:SerialNo");
					q.setParameter("SerialNo", serialNo);
					q.setParameter("Score", score);
					q.setParameter("Grade", grade);
					q.executeUpdate();
			}else{
				m = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
				q = m.createQuery("RULEMODRECORDID =:RecordID");
				q.setParameter("RecordID",recordID);
				bo = q.getSingleResult(false);
				if(bo!=null){
					tx.join(m);
					m.deleteObject(bo);
				}
			}
		}else{
			if("1".equals(testFlag)){
				m = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
				q = m.createQuery("RULEMODRECORDID =:RecordID");
				q.setParameter("RecordID",recordID);
				bo = q.getSingleResult(false);
				if(bo!=null){
					tx.join(m);
					m.deleteObject(bo);
				}
			}
		}
		return "success"+"@"+score+"@"+grade;
	}
	
	/**
	 * 判断阶段测算是否完成。
	 * @return 完成:Yes ,未完成：No
	 */
	
	public String checkCompleteStage()throws JBOException{
		String completeStage = "";
		String att1 = "",att2="";
		if("1".equals(doTranStage)){
			att1 = "att01";
			att2 = "att02";
		}
		if("2".equals(doTranStage)){
			att1="att03";
			att2="att04";
		}
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObjectQuery bq = bm.createQuery("RatingAppID=:RatingAppID");
		BizObject bo = bq.setParameter("RatingAppID",ratingAppID).getSingleResult(false);
		if(bo == null)completeStage="No";
		else{
			if(!StringX.isEmpty(bo.getAttribute(att1).getString()) && !StringX.isEmpty(bo.getAttribute(att2).getString()))
				completeStage = "Yes";
			else 
				completeStage = "No";
		}
		//System.out.println(completeStage);
		return completeStage;
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
	
	public String getRecordID() {
		return recordID;
	}

	public void setRecordID(String recordID) {
		this.recordID = recordID;
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

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	public String getTestFlag() {
		return testFlag;
	}

	public void setTestFlag(String testFlag) {
		this.testFlag = testFlag;
	}

	public String getDoTranStage() {
		return doTranStage;
	}

	public void setDoTranStage(String doTranStage) {
		this.doTranStage = doTranStage;
	}

	public String getRatingAppID() {
		return ratingAppID;
	}

	public void setRatingAppID(String ratingAppID) {
		this.ratingAppID = ratingAppID;
	}
	
	
	
}