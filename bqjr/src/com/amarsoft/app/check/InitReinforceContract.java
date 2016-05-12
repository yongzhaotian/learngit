package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ҵ�񲹵��Զ�����̽�ⳡ��������ʼ����
 * �ڱ����У�ʹ����JBO������JBO��ʹ�ã���ο�JBO����ĵ�
 * @author jschen
 * @date 2010/03/23
 *
 */
public class InitReinforceContract extends Bizlet{
	
	/**
	 * ����ִ�г�ʼ��ʱ�����Զ����ô˷���
	 */
	public Object run(Transaction Sqlca) throws Exception {
		ASValuePool vpJbo = new ASValuePool();
		String sContractNo = (String)this.getAttribute("ObjectNo");	//�ӳ�����ȡ����ͬ��
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ����ͬ����JBO");
		BizObject jboBCContract = getBCContract(sContractNo);
		
		String sCustomerID = jboBCContract.getAttribute("CustomerID").getString();
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ���ͻ�����JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ����˾�ͻ�����JBO");
		BizObject jboEntCustomer = getEntCustomer(sCustomerID);	
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ�����˿ͻ�����JBO");
		BizObject jboIndCustomer = getIndCustomer(sCustomerID);	
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ����������JBO");
		BizObject[] jboGuaranty = getGuaranty(sContractNo);	//���ڵ�����ͬ�п��ܳ��ֶ�������������Ҫ�ö���������
		
		vpJbo.setAttribute("BusinessContract", jboBCContract);		//��غ�ͬ��Ϣ��װΪ����浽������
		vpJbo.setAttribute("CustomerInfo", jboCustomer);	//��ؿͻ���Ϣ��װΪ����浽������
		vpJbo.setAttribute("EntCustomerInfo", jboEntCustomer);	//��ع�˾�ͻ���Ϣ��װΪ����浽������
		vpJbo.setAttribute("IndCustomerInfo", jboIndCustomer);	//��ظ��˿ͻ���Ϣ��װΪ����浽������
		vpJbo.setAttribute("GuarantyContract", jboGuaranty);//��ص�����ͬ��Ϣ��װΪ����浽������
		return vpJbo;	//����ҵ����󼯺�
	}

	/**
	 * ��ʼ����ͬ��Ϣ
	 * @param sContractNo ҵ���ͬ��
	 * @return
	 * @throws Exception
	 */
	public BizObject getBCContract(String sContractNo) throws Exception{
		if(sContractNo == null || sContractNo.length() == 0){
			throw new Exception("������ʼ����δ��ȡ����ͬ�ţ�");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject jboBCContract = manager.createQuery("SerialNo = '" + sContractNo + "'").getSingleResult();
	    return jboBCContract;
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
	
	/**
	 * ��ʼ���ͻ�����
	 * @param sCustomerID
	 * @return
	 * @throws Exception 
	 */
	public BizObject getIndCustomer(String sCustomerID) throws Exception{
		if(sCustomerID == null || sCustomerID.length() == 0){
			throw new Exception("������ʼ����δ��ȡ�ͻ��ţ�");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.IND_INFO");
		BizObject jboCustomer = manager.createQuery("CustomerID = '" + sCustomerID + "'").getSingleResult();
	    return jboCustomer;
	}
	
	/**
	 * ��ʼ���ͻ�����
	 * @param sCustomerID
	 * @return
	 * @throws Exception 
	 */
	public BizObject getEntCustomer(String sCustomerID) throws Exception{
		if(sCustomerID == null || sCustomerID.length() == 0){
			throw new Exception("������ʼ����δ��ȡ�ͻ��ţ�");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject jboCustomer = manager.createQuery("CustomerID = '" + sCustomerID + "'").getSingleResult();
	    return jboCustomer;
	}
	
	/**
	 * ȡ��ͬ�����ĵ�����ͬ����
	 * @param sContractNo
	 * @return
	 */
	public BizObject[] getGuaranty(String sContractNo) throws Exception{
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
		BizObjectQuery q = manager.createQuery("SerialNo in (select R.ObjectNo from jbo.app.CONTRACT_RELATIVE R where R.SerialNo = '"+sContractNo+"' and R.ObjectType = 'GuarantyContract')");
		List jboList = q.getResultList(); //һ��BizObject��������Ϊ�����е�һ��
		Object[] o = jboList.toArray();
		BizObject[] bo = new BizObject[o.length];
		for(int i=0; i<o.length; i++){
			bo[i] = (BizObject)o[i];
		}
		return bo;
	}
}
