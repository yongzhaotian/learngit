package com.amarsoft.app.als.rule.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

/**
 * ��¼�������
 * @author zszhang
 *
 */
public class UpdateRuleRecord {
	
	public BizObjectManager bm = null;
	public BizObjectQuery bq = null;
	public BizObject bo = null;
	
	/**
	 * ��������¹����¼
	 * @param recordID ģ�ͼ�¼���
	 * @param ruleType ��������
	 * @param ruleID ������
	 * @param bomTextIn �������
	 * @param bomTextOut �������
	 * @param doTranStage ����׶�
	 * @return ģ�ͼ�¼���
	 */
	public void update(String recordID,String ruleType,String ruleID,String bomTextIn,String bomTextOut,String doTranStage) throws JBOException{
		JBOTransaction jx = JBOFactory.createJBOTransaction();
		bm = JBOFactory.getFactory().getManager("jbo.app.RULE_RECORD");
		jx.join(bm);
		bq = bm.createQuery("RULEMODRECORDID=:RecordID and REFRULETYPE=:RuleType and REFRULEPOINT=:RuleID and att01=:att01");
		bq.setParameter("RecordID",recordID);
		bq.setParameter("RuleType",ruleType);
		bq.setParameter("RuleID",ruleID);
		bq.setParameter("att01",doTranStage);
		bo = bq.getSingleResult(true);
		if(bo!=null){
			bo.setAttributeValue("BOMTEXTIN", bomTextIn);
			bo.setAttributeValue("BOMTEXTOUT", bomTextOut);
			bo.setAttributeValue("ENDDATETIME", StringFunction.getTodayNow());
			bm.saveObject(bo);
		}else{
			insert(recordID,ruleType,ruleID,bomTextIn,bomTextOut,doTranStage,jx);
		}
		jx.commit();
	}
	
	
	/**
	 * ��������¹����¼
	 * @param recordID ģ�ͼ�¼���
	 * @param ruleType ��������
	 * @param ruleID ������
	 * @param bomTextIn �������
	 * @param bomTextOut �������
	 * @return ģ�ͼ�¼���
	 */
	public void update(String recordID,String ruleType,String ruleID,String bomTextIn,String bomTextOut) throws JBOException{
		JBOTransaction jx = JBOFactory.createJBOTransaction();
		bm = JBOFactory.getFactory().getManager("jbo.app.RULE_RECORD");
		jx.join(bm);
		bq = bm.createQuery("RULEMODRECORDID=:RecordID and REFRULETYPE=:RuleType and REFRULEPOINT=:RuleID");
		bq.setParameter("RecordID",recordID);
		bq.setParameter("RuleType",ruleType);
		bq.setParameter("RuleID",ruleID);
		bo = bq.getSingleResult(true);
		if(bo!=null){
			bo.setAttributeValue("BOMTEXTIN", bomTextIn);
			bo.setAttributeValue("BOMTEXTOUT", bomTextOut);
			bo.setAttributeValue("ENDDATETIME", StringFunction.getTodayNow());
			bm.saveObject(bo);
		}else{
			insert(recordID,ruleType,ruleID,bomTextIn,bomTextOut,"",jx);
		}
		jx.commit();
	}
	/**
	 * ���������¼
	 * @param recordID ģ�ͼ�¼���
	 * @param ruleType ��������
	 * @param ruleID ������
	 * @param bomTextIn �������
	 * @param bomTextOut �������
	 * @return ģ�ͼ�¼���
	 */
	public void insert(String recordID,String ruleType,String ruleID,String bomTextIn,String bomTextOut,String doTranStage,JBOTransaction jx) throws JBOException{
		bm = JBOFactory.getFactory().getManager("jbo.app.RULE_RECORD");
		jx.join(bm);
		bo = bm.newObject();
		bo.getAttribute("RULERECORDID").setNull();
		bo.setAttributeValue("RULEMODRECORDID", recordID);
		bo.setAttributeValue("REFRULETYPE", ruleType);
		bo.setAttributeValue("REFRULEPOINT", ruleID);
		bo.setAttributeValue("BOMTEXTIN", bomTextIn);
		bo.setAttributeValue("BOMTEXTOUT", bomTextOut);
		bo.setAttributeValue("STARTDATETIME", StringFunction.getTodayNow());
		bo.setAttributeValue("ENDDATETIME", StringFunction.getTodayNow());
		bo.setAttributeValue("att01",doTranStage);
		bm.saveObject(bo);
	}

}
