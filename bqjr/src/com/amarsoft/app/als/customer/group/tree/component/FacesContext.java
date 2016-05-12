package com.amarsoft.app.als.customer.group.tree.component;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author syang
 * @date 2011-7-22
 * @describe UI组件上下文容器
 */
public class FacesContext implements Serializable {

	private static final long serialVersionUID = -319380030781207285L;
	protected List<FacesContextListener> listeners ;
	protected Map<String,FacesMessage> messages;
	private Map<String,UIComponent> componentCache;
	protected Map<String,Object> attribute;
	protected UIComponent rootComponent;
	/**
	 * 构造对象
	 */
	public FacesContext(){
		listeners = new ArrayList<FacesContextListener>();
		messages = new HashMap<String,FacesMessage>();
		componentCache = new HashMap<String,UIComponent>();
		attribute = new HashMap<String,Object>();
	}
	public int getComponentCacheSize(){
		return componentCache.size();
	}
	/**
	 * 创建组件
	 * @param id 组件ID
	 * @param _class 类名
	 * @return
	 * @throws FacesException
	 */
	public UIComponent createComponent(String id,Class<? extends UIComponent> _class) throws FacesException{
		UIComponent instance = null;
		try {
			instance = _class.newInstance();
			instance.setId(id);
			instance.setContext(this);
			UIComponent cacheComponent = componentCache.get(id);
			if(cacheComponent!=null) throw new FacesException();
		} catch (FacesException e){
			throw new FacesException("组件ID="+id+"重复");
		} catch (Exception e) {
			throw new FacesException("创建组件ID="+id+"出错");
		}
		return instance;
	}
	/**
	 * 添加一个监听器
	 * @param listener
	 */
	public void addListener(FacesContextListener listener){
		listeners.add(listener);
	}
	/**
	 * 获取监听器列表
	 * @return
	 */
	public List<FacesContextListener> getListeners(){
		return listeners;
	}	
	/**
	 * 设置根组件
	 * @param rootComponent
	 */
	public void setRootComponent(UIComponent rootComponent) {
		this.componentCache.put(rootComponent.getId(), rootComponent);
		this.rootComponent = rootComponent;
	}
	public UIComponent getRootComponent(){
		return rootComponent;
	}
	public void release(){}
	public List<FacesMessage> getMessageList(){
		return null;
	}
	/**
	 * 添加一个消息对象
	 * @param name
	 * @param message
	 */
	public void addMessage(String name,FacesMessage message){
		messages.put(name, message);
	}
	/**
	 * 返回消息对象集
	 * @return
	 */
	public Map<String,FacesMessage> getMessages(){
		return messages;
	}
	/**
	 * 更新组件
	 * @param component
	 * @throws FacesException 
	 */
	public void updateComponent(UIComponent component) throws FacesException{
		if(!componentCache.containsKey(component.getId()))return;
		UIComponent cacheComponent = componentCache.get(component.getId());
		componentCache.put(component.getId(), component);
		UIComponent parent = component.getParent();
		if(parent!=null){
			parent.getChildren().remove(cacheComponent);
			parent.getChildren().add(component);
		}
		invokeListenerEdit(cacheComponent,component);
	}
	/**
	 * 
	 * 给组件referenceComponent之前插入组件component
	 * @param referenceComponent 参考组件
	 * @param component 目标组件
	 * @param pos  参考位置-1在前，1在后
	 * @param listener  是否使用监听器
	 */
	public void insertComponent(UIComponent referenceComponent,UIComponent component,int pos,boolean listener) throws FacesException{
		UIComponent parent = referenceComponent.getParent();
		if(parent==null)throw new FacesException("参考组件为根组件，不能在该组件后插入组件");
		if(referenceComponent.equals(component))throw new FacesException("参考组件与源组为同一组件");
		//检查是否重复
		UIComponent cacheComponent = componentCache.get(component.getId());
		if(cacheComponent!=null) throw new FacesException("组件ID="+component.getId()+"重复");
		
		referenceComponent.getParent().addChildren(referenceComponent, component, pos);
		componentCache.put(component.getId(), component);
		invokeListenerAdd(component);//监听器
	}
	/**
	 * 给组件referenceComponent之前插入组件component
	 * @param referenceComponent 参考组件
	 * @param component 目标组件
	 * @param pos  参考位置-1在前，1在后
	 * @throws FacesException
	 */
	public void insertComponent(UIComponent referenceComponent,UIComponent component,int pos) throws FacesException{
		insertComponent(referenceComponent,component,pos,true);
	}
	/**
	 * 给组件component尾部添加一个子组件
	 * @param component 组件
	 * @param child 子组件对象
	 * @param listener 是否使用监听器
	 * @throws FacesException
	 */
	public void appendChildComponent(UIComponent component,UIComponent child,boolean listener) throws FacesException{
		UIComponent cacheComponent = componentCache.get(child.getId());
		if(cacheComponent!=null) throw new FacesException("组件ID="+child.getId()+"重复");
		component.appendChildren(child);
		componentCache.put(child.getId(), child);
		if(listener)invokeListenerAdd(child);//监听器
	}
	/**
	 * 给组件component尾部添加一个子组件
	 * @param component 组件
	 * @param child 子组件对象
	 * @throws FacesException 
	 */
	public void appendChildComponent(UIComponent component,UIComponent child) throws FacesException{
		appendChildComponent(component,child,true);
	}
	/***
	 * 移除一个组件
	 * @param id
	 * @return
	 * @throws FacesException 
	 */
	public UIComponent removeComponent(String id) throws FacesException{
		UIComponent component = findComponent(id);
		if(component!=null){
			UIComponent parent = component.getParent();
			//从组件树上移除
			if(parent!=null&&parent.getChildren()!=null)parent.getChildren().remove(component);
			//从cache中移除
			componentCache.remove(id);
			//调用监听器
			invokeListenerRemove(component);//监听器
		}
		return component;
	}
	/**
	 * 查找组件
	 * @param id
	 * @return
	 */
	public UIComponent findComponent(String id){
		return componentCache.get(id);
	}
	/**
	 * 向容器中加入属性
	 * @param name
	 * @param value
	 */
	public void setAttribute(String name,String value){
		attribute.put(name, value);
	}
	/**
	 * 取出容器中的属性值
	 * @param name
	 * @return
	 */
	public Object getAttribute(String name){
		return attribute.get(name);
	}
	private void invokeListenerAdd(UIComponent component) throws FacesException{
		for(FacesContextListener listener:listeners){
			listener.addComponent(this,component);
		}
	}
	private void invokeListenerEdit(UIComponent oldComponent,UIComponent newComponent) throws FacesException{
		for(FacesContextListener listener:listeners){
			listener.editComponent(this,oldComponent,newComponent);
		}
	}
	private void invokeListenerRemove(UIComponent component) throws FacesException{
		for(FacesContextListener listener:listeners){
			listener.removeComponent(this,component);
		}
	}
}
