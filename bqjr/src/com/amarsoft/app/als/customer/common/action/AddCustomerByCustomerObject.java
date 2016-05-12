package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.als.bizobject.customer.Customer;
import com.amarsoft.app.als.bizobject.customer.EntCustomer;
import com.amarsoft.app.als.bizobject.customer.IndCustomer;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

/**
 * 通过客户对象新增授信客户（公司/个人授信客户新增通用类）
 * @author Administrator
 *
 */
public class AddCustomerByCustomerObject {
	
	/**
	 * 新增非存量客户
	 * @param customer
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public static String addNewCustomer(Customer customer,JBOTransaction tx) throws JBOException{
		try{
			customer = initCustomerInfo(customer,tx);				//初始化CUSTOMER_INFO
			initCustomerBelong("1",customer,tx);					//初始化CUSTOMER_BELONG
			if(customer instanceof EntCustomer){					//初始化ENT_INFO 或者 IND_INFO
				initEntCustomer((EntCustomer)customer,tx);
			}else if(customer instanceof IndCustomer){
				initIndCustomer((IndCustomer)customer,tx);
			}
			initCustomerAlert(customer,tx);							//初始化客户预警信息
			return customer.getCustomerID();
		}catch(Exception e){
			throw new JBOException("新增客户出错");
		}
	}
	
	/**
	 * 引入没有主办客户经理的客户
	 * @param customer
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public static String importCustomerAsMgt(Customer customer,JBOTransaction tx) throws JBOException{
		try{
			initCustomerBelong("1",customer,tx);
			return "SUCCESS";
		}catch(Exception e){
			throw new JBOException("引入客户出错");
		}
	}
	
	/**
	 * 引入有主办人的客户
	 * @param customer
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public static String importCustomer(Customer customer,JBOTransaction tx) throws JBOException{
		try{
			initCustomerBelong("2",customer,tx);
			return "SUCCESS";
		}catch(Exception e){
			throw new JBOException("引入客户出错");
		}
	}
	/**
	 * 初始化CUSTOMER_INFO
	 * @param customer
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	private static Customer initCustomerInfo(Customer customer,JBOTransaction tx) throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CustomerName", customer.getCustomerName());	// 客户名称
		bo.setAttributeValue("CustomerType", customer.getCustomerType());	// 客户类型
		bo.setAttributeValue("CertType", customer.getCertType());	// 证件类型
		bo.setAttributeValue("CertID", customer.getCertID());	//证件号码
		bo.setAttributeValue("InputOrgID", customer.getInputOrgID());			// 登记机构
		bo.setAttributeValue("InputUserID", customer.getInputUserID());		// 登记用户
		bo.setAttributeValue("InputDate", customer.getInputDate());			// 登记日期
		bo.setAttributeValue("Channel", "1");				// 来源渠道
		bo.setAttributeValue("CreditFlag", "2");			//授信客户标志
		tx.join(bm);
		bm.saveObject(bo);
		//将新增的客户的客户编号赋值给客户对象
		customer.setCustomerID(bo.getAttribute("CustomerID").getString());
		return customer;
	}
	
	/**
	 * 初始化客户关联表CUSTOMER_BELONG
	 * @param sAttribute
	 * @param customer
	 * @param tx
	 * @throws JBOException
	 */
	private static void initCustomerBelong(String sAttribute,Customer customer,JBOTransaction tx) throws JBOException{
		String sToday = StringFunction.getToday();
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID",customer.getCustomerID()); 		// 客户ID
		bo.setAttributeValue("OrgID",customer.getInputOrgID());				// 有权机构ID
		bo.setAttributeValue("UserID",customer.getInputUserID());				// 有权人ID
		bo.setAttributeValue("BelongAttribute",sAttribute);	// 主办权
		bo.setAttributeValue("BelongAttribute1","1");	// 信息查看权
		bo.setAttributeValue("BelongAttribute2",sAttribute);	// 信息维护权
		bo.setAttributeValue("BelongAttribute3",sAttribute);	// 敞口业务办理权
		bo.setAttributeValue("BelongAttribute4","1");	//低风险业务办理权
		bo.setAttributeValue("InputOrgID",customer.getInputOrgID());			// 登记机构
		bo.setAttributeValue("InputUserID",customer.getInputUserID());			// 登记人
		bo.setAttributeValue("InputDate",sToday);			// 登记日期
		bo.setAttributeValue("UpdateDate",sToday);			// 更新日期
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * 初始化ENT_INFO
	 * @param entCustomer
	 * @param tx
	 * @throws JBOException
	 */
	private static void initEntCustomer(EntCustomer entCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID", entCustomer.getCustomerID());			// 客户ID
		if("0103".equals(entCustomer.getOrgNature())||"0104".equals(entCustomer.getOrgNature())
				||"0105".equals(entCustomer.getOrgNature())||"0199".equals(entCustomer.getOrgNature())){
			bo.setAttributeValue("Scope", "5");						//企业规模
		}else{
			bo.setAttributeValue("Scope", entCustomer.getScope());	
		}
		bo.setAttributeValue("EnterpriseName",entCustomer.getCustomerName());	// 客户名称
		bo.setAttributeValue("OrgNature",entCustomer.getOrgNature());		// 机构性质
		bo.setAttributeValue("EmployeeNumber", entCustomer.getEmployeeNumber());	//雇员人数
		bo.setAttributeValue("InputOrgID",entCustomer.getInputOrgID());				// 登记机构
		bo.setAttributeValue("UpdateOrgID",entCustomer.getUpdateOrgID());				// 更新机构
		bo.setAttributeValue("InputUserID",entCustomer.getInputUserID());			// 登记人
		bo.setAttributeValue("UpdateUserID",entCustomer.getUpdateDate());			// 更新人
		bo.setAttributeValue("InputDate",entCustomer.getInputDate());				// 登记日期
		bo.setAttributeValue("UpdateDate",entCustomer.getUpdateDate());				// 更新日期
		bo.setAttributeValue("TempSaveFlag", "1");				// 暂存标志
		bo.setAttributeValue("LicenseNo",entCustomer.getLicenseNo());		// 营业执照号
		bo.setAttributeValue("CorpID",entCustomer.getCorpID());			// 证件编号（组织机构代码证编号）
		bo.setAttributeValue("GROUPFLAG","2");			// 是否集团标志  默认为2 否
		
		/*if("Ent02".equals(entCustomer.getCertType())){	// 证件类型为营业执照
			bo.setAttributeValue("LicenseNo",entCustomer.getCertID());		// 营业执照号
		}else{	// 其他证件		// if("Ent01".equals(certType)){	// 证件类型为组织机构代码	
			bo.setAttributeValue("CorpID",entCustomer.getCertID());			// 证件编号（组织机构代码证编号）
		}*/
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * 初始化IND_INFO
	 * @param indCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void initIndCustomer(IndCustomer indCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.IND_INFO");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID", indCustomer.getCustomerID());			// 客户ID
		bo.setAttributeValue("FullName",indCustomer.getCustomerName());				// 客户名称
		bo.setAttributeValue("CertID",indCustomer.getCertID());						// 证件编号
		bo.setAttributeValue("CertType", indCustomer.getCertType());				// 证件类型
		bo.setAttributeValue("CertID18", indCustomer.getCertID18());				// 18位身份证号
		bo.setAttributeValue("InputOrgID",indCustomer.getInputOrgID());				// 登记机构
		bo.setAttributeValue("UpdateOrgID",indCustomer.getUpdateOrgID());			// 更新机构
		bo.setAttributeValue("InputUserID",indCustomer.getInputUserID());			// 登记人
		bo.setAttributeValue("UpdateUserID",indCustomer.getUpdateDate());			// 更新人
		bo.setAttributeValue("InputDate",indCustomer.getInputDate());				// 登记日期
		bo.setAttributeValue("UpdateDate",indCustomer.getUpdateDate());				// 更新日期
		bo.setAttributeValue("TempSaveFlag", "1");				// 暂存标志
		
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * 初始化客户预警信息
	 * @param customer
	 * @param tx
	 * @throws JBOException
	 */
	public static void initCustomerAlert(Customer customer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ALERT_OBJ_RELA");
		BizObject bo = m.newObject();
		bo.setAttributeValue("RefObjectID", customer.getCustomerID());
		bo.setAttributeValue("AlertStatus", "2");
		tx.join(m);
		m.saveObject(bo);
	}

}
