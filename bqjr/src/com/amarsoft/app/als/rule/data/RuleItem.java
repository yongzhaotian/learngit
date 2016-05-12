package com.amarsoft.app.als.rule.data;

import java.util.List;

/**
 * 模型对象的项目,用于保存规则引擎与应用系统交互的各个模型的对象的项目信息。
 * @author zszhang
 *
 */
public class RuleItem {

	private String itemID;        //项目编号
	private String itemName;      //项目名称
	private String itemRelation;  //项目关系
	private String itemValue;     //项目值
	private List ruleAttributes;  //项目属性
	private String itemType;
	private String itemStyle;
	public String getItemID() {
		return itemID;
	}
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public String getItemRelation() {
		return itemRelation;
	}
	public void setItemRelation(String itemRelation) {
		this.itemRelation = itemRelation;
	}
	public String getItemValue() {
		return itemValue;
	}
	public void setItemValue(String itemValue) {
		this.itemValue = itemValue;
	}
	public List getRuleAttributes() {
		return ruleAttributes;
	}
	public void setRuleAttributes(List ruleAttributes) {
		this.ruleAttributes = ruleAttributes;
	}
	public String getItemType() {
		return itemType;
	}
	public void setItemType(String itemType) {
		this.itemType = itemType;
	}
	public String getItemStyle() {
		return itemStyle;
	}
	public void setItemStyle(String itemStyle) {
		this.itemStyle = itemStyle;
	}
	
	
}
