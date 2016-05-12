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
 * 业务补登自动风险探测场景参数初始化类
 * 在本类中，使用了JBO，关于JBO的使用，请参考JBO相关文档
 * @author jschen
 * @date 2010/03/23
 *
 */
public class InitReinforceContract extends Bizlet{
	
	/**
	 * 场景执行初始化时，会自动调用此方法
	 */
	public Object run(Transaction Sqlca) throws Exception {
		ASValuePool vpJbo = new ASValuePool();
		String sContractNo = (String)this.getAttribute("ObjectNo");	//从场景中取出合同号
		
		ARE.getLog().debug("风险预警初始化类.初始化合同对象JBO");
		BizObject jboBCContract = getBCContract(sContractNo);
		
		String sCustomerID = jboBCContract.getAttribute("CustomerID").getString();
		ARE.getLog().debug("风险预警初始化类.初始化客户对象JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		ARE.getLog().debug("风险预警初始化类.初始化公司客户对象JBO");
		BizObject jboEntCustomer = getEntCustomer(sCustomerID);	
		
		ARE.getLog().debug("风险预警初始化类.初始化个人客户对象JBO");
		BizObject jboIndCustomer = getIndCustomer(sCustomerID);	
		
		ARE.getLog().debug("风险预警初始化类.初始化担保对象JBO");
		BizObject[] jboGuaranty = getGuaranty(sContractNo);	//由于担保合同有可能出现多个，所以这里就要用对象数组了
		
		vpJbo.setAttribute("BusinessContract", jboBCContract);		//相关合同信息封装为对象存到场景中
		vpJbo.setAttribute("CustomerInfo", jboCustomer);	//相关客户信息封装为对象存到场景中
		vpJbo.setAttribute("EntCustomerInfo", jboEntCustomer);	//相关公司客户信息封装为对象存到场景中
		vpJbo.setAttribute("IndCustomerInfo", jboIndCustomer);	//相关个人客户信息封装为对象存到场景中
		vpJbo.setAttribute("GuarantyContract", jboGuaranty);//相关担保合同信息封装为对象存到场景中
		return vpJbo;	//返回业务对象集合
	}

	/**
	 * 初始化合同信息
	 * @param sContractNo 业务合同号
	 * @return
	 * @throws Exception
	 */
	public BizObject getBCContract(String sContractNo) throws Exception{
		if(sContractNo == null || sContractNo.length() == 0){
			throw new Exception("场景初始化，未获取到合同号！");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject jboBCContract = manager.createQuery("SerialNo = '" + sContractNo + "'").getSingleResult();
	    return jboBCContract;
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
	
	/**
	 * 初始化客户对象
	 * @param sCustomerID
	 * @return
	 * @throws Exception 
	 */
	public BizObject getIndCustomer(String sCustomerID) throws Exception{
		if(sCustomerID == null || sCustomerID.length() == 0){
			throw new Exception("场景初始化，未获取客户号！");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.IND_INFO");
		BizObject jboCustomer = manager.createQuery("CustomerID = '" + sCustomerID + "'").getSingleResult();
	    return jboCustomer;
	}
	
	/**
	 * 初始化客户对象
	 * @param sCustomerID
	 * @return
	 * @throws Exception 
	 */
	public BizObject getEntCustomer(String sCustomerID) throws Exception{
		if(sCustomerID == null || sCustomerID.length() == 0){
			throw new Exception("场景初始化，未获取客户号！");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject jboCustomer = manager.createQuery("CustomerID = '" + sCustomerID + "'").getSingleResult();
	    return jboCustomer;
	}
	
	/**
	 * 取合同关联的担保合同对象
	 * @param sContractNo
	 * @return
	 */
	public BizObject[] getGuaranty(String sContractNo) throws Exception{
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
		BizObjectQuery q = manager.createQuery("SerialNo in (select R.ObjectNo from jbo.app.CONTRACT_RELATIVE R where R.SerialNo = '"+sContractNo+"' and R.ObjectType = 'GuarantyContract')");
		List jboList = q.getResultList(); //一个BizObject对象可理解为数据中的一行
		Object[] o = jboList.toArray();
		BizObject[] bo = new BizObject[o.length];
		for(int i=0; i<o.length; i++){
			bo[i] = (BizObject)o[i];
		}
		return bo;
	}
}
