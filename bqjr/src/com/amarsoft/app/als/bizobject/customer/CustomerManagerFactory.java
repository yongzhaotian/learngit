package com.amarsoft.app.als.bizobject.customer;


/**
 * @author syang
 * @since 2011-6-11
 * @describe �ͻ�����������
 */
public abstract class CustomerManagerFactory {
	private static CustomerManagerFactory factory = null;
	/**
	 * ��ȡһ������ʵ��
	 * @return
	 * @throws ClassNotFoundException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public static CustomerManagerFactory getFactory(String className) throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		if(factory==null){
			factory = (CustomerManagerFactory)Class.forName(className).newInstance();
		}
		return factory;
	}
	public abstract CustomerManager getManager(String customerType) throws Exception;
}
