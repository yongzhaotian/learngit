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
 * @describe ���˿ͻ����������
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
	 * ͨ���ͻ���Ż�ȡ���˿ͻ�����ʵ��
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
	 * װ�ظ��˿ͻ�������Ϣ
	 * @param indCustomer
	 * @return
	 */
	protected IndCustomer loadIndCustomerModelInfo(IndCustomer indCustomer){
		//װ�ؿͻ�������Ϣ
		Customer customer=loadCustomerModelInfo(indCustomer);
		if(customer instanceof IndCustomer){
			indCustomer=(IndCustomer)customer;
		}else{
			ARE.getLog().warn("װ�ؿͻ�������Ϣ����!");
		}
		//����customerʵ��
		customer=null;
		return indCustomer;
	}
	
	/**
	 * װ�ظ���ͻ�������Ϣ�ľ��巽��
	 */
	public Customer loadCustomerModelInfo(Customer customer) {
		try {
			BizObject boCustomerModel=JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_MODEL").
				createQuery("CustomerType=:CustomerType").setParameter("CustomerType",((IndCustomer)customer).getCustomerType()).getSingleResult();
			if(boCustomerModel!=null){
				ObjectHelper.fillObjectFromJBO(customer, boCustomerModel);
			}else{
			ARE.getLog().error("������CUSTOMER_MODEL.TypeID=["+this.getCustomerType()+"]�Ŀͻ�����ģ��δ����,��ȷ��!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	
	/**
	 * װ�ظ���ͻ�ҵ����Ϣ
	 * @param indCustomer
	 * @return indCustomer
	 */
	public IndCustomer loadCustomerInfo(IndCustomer indCustomer){
		//װ�ؿͻ��ܱ�(jbo.app.CUSTOMER_INFO)�пͻ�������Ϣ
		Customer customer=super.loadCustomerInfo(indCustomer);
		if(customer instanceof IndCustomer){
			indCustomer=(IndCustomer)customer;
		}else{
			ARE.getLog().warn("װ�ؿͻ�������Ϣ����!");
		}
		//����customerʵ��
		customer=null;
		//װ�ع�˾�ͻ���(jbo.app.ENT_INFO)�пͻ�������Ϣ
		try {
			BizObject boIndInfo=getIndInfoByCustomerID(indCustomer.getCustomerID());
			if(boIndInfo!=null){
				//�ù�˾֤������ΪEnt01��֯��������
				if("Ind01".equalsIgnoreCase(indCustomer.getCertType())){
					indCustomer.setCertID18(indCustomer.getCertID());
				}
				ObjectHelper.fillObjectFromJBO(indCustomer, boIndInfo);
			}else{
				ARE.getLog().error("�ͻ�δ�ҵ�,IND_INFO.CustomerID=[:"+indCustomer.getCustomerID()+"],��ȷ��!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return indCustomer;
	}
	
	/**
	 * װ�ظ��˿ͻ����󣨿ͻ�ҵ����Ϣ�Ϳͻ�������Ϣ��
	 * @param indCustomer
	 * @return	indCustomer
	 */
	private IndCustomer loadIndCustomer(IndCustomer indCustomer){
		indCustomer = loadCustomerInfo(indCustomer);
		indCustomer = loadIndCustomerModelInfo(indCustomer);
		return indCustomer;
	}
	
	/**
	 * ͨ���ͻ���Ż�ȡ���˿ͻ�JBO����
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getIndInfoByCustomerID(String customerID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.IND_INFO").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID).getSingleResult();
	}
	
	/**
	 * �����ͻ�
	 * @return ���״̬+�ͻ����
	 */
	public String addCustomer(Customer customer, String userID,JBOTransaction tx) throws Exception{
		String sReturnInfo="";//�����ͻ���ɺ󷵻�ֵ
		IndCustomer indCustomer=(IndCustomer) customer;
		//�����ͻ�У��
		sReturnInfo = checkCustomerAddNew(indCustomer,userID);
		if("ERROR".equals(sReturnInfo)){
			throw new Exception("У��ͻ��Ƿ���ڼ��ܻ���ϵ�����쳣!");
		}else{
			String sStatusInfo[] = sReturnInfo.split("@");
			if(sStatusInfo[0].equals("01")){				//ϵͳ�в����ڵĿͻ�ֱ������
				//���ݿͻ����������ܻ���ϵ,���������ͻ�����
				sReturnInfo = sReturnInfo+"@"+AddCustomerByCustomerObject.addNewCustomer(indCustomer, tx);
			}
		}
		return sReturnInfo;
	}
	
	/**
	 * �������˿ͻ��ſ���Ϣ(IND_INFO)
	 * @param entCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	protected static void insertIndInfo(IndCustomer indCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.IND_INFO");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID", indCustomer.getCustomerID());			// �ͻ�ID
		bo.setAttributeValue("FullName",indCustomer.getCustomerName());				// �ͻ�����
		bo.setAttributeValue("CertID",indCustomer.getCertID());						// ֤�����
		bo.setAttributeValue("CertType", indCustomer.getCertType());				// ֤������
		bo.setAttributeValue("CertID18", indCustomer.getCertID18());				// 18λ���֤��
		bo.setAttributeValue("InputOrgID",indCustomer.getInputOrgID());				// �Ǽǻ���
		bo.setAttributeValue("UpdateOrgID",indCustomer.getUpdateOrgID());			// ���»���
		bo.setAttributeValue("InputUserID",indCustomer.getInputUserID());			// �Ǽ���
		bo.setAttributeValue("UpdateUserID",indCustomer.getUpdateDate());			// ������
		bo.setAttributeValue("InputDate",indCustomer.getInputDate());				// �Ǽ�����
		bo.setAttributeValue("UpdateDate",indCustomer.getUpdateDate());				// ��������
		bo.setAttributeValue("TempSaveFlag", "1");				// �ݴ��־
		
		tx.join(m);
		m.saveObject(bo);
	}

}
