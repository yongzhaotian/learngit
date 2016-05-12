package com.amarsoft.app.als.bizobject.customer;

import java.util.HashMap;

/**
 * @author syang
 * @since 2011-6-12
 * @describe 客户管理器工厂的一个默认实现
 */
public class DefaultCustomerManagerFactory extends CustomerManagerFactory{
	public static final String ENT_CUSTOMERTYPE="01";		//公司客户
	public static final String LARGE_ENT_CUSTOMERTYPE="0110";//公司客户客户类型代码
//	public static final String SMALL_ENT_CUSTOMERTYPE="0120";//小企业客户客户类型代码
	public static final String IND_CUSTOMERTYPE="03";		//个人客户
	public static final String PERSONAL_IND_CUSTOMERTYPE="0310"; //个人客户客户类型代码
	public static final String INDIVIDUL_IND_CUSTOMERTYPE="0320"; //个体经营户客户类型代码
	public static final String FARMER_IND_CUSTOMERTYPE="0330"; //农户客户类型代码
	public static final String FINANCE_CUSTOMERTYPE="04";		//同业客户客户类型代码
	public static final String GROUP_CUSTOMERTYPE="0210";			//实体集团客户客户类型代码
	public static final String UGBODY_CUSTOMERTYPE="0240";			//联保体客户客户类型代码
	public static final String INDUGBODY_CUSTOMERTYPE="024020";			//个人联保体客户客户类型代码
	public static final String ENTUGBODY_CUSTOMERTYPE="024010";			//公司联保体客户客户类型代码
	public static final String INDCOM_CUSTOMERTYPE="05";			//个体工商户客户类型代码
	protected DefaultCustomerManagerFactory(){
	}
	/**
	 * 获取管理器
	 * @param ValueType 类别(目前支持ValueType.CUSTOMER_TYPE,ValueType.CUSTOMER_ID)
	 * @param value 值(ValueType.CUSTOMER_TYPE则value为客户类别号，ValueType.CUSTOMER_ID则value为客户ID)
	 * @return 管理器
	 */
	public CustomerManager getManager(String customerType) throws Exception{
		//设定初始化测试数据
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
		
		//查找客户类别映射关系
		if(customerType.length()<2) throw new Exception("客户代码["+customerType+"]长度少于两位，不合法");
		CustomerManager manager = null;
		if(!map.containsKey(customerType))throw new Exception("系统中不存在客户类别代码["+customerType+"*]");
		String className = map.get(customerType);
		manager = (CustomerManager)Class.forName(className).newInstance();
		manager.setCustomerType(customerType);
		return manager;
	}
}