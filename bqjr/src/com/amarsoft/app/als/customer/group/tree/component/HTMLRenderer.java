package com.amarsoft.app.als.customer.group.tree.component;


/**
 * @author syang
 * @date 2011-7-22
 * @describe HTML��Ⱦ��
 */
public interface HTMLRenderer<T extends UIComponent> extends Renderer<T> {
	/**
	 * ��ȡ��Ⱦ���HTML����
	 * @return
	 */
	String getHTML() throws Exception;
}
