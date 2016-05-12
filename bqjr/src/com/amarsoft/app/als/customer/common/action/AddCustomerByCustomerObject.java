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
 * ͨ���ͻ������������ſͻ�����˾/�������ſͻ�����ͨ���ࣩ
 * @author Administrator
 *
 */
public class AddCustomerByCustomerObject {
	
	/**
	 * �����Ǵ����ͻ�
	 * @param customer
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public static String addNewCustomer(Customer customer,JBOTransaction tx) throws JBOException{
		try{
			customer = initCustomerInfo(customer,tx);				//��ʼ��CUSTOMER_INFO
			initCustomerBelong("1",customer,tx);					//��ʼ��CUSTOMER_BELONG
			if(customer instanceof EntCustomer){					//��ʼ��ENT_INFO ���� IND_INFO
				initEntCustomer((EntCustomer)customer,tx);
			}else if(customer instanceof IndCustomer){
				initIndCustomer((IndCustomer)customer,tx);
			}
			initCustomerAlert(customer,tx);							//��ʼ���ͻ�Ԥ����Ϣ
			return customer.getCustomerID();
		}catch(Exception e){
			throw new JBOException("�����ͻ�����");
		}
	}
	
	/**
	 * ����û������ͻ�����Ŀͻ�
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
			throw new JBOException("����ͻ�����");
		}
	}
	
	/**
	 * �����������˵Ŀͻ�
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
			throw new JBOException("����ͻ�����");
		}
	}
	/**
	 * ��ʼ��CUSTOMER_INFO
	 * @param customer
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	private static Customer initCustomerInfo(Customer customer,JBOTransaction tx) throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CustomerName", customer.getCustomerName());	// �ͻ�����
		bo.setAttributeValue("CustomerType", customer.getCustomerType());	// �ͻ�����
		bo.setAttributeValue("CertType", customer.getCertType());	// ֤������
		bo.setAttributeValue("CertID", customer.getCertID());	//֤������
		bo.setAttributeValue("InputOrgID", customer.getInputOrgID());			// �Ǽǻ���
		bo.setAttributeValue("InputUserID", customer.getInputUserID());		// �Ǽ��û�
		bo.setAttributeValue("InputDate", customer.getInputDate());			// �Ǽ�����
		bo.setAttributeValue("Channel", "1");				// ��Դ����
		bo.setAttributeValue("CreditFlag", "2");			//���ſͻ���־
		tx.join(bm);
		bm.saveObject(bo);
		//�������Ŀͻ��Ŀͻ���Ÿ�ֵ���ͻ�����
		customer.setCustomerID(bo.getAttribute("CustomerID").getString());
		return customer;
	}
	
	/**
	 * ��ʼ���ͻ�������CUSTOMER_BELONG
	 * @param sAttribute
	 * @param customer
	 * @param tx
	 * @throws JBOException
	 */
	private static void initCustomerBelong(String sAttribute,Customer customer,JBOTransaction tx) throws JBOException{
		String sToday = StringFunction.getToday();
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID",customer.getCustomerID()); 		// �ͻ�ID
		bo.setAttributeValue("OrgID",customer.getInputOrgID());				// ��Ȩ����ID
		bo.setAttributeValue("UserID",customer.getInputUserID());				// ��Ȩ��ID
		bo.setAttributeValue("BelongAttribute",sAttribute);	// ����Ȩ
		bo.setAttributeValue("BelongAttribute1","1");	// ��Ϣ�鿴Ȩ
		bo.setAttributeValue("BelongAttribute2",sAttribute);	// ��Ϣά��Ȩ
		bo.setAttributeValue("BelongAttribute3",sAttribute);	// ����ҵ�����Ȩ
		bo.setAttributeValue("BelongAttribute4","1");	//�ͷ���ҵ�����Ȩ
		bo.setAttributeValue("InputOrgID",customer.getInputOrgID());			// �Ǽǻ���
		bo.setAttributeValue("InputUserID",customer.getInputUserID());			// �Ǽ���
		bo.setAttributeValue("InputDate",sToday);			// �Ǽ�����
		bo.setAttributeValue("UpdateDate",sToday);			// ��������
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * ��ʼ��ENT_INFO
	 * @param entCustomer
	 * @param tx
	 * @throws JBOException
	 */
	private static void initEntCustomer(EntCustomer entCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID", entCustomer.getCustomerID());			// �ͻ�ID
		if("0103".equals(entCustomer.getOrgNature())||"0104".equals(entCustomer.getOrgNature())
				||"0105".equals(entCustomer.getOrgNature())||"0199".equals(entCustomer.getOrgNature())){
			bo.setAttributeValue("Scope", "5");						//��ҵ��ģ
		}else{
			bo.setAttributeValue("Scope", entCustomer.getScope());	
		}
		bo.setAttributeValue("EnterpriseName",entCustomer.getCustomerName());	// �ͻ�����
		bo.setAttributeValue("OrgNature",entCustomer.getOrgNature());		// ��������
		bo.setAttributeValue("EmployeeNumber", entCustomer.getEmployeeNumber());	//��Ա����
		bo.setAttributeValue("InputOrgID",entCustomer.getInputOrgID());				// �Ǽǻ���
		bo.setAttributeValue("UpdateOrgID",entCustomer.getUpdateOrgID());				// ���»���
		bo.setAttributeValue("InputUserID",entCustomer.getInputUserID());			// �Ǽ���
		bo.setAttributeValue("UpdateUserID",entCustomer.getUpdateDate());			// ������
		bo.setAttributeValue("InputDate",entCustomer.getInputDate());				// �Ǽ�����
		bo.setAttributeValue("UpdateDate",entCustomer.getUpdateDate());				// ��������
		bo.setAttributeValue("TempSaveFlag", "1");				// �ݴ��־
		bo.setAttributeValue("LicenseNo",entCustomer.getLicenseNo());		// Ӫҵִ�պ�
		bo.setAttributeValue("CorpID",entCustomer.getCorpID());			// ֤����ţ���֯��������֤��ţ�
		bo.setAttributeValue("GROUPFLAG","2");			// �Ƿ��ű�־  Ĭ��Ϊ2 ��
		
		/*if("Ent02".equals(entCustomer.getCertType())){	// ֤������ΪӪҵִ��
			bo.setAttributeValue("LicenseNo",entCustomer.getCertID());		// Ӫҵִ�պ�
		}else{	// ����֤��		// if("Ent01".equals(certType)){	// ֤������Ϊ��֯��������	
			bo.setAttributeValue("CorpID",entCustomer.getCertID());			// ֤����ţ���֯��������֤��ţ�
		}*/
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * ��ʼ��IND_INFO
	 * @param indCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void initIndCustomer(IndCustomer indCustomer,JBOTransaction tx) throws JBOException{
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
	
	/**
	 * ��ʼ���ͻ�Ԥ����Ϣ
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
