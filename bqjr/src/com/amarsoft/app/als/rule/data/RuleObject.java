package com.amarsoft.app.als.rule.data;

import java.util.List;

/**
 * 模型下的对象,用于保存规则引擎与应用系统交互的各个模型的对象。
 * @author zszhang
 *
 */
public class RuleObject {

	private String objectID;    //对象编号
	private String objectName;  //对象名称
	private String objectType;  //对象类型
	private String objectModule;//对象所属模块
	private List items;    		//对象的项目
	
	public String getObjectID() {
		return objectID;
	}
	public void setObjectID(String objectID) {
		this.objectID = objectID;
	}
	public String getObjectName() {
		return objectName;
	}
	public void setObjectName(String objectName) {
		this.objectName = objectName;
	}
	public String getObjectType() {
		return objectType;
	}
	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}
	public String getObjectModule() {
		return objectModule;
	}
	public void setObjectModule(String objectModule) {
		this.objectModule = objectModule;
	}
	public List getItems() {
		return items;
	}
	public void setItems(List items) {
		this.items = items;
	}
}
