package com.amarsoft.app.als.rule.data;

import java.util.List;

/**
 * ģ�Ͷ������Ŀ,���ڱ������������Ӧ��ϵͳ�����ĸ���ģ�͵Ķ������Ŀ��Ϣ��
 * @author zszhang
 *
 */
public class RuleItem {

	private String itemID;        //��Ŀ���
	private String itemName;      //��Ŀ����
	private String itemRelation;  //��Ŀ��ϵ
	private String itemValue;     //��Ŀֵ
	private List ruleAttributes;  //��Ŀ����
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
