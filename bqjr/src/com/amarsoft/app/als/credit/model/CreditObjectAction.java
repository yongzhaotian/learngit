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
 * 整合授信业务对象
 * 1、该类返回的jbo对象都是只读
 * @author jschen@20121218
 *
 */
public class CreditObjectAction {

	public BizObject creditObject = null; //授信业务对象
	public String creditObjectType = "";
	private String creditObjectNo = "";
	private String realCreditObjectType = "";
	private String curJBOClass = ""; //当前对象对应jbo
	private BizObject curCustomerBO = null; //当前授信业务对象申请人
	private List<BizObject> lstRelaLine = new ArrayList<BizObject>(); //关联额度
	
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
		else throw new JBOException("传入非法授信业务对象："+bo.getBizObjectClass().getName());
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
				throw new JBOException("传入参数creditObjectType"+creditObjectType+"不满足约定条件！");
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
	 * 返回授信业务对象关联的额度
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
	 * 返回实际授信对象类型
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
	 * @param AppendType 附属信息类型。详见CreditConst.APPENDTYPE
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
			throw new JBOException("传入非法附属信息类型："+appendType);
		}
		appendList = bq.getResultList(false); 
		return appendList;
	}
	
	/**
	 * @return curCustomerBO 当前授信业务对象申请人
	 */
	public BizObject getCurCustomerBO() throws JBOException{
		if(curCustomerBO != null)return curCustomerBO;
		CustomerObjectAction customerObjectAction = new CustomerObjectAction(creditObject.getAttribute("CustomerID").getString());
		curCustomerBO = customerObjectAction.getCustomerObject();
		return curCustomerBO;
	}
	
	/**
	 * @return creditObject 当前授信业务对象
	 */
	public BizObject getCreditObjectBO() {
		return this.creditObject;
	}
}
