package com.amarsoft.app.als.customer.group.tree.component;


/**
 * @author syang
 * @date 2011-7-22
 * @describe 容器监听器
 */
public interface FacesContextListener{
	/**
	 * 往容器里添加组件时，触发
	 * @param componet 源组件
	 */
	void addComponent(FacesContext context,UIComponent sourceComponent) throws FacesException;
	/**
	 * 修改容器中组件时时，触发
	 * @param componet
	 */
	void editComponent(FacesContext context,UIComponent oldComponent,UIComponent newComponent) throws FacesException;
	/**
	 * 移除容器中组件时时，触发
	 * @param sourceComponent
	 */
	void removeComponent(FacesContext context,UIComponent sourceComponent) throws FacesException;
}
