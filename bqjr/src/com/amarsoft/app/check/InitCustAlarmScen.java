package com.amarsoft.app.check;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 客户信息预警场景参数初始化类
 * @author djia
 * @date 2009/10/15
 * @history syang 2009/10/26 整理注释
 *
 */
public class InitCustAlarmScen extends Bizlet{

	/**
	 * 场景执行初始化时，会自动调用此方法
	 */
	public Object run(Transaction Sqlca) throws Exception {
		ASValuePool vpJbo = new ASValuePool();
		String sCustomerID = (String)this.getAttribute("ObjectNo");	//从场景中取出申请号
		
		ARE.getLog().debug("风险预警初始化类.初始化客户对象JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		vpJbo.setAttribute("CustomerInfo", jboCustomer);	//相关客户信息封装为对象存到场景中
		return vpJbo;	//返回业务对象集合
	}

	
	/**
	 * 初始化客户对象
	 * @param sApplyNo
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
