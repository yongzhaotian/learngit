package com.amarsoft.app.check;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ֧�������Զ�����̽�ⳡ��������ʼ����
 * @author jfeng
 * @date 2011-06-09
 *
 */
public class InitPaymentScenario extends Bizlet{

	/**
	 * ����ִ�г�ʼ��ʱ�����Զ����ô˷���
	 */
	public Object run(Transaction Sqlca) throws Exception {
		
		ASValuePool VpJbo = new ASValuePool();
		String sPaymentNo = (String)this.getAttribute("TaskNo");//�ӳ�����ȡ����ͬ��
		
		ARE.getLog().debug("����Ԥ����ʼ����.��ʼ��ҵ���ͬ����JBO");
		BizObject jboPayment = getPayment(sPaymentNo);
			
		VpJbo.setAttribute("PaymentInfo", jboPayment);
		return VpJbo;
	}
	
	/**
	 * ��ʼ����ͬ��Ϣ
	 * @param sPaymentNo ҵ���ͬ��
	 * @return
	 * @throws Exception
	 */
	public BizObject getPayment(String sPaymentNo) throws Exception{
		if(sPaymentNo == null||sPaymentNo.length()==0){
			throw new Exception("������ʼ����δ��ȡ����ͬ�ţ�");
		} 
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.PAYMENT_INFO");
		BizObject jboPayment = manager.createQuery("SerialNo = '" + sPaymentNo + "'").getSingleResult();
	    return jboPayment;
	}
	
}
