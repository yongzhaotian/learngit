package com.amarsoft.app.als.rule.impl;

import com.amarsoft.app.als.rule.action.GetCorrelativeValue;
import com.amarsoft.app.als.rule.action.UpdateRuleRecord;
import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.core.json.JSONObject;

public class RatingService extends RuleDefaultService {
	
	/**
	 * ��ȡģ����������
	 * @param serialNo ��ˮ��
	 * @param recordID ģ�ͼ�¼���
	 * @param modelID ģ�ͱ��
	 * @param object �������
	 * @return ��������
	 */
	@Override
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object,String doTranStage) {
		JSONObject jObject = null;
		String ruleID = null;
		String calcResult = null;
		String ruleObject = null;
		String score = null;
		String adjustScore = null;
		double finalScore = 0 ;
		
		if ("RuleFlow".endsWith(ruleType)||"Rule".endsWith(ruleType)) {
			try {
				bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
				bq = bm.createQuery("RULEMODRECORDID=:RecordID");
				bq.setParameter("RecordID", recordID);
				bo = bq.getSingleResult(false);
				if (bo != null) {
					if("1".equals(doTranStage))
						object = bo.getAttribute("BOMTEXTIN").getString();
					else
						object = bo.getAttribute("BOMTEXTIN02").getString();
				}
				
				//��ģ�ͼ�¼����ƴװ
				jObject = RuleOpProvider.combineBomItem(modelID, object);
				GetCorrelativeValue gcv = new GetCorrelativeValue();
				gcv.setModelID(modelID);
				gcv.setSerialNo(serialNo);
				String params = gcv.getValue();
				String[] param = null;
				if(params!=null&&!"".equals(params)){
					param = params.split(";");
					for(int i=0;i<param.length;i++){
						String itemName = param[i].split("=")[0];
						String itemValue = param[i].split("=")[1];
						jObject = RuleOpProvider.setNodeValue(jObject,itemName,itemValue);
					}
				}

				//����ƴװ���BOM
				object = RuleOpProvider.combineBomInfo(modelID, String.valueOf(jObject));

				//��ȡ���ù�����
				ruleID = RuleOpProvider.getRuleID(modelID, "RatingRule",doTranStage);
			} catch (JBOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			ARE.getLog().info("modelID:"+modelID);
			ARE.getLog().info("ruleType:"+ruleType);
			ARE.getLog().info("ruleID:"+ruleID);
			ARE.getLog().info("*********�������*********");
			ARE.getLog().info(object);
			calcResult = RuleConnectionService.callRule(modelID, ruleType, ruleID, object, "");
			ARE.getLog().info("*********������*********");
			ARE.getLog().info(calcResult);
			UpdateRuleRecord urr= new UpdateRuleRecord();
			try {
				urr.update(recordID, ruleType, ruleID, object, calcResult,doTranStage);
			} catch (JBOException e) {
				ARE.getLog().error("���¹����¼ʧ��",e);
			}
		} 
		if("DecisionTable".endsWith(ruleType)){
			try {
				bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
				bq = bm.createQuery("CODENO =:CODENO and ITEMNO=:ITEMNO");
				bq.setParameter("CODENO", "RatingRule");
				bq.setParameter("ITEMNO", modelID);
				bo = bq.getSingleResult(false);
				if (bo != null) {
					ruleID = bo.getAttribute("Attribute1").toString();
					ruleObject = bo.getAttribute("Attribute2").toString();
				}
				
				bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
				bq = bm.createQuery("RatingAppID = :SerialNo");
				bq.setParameter("SerialNo", serialNo);
				bo = bq.getSingleResult(false);
				if (bo != null) {
					score = bo.getAttribute("att01").toString();
					adjustScore = bo.getAttribute("att03").toString();
				}
				
				finalScore = DataConvert.toDouble(score)+DataConvert.toDouble(adjustScore);
				jObject = RuleOpProvider.setNodeValue(jObject,ruleObject,String.valueOf(finalScore));
			} catch (JBOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
			object = String.valueOf(jObject);
			ARE.getLog().info("*********�������*********");
			ARE.getLog().info(object);
			calcResult = RuleConnectionService.callRule(modelID, ruleType, ruleID, object, "");
			ARE.getLog().info("*********������*********");
			ARE.getLog().info(calcResult);
			UpdateRuleRecord urr= new UpdateRuleRecord();
			try {
				urr.update(recordID, ruleType, ruleID, object, calcResult,doTranStage);
			} catch (JBOException e) {
				ARE.getLog().error("���¹����¼ʧ��",e);
			}
		}
		return calcResult;
	}
}
