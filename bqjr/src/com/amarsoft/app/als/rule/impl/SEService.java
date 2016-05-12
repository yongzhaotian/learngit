package com.amarsoft.app.als.rule.impl;

import com.amarsoft.app.als.rule.action.UpdateRuleRecord;
import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.core.json.JSONObject;

public class SEService extends RuleDefaultService {
	
	/**
	 * 获取模型运算结果集
	 * @param serialNo 流水号
	 * @param recordID 模型记录编号
	 * @param modelID 模型编号
	 * @param object 规则对象
	 * @return 运算结果集
	 */
	@Override
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object) {
		JSONObject jObject = null;
		String ruleID = null;
		String calcResult = null;

		try {
			if ("".equals(object)) {
				// 获取模型记录
				bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
				bq = bm.createQuery("RULEMODRECORDID=:RecordID");
				bq.setParameter("RecordID", recordID);
				bo = bq.getSingleResult();
				if (bo != null) {
					object = bo.getAttribute("BOMTEXTIN").toString();
				}
				// 对模型记录进行拼装
				jObject = RuleOpProvider.combineBomItem(modelID, object);

				// 最终拼装完的BOM
				object = RuleOpProvider.combineBomInfo(modelID, String.valueOf(jObject));
			}
			//获取调用规则编号
			ruleID = RuleOpProvider.getRuleID(modelID, "RatingRule");
		} catch (JBOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		ARE.getLog().info("*********业务对象*********");
		ARE.getLog().info(object);

		calcResult = RuleConnectionService.callRule(modelID,ruleType,ruleID,object, "");

		ARE.getLog().info("*********测算结果*********");
		ARE.getLog().info(calcResult);
		UpdateRuleRecord urr= new UpdateRuleRecord();
		try {
			urr.update(recordID, ruleType, ruleID, object, calcResult);
		} catch (JBOException e) {
			ARE.getLog().error("更新规则记录失败",e);
		}
		return calcResult;

	}
}
