package com.amarsoft.app.als.rule.data;

/**
 * ģ�Ͷ�������,���ڱ������������Ӧ��ϵͳ�����ĸ���ģ�Ͷ�����Ϣ�����ԡ�
 * @author zszhang
 *
 */

public class RuleAttribute {
	
	private String attributeID;    //���Ա��
	private String attributeName;  //��������
	private String remark;         //���Ա�ע
	private String describe;       //��������
	
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
