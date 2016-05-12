package com.amarsoft.app.als.credit.approve.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 *复制额度分配节点信息
 */
public class TransferCLDivide {

	private String nObjectType="";
	private String nObjectNo="";
	private String oObjectType="";
	private String oObjectNo="";
	
	/**
	 * 为了兼容非JBO参数的数据复制
	 * @param fromObjectNo 被复制对象编号
	 * @param fromObjectType 被复制对象类型
	 * @param toObjectNo 复制后对象编号
	 * @param toOBjectType 复制后对象类型
	 */
	public TransferCLDivide(String fromObjectNo, String fromObjectType, String toObjectNo, String toOBjectType){
		this.oObjectNo = fromObjectNo;
		this.oObjectType = fromObjectType;
		this.nObjectNo =  toObjectNo;
		this.nObjectType = toOBjectType;
	}
	
	/**
	 * 进行额度切分的复制，并复制下层额度分配
	 * @return 复制切分的条数
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public void  copyCLDivide(JBOTransaction tx) throws JBOException
	{
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_DIVIDE");
		List<BizObject> lstBiz=m.createQuery("objectNo=:objectNo and ObjectType=:objectType and RelativeSerialNo is null")
									.setParameter("objectNo", this.oObjectNo)
									.setParameter("objectType", this.oObjectType).getResultList(false);
		 for(BizObject biz:lstBiz)
		 {
			 BizObject newBiz=m.newObject();
			 newBiz.setAttributesValue(biz);
			 newBiz.setAttributeValue("SerialNo", null);
			 newBiz.setAttributeValue("ObjectType", this.nObjectType);
			 newBiz.setAttributeValue("ObjectNo", this.nObjectNo);
			 m.saveObject(newBiz); 
			 newCLDivide(biz,newBiz,tx);
		 }
	}
	/**
	 * 产生新的CLDIVIDE
	 * @return
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	private void  newCLDivide(BizObject biz,BizObject newFBiz,JBOTransaction tx) throws JBOException
	{
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_DIVIDE");
		tx.join(m);
		List<BizObject> lstBiz=m.createQuery("RelativeSerialNo=:relativeSerialNo")
								.setParameter("relativeSerialNo", biz.getAttribute("SerialNo").getString())
								.getResultList(false); 
		for(BizObject bizRelative:lstBiz)
		{ 
			 BizObject newBiz=m.newObject();
			 newBiz.setAttributesValue(bizRelative);
			 newBiz.setAttributeValue("SerialNo", null);
			 newBiz.setAttributeValue("ObjectType", this.nObjectType);
			 newBiz.setAttributeValue("ObjectNo", this.nObjectNo);
			 newBiz.setAttributeValue("RelativeSerialNo", newFBiz.getAttribute("SerialNo").getString());
			 m.saveObject(newBiz);
			 newCLDivide(bizRelative,newBiz,tx);//cjyu 查找下级额度分配
		}
	}
}
