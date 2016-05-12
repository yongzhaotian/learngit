package com.amarsoft.app.als.credit.approve.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 *���ƶ�ȷ���ڵ���Ϣ
 */
public class TransferCLDivide {

	private String nObjectType="";
	private String nObjectNo="";
	private String oObjectType="";
	private String oObjectNo="";
	
	/**
	 * Ϊ�˼��ݷ�JBO���������ݸ���
	 * @param fromObjectNo �����ƶ�����
	 * @param fromObjectType �����ƶ�������
	 * @param toObjectNo ���ƺ������
	 * @param toOBjectType ���ƺ��������
	 */
	public TransferCLDivide(String fromObjectNo, String fromObjectType, String toObjectNo, String toOBjectType){
		this.oObjectNo = fromObjectNo;
		this.oObjectType = fromObjectType;
		this.nObjectNo =  toObjectNo;
		this.nObjectType = toOBjectType;
	}
	
	/**
	 * ���ж���зֵĸ��ƣ��������²��ȷ���
	 * @return �����зֵ�����
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
	 * �����µ�CLDIVIDE
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
			 newCLDivide(bizRelative,newBiz,tx);//cjyu �����¼���ȷ���
		}
	}
}
