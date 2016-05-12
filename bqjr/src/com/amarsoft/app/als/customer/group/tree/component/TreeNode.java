package com.amarsoft.app.als.customer.group.tree.component;

import java.io.Serializable;

/**
 * @author syang
 * @date 2011-7-23
 * @describe 树节点
 */
public class TreeNode extends UIComponent implements Serializable{

	private static final long serialVersionUID = 7991805965548986061L;
	protected String label = "";
	protected String parentId = "";
	/**
	 * 获取节点文字
	 * @return 节点文字
	 */
	public String getLabel() {
		return label;
	}
	/**
	 * 设置节点文字
	 * @param label 节点文字
	 */
	public void setLabel(String label) {
		this.label = label;
	}
	/**
	 * 父节点编号
	 * @return
	 */
	public String getParentId() {
		return parentId;
	}
	/**
	 * 父节点编号
	 * @param parentId
	 */
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}	

}
