package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

import com.amarsoft.app.als.bizobject.ObjectHelper;
import com.amarsoft.app.als.customer.common.action.AddCustomerByCustomerObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.context.ASUser;

/**
 * @author syang
 * @since 2011-6-11
 * @describe 个人客户对象管理类
 */
public class IndCustomerManager extends CustomerManager implements Serializable{

	private static final long serialVersionUID = 3770031437841846678L;

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.customer.CustomerManager#newInstance(java.lang.String)
	 */
	public Customer newInstance() {
		IndCustomer indCustomer = new IndCustomer();
		indCustomer.setCustomerType(this.getCustomerType());
		indCustomer.indFlag = true;
		return loadCustomerModelInfo(indCustomer);
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.customer.CustomerManager#getInstance(java.lang.String)
	 */
	public IndCustomer getInstance(String customerID) {
		IndCustomer indCustomer = new IndCustomer();
		indCustomer.setCustomerID(customerID);
		indCustomer.indFlag = true;
		return loadIndCustomer(indCustomer);
	}
	
	/**
	 * 通过客户编号获取个人客户轻型实例
	 */
	public IndCustomer getEasyInstance(String customerID) {
		IndCustomer indCustomer = new IndCustomer();
		indCustomer.setCustomerID(customerID);
		indCustomer.setCustomerType(this.getCustomerType());
		indCustomer.indFlag = true;
		return (IndCustomer) loadCustomerModelInfo(indCustomer);
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.customer.CustomerManager#saveInstance(com.amarsoft.app.als.customer.Customer)
	 */
	public void saveInstance(Customer customer) {

	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.customer.CustomerManager#getRightType(com.amarsoft.app.als.customer.Customer, com.amarsoft.context.ASUser)
	 */
	public String getRightType(Customer customer, ASUser user) {
		return null;
	}

	/**
	 * 装载个人客户管理信息
	 * @param indCustomer
	 * @return
	 */
	protected IndCustomer loadIndCustomerModelInfo(IndCustomer indCustomer){
		//装载客户管理信息
		Customer customer=loadCustomerModelInfo(indCustomer);
		if(customer instanceof IndCustomer){
			indCustomer=(IndCustomer)customer;
		}else{
			ARE.getLog().warn("装载客户管理信息出错!");
		}
		//销毁customer实例
		customer=null;
		return indCustomer;
	}
	
	/**
	 * 装载个体客户管理信息的具体方法
	 */
	public Customer loadCustomerModelInfo(Customer customer) {
		try {
			BizObject boCustomerModel=JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_MODEL").
				createQuery("CustomerType=:CustomerType").setParameter("CustomerType",((IndCustomer)customer).getCustomerType()).getSingleResult();
			if(boCustomerModel!=null){
				ObjectHelper.fillObjectFromJBO(customer, boCustomerModel);
			}else{
			ARE.getLog().error("适用于CUSTOMER_MODEL.TypeID=["+this.getCustomerType()+"]的客户管理模型未定义,请确认!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	
	/**
	 * 装载个体客户业务信息
	 * @param indCustomer
	 * @return indCustomer
	 */
	public IndCustomer loadCustomerInfo(IndCustomer indCustomer){
		//装载客户总表(jbo.app.CUSTOMER_INFO)中客户基本信息
		Customer customer=super.loadCustomerInfo(indCustomer);
		if(customer instanceof IndCustomer){
			indCustomer=(IndCustomer)customer;
		}else{
			ARE.getLog().warn("装载客户基本信息出错!");
		}
		//销毁customer实例
		customer=null;
		//装载公司客户表(jbo.app.ENT_INFO)中客户基本信息
		try {
			BizObject boIndInfo=getIndInfoByCustomerID(indCustomer.getCustomerID());
			if(boIndInfo!=null){
				//该公司证件类型为Ent01组织机构代码
				if("Ind01".equalsIgnoreCase(indCustomer.getCertType())){
					indCustomer.setCertID18(indCustomer.getCertID());
				}
				ObjectHelper.fillObjectFromJBO(indCustomer, boIndInfo);
			}else{
				ARE.getLog().error("客户未找到,IND_INFO.CustomerID=[:"+indCustomer.getCustomerID()+"],请确认!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return indCustomer;
	}
	
	/**
	 * 装载个人客户对象（客户业务信息和客户管理信息）
	 * @param indCustomer
	 * @return	indCustomer
	 */
	private IndCustomer loadIndCustomer(IndCustomer indCustomer){
		indCustomer = loadCustomerInfo(indCustomer);
		indCustomer = loadIndCustomerModelInfo(indCustomer);
		return indCustomer;
	}
	
	/**
	 * 通过客户编号获取个人客户JBO对象
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getIndInfoByCustomerID(String customerID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.IND_INFO").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID).getSingleResult();
	}
	
	/**
	 * 新增客户
	 * @return 检查状态+客户编号
	 */
	public String addCustomer(Customer customer, String userID,JBOTransaction tx) throws Exception{
		String sReturnInfo="";//新增客户完成后返回值
		IndCustomer indCustomer=(IndCustomer) customer;
		//新增客户校验
		sReturnInfo = checkCustomerAddNew(indCustomer,userID);
		if("ERROR".equals(sReturnInfo)){
			throw new Exception("校验客户是否存在及管户关系出现异常!");
		}else{
			String sStatusInfo[] = sReturnInfo.split("@");
			if(sStatusInfo[0].equals("01")){				//系统中不存在的客户直接新增
				//根据客户存在与否及其管户关系,进行新增客户操作
				sReturnInfo = sReturnInfo+"@"+AddCustomerByCustomerObject.addNewCustomer(indCustomer, tx);
			}
		}
		return sReturnInfo;
	}
	
	/**
	 * 新增个人客户概况信息(IND_INFO)
	 * @param entCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	protected static void insertIndInfo(IndCustomer indCustomer,JBOTransaction tx) throws JBOException{
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

}
