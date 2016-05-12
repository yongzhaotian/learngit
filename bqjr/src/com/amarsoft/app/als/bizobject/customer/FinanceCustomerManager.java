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
	 * ��ȡͬҵ�ͻ�ʵ��,ʵ���ѳ�ʼ���ͻ����ͼ��ͻ�������Ϣ
	 */
	public FinanceCustomer newInstance() {
		FinanceCustomer financeCustomer = new FinanceCustomer();
		//��ֵ�ͻ�����
		financeCustomer.setCustomerType(this.getCustomerType());
		financeCustomer.finFlag = true;
		return (FinanceCustomer) loadCustomerModelInfo(financeCustomer);

	}

	/**
	 * ��ȡͬҵ�ͻ�ʵ��,ʵ���ѳ�ʼ���ͻ����ͼ��ͻ�������Ϣ
	 */
	public FinanceCustomer getInstance(String customerID) {
		FinanceCustomer financeCustomer = new FinanceCustomer();
		financeCustomer.setCustomerID(customerID);
		financeCustomer.finFlag = true;
		return loadFinanceCustomer(financeCustomer);
	}
	
	/**
	 * ͨ���ͻ���Ż�ȡ��ͬҵ�ͻ�ʵ��
	 */
	public FinanceCustomer getEasyInstance(String customerID){
		FinanceCustomer financeCustomer = new FinanceCustomer();
		financeCustomer.setCustomerID(customerID);
		financeCustomer.setCustomerType(this.getCustomerType());
		financeCustomer.finFlag = true;
		return (FinanceCustomer) loadCustomerModelInfo(financeCustomer);
	}
	/**
	 * װ��ͬҵ�ͻ�(װ�ؿͻ�������Ϣ��ͻ�������Ϣ)
	 * @param entCustomer
	 * @return
	 */
	private FinanceCustomer loadFinanceCustomer(FinanceCustomer financeCustomer){
		//װ�ؿͻ�������Ϣ
		financeCustomer = loadCustomerInfo(financeCustomer);
		//װ�ؿͻ�������Ϣ
		financeCustomer = (FinanceCustomer) loadCustomerModelInfo(financeCustomer);
		return financeCustomer;
	}
	
	protected FinanceCustomer loadCustomerInfo(FinanceCustomer financeCustomer){
		//װ�ؿͻ��ܱ�(jbo.app.CUSTOMER_INFO)�пͻ�������Ϣ
		Customer customer=super.loadCustomerInfo(financeCustomer);
		if(customer instanceof FinanceCustomer){
			financeCustomer=(FinanceCustomer)customer;
		}else{
			ARE.getLog().warn("װ�ؿͻ�������Ϣ����!");
		}
		//����customerʵ��
		customer=null;
		//װ��ͬҵ�ͻ���(jbo.app.ENT_INFO)�пͻ�������Ϣ
		try {
			BizObject boFinanceInfo=getFinanceInfoByCustomerID(financeCustomer.getCustomerID());
			
			if(boFinanceInfo!=null){
				ObjectHelper.fillObjectFromJBO(financeCustomer, boFinanceInfo);
			}else{
				ARE.getLog().error("�ͻ�δ�ҵ�,ENT_INFO.CustomerID=[:"+financeCustomer.getCustomerID()+"],��ȷ��!");
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
		
		String sCustomerExistsOrBelongStatus="";//�ͻ����������ܻ���ϵ
		String sReturnInfo="";//�����ͻ���ɺ󷵻�ֵ
		FinanceCustomer financeCustomer=(FinanceCustomer) customer;
		try {
			//�����ͻ�У��
			sCustomerExistsOrBelongStatus = this.checkCustomerAdd(financeCustomer,curUser.getUserID());
			
		} catch (Exception e) {
			ARE.getLog().error("У��ͻ��Ƿ���ڼ��ܻ���ϵ����!");
			e.printStackTrace();
		}
		if(StringX.isEmpty(sCustomerExistsOrBelongStatus)){
			ARE.getLog().warn("У��ͻ��Ƿ���ڼ��ܻ���ϵ�����쳣!");
		}else{
			/****��ʼ������ʼ****/
			if(tx!=null){
				//���ݿͻ����������ܻ���ϵ,���������ͻ�����
					sReturnInfo=addCustomerAction(sCustomerExistsOrBelongStatus,financeCustomer,curUser,tx);
			}else{
				throw new Exception("���������Ϊ��!");
			}
		}
		return sReturnInfo;
	}
	
	/**
	 * ����ͬҵ�ͻ��ſ���Ϣ(ENT_INFO)
	 * @param financeCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	protected static void insertFinanceInfo(FinanceCustomer financeCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = m.newObject();
		bo.setAttributeValue("CustomerID", financeCustomer.getCustomerID());			// �ͻ�ID
		bo.setAttributeValue("EnterpriseName",financeCustomer.getCustomerName());	// �ͻ�����
		bo.setAttributeValue("AlikeType", financeCustomer.getAlikeType()); //ͬҵ����
		bo.setAttributeValue("AlikeTypeDown", financeCustomer.getAlikeTypeDown()); //ͬҵ������
		bo.setAttributeValue("StateType", financeCustomer.getStateType()); //����
		bo.setAttributeValue("InputOrgID",financeCustomer.getInputOrgID());				// �Ǽǻ���
		bo.setAttributeValue("UpdateOrgID",financeCustomer.getUpdateOrgID());				// ���»���
		bo.setAttributeValue("InputUserID",financeCustomer.getInputUserID());			// �Ǽ���
		bo.setAttributeValue("UpdateUserID",financeCustomer.getUpdateDate());			// ������
		bo.setAttributeValue("InputDate",financeCustomer.getInputDate());				// �Ǽ�����
		bo.setAttributeValue("UpdateDate",financeCustomer.getUpdateDate());				// ��������
		bo.setAttributeValue("TempSaveFlag", "1");				// �ݴ��־
		if("Ent05".equals(financeCustomer.getCertType())){	// ���ڻ������֤
			bo.setAttributeValue("BankLicense",financeCustomer.getCertID());		
		}else if("Ent01".equals(financeCustomer.getCertType())){	// ��֯��������		
			bo.setAttributeValue("CorpID",financeCustomer.getCertID());			
		}else{
			bo.setAttributeValue("SWIFTCode",financeCustomer.getCertID());	//	SWIFT����	
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
