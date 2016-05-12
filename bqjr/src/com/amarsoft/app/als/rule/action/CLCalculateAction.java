package com.amarsoft.app.als.rule.action;

import com.amarsoft.app.als.credit.model.CLAcceptCalculateInit;
import com.amarsoft.app.als.credit.model.CLTrendCalculateInit;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.core.object.ResultObject;

public class CLCalculateAction {
	
	private String modelID;  	 // ģ�ͱ��
	private String serialNo; 	 // ��ˮ��
	private String recordID;     // ģ�ͼ�¼���
	private String ruleType; 	 // ��������
	private String ruleID; 		 // ������
	
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
	
	public String calculate(JBOTransaction tx) throws Exception{
		//JSONObject jResult = new JSONObject();
		Log logger = ARE.getLog();
		String Result = null;
		
		RuleOpAction roa = new RuleOpAction("clcalculate_service");
		try {
			Result = roa.getResult(serialNo,recordID,modelID,ruleType,"");
			//jResult = new JSONObject(Result);
			ResultObject rObject = new ResultObject(Result);
			
			if("R_LIMIT1".equals(modelID)){
				String s1 = rObject.getResult("RETURNS.MaxLimitA", "");//��������޶�A
				String s2 = rObject.getResult("RETURNS.MaxLimitB1", "");//�ͻ��ܸ�ծ�ĺ����ģB1
				String s3 = rObject.getResult("RETURNS.MaxLimitB2", "");//�ͻ��ܸ�ծ�ĺ����ģB2
				Result = String.format("%.2f",Double.parseDouble(s1));
				
				//��ģ�Ͳ��������������ݱ�
				CLAcceptCalculateInit cla = new CLAcceptCalculateInit();
				cla.setSerialNo(serialNo);
				cla.updateCLModelRecord(tx, Result);
				
				cla.setFinanceData(tx, "3", Double.parseDouble(s1));
				cla.setFinanceData(tx, "1", Double.parseDouble(s2));
				cla.setFinanceData(tx, "2", Double.parseDouble(s3));
			}
			
			if("R_LIMIT2".equals(modelID)){
				String s1 = rObject.getResult("RETURNS.������.A", "");//δ��һ��ͻ���Ӫ�����ʽ�Ԥ��
				String s2 = rObject.getResult("RETURNS.������.K", "");//δ��һ��ͻ���Ӫ�����ɱ�
				String s3 = rObject.getResult("RETURNS.������.Z", "");//�����ھ�Ӫ���ʽ���Դ
				String s4 = rObject.getResult("RETURNS.������.CL", "");//��������޶�
				Result = String.format("%.2f",Double.parseDouble(s4));
				
				//��ģ�Ͳ��������������ݱ�
				CLTrendCalculateInit clt = new CLTrendCalculateInit();
				clt.setSerialNo(serialNo);
				clt.updateCLModelRecord(tx, Result);
				
				clt.setFinanceData(tx, "1", Double.parseDouble(s1));
				clt.setFinanceData(tx, "1.1", Double.parseDouble(s2));
				clt.setFinanceData(tx, "2", Double.parseDouble(s3));
				clt.setFinanceData(tx, "5", Double.parseDouble(s4));	
			}
			
			//��ģ�Ͳ�������������¼��
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("���ù�������ʧ�ܣ�");
			Result = "_ERROR_";
		}
		
		return Result;
	}
}
