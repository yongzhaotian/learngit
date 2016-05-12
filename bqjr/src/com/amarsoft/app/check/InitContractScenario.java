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
 * 业务合同签订自动风险探测场景参数初始化类
 * 在本类中，使用了JBO，关于JBO的使用，请参考JBO相关文档
 * @author syang
 * @date 2009/11/12
 *
 */
public class InitContractScenario extends Bizlet{
	
	/**
	 * 场景执行初始化时，会自动调用此方法
	 */
	public Object run(Transaction Sqlca) throws Exception {
		Parser.registerFunction("GETBUSINESSNAME");
		
		ASValuePool vpJbo = new ASValuePool();
		String sApproveNo = (String)this.getAttribute("ObjectNo");	//从场景中取出批复号
		
		ARE.getLog().debug("风险预警初始化类.初始化业务批复对象JBO");
		BizObject jboApprove = getApprove(sApproveNo);
		
		String sCustomerID = jboApprove.getAttribute("CustomerID").getString();
		ARE.getLog().debug("风险预警初始化类.初始化客户对象JBO");
		BizObject jboCustomer = getCustomer(sCustomerID);
		
		ARE.getLog().debug("风险预警初始化类.初始化担保对象JBO");
		BizObject[] jboGuaranty = getGuaranty(sApproveNo);	//由于担保合同有可能出现多个，所以这里就要用对象数组了
		
		vpJbo.setAttribute("BusinessApprove", jboApprove);		//相关批复信息封装为对象存到场景中
		vpJbo.setAttribute("CustomerInfo", jboCustomer);	//相关客户信息封装为对象存到场景中
		vpJbo.setAttribute("GuarantyContract", jboGuaranty);//相关担保合同信息封装为对象存到场景中
		return vpJbo;	//返回业务对象集合
	}

	/**
	 * 初始化批复信息
	 * @param sApplyNo 业务批复批复号
	 * @return
	 * @throws Exception
	 */
	public BizObject getApprove(String sApproveNo) throws Exception{
		if(sApproveNo == null || sApproveNo.length() == 0){
			throw new Exception("场景初始化，未获取到批复号！");
		}
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
		BizObject jboApprove = manager.createQuery("select * from o where SerialNo = '" + sApproveNo + "'").getSingleResult();
	    return jboApprove;
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
	
	/**
	 * 取批复关联的担保合同对象
	 * @param sApplyNo
	 * @return
	 */
	public BizObject[] getGuaranty(String sApproveNo) throws Exception{
		BizObjectManager manager= JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
		BizObjectQuery q = manager.createQuery("SerialNo in (select R.ObjectNo from jbo.app.APPROVE_RELATIVE R where R.SerialNo = '"+sApproveNo+"' and R.ObjectType = 'GuarantyContract')");
		List jboList = q.getResultList(); //一个BizObject对象可理解为数据中的一行
		Object[] o = jboList.toArray();
		BizObject[] bo = new BizObject[o.length];
		for(int i=0; i<o.length; i++){
			bo[i] = (BizObject)o[i];
		}
		return bo;
	}
}
