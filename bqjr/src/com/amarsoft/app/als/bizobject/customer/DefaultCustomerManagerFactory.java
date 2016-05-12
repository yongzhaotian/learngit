package com.amarsoft.app.als.bizobject.customer;

import java.util.HashMap;

/**
 * @author syang
 * @since 2011-6-12
 * @describe �ͻ�������������һ��Ĭ��ʵ��
 */
public class DefaultCustomerManagerFactory extends CustomerManagerFactory{
	public static final String ENT_CUSTOMERTYPE="01";		//��˾�ͻ�
	public static final String LARGE_ENT_CUSTOMERTYPE="0110";//��˾�ͻ��ͻ����ʹ���
//	public static final String SMALL_ENT_CUSTOMERTYPE="0120";//С��ҵ�ͻ��ͻ����ʹ���
	public static final String IND_CUSTOMERTYPE="03";		//���˿ͻ�
	public static final String PERSONAL_IND_CUSTOMERTYPE="0310"; //���˿ͻ��ͻ����ʹ���
	public static final String INDIVIDUL_IND_CUSTOMERTYPE="0320"; //���徭Ӫ���ͻ����ʹ���
	public static final String FARMER_IND_CUSTOMERTYPE="0330"; //ũ���ͻ����ʹ���
	public static final String FINANCE_CUSTOMERTYPE="04";		//ͬҵ�ͻ��ͻ����ʹ���
	public static final String GROUP_CUSTOMERTYPE="0210";			//ʵ�弯�ſͻ��ͻ����ʹ���
	public static final String UGBODY_CUSTOMERTYPE="0240";			//������ͻ��ͻ����ʹ���
	public static final String INDUGBODY_CUSTOMERTYPE="024020";			//����������ͻ��ͻ����ʹ���
	public static final String ENTUGBODY_CUSTOMERTYPE="024010";			//��˾������ͻ��ͻ����ʹ���
	public static final String INDCOM_CUSTOMERTYPE="05";			//���幤�̻��ͻ����ʹ���
	protected DefaultCustomerManagerFactory(){
	}
	/**
	 * ��ȡ������
	 * @param ValueType ���(Ŀǰ֧��ValueType.CUSTOMER_TYPE,ValueType.CUSTOMER_ID)
	 * @param value ֵ(ValueType.CUSTOMER_TYPE��valueΪ�ͻ����ţ�ValueType.CUSTOMER_ID��valueΪ�ͻ�ID)
	 * @return ������
	 */
	public CustomerManager getManager(String customerType) throws Exception{
		//�趨��ʼ����������
		HashMap<String,String> map = new HashMap<String,String>();
		map.put(ENT_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.EntCustomerManager");
		map.put(LARGE_ENT_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.EntCustomerManager");
//		map.put(SMALL_ENT_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.EntCustomerManager");
		map.put(IND_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.IndCustomerManager");
		map.put(PERSONAL_IND_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.IndCustomerManager");
		map.put(INDIVIDUL_IND_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.IndCustomerManager");
		map.put(FARMER_IND_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.IndCustomerManager");
		map.put(FINANCE_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.FinanceCustomerManager");
		map.put(GROUP_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.GroupCustomerManager");
		map.put(UGBODY_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.GroupCustomerManager");
		map.put(INDUGBODY_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.GroupCustomerManager");
		map.put(ENTUGBODY_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.GroupCustomerManager");
		map.put(INDCOM_CUSTOMERTYPE,"com.amarsoft.app.als.bizobject.customer.IndComCustomerManager");
		
		//���ҿͻ����ӳ���ϵ
		if(customerType.length()<2) throw new Exception("�ͻ�����["+customerType+"]����������λ�����Ϸ�");
		CustomerManager manager = null;
		if(!map.containsKey(customerType))throw new Exception("ϵͳ�в����ڿͻ�������["+customerType+"*]");
		String className = map.get(customerType);
		manager = (CustomerManager)Class.forName(className).newInstance();
		manager.setCustomerType(customerType);
		return manager;
	}
}