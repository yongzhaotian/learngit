package com.amarsoft.app.als.bizobject.customer;

import java.util.List;

import com.amarsoft.app.als.bizobject.ObjectHelper;
import com.amarsoft.app.als.customer.common.action.GetCustomer;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.context.ASUser;

/**
 * @author syang
 * @since 2011-6-11
 * @describe 客户管理类接口
 */
public abstract class CustomerManager {
	private String customerType=null;
	public String getCustomerType() {
		return customerType;
	}
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	/**
	 * 创建一个客户对象实例
	 * @return
	 */
	public abstract Customer newInstance();
	/**
	 * 根据客户号，获取一个客户对象实例
	 * @param customerID 客户号
	 * @return
	 */
	public abstract Customer getInstance(String customerID);
	/**
	 * 根据客户编号，获得一个轻客户对象实例，只装载部分常用数据
	 * @param customerID
	 * @return
	 */
	public abstract Customer getEasyInstance(String customerID);
	/**
	 * 保存一个客户对象实例
	 * @param customer
	 */
	public abstract void saveInstance(Customer customer);
	/**
	 * 获取用户对于客户对象的权限
	 * @param customer 客户对象
	 * @param user 用户对象
	 * @return
	 */
	public abstract String getRightType(Customer customer,ASUser user);
	/**
	 * 装载客户基本信息
	 * @param customer
	 * @return
	 */
	public Customer loadCustomerInfo(Customer customer){
		try {
			//---------------装载CUSTOMER_INFO表信息--------------------------------
			BizObject boCustomerInfo=JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customer.getCustomerID()).getSingleResult();
			if(boCustomerInfo!=null){
				//由查询得到的CUSTOMER_INFO表JBO对象填充客户对象
				ObjectHelper.fillObjectFromJBO(customer, boCustomerInfo);
			}else{
				ARE.getLog().error("客户未找到,CUSTOMER_INFO.CustomerID=["+customer.getCustomerID()+"],请确认!");
			}
			
			//--------------装载管户人，管户机构信息---------------------------------
			BizObject boCustomerBelong = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG").createQuery("CustomerID=:CustomerID and BelongAttribute='1'")
										.setParameter("CustomerID",customer.getCustomerID()).getSingleResult();
			if(boCustomerBelong!=null){
				String sMgtOrgID = boCustomerBelong.getAttribute("OrgID").getString();
				String sMgtUserID = boCustomerBelong.getAttribute("UserID").getString();
				if(sMgtOrgID==null)	sMgtOrgID = "";
				if(sMgtUserID==null) 	sMgtUserID = "";
				
				customer.setMgtOrgID(sMgtOrgID);
				customer.setMgtUserID(sMgtUserID);
			}else{
				customer.setMgtOrgID("");
				customer.setMgtUserID("");
			}
			
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	/**
	 * 装载客户管理信息
	 * @param customer
	 * @return
	 */
	public Customer loadCustomerModelInfo(Customer customer){
		try {
			BizObject boCustomerModel=JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_MODEL").
				createQuery("CustomerType=:CustomerType and IsInUse='1'").setParameter("CustomerType",customer.getCustomerType()).getSingleResult();
			if(boCustomerModel!=null){
				ObjectHelper.fillObjectFromJBO(customer, boCustomerModel);
			}else{
			ARE.getLog().error("适用于CUSTOMER_MODEL.CustomerType=["+this.getCustomerType()+"的客户管理模型未定义,请确认!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	/**
	 * 校验客户新增状态
	 * @param customer:客户对象实例
	 * @param userID:当前用户编号
	 * @return 返回5种类型返回值
	 *      1.客户存在
	 *        1.1:客户的客户类型与新增时录入的客户类型不一致
	 *        		---返回提示信息"客户已存在,不能在此引入!"
	 *        1.2:客户的客户类型与新增时录入的客户类型一致,则获取客户的管户关系
	 *        	1.2.1:客户与当前用户存在管户关系
	 *        		---返回"客户已存在且已被自己引入!"
	 *        	1.2.2:客户与当前用户不存在管户关系
	 *          	1.2.2.1:客户有管户客户经理
	 *          		---返回"05@客户编号"
	 *          	1.2.2.2:客户没有管户客户经理
	 *          		---返回"04@客户编号"
	 *      2.客户不存在
	 *      	---返回"01"
	 *      
	 */
	public String checkCustomerAdd(Customer customer, String userID) throws Exception {
		String sReturnStatus="";//返回值
		//客户编号,客户类型(系统中该客户的客户类型),客户类型名称(系统中该客户的客户类型名称),证件类型名称
		String sCustomerID="",sHaveCustomerType="",sHaveCustomerTypeName="",sCertTypeName="";
		/**第一步:通过证件类型、证件号码获取客户对象**/
		BizObject boCustomerInfo = getCustomerByCertTypeAndID(customer.getCertType(),customer.getCertID());
		/**第二步:判断录入的客户是否存在**/
		if(boCustomerInfo != null){
			sCustomerID = boCustomerInfo.getAttribute("CustomerID").getString();//客户编号
			sHaveCustomerType = boCustomerInfo.getAttribute("CustomerType").getString();//客户类型
			BizObject boCustomerModel=getCustomerModelByCustomerType(sHaveCustomerType);
			if(boCustomerModel!=null){
				sHaveCustomerTypeName = boCustomerModel.getAttribute("CustomerTypeName").getString();//客户类型名称
				//sCertTypeName=NameManager.getItemName("CertType",customer.getCertType());
				sCertTypeName=customer.getCertType();
				//若系统中该客户类型与新增客户时所选择的客户类型不一致,则提示
				if(!StringX.isEmpty(sHaveCustomerType) && !sHaveCustomerType.equalsIgnoreCase(customer.getCustomerType())){
					sReturnStatus="证件类型:"+sCertTypeName+",证件号码:"+customer.getCertID()+"的客户已存在.客户类型为"+sHaveCustomerTypeName+",不能在此引入!";
				}else{
					//检查客户管户关系
					sReturnStatus=checkCustomerBelong(sCustomerID,userID);
					//02:客户已存在并已被自己引入,返回“提示信息”
					if("02".equalsIgnoreCase(sReturnStatus)){
						sReturnStatus="证件类型:"+sCertTypeName+",证件号码:"+customer.getCertID()+"的客户已存在,并在"+sHaveCustomerTypeName+"客户管理页面被您引入过，请确认!";
					}
					//05:客户已存在但已有管户客户经理,返回“客户管户状态@提示信息@客户编号”
					if("05".equalsIgnoreCase(sReturnStatus)){
						sReturnStatus=sReturnStatus+"@证件类型:"+sCertTypeName+",证件号码:"+customer.getCertID()+"的客户已成功引入,您需要提交权限申请来获取该客户权限!";
						sReturnStatus=sReturnStatus+"@"+sCustomerID;
					}
					//04:客户已存在且没有管户客户经理,返回“客户管户状态@客户编号”
					if("04".equalsIgnoreCase(sReturnStatus)){
						sReturnStatus=sReturnStatus+"@"+sCustomerID;
					}
				}
			}else{
				throw new Exception("客户编号为"+sCustomerID+"的客户的客户类型异常,其客户类型代码为"+sHaveCustomerType+"在系统中未定义,请确认!");
			}
		}else{
			//该客户在系统中不存在
			sReturnStatus = "01";
		}
		return sReturnStatus;
	}
	/**
	 * 新增客户
	 * @param customer
	 * @param userID
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public abstract String addCustomer(Customer customer,String userID,JBOTransaction tx) throws Exception;
	/**
	 * 根据客户存在与否及客户管户关系状态进行客户新增操作
	 * @param sCustomerExistsOrBelongStatus:客户存在与否及客户管户关系状态
	 *        05：客户已存在,且已存在管户客户经理
	 *        04: 客户已存在,但不存在管户客户经理
	 *        01: 客户不存在
	 * @param curUser：当前用户
	 * @param tx:事务
	 * @return 
	 * @throws JBOException 
	 */
	protected String addCustomerAction(String sCustomerExistsOrBelongStatus,Customer customer,ASUserObject curUser,JBOTransaction tx) throws JBOException{
		/*
		 * sCustomerExistsOrBelongStatus：客户存在与否及客户管户关系状态说明
		 *	    1.客户存在
		 *        1.1:客户的客户类型与新增时录入的客户类型不一致
		 *        		---sCustomerExistsOrBelongStatus="客户已存在,不能在此引入!"
		 *        1.2:客户的客户类型与新增时录入的客户类型一致,则获取客户的管户关系
		 *        	1.2.1:客户与当前用户存在管户关系
		 *        		---sCustomerExistsOrBelongStatus="客户已存在且已被自己引入!"
		 *        	1.2.2:客户与当前用户不存在管户关系
		 *          	1.2.2.1:客户有管户客户经理
		 *          		---sCustomerExistsOrBelongStatus="05@提示信息@客户编号"
		 *          	1.2.2.2:客户没有管户客户经理
		 *          		---sCustomerExistsOrBelongStatus="04@客户编号"
		 *      2.客户不存在
		 *      	---sCustomerExistsOrBelongStatus="01"
		 */
		String sReturnInfo="";
		//01:要新增的客户在系统不存在,04开头:要新增的客户已在系统中存在,但没有管户客户经理
		if(!"01".equalsIgnoreCase(sCustomerExistsOrBelongStatus) && !sCustomerExistsOrBelongStatus.startsWith("04")){
			//05开头：客户已存在,且已存在管户客户经理
			if(sCustomerExistsOrBelongStatus.startsWith("05")){
				String[] sReturnStatuInfos=sCustomerExistsOrBelongStatus.split("@");
				//由于客户目前已有管户客户经理，不赋予任何权限
				insertCustomerBelong("2",sReturnStatuInfos[2],curUser.getUserID(),curUser.getOrgID(),tx);
				//只返回提示信息,不用返回客户编号
				sReturnInfo=sReturnStatuInfos[0]+"@"+sReturnStatuInfos[1];
			}else{
				sReturnInfo=sCustomerExistsOrBelongStatus;
			}
		}else{
			//客户已在系统中存在但无管户客户经理,则赋给所有权限
			if(sCustomerExistsOrBelongStatus.startsWith("04")){
				String[] sReturnStatuInfos=sCustomerExistsOrBelongStatus.split("@");
				//由于客户目前没有管户客户经理，赋予所有权限
				insertCustomerBelong("1",sReturnStatuInfos[1],curUser.getUserID(),curUser.getOrgID(),tx);
				sReturnInfo=sCustomerExistsOrBelongStatus;
			}
			//01：客户不存在,则新增客户
			if("01".equalsIgnoreCase(sCustomerExistsOrBelongStatus)){
				//向CUSTOMER_INFO新增一条记录
				insertCustomerInfo(customer,tx);
				//根据传入对象真正是哪一类具体的对象,决定向哪张表新增数据
				if(customer instanceof EntCustomer){
					//向ENT_INFO新增一条记录
					EntCustomerManager.insertEntInfo((EntCustomer)customer,tx);
				}else if(customer instanceof IndCustomer){
					//向IND_INFO新增一条记录
					IndCustomerManager.insertIndInfo((IndCustomer)customer,tx);
				}else if(customer instanceof FinanceCustomer){
					//向ENT_INFO新增一条记录
					//FinanceCustomerManager.insertFinanceInfo((FinanceCustomer)customer,tx);
				}
				//向CUSTOMER_INFO新增一条记录
				//新增客户，默认赠予全部权限
				insertCustomerBelong("1",customer.getCustomerID(),curUser.getUserID(),curUser.getOrgID(),tx);
				//返回值拼接上客户编号
				sReturnInfo=sCustomerExistsOrBelongStatus+"@"+customer.getCustomerID();
			}
		}
		return sReturnInfo;
	}
	/**
	 * 通过客户证件类型与证件编号获取客户JBO对象
	 * @param sCertType
	 * @param sCertID
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCustomerByCertTypeAndID(String sCertType,String sCertID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO").createQuery("CertType=:CertType and CertID=:CertID").setParameter("CertType",sCertType).setParameter("CertID",sCertID).getSingleResult();
	}
	/**
	 * 通过客户组织机构代码获取客户数量，判断客户是否存在
	 * @param sCorpID
	 * @return
	 * @throws JBOException
	 */
	public static int getCustomerByCorpID(String sCorpID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("CorpID=:CorpID").setParameter("CorpID",sCorpID).getTotalCount();
	}
	/**
	 * 通过客户营业执照代码获取客户数量，判断客户是否存在
	 * @param sLicenceNO
	 * @return
	 * @throws JBOException
	 */
	public static int getCustomerByLicenseNO(String sLicenseNO) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("LicenseNO=:LicenseNO").setParameter("LicenseNO",sLicenseNO).getTotalCount();
	}
	/**
	 * 通过客户营业执照代码和组织机构代码获取客户数量，判断客户是否存在
	 * @param sLicenceNO
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCustomerByLicenseNoAndCorpID(String sLicenseNO,String sCorpID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("LicenseNO=:LicenseNO or CorpID=:CorpID order by CorpID").setParameter("LicenseNO",sLicenseNO).setParameter("CorpID", sCorpID).getSingleResult();
	}
	/**
	 * 通过客户类型获取客户配置(CUSTOMER_MODEL)JBO对象
	 * @param sCustomerType
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCustomerModelByCustomerType(String sCustomerType) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_MODEL").createQuery("CustomerType=:CustomerType").setParameter("CustomerType",sCustomerType).getSingleResult();
	}
	/**
	 * 获取客户柜员关联关系
	 * @param customerID 客户号
	 * @param userID 柜员号
	 * @return
	 * @throws JBOException
	 */
	@SuppressWarnings("unchecked")
	public List<BizObject> getCustomerBelongList(String customerID,String userID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG")
				.createQuery("CustomerID=:CustomerID and UserID=:UserID")
				.setParameter("CustomerID",customerID)
				.setParameter("UserID",userID)
				.getResultList();
	}
	/**
	 * @param sCustomerID:客户编号
	 * @param sUserID:用户编号
	 * @return 客户与用户之间的管户关系
	 * 			02：用户已与该客户建立有效关联
	 * 			04：当前用户没有与该客户建立关联,且没有和任何客户建立主办权
	 * 			05：当前用户没有与该客户建立关联,但和其他客户建立主办权
	 * @throws JBOException
	 */
	protected static String checkCustomerBelong(String sCustomerID,String sUserID) throws JBOException{
		String sReturnStatus="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		int iCount = 0;
		//获取当前客户是否与当前用户建立了关联
		m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		q = m.createQuery("CustomerID=:CustomerID and UserID=:UserID");
		q.setParameter("CustomerID",sCustomerID).setParameter("UserID",sUserID);
		iCount = q.getTotalCount();
		if(iCount > 0){
			//用户已与该客户建立有效关联
			sReturnStatus = "02";
		}else{
			//检查该客户是否有管户人
			q = m.createQuery("CustomerID=:CustomerID and BelongAttribute=:BelongAttribute");
			q.setParameter("CustomerID",sCustomerID).setParameter("BelongAttribute","1");
			iCount = q.getTotalCount();
			if(iCount > 0){
				//当前用户没有与该客户建立关联,但和其他客户建立主办权
				sReturnStatus = "05";
			}else{
				//当前用户没有与该客户建立关联,且没有和任何客户建立主办权
				sReturnStatus = "04";
			}
		}
		return sReturnStatus;
	}
	/**
  	 * 插入数据至CUSTOMER_BELONG
  	 * @param attribute [主办权，信息查看权，信息维护权，业务办理权]标志
  	 * @throws JBOException
  	 */
	protected void insertCustomerBelong(String attribute,String customerID,String userID,String orgID,JBOTransaction tx) throws JBOException{
		String sToday = StringFunction.getToday();
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID",customerID); 		// 客户ID
		bo.setAttributeValue("OrgID",orgID);				// 有权机构ID
		bo.setAttributeValue("UserID",userID);				// 有权人ID
		bo.setAttributeValue("BelongAttribute",attribute);	// 主办权
		bo.setAttributeValue("BelongAttribute1",attribute);	// 信息查看权
		bo.setAttributeValue("BelongAttribute2",attribute);	// 信息维护权
		bo.setAttributeValue("BelongAttribute3",attribute);	// 业务办理权
		bo.setAttributeValue("BelongAttribute4",attribute);
		bo.setAttributeValue("InputOrgID",orgID);			// 登记机构
		bo.setAttributeValue("InputUserID",userID);			// 登记人
		bo.setAttributeValue("InputDate",sToday);			// 登记日期
		bo.setAttributeValue("UpdateDate",sToday);			// 更新日期
		tx.join(m);
		m.saveObject(bo);
	}
	/**
	 * 插入数据至CUSTOMER_INFO
	 * @param cusotmerType 客户类型，不同的客户类型，插入的字段会有所不同
	 * @throws JBOException 
	 */
	protected void insertCustomerInfo(Customer customer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = m.newObject();
		bo.setAttributeValue("CustomerName", customer.getCustomerName());	// 客户名称
		bo.setAttributeValue("CustomerType", customer.getCustomerType());	// 客户类型
		bo.setAttributeValue("CertType", customer.getCertType());	// 证件类型
		bo.setAttributeValue("CertID", customer.getCertID());	//证件号码
		bo.setAttributeValue("InputOrgID", customer.getInputOrgID());			// 登记机构
		bo.setAttributeValue("InputUserID", customer.getInputUserID());		// 登记用户
		bo.setAttributeValue("InputDate", customer.getInputDate());			// 登记日期
		bo.setAttributeValue("Channel", "1");				// 来源渠道
		bo.setAttributeValue("CreditFlag", "2");			//授信客户标志
		tx.join(m);
		m.saveObject(bo);
		//将新增的客户的客户编号赋值给客户对象
		customer.setCustomerID(bo.getAttribute("CustomerID").getString());
	}
	
	/**
	 * 客户注册检查 01-新增客户  02-有主办人的存量客户 03-无主办人的存量客户 04-主办人为自己的存量客户 05-非授信客户的存量客户
	 * @param customer
	 * @param userID
	 * @return
	 * @throws Exception
	 */
	public String checkCustomerAddNew(Customer customer,String userID) throws Exception{
		String sReturnStatus="";//返回值
		String sCustomerID=""; //客户编号
		String sCustomerType = "";	//客户大类
		String sOrgNature="";//
		boolean bCorpLicenseUnique=true;//营业执照或组织机构代码是否已存在
		if(customer instanceof EntCustomer){
			EntCustomer entCustomer = (EntCustomer)customer;
			sOrgNature=entCustomer.getOrgNature();
			/**法人企业0101和非法人企业0102注册时会同时检测两类证件类型是否存在，若有一个存在则不允许重复注册**/
			if("0101".equals(sOrgNature)||"0102".equals(sOrgNature)){
				BizObject boEntCustomer = getCustomerByLicenseNoAndCorpID(entCustomer.getLicenseNo(), entCustomer.getCorpID());
				if(boEntCustomer != null){
					sCustomerID = boEntCustomer.getAttribute("CustomerID").getString();
					sCustomerType = GetCustomer.getCustomerType(sCustomerID);
					bCorpLicenseUnique=false;
				}
			}
		}
		
		/**第一步:通过证件类型、证件号码获取客户对象**/
		BizObject boCustomerInfo = getCustomerInfo(customer);
		/**第二步:判断录入的客户是否存在**/
		if(boCustomerInfo != null||!bCorpLicenseUnique){
			if(bCorpLicenseUnique){
				sCustomerID = boCustomerInfo.getAttribute("CustomerID").getString();//客户编号
				sCustomerType = boCustomerInfo.getAttribute("CustomerType").getString();	//客户类型
				/**第三步：判断是否属于同一类型的客户**/
				if(!(sCustomerType.equals(customer.getCustomerType()))){
					sReturnStatus = "06@"+sCustomerID;
				}else{
					sReturnStatus = checkCustomerBelongNew(sCustomerID,userID)+"@"+sCustomerID;
				}
			}else{
				/**第三步：判断是否属于同一类型的客户**/
				if(!(sCustomerType.equals(customer.getCustomerType()))){
					sReturnStatus = "06@"+sCustomerID;
				}else{
					sReturnStatus = checkCustomerBelongNew(sCustomerID,userID)+"@"+sCustomerID;
				}
			}
		}else{
			//该客户在系统中不存在
			sReturnStatus = "01";
		}
		return sReturnStatus;
	} 
	
	/**
	 * @param sCustomerID:客户编号
	 * @param sUserID:用户编号
	 * @return 客户与用户之间的管户关系
	 * 			02：当前用户没有与该客户建立关联,但和其他客户建立主办权
	 * 			03：当前用户没有与该客户建立关联,且没有和任何客户建立主办权
	 * 			04：用户已与该客户建立有效关联
	 * @throws JBOException
	 */
	protected static String checkCustomerBelongNew(String sCustomerID,String sUserID) throws JBOException{
		String sReturnStatus="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		int iCount = 0;
		//获取当前客户是否与当前用户建立了关联
		m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		q = m.createQuery("CustomerID=:CustomerID and UserID=:UserID");
		q.setParameter("CustomerID",sCustomerID).setParameter("UserID",sUserID);
		iCount = q.getTotalCount();
		if(iCount > 0){
			//用户已与该客户建立有效关联
			sReturnStatus = "04";
		}else{
			//检查该客户是否有管户人
			q = m.createQuery("CustomerID=:CustomerID and BelongAttribute=:BelongAttribute");
			q.setParameter("CustomerID",sCustomerID).setParameter("BelongAttribute","1");
			iCount = q.getTotalCount();
			if(iCount > 0){
				//当前用户没有与该客户建立关联,但和其他客户建立主办权
				sReturnStatus = "02";
			}else{
				//当前用户没有与该客户建立关联,且没有和任何客户建立主办权
				sReturnStatus = "03";
			}
		}
		return sReturnStatus;
	}
	
	/**
	 * 获取CUSTOMER_INFO表客户数据对象
	 * @param customer
	 * @return
	 * @throws Exception
	 */
	protected static BizObject getCustomerInfo(Customer customer) throws Exception{
		BizObject bo = null;
		/**个人客户身份证注册需要核对15 18位身份证**/
		if(customer.isInd() && (customer.getCertType().equals("Ind01") || customer.getCertType().equals("Ind08"))){ 
			String sPID = customer.getCertID();
			String sPID15,sPID18;
			if(sPID.length()==15){
				sPID15 = sPID;
				sPID18 = StringFunction.fixPID(sPID);
			}else{
				sPID15 = sPID.substring(0, 6)+sPID.substring(8,17);
				sPID18 = sPID;
			}
			
			BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
			bo = bom.createQuery("(CertType='Ind01' or CertType='Ind08') and CertID=:CertID").setParameter("CertID",sPID15).getSingleResult();
			if(bo==null){
				bo = bom.createQuery("(CertType='Ind01' or CertType='Ind08') and CertID=:CertID").setParameter("CertID",sPID18).getSingleResult();
			}
		}else{
			bo = getCustomerByCertTypeAndID(customer.getCertType(),customer.getCertID());
		}
		
		return bo;
	}
	
//	/**
//	 * 获取事务
//	 * @return
//	 * @throws Exception 
//	 */
//	protected JBOTransaction getJBOTransaction() throws Exception{
//		JBOTransaction tx=null;
//		try {
//			tx = JBOFactory.createJBOTransaction();
//		} catch (JBOException e1) {
//			ARE.getLog().error("获取事务出错!");
//			e1.printStackTrace();
//		}
//		if(tx==null){
//			throw new Exception("获取事务出错!");
//		}
//		return tx;
//	}
}
