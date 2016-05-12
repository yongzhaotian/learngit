package com.amarsoft.app.als.rule.data;

import java.util.List;

/**
 * 模型,用于保存规则引擎与应用系统交互的模型。
 * @author zszhang
 *
 */
public class RuleModel {
	
	private String modelID;   //模型编号
	private String modelName; //模型名称
	private String modelType; //模型类型
	private List ruleObjects; //模型对象 
	
	public String getModelID() {
		return modelID;
	}
	public void setModelID(String modelID) {
		this.modelID = modelID;
	}
	public String getModelName() {
		return modelName;
	}
	public void setModelName(String modelName) {
		this.modelName = modelName;
	}
	public String getModelType() {
		return modelType;
	}
	public void setModelType(String modelType) {
		this.modelType = modelType;
	}
	public List getRuleObjects() {
		return ruleObjects;
	}
	public void setRuleObjects(List ruleObjects) {
		this.ruleObjects = ruleObjects;
	}
	

}
