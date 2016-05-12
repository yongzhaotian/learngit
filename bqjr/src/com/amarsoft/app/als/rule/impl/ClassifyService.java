package com.amarsoft.app.als.rule.impl;

import com.amarsoft.app.als.rule.action.GetCorrelativeValue;
import com.amarsoft.app.als.rule.action.UpdateRuleRecord;
import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.core.json.JSONObject;

public class ClassifyService extends RuleDefaultService {
	
	/**
	 * ��ȡģ����������
	 * @param serialNo ��ˮ��
	 * @param recordID ģ�ͼ�¼���
	 * @param modelID ģ�ͱ��
	 * @param object �������
	 * @return ��������
	 */
	@Override
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object){
		JSONObject jObject = null;
		String ruleID = null;
		String calcResult = null;

		try {
			//��ȡģ�ͼ�¼
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
			bq = bm.createQuery("RULEMODRECORDID=:RecordID");
			bq.setParameter("RecordID", recordID);
			bo = bq.getSingleResult();
			if (bo != null) {
				object = bo.getAttribute("BOMTEXTIN").toString();
			}
			//System.out.println("object:"+object);
			//��ģ�ͼ�¼����ƴװ
			jObject = RuleOpProvider.combineBomItem(modelID, object);

			//��ȡӦ��ϵͳ��������ݣ�������ƴװ
			GetCorrelativeValue gcv = new GetCorrelativeValue();
			gcv.setModelID(modelID);
			gcv.setSerialNo(serialNo);
			String params = gcv.getRatingInfo();
			String[] param = null;
			if (params != null && !"".equals(params)) {
				param = params.split(";");
				for (int i = 0; i < param.length; i++) {
					String itemName = param[i].split("=")[0];
					String itemValue = param[i].split("=")[1];
					jObject = RuleOpProvider.setNodeValue(jObject, itemName,itemValue);
				}
			}

			//����ƴװ���BOM
			object = RuleOpProvider.combineBomInfo(modelID, String.valueOf(jObject));

			//��ȡ���ù�����
			ruleID = RuleOpProvider.getRuleID(modelID, "RatingRule");
		} catch (JBOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		ARE.getLog().info("*********�������*********");
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
