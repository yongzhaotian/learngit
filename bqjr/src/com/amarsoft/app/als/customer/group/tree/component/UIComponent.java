package com.amarsoft.app.als.customer.group.tree.component;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author syang
 * @date 2011-7-22
 * @describe UI组件基础类
 */
public class UIComponent implements Serializable {
	
	private static final long serialVersionUID = -8769988502022471600L;
	protected FacesContext context;
	protected String id = "";
	protected UIComponent parent = null;
	protected List<UIComponent> children ;
	protected boolean visiable = true;
	
	/**
	 * 构造一个UI组件
	 * @param id 组件号
	 */	
	public UIComponent() {
		children = new ArrayList<UIComponent>();
	}
	/**
	 * 设置组件所在的上下文容器
	 * @param context
	 */
	public void setContext(FacesContext context){
		this.context = context;
	}
	/**
	 * 获取组件所在的上下文容器
	 * @return
	 */
	public FacesContext getContext(){
		return context;
	}
	/***
	 * 设置组件号，若组件与系统已有组件重复，则抛出异常
	 * @param id 组件号
	 * @throws FacesException
	 */
	public void setId(String id){
		this.id = id;
	}
	/**
	 * 获取组件号
	 * @return
	 */
	public String getId(){
		return this.id;
	}
	/**
	 * 设置父组件
	 * @param parent
	 */
	public void setParent(UIComponent parent){
		this.parent = parent;
	}
	/**
	 * 获取组件
	 * @return
	 */
	public UIComponent getParent(){
		return parent;
	}
	/**
	 * 获取子组件列表
	 * @return
	 */
	public List<UIComponent> getChildren(){
		return children;
	}
	/**
	 * 添加一个子组件节点
	 * @param component
	 */
	public void appendChildren(UIComponent component){
		component.setParent(this);
		children.add(component);
	}
	/**
	 * 添加一个组件节点
	 * @param referenceComponent 参考组件
	 * @param component 添加组件
	 * @param pos 参考位置-1在前，1在后
	 */
	public void addChildren(UIComponent referenceComponent,UIComponent component,int pos){
		component.setParent(this);
		int index = children.indexOf(referenceComponent);
		if(index<0)index=0;
		if(pos<0)children.add(index,component);
		else if(pos>0)children.add(index+1,component);
	}
	/**
	 * 设置是否可见
	 */
	public void setVisiable(boolean visiable){
		this.visiable=visiable;
	}
	/**
	 * 是否可见
	 * @return
	 */
	public boolean isVisiable(){
		return visiable;
	}
}
