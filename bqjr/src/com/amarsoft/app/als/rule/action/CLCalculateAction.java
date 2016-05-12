package com.amarsoft.app.als.rule.action;

import com.amarsoft.app.als.credit.model.CLAcceptCalculateInit;
import com.amarsoft.app.als.credit.model.CLTrendCalculateInit;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.core.object.ResultObject;

public class CLCalculateAction {
	
	private String modelID;  	 // 模型编号
	private String serialNo; 	 // 流水号
	private String recordID;     // 模型记录编号
	private String ruleType; 	 // 规则类型
	private String ruleID; 		 // 规则编号
	
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
				String s1 = rObject.getResult("RETURNS.MaxLimitA", "");//最高授信限额A
				String s2 = rObject.getResult("RETURNS.MaxLimitB1", "");//客户总负债的合理规模B1
				String s3 = rObject.getResult("RETURNS.MaxLimitB2", "");//客户总负债的合理规模B2
				Result = String.format("%.2f",Double.parseDouble(s1));
				
				//将模型测算结果更新至数据表
				CLAcceptCalculateInit cla = new CLAcceptCalculateInit();
				cla.setSerialNo(serialNo);
				cla.updateCLModelRecord(tx, Result);
				
				cla.setFinanceData(tx, "3", Double.parseDouble(s1));
				cla.setFinanceData(tx, "1", Double.parseDouble(s2));
				cla.setFinanceData(tx, "2", Double.parseDouble(s3));
			}
			
			if("R_LIMIT2".equals(modelID)){
				String s1 = rObject.getResult("RETURNS.计算结果.A", "");//未来一年客户经营所需资金预测
				String s2 = rObject.getResult("RETURNS.计算结果.K", "");//未来一年客户经营活动所需成本
				String s3 = rObject.getResult("RETURNS.计算结果.Z", "");//可用于经营的资金来源
				String s4 = rObject.getResult("RETURNS.计算结果.CL", "");//最高授信限额
				Result = String.format("%.2f",Double.parseDouble(s4));
				
				//将模型测算结果更新至数据表
				CLTrendCalculateInit clt = new CLTrendCalculateInit();
				clt.setSerialNo(serialNo);
				clt.updateCLModelRecord(tx, Result);
				
				clt.setFinanceData(tx, "1", Double.parseDouble(s1));
				clt.setFinanceData(tx, "1.1", Double.parseDouble(s2));
				clt.setFinanceData(tx, "2", Double.parseDouble(s3));
				clt.setFinanceData(tx, "5", Double.parseDouble(s4));	
			}
			
			//将模型测算结果更新至记录表
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("调用规则引擎失败！");
			Result = "_ERROR_";
		}
		
		return Result;
	}
}
