package com.amarsoft.app.als.rule.data;

import java.util.List;

/**
 * ģ��,���ڱ������������Ӧ��ϵͳ������ģ�͡�
 * @author zszhang
 *
 */
public class RuleModel {
	
	private String modelID;   //ģ�ͱ��
	private String modelName; //ģ������
	private String modelType; //ģ������
	private List ruleObjects; //ģ�Ͷ��� 
	
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
