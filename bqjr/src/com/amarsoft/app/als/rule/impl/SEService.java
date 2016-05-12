package com.amarsoft.app.als.rule.impl;

import com.amarsoft.app.als.rule.action.UpdateRuleRecord;
import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.core.json.JSONObject;

public class SEService extends RuleDefaultService {
	
	/**
	 * ��ȡģ����������
	 * @param serialNo ��ˮ��
	 * @param recordID ģ�ͼ�¼���
	 * @param modelID ģ�ͱ��
	 * @param object �������
	 * @return ��������
	 */
	@Override
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object) {
		JSONObject jObject = null;
		String ruleID = null;
		String calcResult = null;

		try {
			if ("".equals(object)) {
				// ��ȡģ�ͼ�¼
				bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
				bq = bm.createQuery("RULEMODRECORDID=:RecordID");
				bq.setParameter("RecordID", recordID);
				bo = bq.getSingleResult();
				if (bo != null) {
					object = bo.getAttribute("BOMTEXTIN").toString();
				}
				// ��ģ�ͼ�¼����ƴװ
				jObject = RuleOpProvider.combineBomItem(modelID, object);

				// ����ƴװ���BOM
				object = RuleOpProvider.combineBomInfo(modelID, String.valueOf(jObject));
			}
			//��ȡ���ù�����
			ruleID = RuleOpProvider.getRuleID(modelID, "RatingRule");
		} catch (JBOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		ARE.getLog().info("*********ҵ�����*********");
		ARE.getLog().info(object);

		calcResult = RuleConnectionService.callRule(modelID,ruleType,ruleID,object, "");

		ARE.getLog().info("*********������*********");
		ARE.getLog().info(calcResult);
		UpdateRuleRecord urr= new UpdateRuleRecord();
		try {
			urr.update(recordID, ruleType, ruleID, object, calcResult);
		} catch (JBOException e) {
			ARE.getLog().error("���¹����¼ʧ��",e);
		}
		return calcResult;

	}
}
