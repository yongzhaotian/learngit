package com.amarsoft.app.als.rating.bizlets;

import com.amarsoft.app.als.rule.action.RuleOpAction;
import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.core.json.JSONObject;

public class ExecuteRating extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String serialNo = (String) this.getAttribute("SerialNo");
		String recordID = (String) this.getAttribute("RecordID");
		String modelID = (String) this.getAttribute("ModelID");
		String ruleType = (String) this.getAttribute("RuleType");
		String doTranStage = (String) this.getAttribute("DoTranStage");
		String testFlag = (String) this.getAttribute("TestFlag");
		JSONObject jResult = new JSONObject();
		Log logger = ARE.getLog();

		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String score = null;
		String grade = null;
		String result = null;
		
		JBOTransaction tx = JBOFactory.createJBOTransaction();
		RuleOpAction roa = new RuleOpAction("rating_service");
		try {
			result = roa.getResult(serialNo,recordID,modelID,ruleType,"",doTranStage);
			jResult = new JSONObject(result);
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

}
