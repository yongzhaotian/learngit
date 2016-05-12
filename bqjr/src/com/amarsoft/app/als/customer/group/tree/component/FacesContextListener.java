package com.amarsoft.app.als.customer.group.tree.component;


/**
 * @author syang
 * @date 2011-7-22
 * @describe ����������
 */
public interface FacesContextListener{
	/**
	 * ��������������ʱ������
	 * @param componet Դ���
	 */
	void addComponent(FacesContext context,UIComponent sourceComponent) throws FacesException;
	/**
	 * �޸����������ʱʱ������
	 * @param componet
	 */
	void editComponent(FacesContext context,UIComponent oldComponent,UIComponent newComponent) throws FacesException;
	/**
	 * �Ƴ����������ʱʱ������
	 * @param sourceComponent
	 */
	void removeComponent(FacesContext context,UIComponent sourceComponent) throws FacesException;
}
