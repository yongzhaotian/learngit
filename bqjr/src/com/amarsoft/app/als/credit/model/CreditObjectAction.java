package com.amarsoft.app.als.credit.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.als.customer.model.CustomerObjectAction;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * ��������ҵ�����
 * 1�����෵�ص�jbo������ֻ��
 * @author jschen@20121218
 *
 */
public class CreditObjectAction {

	public BizObject creditObject = null; //����ҵ�����
	public String creditObjectType = "";
	private String creditObjectNo = "";
	private String realCreditObjectType = "";
	private String curJBOClass = ""; //��ǰ�����Ӧjbo
	private BizObject curCustomerBO = null; //��ǰ����ҵ�����������
	private List<BizObject> lstRelaLine = new ArrayList<BizObject>(); //�������
	
	public CreditObjectAction(String creditObjectNo,String creditObjectType) {
		this.creditObjectType = creditObjectType;
		this.realCreditObjectType = creditObjectType;
		this.creditObjectNo = creditObjectNo;
		init(creditObjectNo,creditObjectType);
	}
	
	public CreditObjectAction(BizObject bo) throws JBOException{
		if(bo.getBizObjectClass().getName().equalsIgnoreCase("BUSINESS_APPLY")){
			init(bo.getAttribute("SerialNo").getString(),CreditConst.CREDITOBJECT_APPLY_REAL);
		}else if(bo.getBizObjectClass().getName().equalsIgnoreCase("BUSINESS_APPROVE")){
			init(bo.getAttribute("SerialNo").getString(),CreditConst.CREDITOBJECT_APPROVE_REAL);
		}else if(bo.getBizObjectClass().getName().equalsIgnoreCase("BUSINESS_CONTRACT")){
			init(bo.getAttribute("SerialNo").getString(),CreditConst.CREDITOBJECT_CONTRACT_REAL);
		}
		else throw new JBOException("����Ƿ�����ҵ�����"+bo.getBizObjectClass().getName());
	}
	
	private void init(String creditObjectNo,String creditObjectType){
		this.creditObjectType = creditObjectType;
		this.realCreditObjectType = creditObjectType;
		this.creditObjectNo = creditObjectNo;
		try {
			if(creditObjectType.equalsIgnoreCase(CreditConst.CREDITOBJECT_APPLY_REAL)) curJBOClass = "jbo.app.BUSINESS_APPLY";
			else if(creditObjectType.equalsIgnoreCase(CreditConst.CREDITOBJECT_APPROVE_REAL)) curJBOClass = "jbo.app.BUSINESS_APPROVE";
			else if(creditObjectType.equalsIgnoreCase(CreditConst.CREDITOBJECT_CONTRACT_REAL)) curJBOClass = "jbo.app.BUSINESS_CONTRACT";
			else if(creditObjectType.equalsIgnoreCase(CreditConst.CREDITOBJECT_CONTRACT_QUERY)) curJBOClass = "jbo.app.BUSINESS_CONTRACT";
			else if(creditObjectType.equalsIgnoreCase(CreditConst.CREDITOBJECT_REINFORCECONTRACT_VIRTUAL) || creditObjectType.equalsIgnoreCase(CreditConst.CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL)){
				curJBOClass = "jbo.app.BUSINESS_CONTRACT";
				realCreditObjectType = CreditConst.CREDITOBJECT_CONTRACT_REAL;
			}else {
				throw new JBOException("�������creditObjectType"+creditObjectType+"������Լ��������");
			}
			this.creditObject=JBOFactory.getBizObject(curJBOClass, this.getCreditObjectNo());		
		}catch (JBOException e) {
			e.printStackTrace();
		}
		
	}
	
	public String getCustomerType()throws JBOException{
		String customerType = "";
		customerType = getCurCustomerBO().getAttribute("CustomerType").getString(); 
		return customerType;
	}
	
	/**
	 * ��������ҵ���������Ķ��
	 * @return lstRelaLine
	 * @throws JBOException
	 */
	@SuppressWarnings("unchecked")
	public List<BizObject> getRelativeCreditLineList() throws JBOException{
		if(!lstRelaLine.isEmpty())return lstRelaLine;
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		lstRelaLine = m.createQuery("O.SerialNo in (select CO.RelativeSerialNo from jbo.app.CL_OCCUPY CO where CO.ObjectType =:ObjectType and CO.ObjectNo =:ObjectNo)")
						.setParameter("ObjectType", this.getRealCreditObjectType())
						.setParameter("ObjectNo", this.getCreditObjectNo())
						.getResultList(false);
		return lstRelaLine;
	}
	
	/**
	 * ����ʵ�����Ŷ�������
	 * @return
	 */
	public String getRealCreditObjectType() {
		return realCreditObjectType;
	}

	public String getCreditObjectNo() {
		return creditObjectNo;
	}
	
	/**
	 * 
	 * @param AppendType ������Ϣ���͡����CreditConst.APPENDTYPE
	 * @return
	 */
	public List<BizObject> getAppendList(String appendType) throws JBOException{
		List<BizObject> appendList = generateAppendList(appendType);
		return appendList;
	}
	
	@SuppressWarnings("unchecked")
	private List<BizObject> generateAppendList(String appendType) throws JBOException{
		List<BizObject> appendList = null;
		BizObjectQuery bq = null;
		String appendJBOClass = "";
		if(appendType.equals(CreditConst.APPENDTYPE_DIVIDELINE)){
			appendJBOClass = "jbo.app.CL_DIVIDE";
			bq = JBOFactory.getBizObjectManager(appendJBOClass)
				.createQuery("ObjectType =:ObjectType and ObjectNo =:ObjectNo")
				.setParameter("ObjectType", this.getRealCreditObjectType())
				.setParameter("ObjectNo", this.getCreditObjectNo());
		}else {
			throw new JBOException("����Ƿ�������Ϣ���ͣ�"+appendType);
		}
		appendList = bq.getResultList(false); 
		return appendList;
	}
	
	/**
	 * @return curCustomerBO ��ǰ����ҵ�����������
	 */
	public BizObject getCurCustomerBO() throws JBOException{
		if(curCustomerBO != null)return curCustomerBO;
		CustomerObjectAction customerObjectAction = new CustomerObjectAction(creditObject.getAttribute("CustomerID").getString());
		curCustomerBO = customerObjectAction.getCustomerObject();
		return curCustomerBO;
	}
	
	/**
	 * @return creditObject ��ǰ����ҵ�����
	 */
	public BizObject getCreditObjectBO() {
		return this.creditObject;
	}
}
