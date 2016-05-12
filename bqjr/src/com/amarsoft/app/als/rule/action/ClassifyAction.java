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

	String modelID;  	 // ģ�ͱ��
	String serialNo; 	 // ��ˮ��
	String recordID;     // ģ�ͼ�¼���
	String ruleType; 	 // ��������
	String ruleID; 		 // ������
	String customerType; //	�ͻ�����

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
			logger.error("���ù�������ʧ�ܣ�");
		}

		String sStatus = RuleOpProvider.getNodeValue(jResult,"RESULTS.STATUS", "");

		// �ж�������ؽ���ɹ������µ��ü�¼
		if ("1".equals(sStatus)) {
			grade = RuleOpProvider.getNodeValue(jResult,"RETURNS.��Ȩ��������༶��G01", "");
		
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
			logger.error("���ù�������ʧ�ܣ�");
		}

		String sStatus = RuleOpProvider.getNodeValue(jResult,"RESULTS.STATUS", "");

		// �ж�������ؽ���ɹ������µ��ü�¼
		if ("1".equals(sStatus)) {
			grade = RuleOpProvider.getNodeValue(jResult,"RETURNS.��Ȩ��������༶��G01", "");
		
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
		//������ֵ���ʱ������Ĭ���϶����
		BizObjectManager m = null;
		BizObjectQuery q = null;
		String grade = "96";
		
		m = JBOFactory.getFactory().getManager("jbo.app.CLASSIFY_APPLY_SET");
		tx.join(m);
		q = m.createQuery("update O set ATT01 =:Grade,CLASSIFYSCORE01=:CLASSIFYSCORE01,CLASSIFYGRADE01=:CLASSIFYGRADE01,Status='1' where ClassifyAppID =:SerialNo");
		q.setParameter("SerialNo", serialNo);
		q.setParameter("Grade", grade);
		q.setParameter("CLASSIFYSCORE01", 96);
		q.setParameter("CLASSIFYGRADE01", "��������");
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