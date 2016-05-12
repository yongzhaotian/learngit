package com.amarsoft.app.als.rule.action;

import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.core.json.JSONObject;

public class ClassifyAction {

	String modelID;  	 // 模型编号
	String serialNo; 	 // 流水号
	String recordID;     // 模型记录编号
	String ruleType; 	 // 规则类型
	String ruleID; 		 // 规则编号
	String customerType; //	客户类型

	public String classify(JBOTransaction tx) throws Exception {
		JSONObject jResult = new JSONObject();
		Log logger = ARE.getLog();

		BizObjectManager m = null;
		BizObjectQuery q = null;
		String grade = null;
		
		RuleOpAction roa = new RuleOpAction("classify_service");
		try {
			String Result = roa.getResult(serialNo,recordID,modelID,ruleType,"");
			jResult = new JSONObject(Result);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("调用规则引擎失败！");
		}

		String sStatus = RuleOpProvider.getNodeValue(jResult,"RESULTS.STATUS", "");

		// 判断如果返回结果成功，更新调用记录
		if ("1".equals(sStatus)) {
			grade = RuleOpProvider.getNodeValue(jResult,"RETURNS.加权调整后分类级别G01", "");
		
			m = JBOFactory.getFactory().getManager("jbo.app.CLASSIFY_APPLY");
			tx.join(m);
			q = m.createQuery("update O set ATT01 =:Grade where ClassifyAppID =:SerialNo");
			q.setParameter("SerialNo", serialNo);
			q.setParameter("Grade", grade);
			q.executeUpdate();
		}
		return "success"+"@"+grade;
	}
	
	public String classifyUnit(JBOTransaction tx) throws Exception {
		JSONObject jResult = new JSONObject();
		Log logger = ARE.getLog();

		BizObjectManager m = null;
		BizObjectQuery q = null;
		String grade = null;
		
		RuleOpAction roa = new RuleOpAction("classify_service");
		try {
			String Result = roa.getResult(serialNo,recordID,modelID,ruleType,"");
			jResult = new JSONObject(Result);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("调用规则引擎失败！");
		}

		String sStatus = RuleOpProvider.getNodeValue(jResult,"RESULTS.STATUS", "");

		// 判断如果返回结果成功，更新调用记录
		if ("1".equals(sStatus)) {
			grade = RuleOpProvider.getNodeValue(jResult,"RETURNS.加权调整后分类级别G01", "");
		
			m = JBOFactory.getFactory().getManager("jbo.app.CLASSIFY_APPLY_SET");
			tx.join(m);
			q = m.createQuery("update O set ATT01 =:Grade where ClassifyAppID =:SerialNo");
			q.setParameter("SerialNo", serialNo);
			q.setParameter("Grade", grade);
			q.executeUpdate();
		}
		return "success"+"@"+grade;
	}
	
	public String classifyTemp(JBOTransaction tx) throws Exception {
		//分类初分的临时方法，默认认定完成
		BizObjectManager m = null;
		BizObjectQuery q = null;
		String grade = "96";
		
		m = JBOFactory.getFactory().getManager("jbo.app.CLASSIFY_APPLY_SET");
		tx.join(m);
		q = m.createQuery("update O set ATT01 =:Grade,CLASSIFYSCORE01=:CLASSIFYSCORE01,CLASSIFYGRADE01=:CLASSIFYGRADE01,Status='1' where ClassifyAppID =:SerialNo");
		q.setParameter("SerialNo", serialNo);
		q.setParameter("Grade", grade);
		q.setParameter("CLASSIFYSCORE01", 96);
		q.setParameter("CLASSIFYGRADE01", "正常二级");
		q.executeUpdate();
		return "success"+"@"+grade;
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
}