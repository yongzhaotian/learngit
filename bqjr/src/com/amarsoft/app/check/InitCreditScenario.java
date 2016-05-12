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
	 * 场景执行初始化时，会自动调用此方法
	 */
	public Object run(Transaction Sqlca) throws Exception {
		
		ASValuePool VpJbo = new ASValuePool();
		String sContractNo = (String)this.getAttribute("SerialNo");//从场景中取出合同号
		
		ARE.getLog().debug("风险预警初始化类.初始化业务合同对象JBO");
		BizObject jboContract = getContract(sContractNo);
		
		String sCustomerID = jboContract.getAttribute("CustomerID").getString();
		ARE.getLog().debug("风险预警初始化类.初始化客户对象JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		VpJbo.setAttribute("BusinessContract", jboContract);
		VpJbo.setAttribute("CustomerInfo", jboCustomer);
		return VpJbo;
	}
	
	/**
	 * 初始化合同信息
	 * @param sContractNo 业务合同号
	 * @return
	 * @throws Exception
	 */
	public BizObject getContract(String sContractNo) throws Exception{
		if(sContractNo == null||sContractNo.length()==0){
			throw new Exception("场景初始化，未获取到合同号！");
		} 
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject jboContract = manager.createQuery("SerialNo = '" + sContractNo + "'").getSingleResult();
	    return jboContract;
	}
	
	/**
	 * 初始化客户对象
	 * @param sCustomerID
	 * @return
	 * @throws Exception 
	 */
	public BizObject getCustomer(String sCustomerID) throws Exception{
		
		if(sCustomerID == null || sCustomerID.length() == 0){
			throw new Exception("场景初始化，未获取客户号！");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject jboCustomer = manager.createQuery("CustomerID = '" + sCustomerID + "'").getSingleResult();
	    return jboCustomer;
	}
	
	
}
