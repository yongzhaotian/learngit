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
 * @describe ��ҵ�ͻ�������
 */
public class EntCustomerManager extends CustomerManager implements Serializable{

	private static final long serialVersionUID = 5469326751174744399L;

	/**
	 * ��ȡ��˾�ͻ�ʵ��,ʵ���ѳ�ʼ���ͻ����ͼ��ͻ�������Ϣ
	 */
	public EntCustomer newInstance() {
		EntCustomer entCustomer = new EntCustomer();
		//��ֵ�ͻ�����
		entCustomer.setCustomerType(this.getCustomerType());
		entCustomer.entFlag = true;
		return entCustomer;
	}

	/**
	 * ͨ���ͻ���Ż�ȡ��˾�ͻ�ʵ��
	 */
	public EntCustomer getInstance(String customerID) {
		EntCustomer entCustomer = new EntCustomer();
		entCustomer.setCustomerID(customerID);
		entCustomer.entFlag = true;
		return loadEntCustomer(entCustomer);
	}
	
	/**
	 * ͨ���ͻ���Ż�ȡ�ṫ˾�ͻ�ʵ��
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
	 * װ�ع�˾�ͻ�������Ϣ
	 * @param entCustomer
	 * @return
	 */
	protected EntCustomer loadEntCustomerModelInfo(EntCustomer entCustomer){
		//װ�ؿͻ�������Ϣ
		Customer customer=loadCustomerModelInfo(entCustomer);
		if(customer instanceof EntCustomer){
			entCustomer=(EntCustomer)customer;
		}else{
			ARE.getLog().warn("װ�ؿͻ�������Ϣ����!");
		}
		//����customerʵ��
		customer=null;
		return entCustomer;
	}
	/**
	 * װ�ع�˾�ͻ�������Ϣ
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
				ARE.getLog().warn("������CUSTOMER_MODEL.CUSTOMERTYPE=["+customer.getCustomerType()+"],OrgNature=["+((EntCustomer)customer).getOrgNature()+"]�Ŀͻ�����ģ��δ����,��ȷ��!");
			}
			
			/*���OrgNatureΪ������ݿͻ�����Ĭ����ʾģ��,����ǰ�˳���*/
			String sOrgNature = ((EntCustomer)customer).getOrgNature();
			if(sOrgNature==null || sOrgNature.length()==0){
				sOrgNature = "0101";
			}
			
			BizObject codeModel = JBOFactory.createBizObjectQuery("jbo.sys.CODE_LIBRARY","CodeNo='CustomerOrgType' and ItemNo=:ItemNo and IsInUse='1'")
								.setParameter("ItemNo",sOrgNature).getSingleResult(false);
			if(codeModel!=null){
				customer.setDetailTempletNo(codeModel.getAttribute("ItemAttribute").getString());
			}else{
				ARE.getLog().warn("������OrgNature="+((EntCustomer)customer).getOrgNature()+"����ʾģ��δ�ҵ���");
			}
			
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	/**
	 * װ�ع�˾�ͻ�(װ�ؿͻ�������Ϣ��ͻ�������Ϣ)
	 * @param entCustomer
	 * @return
	 */
	private EntCustomer loadEntCustomer(EntCustomer entCustomer){
		/***ͨ���ͻ���ų�ʼ����˾�ͻ�����ʱ,Ӧ��װ�ؿͻ��Ļ�����Ϣ,����������װ�ؿͻ�������Ϣʱ��ȡ��˾�ͻ�������(CustomerType)����������(OrgNature)***/
		//װ�ؿͻ�������Ϣ
		entCustomer=loadCustomerInfo(entCustomer);
		//װ�ؿͻ�������Ϣ
		entCustomer=loadEntCustomerModelInfo(entCustomer);
		return entCustomer;
	}
	/**
	 * װ�ؿͻ�������Ϣ
	 * @param entCustomer:��˾�ͻ�����
	 * @return
	 */
	public EntCustomer loadCustomerInfo(EntCustomer entCustomer){
		//װ�ؿͻ��ܱ�(jbo.app.CUSTOMER_INFO)�пͻ�������Ϣ
		Customer customer=super.loadCustomerInfo(entCustomer);
		if(customer instanceof EntCustomer){
			entCustomer=(EntCustomer)customer;
		}else{
			ARE.getLog().warn("װ�ؿͻ�������Ϣ����!");
		}
		//����customerʵ��
		customer=null;
		//װ�ع�˾�ͻ���(jbo.app.ENT_INFO)�пͻ�������Ϣ
		try {
			BizObject boEntInfo=getEntInfoByCustomerID(entCustomer.getCustomerID());
			if(boEntInfo!=null){
				//�ù�˾֤������ΪEnt01��֯��������
				if("Ent01".equalsIgnoreCase(entCustomer.getCertType())){
					entCustomer.setCorpID(entCustomer.getCertID());
				}
				ObjectHelper.fillObjectFromJBO(entCustomer, boEntInfo);
			}else{
				ARE.getLog().error("�ͻ�δ�ҵ�,ENT_INFO.CustomerID=[:"+entCustomer.getCustomerID()+"],��ȷ��!");
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
	 * ͨ���ͻ���Ż�ȡ��˾�ͻ�JBO����
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getEntInfoByCustomerID(String customerID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID).getSingleResult();
	}

	/**
	 * �����ͻ�
	 * @return ���״̬+�ͻ����
	 */
	public String addCustomer(Customer customer, String userID,JBOTransaction tx) throws Exception{
		String sReturnInfo="";//�����ͻ���ɺ󷵻�ֵ
		EntCustomer entCustomer=(EntCustomer) customer;
		//�����ͻ�У��
		sReturnInfo = checkCustomerAddNew(entCustomer,userID);
		if("ERROR".equals(sReturnInfo)){
			throw new Exception("У��ͻ��Ƿ���ڼ��ܻ���ϵ�����쳣!");
		}else{
			String sStatusInfo[] = sReturnInfo.split("@");
			if(sStatusInfo[0].equals("01")){				//ϵͳ�в����ڵĿͻ�ֱ������
				//���ݿͻ����������ܻ���ϵ,���������ͻ�����
				sReturnInfo = sReturnInfo+"@"+AddCustomerByCustomerObject.addNewCustomer(entCustomer, tx);
			}
		}
		return sReturnInfo;
	}
	
	/**
	 * ������˾�ͻ��ſ���Ϣ(ENT_INFO)
	 * @param entCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	protected static void insertEntInfo(EntCustomer entCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID", entCustomer.getCustomerID());			// �ͻ�ID
		bo.setAttributeValue("EnterpriseName",entCustomer.getCustomerName());	// �ͻ�����
		bo.setAttributeValue("OrgNature",entCustomer.getOrgNature());		// ��������
//		bo.setAttributeValue("GroupFlag", sGroupType);			// ���ſͻ���־
		bo.setAttributeValue("InputOrgID",entCustomer.getInputOrgID());				// �Ǽǻ���
		bo.setAttributeValue("UpdateOrgID",entCustomer.getUpdateOrgID());				// ���»���
		bo.setAttributeValue("InputUserID",entCustomer.getInputUserID());			// �Ǽ���
		bo.setAttributeValue("UpdateUserID",entCustomer.getUpdateDate());			// ������
		bo.setAttributeValue("InputDate",entCustomer.getInputDate());				// �Ǽ�����
		bo.setAttributeValue("UpdateDate",entCustomer.getUpdateDate());				// ��������
		bo.setAttributeValue("TempSaveFlag", "1");				// �ݴ��־
		
		if("Ent02".equals(entCustomer.getCertType())){	// ֤������ΪӪҵִ��
			bo.setAttributeValue("LicenseNo",entCustomer.getCertID());		// Ӫҵִ�պ�
		}else{	// ����֤��		// if("Ent01".equals(certType)){	// ֤������Ϊ��֯��������	
			bo.setAttributeValue("CorpID",entCustomer.getCertID());			// ֤����ţ���֯��������֤��ţ�
		}
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * ��ȡ��������
	 * @param customerID
	 * @return
	 */
	protected static String getOrgNature(String customerID){
		String sOrgNature = "";
		try{
			sOrgNature = GetCustomer.getOrgNatrue(customerID);
		}catch(Exception e){
			ARE.getLog().error("װ����ͻ�����ʱ��ȡ�������ͳ���");
			e.printStackTrace();
		}
		return sOrgNature;
	}
	
}
