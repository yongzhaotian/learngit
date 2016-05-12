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
	 * 获取模型运算结果集
	 * @param serialNo 流水号
	 * @param recordID 模型记录编号
	 * @param modelID 模型编号
	 * @param object 规则对象
	 * @return 运算结果集
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
				
				//对模型记录进行拼装
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

				//最终拼装完的BOM
				object = RuleOpProvider.combineBomInfo(modelID, String.valueOf(jObject));

				//获取调用规则编号
				ruleID = RuleOpProvider.getRuleID(modelID, "RatingRule",doTranStage);
			} catch (JBOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			ARE.getLog().info("modelID:"+modelID);
			ARE.getLog().info("ruleType:"+ruleType);
			ARE.getLog().info("ruleID:"+ruleID);
			ARE.getLog().info("*********输出对象*********");
			ARE.getLog().info(object);
			calcResult = RuleConnectionService.callRule(modelID, ruleType, ruleID, object, "");
			ARE.getLog().info("*********测算结果*********");
			ARE.getLog().info(calcResult);
			UpdateRuleRecord urr= new UpdateRuleRecord();
			try {
				urr.update(recordID, ruleType, ruleID, object, calcResult,doTranStage);
			} catch (JBOException e) {
				ARE.getLog().error("更新规则记录失败",e);
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
			ARE.getLog().info("*********输出对象*********");
			ARE.getLog().info(object);
			calcResult = RuleConnectionService.callRule(modelID, ruleType, ruleID, object, "");
			ARE.getLog().info("*********测算结果*********");
			ARE.getLog().info(calcResult);
			UpdateRuleRecord urr= new UpdateRuleRecord();
			try {
				urr.update(recordID, ruleType, ruleID, object, calcResult,doTranStage);
			} catch (JBOException e) {
				ARE.getLog().error("更新规则记录失败",e);
			}
		}
		return calcResult;
	}
}
