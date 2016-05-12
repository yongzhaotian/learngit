package com.amarsoft.app.als.credit.cl.model;

import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * �������ҵ���ͬ�뵣���Ĺ�����ϵ
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
			ARE.getLog().error("����Ƿ��������ͣ�");
		}
		return jboClass;
	}
	/**
	 * ���ҵ���µĵ�����ͬ��Ϣ
	 * @param biz
	 * @return
	 * @throws JBOException
	 */
	public  static List<BizObject> getGuarantyContract(LmtAccountInfo businessInfo) throws JBOException
	{
		return getGuarantyContract(businessInfo.getAccountType(),businessInfo.getAccountNo());
	}
	
	/**
	 * ���ҵ���µĵ�����ͬ��Ϣ
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
	 * ��õ�����Ӧ�ĺ�ͬ
	 * <li>������Ⱥ�δ��ɵǼǵĺ�ͬ��������
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
	 * ��ø�ҵ��ռ�õ����Ľ��������Ϊ��������͵���������
	 * <li>���ؽ��Ϊ=min(ҵ����������ε������)
	 * <li> GUR_SERIALNO ΪGuaranty_Contract ��ˮ�� 
	 * <li> SerialNo  Ϊҵ����ˮ�� ��ˮ�� 
	 * @return
	 * @throws JBOException 
	 */
	/*
	public static double getBusinessUseSum(GuarantyContract gcontract,BusinessInfo businessInfo) throws JBOException
	{ 
		BizObject bizGuaranty=getBusinessGuaranty(gcontract.getBizObject(),businessInfo);
		double dBusinessSum=businessInfo.getUseBusinessSum();//ҵ���������
		double dAllosum=bizGuaranty.getAttribute("ALLOCSUM").getDouble();
		return  Math.min(dBusinessSum, dAllosum);
	}
	*/
	 
	/**
	 * ��õ���ҵ����ʹ�õĵ�����ͬ���
	 * @param gcontract
	 * @param lmtAccountInfo
	 * @return
	 * @throws JBOException
	 */
	public   static double getBusinessUseSum(BizObject  gcontract,LmtAccountInfo lmtAccountInfo) throws JBOException
	{ 
 		BizObject bizGuaranty=getBusinessGuaranty(gcontract,lmtAccountInfo);
		double dBusinessSum=lmtAccountInfo.getUseBusinessSum();//ҵ���������
		double dAllosum=bizGuaranty.getAttribute("ALLOCSUM").getDouble();
		return Math.min(dBusinessSum, dAllosum);
	}
	/**
	 * ���ҵ���뵣����ͬ�Ĺ�����ϵ
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
	 * ���ҵ���µĵ�����ͬ��Ϣ
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
	 * ���ҵ���µ����еİ���ͬ��Ϣ
	 * @param biz ���롢��������ͬ��Ϣ
	 * @return
	 */
	public static  List<BizObject> getGuaranty(BizObject biz) throws JBOException
	{
		String sObjectType=CLRelativeAction.getObjectType(biz);
		String sObjectNo=biz.getAttribute("SerialNo").getString();
		return GuarantyRelative.getGuarantyContract(sObjectType, sObjectNo);
	}
	 /**
	  * ��õ�����ͬ�µĵ�������Ϣ
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
