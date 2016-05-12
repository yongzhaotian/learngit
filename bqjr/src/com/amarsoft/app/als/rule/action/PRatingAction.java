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

/*************************************************************
 * author: DXS
 * date: 20111006
 * remark: 
 *		���˿ͻ�����ר��
 *************************************************************/
public class PRatingAction extends RatingAction{


	public PRatingAction(String serialNo,String recordID,String modelID,
			String ruleType,String customerType,String testFlag)
	{
		super(serialNo,recordID,modelID,ruleType,customerType,testFlag);
	}
	
	public PRatingAction(){  }
	
	
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
			Result = roa.getResult(serialNo,recordID,modelID,ruleType,"");
			jResult = new JSONObject(Result);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("���ù�������ʧ�ܣ�");
		}

		String sStatus = RuleOpProvider.getNodeValue(jResult,"RESULTS.STATUS", "");

		// �ж�������ؽ���ɹ������µ��ü�¼
		if ("1".equals(sStatus)) {
			/*score = RuleOpProvider.getNodeValue(jResult,"RETURNS.�����ܷ�", "");
			grade = RuleOpProvider.getNodeValue(jResult,"RETURNS.����ȼ�", "");
			if(("04").equals(customerType)){
				score = RuleOpProvider.getNodeValue(jResult,"RETURNS.���.�÷�", "");
				grade = RuleOpProvider.getNodeValue(jResult,"RETURNS.���.����", "");
			}*/
			score = RuleOpProvider.getNodeValue(jResult,"RETURNS.���.�÷�", "");
			grade = RuleOpProvider.getNodeValue(jResult,"RETURNS.���.����", "");
			score = DataConvert.toMoney(score);
			if(score.startsWith("-"))score="0";
			
			if(!"1".equals(testFlag)){
					m = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
					tx.join(m);
					q = m.createQuery("update O set RatingScore01 =:Score,RatingGrade01=:Grade where RatingAppID =:SerialNo");
					q.setParameter("SerialNo", serialNo);
					q.setParameter("Score", score);
					q.setParameter("Grade", grade);
					q.executeUpdate();
			}else{
				m = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
				q = m.createQuery("RULEMODRECORDID =:RecordID");
				q.setParameter("RecordID",recordID);
				bo = q.getSingleResult();
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
				bo = q.getSingleResult();
				if(bo!=null){
					tx.join(m);
					m.deleteObject(bo);
				}
			}
		}
		return "success"+"@"+score+"@"+grade;
	}	
}