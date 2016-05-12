package com.amarsoft.app.als.customer.group.tree.component;


/**
 * @author syang
 * @date 2011-7-22
 * @describe ����UI�����Ⱦ���ӿ�
 */
public interface Renderer<T  extends UIComponent> {
	/**
	 * �ָ����
	 * @param context ����������
	 * @param component �������
	 */
	void decode(FacesContext context,T component) throws Exception;
	/**
	 * ���뿪ʼ����
	 * @param context ����������
	 * @param component �������
	 */
	void encodeBegin(FacesContext context,T component) throws Exception;
	/**
	 * �������岿��
	 * @param context ����������
	 * @param component �������
	 */
	void encodeBody(FacesContext context,T component) throws Exception;
	/**
	 * ����β��
	 * @param context ����������
	 * @param component �������
	 */
	void encodeEnd(FacesContext context,T component) throws Exception;
}
