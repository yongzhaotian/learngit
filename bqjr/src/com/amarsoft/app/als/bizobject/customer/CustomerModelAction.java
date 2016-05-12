package com.amarsoft.app.als.bizobject.customer;

import com.amarsoft.app.als.customer.common.action.GetCustomer;
import com.amarsoft.are.ARE;

/**
 * @author syang
 * @since 2011-6-12
 * @describe ����ʵ�ִ���manager�еķ������û�����ʱ��ֻ��Ҫ���ñ��༴�ɣ�����Ҫ֪������manager����Ϣ��
 */
public class CustomerModelAction {
	private CustomerManager manager = null;
	public static final String  FACTORY_CLASS="com.amarsoft.app.als.bizobject.customer.DefaultCustomerManagerFactory";
	
	public CustomerModelAction(){}
	/**
	 * ���ݲ���customerType(�ͻ�����)��ʼ���ͻ�����,�˿ͻ�������пͻ��Ĺ�������,������һ�������Ŀͻ�����
	 * @param customerType
	 * @return
	 */
	public Customer initByCustomerType(String customerType){
		//��ȡ�ͻ����������
		init(customerType);
		//�����ͻ�����
		return manager.newInstance();
	}
	/**
	 * ���ݲ���customerID(�ͻ����)��ʼ���ͻ�����,�˿ͻ�������һ�������Ŀͻ�����
	 * @param customerID
	 * @return
	 */
	public Customer initByCustomerID(String customerID){
		init(getCustomerType(customerID));
		return manager.getInstance(customerID);
	}
	
	/**
	 * ���ݲ���customerID(�ͻ����)��ʼ���ͻ����󣬴˿ͻ������ǽ�����CUSTOMER_MODEL��Ϣ����ͻ�����
	 * @param customerID
	 * @return
	 */
	public Customer initModelByCustomerID(String customerID){
		init(getCustomerType(customerID));
		return manager.getEasyInstance(customerID);
	}
	/**
	 * ��ʼ���ͻ��������
	 * @param customerType
	 */
	private void init(String customerType){
		try {
			this.manager = CustomerManagerFactory.getFactory(FACTORY_CLASS).getManager(customerType);
		} catch (Exception e) {
			ARE.getLog().error("��ȡ�ͻ��������������!");
			e.printStackTrace();
		}
	}
	/**
	 * ��ȡ��ǰ�ͻ�����Ĺ���������
	 * @return
	 */
	public CustomerManager getManager() {
		return manager;
	}
	/**
	 * ���ݿͻ���Ż�ȡ�ͻ�����
	 * @param customerID
	 * @return
	 */
	public static String getCustomerType(String customerID) {
		String sCustomerType ="";
		try {
			sCustomerType=GetCustomer.getCustomerType(customerID);
		} catch (Exception e) {
			ARE.getLog().error("��ȡ�ͻ����ͳ���!");
			e.printStackTrace();
		}
		return sCustomerType;
	}
}
