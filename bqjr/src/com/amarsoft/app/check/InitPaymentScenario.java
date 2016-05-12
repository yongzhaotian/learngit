package com.amarsoft.app.check;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 支付审批自动风险探测场景参数初始化类
 * @author jfeng
 * @date 2011-06-09
 *
 */
public class InitPaymentScenario extends Bizlet{

	/**
	 * 场景执行初始化时，会自动调用此方法
	 */
	public Object run(Transaction Sqlca) throws Exception {
		
		ASValuePool VpJbo = new ASValuePool();
		String sPaymentNo = (String)this.getAttribute("TaskNo");//从场景中取出合同号
		
		ARE.getLog().debug("风险预警初始化类.初始化业务合同对象JBO");
		BizObject jboPayment = getPayment(sPaymentNo);
			
		VpJbo.setAttribute("PaymentInfo", jboPayment);
		return VpJbo;
	}
	
	/**
	 * 初始化合同信息
	 * @param sPaymentNo 业务合同号
	 * @return
	 * @throws Exception
	 */
	public BizObject getPayment(String sPaymentNo) throws Exception{
		if(sPaymentNo == null||sPaymentNo.length()==0){
			throw new Exception("场景初始化，未获取到合同号！");
		} 
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.PAYMENT_INFO");
		BizObject jboPayment = manager.createQuery("SerialNo = '" + sPaymentNo + "'").getSingleResult();
	    return jboPayment;
	}
	
}
