package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

import com.amarsoft.app.als.bizobject.ObjectHelper;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.context.ASUser;

public class FinanceCustomerManager  extends CustomerManager implements Serializable{

	private static final long serialVersionUID = -1311351950436979780L;

	/**
	 * 获取同业客户实例,实例已初始化客户类型及客户管理信息
	 */
	public FinanceCustomer newInstance() {
		FinanceCustomer financeCustomer = new FinanceCustomer();
		//赋值客户类型
		financeCustomer.setCustomerType(this.getCustomerType());
		financeCustomer.finFlag = true;
		return (FinanceCustomer) loadCustomerModelInfo(financeCustomer);

	}

	/**
	 * 获取同业客户实例,实例已初始化客户类型及客户管理信息
	 */
	public FinanceCustomer getInstance(String customerID) {
		FinanceCustomer financeCustomer = new FinanceCustomer();
		financeCustomer.setCustomerID(customerID);
		financeCustomer.finFlag = true;
		return loadFinanceCustomer(financeCustomer);
	}
	
	/**
	 * 通过客户编号获取轻同业客户实例
	 */
	public FinanceCustomer getEasyInstance(String customerID){
		FinanceCustomer financeCustomer = new FinanceCustomer();
		financeCustomer.setCustomerID(customerID);
		financeCustomer.setCustomerType(this.getCustomerType());
		financeCustomer.finFlag = true;
		return (FinanceCustomer) loadCustomerModelInfo(financeCustomer);
	}
	/**
	 * 装载同业客户(装载客户管理信息与客户基本信息)
	 * @param entCustomer
	 * @return
	 */
	private FinanceCustomer loadFinanceCustomer(FinanceCustomer financeCustomer){
		//装载客户基本信息
		financeCustomer = loadCustomerInfo(financeCustomer);
		//装载客户管理信息
		financeCustomer = (FinanceCustomer) loadCustomerModelInfo(financeCustomer);
		return financeCustomer;
	}
	
	protected FinanceCustomer loadCustomerInfo(FinanceCustomer financeCustomer){
		//装载客户总表(jbo.app.CUSTOMER_INFO)中客户基本信息
		Customer customer=super.loadCustomerInfo(financeCustomer);
		if(customer instanceof FinanceCustomer){
			financeCustomer=(FinanceCustomer)customer;
		}else{
			ARE.getLog().warn("装载客户基本信息出错!");
		}
		//销毁customer实例
		customer=null;
		//装载同业客户表(jbo.app.ENT_INFO)中客户基本信息
		try {
			BizObject boFinanceInfo=getFinanceInfoByCustomerID(financeCustomer.getCustomerID());
			
			if(boFinanceInfo!=null){
				ObjectHelper.fillObjectFromJBO(financeCustomer, boFinanceInfo);
			}else{
				ARE.getLog().error("客户未找到,ENT_INFO.CustomerID=[:"+financeCustomer.getCustomerID()+"],请确认!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return financeCustomer;
	}
	
	
	
	private BizObject getFinanceInfoByCustomerID(String customerID) throws JBOException {
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID).getSingleResult();
	}

	@Override
	public void saveInstance(Customer customer) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public String addCustomer(Customer customer,String userID,JBOTransaction tx) throws Exception  {
		ASUserObject curUser = ASUserObject.getUser(userID);
		
		String sCustomerExistsOrBelongStatus="";//客户存在与否及其管户关系
		String sReturnInfo="";//新增客户完成后返回值
		FinanceCustomer financeCustomer=(FinanceCustomer) customer;
		try {
			//新增客户校验
			sCustomerExistsOrBelongStatus = this.checkCustomerAdd(financeCustomer,curUser.getUserID());
			
		} catch (Exception e) {
			ARE.getLog().error("校验客户是否存在及管户关系出错!");
			e.printStackTrace();
		}
		if(StringX.isEmpty(sCustomerExistsOrBelongStatus)){
			ARE.getLog().warn("校验客户是否存在及管户关系出现异常!");
		}else{
			/****初始化事务开始****/
			if(tx!=null){
				//根据客户存在与否及其管户关系,进行新增客户操作
					sReturnInfo=addCustomerAction(sCustomerExistsOrBelongStatus,financeCustomer,curUser,tx);
			}else{
				throw new Exception("传入的事务为空!");
			}
		}
		return sReturnInfo;
	}
	
	/**
	 * 新增同业客户概况信息(ENT_INFO)
	 * @param financeCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	protected static void insertFinanceInfo(FinanceCustomer financeCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = m.newObject();
		bo.setAttributeValue("CustomerID", financeCustomer.getCustomerID());			// 客户ID
		bo.setAttributeValue("EnterpriseName",financeCustomer.getCustomerName());	// 客户名称
		bo.setAttributeValue("AlikeType", financeCustomer.getAlikeType()); //同业类型
		bo.setAttributeValue("AlikeTypeDown", financeCustomer.getAlikeTypeDown()); //同业子类型
		bo.setAttributeValue("StateType", financeCustomer.getStateType()); //国别
		bo.setAttributeValue("InputOrgID",financeCustomer.getInputOrgID());				// 登记机构
		bo.setAttributeValue("UpdateOrgID",financeCustomer.getUpdateOrgID());				// 更新机构
		bo.setAttributeValue("InputUserID",financeCustomer.getInputUserID());			// 登记人
		bo.setAttributeValue("UpdateUserID",financeCustomer.getUpdateDate());			// 更新人
		bo.setAttributeValue("InputDate",financeCustomer.getInputDate());				// 登记日期
		bo.setAttributeValue("UpdateDate",financeCustomer.getUpdateDate());				// 更新日期
		bo.setAttributeValue("TempSaveFlag", "1");				// 暂存标志
		if("Ent05".equals(financeCustomer.getCertType())){	// 金融机构许可证
			bo.setAttributeValue("BankLicense",financeCustomer.getCertID());		
		}else if("Ent01".equals(financeCustomer.getCertType())){	// 组织机构代码		
			bo.setAttributeValue("CorpID",financeCustomer.getCertID());			
		}else{
			bo.setAttributeValue("SWIFTCode",financeCustomer.getCertID());	//	SWIFT代码	
		}
		tx.join(m);
		m.saveObject(bo);
	}

	@Override
	public String getRightType(Customer customer, ASUser user) {
		// TODO Auto-generated method stub
		return null;
	}

}
