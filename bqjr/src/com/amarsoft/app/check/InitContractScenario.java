package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.ql.Parser;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ҵ���ͬǩ���Զ�����̽�ⳡ��������ʼ����
 * �ڱ����У�ʹ����JBO������JBO��ʹ�ã���ο�JBO����ĵ�
 * @author syang
 * @date 2009/11/12
 *
 */
public class InitContractScenario extends Bizlet{
	
	/**
	 * ����ִ�г�ʼ��ʱ�����Զ����ô˷���
	 */
	public Object run(Transaction Sqlca) throws Exception {
		Parser.registerFunction("GETBUSINESSNAME");
		
		ASValuePool vpJbo = new ASValuePool();
		String sApproveNo = (String)this.getAttribute("ObjectNo");	//�ӳ�����ȡ��������
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ��ҵ����������JBO");
		BizObject jboApprove = getApprove(sApproveNo);
		
		String sCustomerID = jboApprove.getAttribute("CustomerID").getString();
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ���ͻ�����JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ����������JBO");
		BizObject[] jboGuaranty = getGuaranty(sApproveNo);	//���ڵ�����ͬ�п��ܳ��ֶ�������������Ҫ�ö���������
		
		vpJbo.setAttribute("BusinessApprove", jboApprove);		//���������Ϣ��װΪ����浽������
		vpJbo.setAttribute("CustomerInfo", jboCustomer);	//��ؿͻ���Ϣ��װΪ����浽������
		vpJbo.setAttribute("GuarantyContract", jboGuaranty);//��ص�����ͬ��Ϣ��װΪ����浽������
		return vpJbo;	//����ҵ����󼯺�
	}

	/**
	 * ��ʼ��������Ϣ
	 * @param sApplyNo ҵ������������
	 * @return
	 * @throws Exception
	 */
	public BizObject getApprove(String sApproveNo) throws Exception{
		if(sApproveNo == null || sApproveNo.length() == 0){
			throw new Exception("������ʼ����δ��ȡ�������ţ�");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
		BizObject jboApprove = manager.createQuery("select * from o where SerialNo = '" + sApproveNo + "'").getSingleResult();
	    return jboApprove;
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
	
	/**
	 * ȡ���������ĵ�����ͬ����
	 * @param sApplyNo
	 * @return
	 */
	public BizObject[] getGuaranty(String sApproveNo) throws Exception{
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
		BizObjectQuery q = manager.createQuery("SerialNo in (select R.ObjectNo from jbo.app.APPROVE_RELATIVE R where R.SerialNo = '"+sApproveNo+"' and R.ObjectType = 'GuarantyContract')");
		List jboList = q.getResultList(); //һ��BizObject��������Ϊ�����е�һ��
		Object[] o = jboList.toArray();
		BizObject[] bo = new BizObject[o.length];
		for(int i=0; i<o.length; i++){
			bo[i] = (BizObject)o[i];
		}
		return bo;
	}
}
