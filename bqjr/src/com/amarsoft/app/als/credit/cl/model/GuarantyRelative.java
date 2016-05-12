package com.amarsoft.app.als.credit.cl.model;

import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 此类管理业务合同与担保的关联关系
 * @author Administrator
 *
 */
public class GuarantyRelative {

	private static String getJBOClassForRelative(String accountType){
		String jboClass = "";
		if(accountType.equals(LmtAccountInfo.LMTACCOUNTTYPE_BA)){
			jboClass = "jbo.app.APPLY_RELATIVE";
		}else if(accountType.equals(LmtAccountInfo.LMTACCOUNTTYPE_BAP)){
			jboClass = "jbo.app.APPROVE_RELATIVE";
		}else if(accountType.equals(LmtAccountInfo.LMTACCOUNTTYPE_BC)){
			jboClass = "jbo.app.CONTRACT_RELATIVE";
		}else{
			ARE.getLog().error("传入非法对象类型！");
		}
		return jboClass;
	}
	/**
	 * 获得业务下的担保合同信息
	 * @param biz
	 * @return
	 * @throws JBOException
	 */
	public  static List<BizObject> getGuarantyContract(LmtAccountInfo businessInfo) throws JBOException
	{
		return getGuarantyContract(businessInfo.getAccountType(),businessInfo.getAccountNo());
	}
	
	/**
	 * 获得业务下的担保合同信息
	 * @param sObjectType
	 * @param sObjectNo
	 * @return
	 * @throws JBOException
	 */
	@SuppressWarnings("unchecked")
	public  static List<BizObject> getGuarantyContract(String sObjectType,String sObjectNo) throws JBOException
	{
		
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.GUARANTY_CONTRACT");
		List<BizObject>  lstGC=m.createQuery(" O.SerialNo in (SELECT AR.ObjectNo FROM "+getJBOClassForRelative(sObjectType)+" AR " +
												" WHERE AR.SerialNo = :SerialNo  " +
												" AND AR.ObjectType = 'GuarantyContract' )")
									.setParameter("SerialNo", sObjectNo)
									.getResultList(false); 
		
		return lstGC;
	}
	
	/**
	 * 获得担保对应的合同
	 * <li>不将额度和未完成登记的合同计算在内
	 * @return
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public static AccountManager getGuarantyBusiness(BizObject biz) throws JBOException
	{
		AccountManager  accountManager=new AccountManager();
		String sGuarantyNo=biz.getAttribute("SerialNo").getString();
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		//List<BizObject>  lstBc=m.createQuery("   Status in ('210','230') and BusinessType not like '3%' and SerialNo in (SELECT  AR.SerialNo  FROM jbo.app.AGR_CRE_SEC_RELA AR " +
		List<BizObject>  lstBc=m.createQuery("   (FinishDate is null or FinishDate <> '') and BusinessType not like '3%' and SerialNo in (SELECT  AR.SerialNo  FROM jbo.app.CONTRACT_RELATIVE AR " +
												" WHERE AR.ObjectNo = :objectNo  " +
												" AND AR.ObjectType = 'GuarantyContract')")
									.setParameter("objectNo", sGuarantyNo)
									.getResultList(false);  
		for(BizObject bo:lstBc)
		{
			BusinessContractAccount binfo=new BusinessContractAccount(bo,true);
			accountManager.addAccountInfo(binfo);
		}
		return accountManager;
		 
	}
	
	/**
	 * 获得该业务占用担保的金额，计算规则为，名义金额和担保引入金额
	 * <li>返回结果为=min(业务名义金额，本次担保金额)
	 * <li> GUR_SERIALNO 为Guaranty_Contract 流水号 
	 * <li> SerialNo  为业务流水号 流水号 
	 * @return
	 * @throws JBOException 
	 */
	/*
	public static double getBusinessUseSum(GuarantyContract gcontract,BusinessInfo businessInfo) throws JBOException
	{ 
		BizObject bizGuaranty=getBusinessGuaranty(gcontract.getBizObject(),businessInfo);
		double dBusinessSum=businessInfo.getUseBusinessSum();//业务的名义金额
		double dAllosum=bizGuaranty.getAttribute("ALLOCSUM").getDouble();
		return  Math.min(dBusinessSum, dAllosum);
	}
	*/
	 
	/**
	 * 获得担保业务下使用的担保合同金额
	 * @param gcontract
	 * @param lmtAccountInfo
	 * @return
	 * @throws JBOException
	 */
	public   static double getBusinessUseSum(BizObject  gcontract,LmtAccountInfo lmtAccountInfo) throws JBOException
	{ 
 		BizObject bizGuaranty=getBusinessGuaranty(gcontract,lmtAccountInfo);
		double dBusinessSum=lmtAccountInfo.getUseBusinessSum();//业务的名义金额
		double dAllosum=bizGuaranty.getAttribute("ALLOCSUM").getDouble();
		return Math.min(dBusinessSum, dAllosum);
	}
	/**
	 * 获得业务与担保合同的关联关系
	 * @param biz
	 * @param businessInfo
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getBusinessGuaranty(BizObject boGuaranty,LmtAccountInfo lmtAccountInfo) throws JBOException
	{
 		String gcSerialNo=boGuaranty.getAttribute("SerialNo").getString();
		BizObjectManager m=JBOFactory.getBizObjectManager(getJBOClassForRelative(lmtAccountInfo.getAccountType()));
		BizObject bizGuaranty=m.createQuery("ObjectNo = :gurantyNo and ObjectType = 'GuarantyContract' and  SerialNo=:serialNo")
					.setParameter("gurantyNo",gcSerialNo)
					.setParameter("serialNo",lmtAccountInfo.getAccountNo()).getSingleResult(false);
		 
		return bizGuaranty;
	}
	
	
	/**
	 * 获得业务下的担保合同信息
	 * @param biz
	 * @return
	 */
	public static  List<BizObject> getBusinessGuaranty(BizObject biz) throws JBOException
	{
		String sObjectType=CLRelativeAction.getObjectType(biz);
		String sObjectNo=biz.getAttribute("SerialNo").getString();
		return GuarantyRelative.getGuarantyContract(sObjectType, sObjectNo);
	}
	
	
	/**
	 * 获得业务下的所有的包合同信息
	 * @param biz 申请、批复、合同信息
	 * @return
	 */
	public static  List<BizObject> getGuaranty(BizObject biz) throws JBOException
	{
		String sObjectType=CLRelativeAction.getObjectType(biz);
		String sObjectNo=biz.getAttribute("SerialNo").getString();
		return GuarantyRelative.getGuarantyContract(sObjectType, sObjectNo);
	}
	 /**
	  * 获得担保合同下的担保物信息
	  * @return
	  * @throws JBOException 
	  */
	@SuppressWarnings("unchecked")
	public static   List<BizObject> getGuarantyInfo(BizObject bizGContract) throws JBOException
	{
		String sSerialNo=bizGContract.getAttribute("SerialNo").getString();
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.GUARANTY_INFO");
		List<BizObject>	 lst=m.createQuery("O.GuarantyID IN (SELECT GR.GuarantyID" +
							"  FROM jbo.app.GUARANTY_RELATIVE GR  WHERE GR.ContractNo=:gcontractNo)")
							.setParameter("gcontractNo", sSerialNo)
							.getResultList(false);
		return lst;
	}
	
}
