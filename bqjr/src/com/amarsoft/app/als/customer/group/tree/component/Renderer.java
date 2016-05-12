package com.amarsoft.app.als.customer.group.tree.component;


/**
 * @author syang
 * @date 2011-7-22
 * @describe 定义UI组件渲染器接口
 */
public interface Renderer<T  extends UIComponent> {
	/**
	 * 恢复组件
	 * @param context 上下文容器
	 * @param component 组件对象
	 */
	void decode(FacesContext context,T component) throws Exception;
	/**
	 * 编码开始部分
	 * @param context 上下文容器
	 * @param component 组件对象
	 */
	void encodeBegin(FacesContext context,T component) throws Exception;
	/**
	 * 编码主体部分
	 * @param context 上下文容器
	 * @param component 组件对象
	 */
	void encodeBody(FacesContext context,T component) throws Exception;
	/**
	 * 编码尾部
	 * @param context 上下文容器
	 * @param component 组件对象
	 */
	void encodeEnd(FacesContext context,T component) throws Exception;
}
