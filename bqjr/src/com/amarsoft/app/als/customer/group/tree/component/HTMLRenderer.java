package com.amarsoft.app.als.customer.group.tree.component;


/**
 * @author syang
 * @date 2011-7-22
 * @describe HTML渲染器
 */
public interface HTMLRenderer<T extends UIComponent> extends Renderer<T> {
	/**
	 * 获取渲染后的HTML编码
	 * @return
	 */
	String getHTML() throws Exception;
}
