package com.amarsoft.app.check;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �ͻ���ϢԤ������������ʼ����
 * @author djia
 * @date 2009/10/15
 * @history syang 2009/10/26 ����ע��
 *
 */
public class InitCustAlarmScen extends Bizlet{

	/**
	 * ����ִ�г�ʼ��ʱ�����Զ����ô˷���
	 */
	public Object run(Transaction Sqlca) throws Exception {
		ASValuePool vpJbo = new ASValuePool();
		String sCustomerID = (String)this.getAttribute("ObjectNo");	//�ӳ�����ȡ�������
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ���ͻ�����JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		vpJbo.setAttribute("CustomerInfo", jboCustomer);	//��ؿͻ���Ϣ��װΪ����浽������
		return vpJbo;	//����ҵ����󼯺�
	}

	
	/**
	 * ��ʼ���ͻ�����
	 * @param sApplyNo
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
