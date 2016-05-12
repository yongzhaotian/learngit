package com.amarsoft.app.als.customer.group.tree.component;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author syang
 * @date 2011-7-22
 * @describe UI���������
 */
public class UIComponent implements Serializable {
	
	private static final long serialVersionUID = -8769988502022471600L;
	protected FacesContext context;
	protected String id = "";
	protected UIComponent parent = null;
	protected List<UIComponent> children ;
	protected boolean visiable = true;
	
	/**
	 * ����һ��UI���
	 * @param id �����
	 */	
	public UIComponent() {
		children = new ArrayList<UIComponent>();
	}
	/**
	 * ����������ڵ�����������
	 * @param context
	 */
	public void setContext(FacesContext context){
		this.context = context;
	}
	/**
	 * ��ȡ������ڵ�����������
	 * @return
	 */
	public FacesContext getContext(){
		return context;
	}
	/***
	 * ��������ţ��������ϵͳ��������ظ������׳��쳣
	 * @param id �����
	 * @throws FacesException
	 */
	public void setId(String id){
		this.id = id;
	}
	/**
	 * ��ȡ�����
	 * @return
	 */
	public String getId(){
		return this.id;
	}
	/**
	 * ���ø����
	 * @param parent
	 */
	public void setParent(UIComponent parent){
		this.parent = parent;
	}
	/**
	 * ��ȡ���
	 * @return
	 */
	public UIComponent getParent(){
		return parent;
	}
	/**
	 * ��ȡ������б�
	 * @return
	 */
	public List<UIComponent> getChildren(){
		return children;
	}
	/**
	 * ���һ��������ڵ�
	 * @param component
	 */
	public void appendChildren(UIComponent component){
		component.setParent(this);
		children.add(component);
	}
	/**
	 * ���һ������ڵ�
	 * @param referenceComponent �ο����
	 * @param component ������
	 * @param pos �ο�λ��-1��ǰ��1�ں�
	 */
	public void addChildren(UIComponent referenceComponent,UIComponent component,int pos){
		component.setParent(this);
		int index = children.indexOf(referenceComponent);
		if(index<0)index=0;
		if(pos<0)children.add(index,component);
		else if(pos>0)children.add(index+1,component);
	}
	/**
	 * �����Ƿ�ɼ�
	 */
	public void setVisiable(boolean visiable){
		this.visiable=visiable;
	}
	/**
	 * �Ƿ�ɼ�
	 * @return
	 */
	public boolean isVisiable(){
		return visiable;
	}
}
