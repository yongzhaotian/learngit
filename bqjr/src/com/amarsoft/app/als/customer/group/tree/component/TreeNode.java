package com.amarsoft.app.als.customer.group.tree.component;

import java.io.Serializable;

/**
 * @author syang
 * @date 2011-7-23
 * @describe ���ڵ�
 */
public class TreeNode extends UIComponent implements Serializable{

	private static final long serialVersionUID = 7991805965548986061L;
	protected String label = "";
	protected String parentId = "";
	/**
	 * ��ȡ�ڵ�����
	 * @return �ڵ�����
	 */
	public String getLabel() {
		return label;
	}
	/**
	 * ���ýڵ�����
	 * @param label �ڵ�����
	 */
	public void setLabel(String label) {
		this.label = label;
	}
	/**
	 * ���ڵ���
	 * @return
	 */
	public String getParentId() {
		return parentId;
	}
	/**
	 * ���ڵ���
	 * @param parentId
	 */
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}	

}
