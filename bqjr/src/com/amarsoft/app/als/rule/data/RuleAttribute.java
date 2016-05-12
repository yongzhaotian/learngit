package com.amarsoft.app.als.rule.data;

/**
 * 模型对象属性,用于保存规则引擎与应用系统交互的各个模型对象信息的属性。
 * @author zszhang
 *
 */

public class RuleAttribute {
	
	private String attributeID;    //属性编号
	private String attributeName;  //属性名称
	private String remark;         //属性备注
	private String describe;       //属性描述
	
	public String getAttributeID() {
		return attributeID;
	}
	public void setAttributeID(String attributeID) {
		this.attributeID = attributeID;
	}
	public String getAttributeName() {
		return attributeName;
	}
	public void setAttributeName(String attributeName) {
		this.attributeName = attributeName;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getDescribe() {
		return describe;
	}
	public void setDescribe(String describe) {
		this.describe = describe;
	}
}
