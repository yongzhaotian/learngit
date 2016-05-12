package com.amarsoft.app.als.bizobject.customer;

import com.amarsoft.app.als.customer.common.action.GetCustomer;
import com.amarsoft.are.ARE;

/**
 * @author syang
 * @since 2011-6-12
 * @describe 该类实现代理manager中的方法，用户调用时，只需要调用本类即可，不需要知道关于manager的信息。
 */
public class CustomerModelAction {
	private CustomerManager manager = null;
	public static final String  FACTORY_CLASS="com.amarsoft.app.als.bizobject.customer.DefaultCustomerManagerFactory";
	
	public CustomerModelAction(){}
	/**
	 * 根据参数customerType(客户类型)初始化客户对象,此客户对象仅有客户的管理属性,并不是一个完整的客户对象
	 * @param customerType
	 * @return
	 */
	public Customer initByCustomerType(String customerType){
		//获取客户对象管理器
		init(customerType);
		//创建客户对象
		return manager.newInstance();
	}
	/**
	 * 根据参数customerID(客户编号)初始化客户对象,此客户对象是一个完整的客户对象
	 * @param customerID
	 * @return
	 */
	public Customer initByCustomerID(String customerID){
		init(getCustomerType(customerID));
		return manager.getInstance(customerID);
	}
	
	/**
	 * 根据参数customerID(客户编号)初始化客户对象，此客户对象是仅包含CUSTOMER_MODEL信息的轻客户对象
	 * @param customerID
	 * @return
	 */
	public Customer initModelByCustomerID(String customerID){
		init(getCustomerType(customerID));
		return manager.getEasyInstance(customerID);
	}
	/**
	 * 初始化客户管理对象
	 * @param customerType
	 */
	private void init(String customerType){
		try {
			this.manager = CustomerManagerFactory.getFactory(FACTORY_CLASS).getManager(customerType);
		} catch (Exception e) {
			ARE.getLog().error("获取客户对象管理器出错!");
			e.printStackTrace();
		}
	}
	/**
	 * 获取当前客户对象的管理器对象
	 * @return
	 */
	public CustomerManager getManager() {
		return manager;
	}
	/**
	 * 根据客户编号获取客户类型
	 * @param customerID
	 * @return
	 */
	public static String getCustomerType(String customerID) {
		String sCustomerType ="";
		try {
			sCustomerType=GetCustomer.getCustomerType(customerID);
		} catch (Exception e) {
			ARE.getLog().error("获取客户类型出错!");
			e.printStackTrace();
		}
		return sCustomerType;
	}
}
