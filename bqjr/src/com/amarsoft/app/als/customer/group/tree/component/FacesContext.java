package com.amarsoft.app.als.customer.group.tree.component;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author syang
 * @date 2011-7-22
 * @describe UI�������������
 */
public class FacesContext implements Serializable {

	private static final long serialVersionUID = -319380030781207285L;
	protected List<FacesContextListener> listeners ;
	protected Map<String,FacesMessage> messages;
	private Map<String,UIComponent> componentCache;
	protected Map<String,Object> attribute;
	protected UIComponent rootComponent;
	/**
	 * �������
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
	 * �������
	 * @param id ���ID
	 * @param _class ����
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
			throw new FacesException("���ID="+id+"�ظ�");
		} catch (Exception e) {
			throw new FacesException("�������ID="+id+"����");
		}
		return instance;
	}
	/**
	 * ���һ��������
	 * @param listener
	 */
	public void addListener(FacesContextListener listener){
		listeners.add(listener);
	}
	/**
	 * ��ȡ�������б�
	 * @return
	 */
	public List<FacesContextListener> getListeners(){
		return listeners;
	}	
	/**
	 * ���ø����
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
	 * ���һ����Ϣ����
	 * @param name
	 * @param message
	 */
	public void addMessage(String name,FacesMessage message){
		messages.put(name, message);
	}
	/**
	 * ������Ϣ����
	 * @return
	 */
	public Map<String,FacesMessage> getMessages(){
		return messages;
	}
	/**
	 * �������
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
	 * �����referenceComponent֮ǰ�������component
	 * @param referenceComponent �ο����
	 * @param component Ŀ�����
	 * @param pos  �ο�λ��-1��ǰ��1�ں�
	 * @param listener  �Ƿ�ʹ�ü�����
	 */
	public void insertComponent(UIComponent referenceComponent,UIComponent component,int pos,boolean listener) throws FacesException{
		UIComponent parent = referenceComponent.getParent();
		if(parent==null)throw new FacesException("�ο����Ϊ������������ڸ������������");
		if(referenceComponent.equals(component))throw new FacesException("�ο������Դ��Ϊͬһ���");
		//����Ƿ��ظ�
		UIComponent cacheComponent = componentCache.get(component.getId());
		if(cacheComponent!=null) throw new FacesException("���ID="+component.getId()+"�ظ�");
		
		referenceComponent.getParent().addChildren(referenceComponent, component, pos);
		componentCache.put(component.getId(), component);
		invokeListenerAdd(component);//������
	}
	/**
	 * �����referenceComponent֮ǰ�������component
	 * @param referenceComponent �ο����
	 * @param component Ŀ�����
	 * @param pos  �ο�λ��-1��ǰ��1�ں�
	 * @throws FacesException
	 */
	public void insertComponent(UIComponent referenceComponent,UIComponent component,int pos) throws FacesException{
		insertComponent(referenceComponent,component,pos,true);
	}
	/**
	 * �����componentβ�����һ�������
	 * @param component ���
	 * @param child ���������
	 * @param listener �Ƿ�ʹ�ü�����
	 * @throws FacesException
	 */
	public void appendChildComponent(UIComponent component,UIComponent child,boolean listener) throws FacesException{
		UIComponent cacheComponent = componentCache.get(child.getId());
		if(cacheComponent!=null) throw new FacesException("���ID="+child.getId()+"�ظ�");
		component.appendChildren(child);
		componentCache.put(child.getId(), child);
		if(listener)invokeListenerAdd(child);//������
	}
	/**
	 * �����componentβ�����һ�������
	 * @param component ���
	 * @param child ���������
	 * @throws FacesException 
	 */
	public void appendChildComponent(UIComponent component,UIComponent child) throws FacesException{
		appendChildComponent(component,child,true);
	}
	/***
	 * �Ƴ�һ�����
	 * @param id
	 * @return
	 * @throws FacesException 
	 */
	public UIComponent removeComponent(String id) throws FacesException{
		UIComponent component = findComponent(id);
		if(component!=null){
			UIComponent parent = component.getParent();
			//����������Ƴ�
			if(parent!=null&&parent.getChildren()!=null)parent.getChildren().remove(component);
			//��cache���Ƴ�
			componentCache.remove(id);
			//���ü�����
			invokeListenerRemove(component);//������
		}
		return component;
	}
	/**
	 * �������
	 * @param id
	 * @return
	 */
	public UIComponent findComponent(String id){
		return componentCache.get(id);
	}
	/**
	 * �������м�������
	 * @param name
	 * @param value
	 */
	public void setAttribute(String name,String value){
		attribute.put(name, value);
	}
	/**
	 * ȡ�������е�����ֵ
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
