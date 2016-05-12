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
 * @describe �ͻ�������ӿ�
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
	 * ����һ���ͻ�����ʵ��
	 * @return
	 */
	public abstract Customer newInstance();
	/**
	 * ���ݿͻ��ţ���ȡһ���ͻ�����ʵ��
	 * @param customerID �ͻ���
	 * @return
	 */
	public abstract Customer getInstance(String customerID);
	/**
	 * ���ݿͻ���ţ����һ����ͻ�����ʵ����ֻװ�ز��ֳ�������
	 * @param customerID
	 * @return
	 */
	public abstract Customer getEasyInstance(String customerID);
	/**
	 * ����һ���ͻ�����ʵ��
	 * @param customer
	 */
	public abstract void saveInstance(Customer customer);
	/**
	 * ��ȡ�û����ڿͻ������Ȩ��
	 * @param customer �ͻ�����
	 * @param user �û�����
	 * @return
	 */
	public abstract String getRightType(Customer customer,ASUser user);
	/**
	 * װ�ؿͻ�������Ϣ
	 * @param customer
	 * @return
	 */
	public Customer loadCustomerInfo(Customer customer){
		try {
			//---------------װ��CUSTOMER_INFO����Ϣ--------------------------------
			BizObject boCustomerInfo=JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customer.getCustomerID()).getSingleResult();
			if(boCustomerInfo!=null){
				//�ɲ�ѯ�õ���CUSTOMER_INFO��JBO�������ͻ�����
				ObjectHelper.fillObjectFromJBO(customer, boCustomerInfo);
			}else{
				ARE.getLog().error("�ͻ�δ�ҵ�,CUSTOMER_INFO.CustomerID=["+customer.getCustomerID()+"],��ȷ��!");
			}
			
			//--------------װ�عܻ��ˣ��ܻ�������Ϣ---------------------------------
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
	 * װ�ؿͻ�������Ϣ
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
			ARE.getLog().error("������CUSTOMER_MODEL.CustomerType=["+this.getCustomerType()+"�Ŀͻ�����ģ��δ����,��ȷ��!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	/**
	 * У��ͻ�����״̬
	 * @param customer:�ͻ�����ʵ��
	 * @param userID:��ǰ�û����
	 * @return ����5�����ͷ���ֵ
	 *      1.�ͻ�����
	 *        1.1:�ͻ��Ŀͻ�����������ʱ¼��Ŀͻ����Ͳ�һ��
	 *        		---������ʾ��Ϣ"�ͻ��Ѵ���,�����ڴ�����!"
	 *        1.2:�ͻ��Ŀͻ�����������ʱ¼��Ŀͻ�����һ��,���ȡ�ͻ��Ĺܻ���ϵ
	 *        	1.2.1:�ͻ��뵱ǰ�û����ڹܻ���ϵ
	 *        		---����"�ͻ��Ѵ������ѱ��Լ�����!"
	 *        	1.2.2:�ͻ��뵱ǰ�û������ڹܻ���ϵ
	 *          	1.2.2.1:�ͻ��йܻ��ͻ�����
	 *          		---����"05@�ͻ����"
	 *          	1.2.2.2:�ͻ�û�йܻ��ͻ�����
	 *          		---����"04@�ͻ����"
	 *      2.�ͻ�������
	 *      	---����"01"
	 *      
	 */
	public String checkCustomerAdd(Customer customer, String userID) throws Exception {
		String sReturnStatus="";//����ֵ
		//�ͻ����,�ͻ�����(ϵͳ�иÿͻ��Ŀͻ�����),�ͻ���������(ϵͳ�иÿͻ��Ŀͻ���������),֤����������
		String sCustomerID="",sHaveCustomerType="",sHaveCustomerTypeName="",sCertTypeName="";
		/**��һ��:ͨ��֤�����͡�֤�������ȡ�ͻ�����**/
		BizObject boCustomerInfo = getCustomerByCertTypeAndID(customer.getCertType(),customer.getCertID());
		/**�ڶ���:�ж�¼��Ŀͻ��Ƿ����**/
		if(boCustomerInfo != null){
			sCustomerID = boCustomerInfo.getAttribute("CustomerID").getString();//�ͻ����
			sHaveCustomerType = boCustomerInfo.getAttribute("CustomerType").getString();//�ͻ�����
			BizObject boCustomerModel=getCustomerModelByCustomerType(sHaveCustomerType);
			if(boCustomerModel!=null){
				sHaveCustomerTypeName = boCustomerModel.getAttribute("CustomerTypeName").getString();//�ͻ���������
				//sCertTypeName=NameManager.getItemName("CertType",customer.getCertType());
				sCertTypeName=customer.getCertType();
				//��ϵͳ�иÿͻ������������ͻ�ʱ��ѡ��Ŀͻ����Ͳ�һ��,����ʾ
				if(!StringX.isEmpty(sHaveCustomerType) && !sHaveCustomerType.equalsIgnoreCase(customer.getCustomerType())){
					sReturnStatus="֤������:"+sCertTypeName+",֤������:"+customer.getCertID()+"�Ŀͻ��Ѵ���.�ͻ�����Ϊ"+sHaveCustomerTypeName+",�����ڴ�����!";
				}else{
					//���ͻ��ܻ���ϵ
					sReturnStatus=checkCustomerBelong(sCustomerID,userID);
					//02:�ͻ��Ѵ��ڲ��ѱ��Լ�����,���ء���ʾ��Ϣ��
					if("02".equalsIgnoreCase(sReturnStatus)){
						sReturnStatus="֤������:"+sCertTypeName+",֤������:"+customer.getCertID()+"�Ŀͻ��Ѵ���,����"+sHaveCustomerTypeName+"�ͻ�����ҳ�汻�����������ȷ��!";
					}
					//05:�ͻ��Ѵ��ڵ����йܻ��ͻ�����,���ء��ͻ��ܻ�״̬@��ʾ��Ϣ@�ͻ���š�
					if("05".equalsIgnoreCase(sReturnStatus)){
						sReturnStatus=sReturnStatus+"@֤������:"+sCertTypeName+",֤������:"+customer.getCertID()+"�Ŀͻ��ѳɹ�����,����Ҫ�ύȨ����������ȡ�ÿͻ�Ȩ��!";
						sReturnStatus=sReturnStatus+"@"+sCustomerID;
					}
					//04:�ͻ��Ѵ�����û�йܻ��ͻ�����,���ء��ͻ��ܻ�״̬@�ͻ���š�
					if("04".equalsIgnoreCase(sReturnStatus)){
						sReturnStatus=sReturnStatus+"@"+sCustomerID;
					}
				}
			}else{
				throw new Exception("�ͻ����Ϊ"+sCustomerID+"�Ŀͻ��Ŀͻ������쳣,��ͻ����ʹ���Ϊ"+sHaveCustomerType+"��ϵͳ��δ����,��ȷ��!");
			}
		}else{
			//�ÿͻ���ϵͳ�в�����
			sReturnStatus = "01";
		}
		return sReturnStatus;
	}
	/**
	 * �����ͻ�
	 * @param customer
	 * @param userID
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public abstract String addCustomer(Customer customer,String userID,JBOTransaction tx) throws Exception;
	/**
	 * ���ݿͻ�������񼰿ͻ��ܻ���ϵ״̬���пͻ���������
	 * @param sCustomerExistsOrBelongStatus:�ͻ�������񼰿ͻ��ܻ���ϵ״̬
	 *        05���ͻ��Ѵ���,���Ѵ��ڹܻ��ͻ�����
	 *        04: �ͻ��Ѵ���,�������ڹܻ��ͻ�����
	 *        01: �ͻ�������
	 * @param curUser����ǰ�û�
	 * @param tx:����
	 * @return 
	 * @throws JBOException 
	 */
	protected String addCustomerAction(String sCustomerExistsOrBelongStatus,Customer customer,ASUserObject curUser,JBOTransaction tx) throws JBOException{
		/*
		 * sCustomerExistsOrBelongStatus���ͻ�������񼰿ͻ��ܻ���ϵ״̬˵��
		 *	    1.�ͻ�����
		 *        1.1:�ͻ��Ŀͻ�����������ʱ¼��Ŀͻ����Ͳ�һ��
		 *        		---sCustomerExistsOrBelongStatus="�ͻ��Ѵ���,�����ڴ�����!"
		 *        1.2:�ͻ��Ŀͻ�����������ʱ¼��Ŀͻ�����һ��,���ȡ�ͻ��Ĺܻ���ϵ
		 *        	1.2.1:�ͻ��뵱ǰ�û����ڹܻ���ϵ
		 *        		---sCustomerExistsOrBelongStatus="�ͻ��Ѵ������ѱ��Լ�����!"
		 *        	1.2.2:�ͻ��뵱ǰ�û������ڹܻ���ϵ
		 *          	1.2.2.1:�ͻ��йܻ��ͻ�����
		 *          		---sCustomerExistsOrBelongStatus="05@��ʾ��Ϣ@�ͻ����"
		 *          	1.2.2.2:�ͻ�û�йܻ��ͻ�����
		 *          		---sCustomerExistsOrBelongStatus="04@�ͻ����"
		 *      2.�ͻ�������
		 *      	---sCustomerExistsOrBelongStatus="01"
		 */
		String sReturnInfo="";
		//01:Ҫ�����Ŀͻ���ϵͳ������,04��ͷ:Ҫ�����Ŀͻ�����ϵͳ�д���,��û�йܻ��ͻ�����
		if(!"01".equalsIgnoreCase(sCustomerExistsOrBelongStatus) && !sCustomerExistsOrBelongStatus.startsWith("04")){
			//05��ͷ���ͻ��Ѵ���,���Ѵ��ڹܻ��ͻ�����
			if(sCustomerExistsOrBelongStatus.startsWith("05")){
				String[] sReturnStatuInfos=sCustomerExistsOrBelongStatus.split("@");
				//���ڿͻ�Ŀǰ���йܻ��ͻ������������κ�Ȩ��
				insertCustomerBelong("2",sReturnStatuInfos[2],curUser.getUserID(),curUser.getOrgID(),tx);
				//ֻ������ʾ��Ϣ,���÷��ؿͻ����
				sReturnInfo=sReturnStatuInfos[0]+"@"+sReturnStatuInfos[1];
			}else{
				sReturnInfo=sCustomerExistsOrBelongStatus;
			}
		}else{
			//�ͻ�����ϵͳ�д��ڵ��޹ܻ��ͻ�����,�򸳸�����Ȩ��
			if(sCustomerExistsOrBelongStatus.startsWith("04")){
				String[] sReturnStatuInfos=sCustomerExistsOrBelongStatus.split("@");
				//���ڿͻ�Ŀǰû�йܻ��ͻ�������������Ȩ��
				insertCustomerBelong("1",sReturnStatuInfos[1],curUser.getUserID(),curUser.getOrgID(),tx);
				sReturnInfo=sCustomerExistsOrBelongStatus;
			}
			//01���ͻ�������,�������ͻ�
			if("01".equalsIgnoreCase(sCustomerExistsOrBelongStatus)){
				//��CUSTOMER_INFO����һ����¼
				insertCustomerInfo(customer,tx);
				//���ݴ��������������һ�����Ķ���,���������ű���������
				if(customer instanceof EntCustomer){
					//��ENT_INFO����һ����¼
					EntCustomerManager.insertEntInfo((EntCustomer)customer,tx);
				}else if(customer instanceof IndCustomer){
					//��IND_INFO����һ����¼
					IndCustomerManager.insertIndInfo((IndCustomer)customer,tx);
				}else if(customer instanceof FinanceCustomer){
					//��ENT_INFO����һ����¼
					//FinanceCustomerManager.insertFinanceInfo((FinanceCustomer)customer,tx);
				}
				//��CUSTOMER_INFO����һ����¼
				//�����ͻ���Ĭ������ȫ��Ȩ��
				insertCustomerBelong("1",customer.getCustomerID(),curUser.getUserID(),curUser.getOrgID(),tx);
				//����ֵƴ���Ͽͻ����
				sReturnInfo=sCustomerExistsOrBelongStatus+"@"+customer.getCustomerID();
			}
		}
		return sReturnInfo;
	}
	/**
	 * ͨ���ͻ�֤��������֤����Ż�ȡ�ͻ�JBO����
	 * @param sCertType
	 * @param sCertID
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCustomerByCertTypeAndID(String sCertType,String sCertID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO").createQuery("CertType=:CertType and CertID=:CertID").setParameter("CertType",sCertType).setParameter("CertID",sCertID).getSingleResult();
	}
	/**
	 * ͨ���ͻ���֯���������ȡ�ͻ��������жϿͻ��Ƿ����
	 * @param sCorpID
	 * @return
	 * @throws JBOException
	 */
	public static int getCustomerByCorpID(String sCorpID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("CorpID=:CorpID").setParameter("CorpID",sCorpID).getTotalCount();
	}
	/**
	 * ͨ���ͻ�Ӫҵִ�մ����ȡ�ͻ��������жϿͻ��Ƿ����
	 * @param sLicenceNO
	 * @return
	 * @throws JBOException
	 */
	public static int getCustomerByLicenseNO(String sLicenseNO) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("LicenseNO=:LicenseNO").setParameter("LicenseNO",sLicenseNO).getTotalCount();
	}
	/**
	 * ͨ���ͻ�Ӫҵִ�մ������֯���������ȡ�ͻ��������жϿͻ��Ƿ����
	 * @param sLicenceNO
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCustomerByLicenseNoAndCorpID(String sLicenseNO,String sCorpID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("LicenseNO=:LicenseNO or CorpID=:CorpID order by CorpID").setParameter("LicenseNO",sLicenseNO).setParameter("CorpID", sCorpID).getSingleResult();
	}
	/**
	 * ͨ���ͻ����ͻ�ȡ�ͻ�����(CUSTOMER_MODEL)JBO����
	 * @param sCustomerType
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCustomerModelByCustomerType(String sCustomerType) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_MODEL").createQuery("CustomerType=:CustomerType").setParameter("CustomerType",sCustomerType).getSingleResult();
	}
	/**
	 * ��ȡ�ͻ���Ա������ϵ
	 * @param customerID �ͻ���
	 * @param userID ��Ա��
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
	 * @param sCustomerID:�ͻ����
	 * @param sUserID:�û����
	 * @return �ͻ����û�֮��Ĺܻ���ϵ
	 * 			02���û�����ÿͻ�������Ч����
	 * 			04����ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ
	 * 			05����ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ
	 * @throws JBOException
	 */
	protected static String checkCustomerBelong(String sCustomerID,String sUserID) throws JBOException{
		String sReturnStatus="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		int iCount = 0;
		//��ȡ��ǰ�ͻ��Ƿ��뵱ǰ�û������˹���
		m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		q = m.createQuery("CustomerID=:CustomerID and UserID=:UserID");
		q.setParameter("CustomerID",sCustomerID).setParameter("UserID",sUserID);
		iCount = q.getTotalCount();
		if(iCount > 0){
			//�û�����ÿͻ�������Ч����
			sReturnStatus = "02";
		}else{
			//���ÿͻ��Ƿ��йܻ���
			q = m.createQuery("CustomerID=:CustomerID and BelongAttribute=:BelongAttribute");
			q.setParameter("CustomerID",sCustomerID).setParameter("BelongAttribute","1");
			iCount = q.getTotalCount();
			if(iCount > 0){
				//��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ
				sReturnStatus = "05";
			}else{
				//��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ
				sReturnStatus = "04";
			}
		}
		return sReturnStatus;
	}
	/**
  	 * ����������CUSTOMER_BELONG
  	 * @param attribute [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־
  	 * @throws JBOException
  	 */
	protected void insertCustomerBelong(String attribute,String customerID,String userID,String orgID,JBOTransaction tx) throws JBOException{
		String sToday = StringFunction.getToday();
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		BizObject bo = m.newObject();
		
		bo.setAttributeValue("CustomerID",customerID); 		// �ͻ�ID
		bo.setAttributeValue("OrgID",orgID);				// ��Ȩ����ID
		bo.setAttributeValue("UserID",userID);				// ��Ȩ��ID
		bo.setAttributeValue("BelongAttribute",attribute);	// ����Ȩ
		bo.setAttributeValue("BelongAttribute1",attribute);	// ��Ϣ�鿴Ȩ
		bo.setAttributeValue("BelongAttribute2",attribute);	// ��Ϣά��Ȩ
		bo.setAttributeValue("BelongAttribute3",attribute);	// ҵ�����Ȩ
		bo.setAttributeValue("BelongAttribute4",attribute);
		bo.setAttributeValue("InputOrgID",orgID);			// �Ǽǻ���
		bo.setAttributeValue("InputUserID",userID);			// �Ǽ���
		bo.setAttributeValue("InputDate",sToday);			// �Ǽ�����
		bo.setAttributeValue("UpdateDate",sToday);			// ��������
		tx.join(m);
		m.saveObject(bo);
	}
	/**
	 * ����������CUSTOMER_INFO
	 * @param cusotmerType �ͻ����ͣ���ͬ�Ŀͻ����ͣ�������ֶλ�������ͬ
	 * @throws JBOException 
	 */
	protected void insertCustomerInfo(Customer customer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = m.newObject();
		bo.setAttributeValue("CustomerName", customer.getCustomerName());	// �ͻ�����
		bo.setAttributeValue("CustomerType", customer.getCustomerType());	// �ͻ�����
		bo.setAttributeValue("CertType", customer.getCertType());	// ֤������
		bo.setAttributeValue("CertID", customer.getCertID());	//֤������
		bo.setAttributeValue("InputOrgID", customer.getInputOrgID());			// �Ǽǻ���
		bo.setAttributeValue("InputUserID", customer.getInputUserID());		// �Ǽ��û�
		bo.setAttributeValue("InputDate", customer.getInputDate());			// �Ǽ�����
		bo.setAttributeValue("Channel", "1");				// ��Դ����
		bo.setAttributeValue("CreditFlag", "2");			//���ſͻ���־
		tx.join(m);
		m.saveObject(bo);
		//�������Ŀͻ��Ŀͻ���Ÿ�ֵ���ͻ�����
		customer.setCustomerID(bo.getAttribute("CustomerID").getString());
	}
	
	/**
	 * �ͻ�ע���� 01-�����ͻ�  02-�������˵Ĵ����ͻ� 03-�������˵Ĵ����ͻ� 04-������Ϊ�Լ��Ĵ����ͻ� 05-�����ſͻ��Ĵ����ͻ�
	 * @param customer
	 * @param userID
	 * @return
	 * @throws Exception
	 */
	public String checkCustomerAddNew(Customer customer,String userID) throws Exception{
		String sReturnStatus="";//����ֵ
		String sCustomerID=""; //�ͻ����
		String sCustomerType = "";	//�ͻ�����
		String sOrgNature="";//
		boolean bCorpLicenseUnique=true;//Ӫҵִ�ջ���֯���������Ƿ��Ѵ���
		if(customer instanceof EntCustomer){
			EntCustomer entCustomer = (EntCustomer)customer;
			sOrgNature=entCustomer.getOrgNature();
			/**������ҵ0101�ͷǷ�����ҵ0102ע��ʱ��ͬʱ�������֤�������Ƿ���ڣ�����һ�������������ظ�ע��**/
			if("0101".equals(sOrgNature)||"0102".equals(sOrgNature)){
				BizObject boEntCustomer = getCustomerByLicenseNoAndCorpID(entCustomer.getLicenseNo(), entCustomer.getCorpID());
				if(boEntCustomer != null){
					sCustomerID = boEntCustomer.getAttribute("CustomerID").getString();
					sCustomerType = GetCustomer.getCustomerType(sCustomerID);
					bCorpLicenseUnique=false;
				}
			}
		}
		
		/**��һ��:ͨ��֤�����͡�֤�������ȡ�ͻ�����**/
		BizObject boCustomerInfo = getCustomerInfo(customer);
		/**�ڶ���:�ж�¼��Ŀͻ��Ƿ����**/
		if(boCustomerInfo != null||!bCorpLicenseUnique){
			if(bCorpLicenseUnique){
				sCustomerID = boCustomerInfo.getAttribute("CustomerID").getString();//�ͻ����
				sCustomerType = boCustomerInfo.getAttribute("CustomerType").getString();	//�ͻ�����
				/**���������ж��Ƿ�����ͬһ���͵Ŀͻ�**/
				if(!(sCustomerType.equals(customer.getCustomerType()))){
					sReturnStatus = "06@"+sCustomerID;
				}else{
					sReturnStatus = checkCustomerBelongNew(sCustomerID,userID)+"@"+sCustomerID;
				}
			}else{
				/**���������ж��Ƿ�����ͬһ���͵Ŀͻ�**/
				if(!(sCustomerType.equals(customer.getCustomerType()))){
					sReturnStatus = "06@"+sCustomerID;
				}else{
					sReturnStatus = checkCustomerBelongNew(sCustomerID,userID)+"@"+sCustomerID;
				}
			}
		}else{
			//�ÿͻ���ϵͳ�в�����
			sReturnStatus = "01";
		}
		return sReturnStatus;
	} 
	
	/**
	 * @param sCustomerID:�ͻ����
	 * @param sUserID:�û����
	 * @return �ͻ����û�֮��Ĺܻ���ϵ
	 * 			02����ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ
	 * 			03����ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ
	 * 			04���û�����ÿͻ�������Ч����
	 * @throws JBOException
	 */
	protected static String checkCustomerBelongNew(String sCustomerID,String sUserID) throws JBOException{
		String sReturnStatus="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		int iCount = 0;
		//��ȡ��ǰ�ͻ��Ƿ��뵱ǰ�û������˹���
		m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		q = m.createQuery("CustomerID=:CustomerID and UserID=:UserID");
		q.setParameter("CustomerID",sCustomerID).setParameter("UserID",sUserID);
		iCount = q.getTotalCount();
		if(iCount > 0){
			//�û�����ÿͻ�������Ч����
			sReturnStatus = "04";
		}else{
			//���ÿͻ��Ƿ��йܻ���
			q = m.createQuery("CustomerID=:CustomerID and BelongAttribute=:BelongAttribute");
			q.setParameter("CustomerID",sCustomerID).setParameter("BelongAttribute","1");
			iCount = q.getTotalCount();
			if(iCount > 0){
				//��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ
				sReturnStatus = "02";
			}else{
				//��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ
				sReturnStatus = "03";
			}
		}
		return sReturnStatus;
	}
	
	/**
	 * ��ȡCUSTOMER_INFO��ͻ����ݶ���
	 * @param customer
	 * @return
	 * @throws Exception
	 */
	protected static BizObject getCustomerInfo(Customer customer) throws Exception{
		BizObject bo = null;
		/**���˿ͻ����֤ע����Ҫ�˶�15 18λ���֤**/
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
//	 * ��ȡ����
//	 * @return
//	 * @throws Exception 
//	 */
//	protected JBOTransaction getJBOTransaction() throws Exception{
//		JBOTransaction tx=null;
//		try {
//			tx = JBOFactory.createJBOTransaction();
//		} catch (JBOException e1) {
//			ARE.getLog().error("��ȡ�������!");
//			e1.printStackTrace();
//		}
//		if(tx==null){
//			throw new Exception("��ȡ�������!");
//		}
//		return tx;
//	}
}
