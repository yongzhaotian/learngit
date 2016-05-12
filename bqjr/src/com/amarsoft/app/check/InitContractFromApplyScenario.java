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
 * @author wqchen
 * @date 2010/03/20
 *
 */
public class InitContractFromApplyScenario extends Bizlet{
	
	/**
	 * ����ִ�г�ʼ��ʱ�����Զ����ô˷���
	 */
	public Object run(Transaction Sqlca) throws Exception {
		Parser.registerFunction("SUBSTR");
		
		ASValuePool vpJbo = new ASValuePool();
		String sApplyNo = (String)this.getAttribute("ObjectNo");	//�ӳ�����ȡ�������
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ��ҵ���������JBO");
		BizObject jboApply = getApprove(sApplyNo);
		
		String sCustomerID = jboApply.getAttribute("CustomerID").getString();
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ���ͻ�����JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ����������JBO");
		BizObject[] jboGuaranty = getGuaranty(sApplyNo);	//���ڵ�����ͬ�п��ܳ��ֶ�������������Ҫ�ö���������
		
		vpJbo.setAttribute("BusinessApply", jboApply);		//���������Ϣ��װΪ����浽������
		vpJbo.setAttribute("CustomerInfo", jboCustomer);	//��ؿͻ���Ϣ��װΪ����浽������
		vpJbo.setAttribute("GuarantyContract", jboGuaranty);//��ص�����ͬ��Ϣ��װΪ����浽������
		return vpJbo;	//����ҵ����󼯺�
	}

	/**
	 * ��ʼ����Ϣ
	 * @param sApplyNo ҵ�������
	 * @return
	 * @throws Exception
	 */
	public BizObject getApprove(String sApplyNo) throws Exception{
		if(sApplyNo == null || sApplyNo.length() == 0){
			throw new Exception("������ʼ����δ��ȡ������ţ�");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
		BizObject jboApply = manager.createQuery("select * from o where SerialNo = '" + sApplyNo + "'").getSingleResult();
	    return jboApply;
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
	 * ȡ��������ĵ�����ͬ����
	 * @param sApplyNo
	 * @return
	 */
	public BizObject[] getGuaranty(String sApplyNo) throws Exception{
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
		BizObjectQuery q = manager.createQuery("SerialNo in (select R.ObjectNo from jbo.app.APPLY_RELATIVE R where R.SerialNo = '"+sApplyNo+"' and R.ObjectType = 'GuarantyContract')");
		List jboList = q.getResultList(); //һ��BizObject��������Ϊ�����е�һ��
		Object[] o = jboList.toArray();
		BizObject[] bo = new BizObject[o.length];
		for(int i=0; i<o.length; i++){
			bo[i] = (BizObject)o[i];
		}
		return bo;
	}
}
