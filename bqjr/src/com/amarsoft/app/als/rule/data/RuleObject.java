package com.amarsoft.app.als.rule.data;

import java.util.List;

/**
 * ģ���µĶ���,���ڱ������������Ӧ��ϵͳ�����ĸ���ģ�͵Ķ���
 * @author zszhang
 *
 */
public class RuleObject {

	private String objectID;    //������
	private String objectName;  //��������
	private String objectType;  //��������
	private String objectModule;//��������ģ��
	private List items;    		//�������Ŀ
	
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
