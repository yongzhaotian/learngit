package com.amarsoft.app.check;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitCreditScenario extends Bizlet{

	/**
	 * ����ִ�г�ʼ��ʱ�����Զ����ô˷���
	 */
	public Object run(Transaction Sqlca) throws Exception {
		
		ASValuePool VpJbo = new ASValuePool();
		String sContractNo = (String)this.getAttribute("SerialNo");//�ӳ�����ȡ����ͬ��
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ��ҵ���ͬ����JBO");
		BizObject jboContract = getContract(sContractNo);
		
		String sCustomerID = jboContract.getAttribute("CustomerID").getString();
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ���ͻ�����JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		VpJbo.setAttribute("BusinessContract", jboContract);
		VpJbo.setAttribute("CustomerInfo", jboCustomer);
		return VpJbo;
	}
	
	/**
	 * ��ʼ����ͬ��Ϣ
	 * @param sContractNo ҵ���ͬ��
	 * @return
	 * @throws Exception
	 */
	public BizObject getContract(String sContractNo) throws Exception{
		if(sContractNo == null||sContractNo.length()==0){
			throw new Exception("������ʼ����δ��ȡ����ͬ�ţ�");
		} 
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject jboContract = manager.createQuery("SerialNo = '" + sContractNo + "'").getSingleResult();
	    return jboContract;
	}
	
	/**
	 * ��ʼ���ͻ�����
	 * @param sCustomerID
	 * @return
	 * @throws Exception 
	 */
	public BizObject getCustomer(String sCustomerID) throws Exception{
		
		if(sCustomerID == null || sCustomerID.length() == 0){
			throw new Exception("������ʼ����δ��ȡ�ͻ��ţ�");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject jboCustomer = manager.createQuery("CustomerID = '" + sCustomerID + "'").getSingleResult();
	    return jboCustomer;
	}
	
	
}
