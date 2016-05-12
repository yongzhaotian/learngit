package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

import com.amarsoft.app.als.bizobject.ObjectHelper;
import com.amarsoft.app.als.customer.common.action.AddCustomerByCustomerObject;
import com.amarsoft.app.als.customer.common.action.GetCustomer;
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
 * @describe 企业客户管理类
 */
public class EntCustomerManager extends CustomerManager implements Serializable{

	private static final long serialVersionUID = 5469326751174744399L;

	/**
	 * 获取公司客户实例,实例已初始化客户类型及客户管理信息
	 */
	public EntCustomer newInstance() {
		EntCustomer entCustomer = new EntCustomer();
		//赋值客户类型
		entCustomer.setCustomerType(this.getCustomerType());
		entCustomer.entFlag = true;
		return entCustomer;
	}

	/**
	 * 通过客户编号获取公司客户实例
	 */
	public EntCustomer getInstance(String customerID) {
		EntCustomer entCustomer = new EntCustomer();
		entCustomer.setCustomerID(customerID);
		entCustomer.entFlag = true;
		return loadEntCustomer(entCustomer);
	}
	
	/**
	 * 通过客户编号获取轻公司客户实例
	 */
	public EntCustomer getEasyInstance(String customerID){
		EntCustomer entCustomer = new EntCustomer();
		entCustomer.setCustomerID(customerID);
		entCustomer.setCustomerType(this.getCustomerType());
		entCustomer.setOrgNature(getOrgNature(customerID));
		entCustomer.entFlag = true;
		return loadEntCustomerModelInfo(entCustomer);
	}
	/**
	 * 装载公司客户管理信息
	 * @param entCustomer
	 * @return
	 */
	protected EntCustomer loadEntCustomerModelInfo(EntCustomer entCustomer){
		//装载客户管理信息
		Customer customer=loadCustomerModelInfo(entCustomer);
		if(customer instanceof EntCustomer){
			entCustomer=(EntCustomer)customer;
		}else{
			ARE.getLog().warn("装载客户管理信息出错!");
		}
		//销毁customer实例
		customer=null;
		return entCustomer;
	}
	/**
	 * 装载公司客户管理信息
	 * @param Customer
	 * @return
	 */
	public Customer loadCustomerModelInfo(Customer customer) {
		try {
			BizObject boCustomerModel=JBOFactory.createBizObjectQuery("jbo.app.CUSTOMER_MODEL","CUSTOMERTYPE=:CUSTOMERTYPE and IsInUse='1'")
									.setParameter("CUSTOMERTYPE",((EntCustomer)customer).getCustomerType()).getSingleResult(false);
			if(boCustomerModel!=null){
				ObjectHelper.fillObjectFromJBO(customer, boCustomerModel);
			}else{
				ARE.getLog().warn("适用于CUSTOMER_MODEL.CUSTOMERTYPE=["+customer.getCustomerType()+"],OrgNature=["+((EntCustomer)customer).getOrgNature()+"]的客户管理模型未定义,请确认!");
			}
			
			/*如果OrgNature为空则根据客户类型默认显示模板,避免前端出错*/
			String sOrgNature = ((EntCustomer)customer).getOrgNature();
			if(sOrgNature==null || sOrgNature.length()==0){
				sOrgNature = "0101";
			}
			
			BizObject codeModel = JBOFactory.createBizObjectQuery("jbo.sys.CODE_LIBRARY","CodeNo='CustomerOrgType' and ItemNo=:ItemNo and IsInUse='1'")
								.setParameter("ItemNo",sOrgNature).getSingleResult(false);
			if(codeModel!=null){
				customer.setDetailTempletNo(codeModel.getAttribute("ItemAttribute").getString());
			}else{
				ARE.getLog().warn("适用于OrgNature="+((EntCustomer)customer).getOrgNature()+"的显示模板未找到！");
			}
			
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	/**
	 * 装载公司客户(装载客户管理信息与客户基本信息)
	 * @param entCustomer
	 * @return
	 */
	private EntCustomer loadEntCustomer(EntCustomer entCustomer){
		/***通过客户编号初始化公司客户对象时,应先装载客户的基本信息,这样才能在装载客户管理信息时获取公司客户的类型(CustomerType)及机构类型(OrgNature)***/
		//装载客户基本信息
		entCustomer=loadCustomerInfo(entCustomer);
		//装载客户管理信息
		entCustomer=loadEntCustomerModelInfo(entCustomer);
		return entCustomer;
	}
	/**
	 * 装载客户基本信息
	 * @param entCustomer:公司客户对象
	 * @return
	 */
	public EntCustomer loadCustomerInfo(EntCustomer entCustomer){
		//装载客户总表(jbo.app.CUSTOMER_INFO)中客户基本信息
		Customer customer=super.loadCustomerInfo(entCustomer);
		if(customer instanceof EntCustomer){
			entCustomer=(EntCustomer)customer;
		}else{
			ARE.getLog().warn("装载客户基本信息出错!");
		}
		//销毁customer实例
		customer=null;
		//装载公司客户表(jbo.app.ENT_INFO)中客户基本信息
		try {
			BizObject boEntInfo=getEntInfoByCustomerID(entCustomer.getCustomerID());
			if(boEntInfo!=null){
				//该公司证件类型为Ent01组织机构代码
				if("Ent01".equalsIgnoreCase(entCustomer.getCertType())){
					entCustomer.setCorpID(entCustomer.getCertID());
				}
				ObjectHelper.fillObjectFromJBO(entCustomer, boEntInfo);
			}else{
				ARE.getLog().error("客户未找到,ENT_INFO.CustomerID=[:"+entCustomer.getCustomerID()+"],请确认!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return entCustomer;
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
	 * 通过客户编号获取公司客户JBO对象
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getEntInfoByCustomerID(String customerID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID).getSingleResult();
	}

	/**
	 * 新增客户
	 * @return 检查状态+客户编号
	 */
	public String addCustomer(Customer customer, String userID,JBOTransaction tx) throws Exception{
		String sReturnInfo="";//新增客户完成后返回值
		EntCustomer entCustomer=(EntCustomer) customer;
		//新增客户校验
		sReturnInfo = checkCustomerAddNew(entCustomer,userID);
		if("ERROR".equals(sReturnInfo)){
			throw new Exception("校验客户是否存在及管户关系出现异常!");
		}else{
			String sStatusInfo[] = sReturnInfo.split("@");
			if(sStatusInfo[0].equals("01")){				//系统中不存在的客户直接新增
				//根据客户存在与否及其管户关系,进行新增客户操作
				sReturnInfo = sReturnInfo+"@"+AddCustomerByCustomerObject.addNewCustomer(entCustomer, tx);
			}
		}
		return sReturnInfo;
	}
	
	/**
	 * 新增公司客户概况信息(ENT_INFO)
	 * @param entCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	protected static void insertEntInfo(EntCustomer entCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID", entCustomer.getCustomerID());			// 客户ID
		bo.setAttributeValue("EnterpriseName",entCustomer.getCustomerName());	// 客户名称
		bo.setAttributeValue("OrgNature",entCustomer.getOrgNature());		// 机构性质
//		bo.setAttributeValue("GroupFlag", sGroupType);			// 集团客户标志
		bo.setAttributeValue("InputOrgID",entCustomer.getInputOrgID());				// 登记机构
		bo.setAttributeValue("UpdateOrgID",entCustomer.getUpdateOrgID());				// 更新机构
		bo.setAttributeValue("InputUserID",entCustomer.getInputUserID());			// 登记人
		bo.setAttributeValue("UpdateUserID",entCustomer.getUpdateDate());			// 更新人
		bo.setAttributeValue("InputDate",entCustomer.getInputDate());				// 登记日期
		bo.setAttributeValue("UpdateDate",entCustomer.getUpdateDate());				// 更新日期
		bo.setAttributeValue("TempSaveFlag", "1");				// 暂存标志
		
		if("Ent02".equals(entCustomer.getCertType())){	// 证件类型为营业执照
			bo.setAttributeValue("LicenseNo",entCustomer.getCertID());		// 营业执照号
		}else{	// 其他证件		// if("Ent01".equals(certType)){	// 证件类型为组织机构代码	
			bo.setAttributeValue("CorpID",entCustomer.getCertID());			// 证件编号（组织机构代码证编号）
		}
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * 获取机构类型
	 * @param customerID
	 * @return
	 */
	protected static String getOrgNature(String customerID){
		String sOrgNature = "";
		try{
			sOrgNature = GetCustomer.getOrgNatrue(customerID);
		}catch(Exception e){
			ARE.getLog().error("装载轻客户对象时获取机构类型出错");
			e.printStackTrace();
		}
		return sOrgNature;
	}
	
}
