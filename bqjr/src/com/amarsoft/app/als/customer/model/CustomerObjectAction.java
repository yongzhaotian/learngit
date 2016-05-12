package com.amarsoft.app.als.customer.model;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 整合授信业务对象
 * @author jschen@20130107
 *
 */
public class CustomerObjectAction {
	
	private BizObject customerObject = null;
	private String customerID = "";
	private String curCustomerJBOClass = "";
	
	public CustomerObjectAction(String customerID) {
		this.customerID = customerID;
		try {
			BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CUSTOMER_INFO");
			String customerType = JBOFactory.getBizObject("jbo.app.CUSTOMER_INFO", this.customerID).getAttribute("CustomerType").getString();
			initCurCustomerJBOClass(customerType);
			
			m=JBOFactory.getBizObjectManager(curCustomerJBOClass);
			if(curCustomerJBOClass.equals("jbo.app.GROUP_INFO")){
				customerObject = m.createQuery("select \"O.*\", A.CustomerType,A.CertType,A.CertID," +
								"A.Status,A.BelongGroupID,A.Channel,A.LoanCardNo,A.CustomerScale " +
								"from O, jbo.app.CUSTOMER_INFO A where A.CustomerID = O.GroupID and A.CustomerID =:CustomerID")
								.setParameter("CustomerID", this.customerID)
								.getSingleResult(false);
			}else{
				customerObject = m.createQuery("select \"O.*\", A.CustomerType,A.CertType,A.CertID," +
								"A.MFCustomerID,A.Status,A.Channel,A.LoanCardNo,A.CustomerScale " +
								"from O,jbo.app.CUSTOMER_INFO A where O.CustomerID = A.CustomerID and O.CustomerID =:CustomerID")
								.setParameter("CustomerID", this.customerID)
								.getSingleResult(false);
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}

	public CustomerObjectAction(BizObject customerObject) {
		this.customerObject = customerObject;
	}
	
	/**
	 * 根据客户类型获取实体表
	 * @param customerType
	 * @return
	 */
	private void initCurCustomerJBOClass(String customerType){
		if(customerType.startsWith("01")){
			curCustomerJBOClass = "jbo.app.ENT_INFO";
		}else if(customerType.startsWith("02")){
			curCustomerJBOClass = "jbo.app.GROUP_INFO";
		}else if(customerType.startsWith("03")){
			curCustomerJBOClass = "jbo.app.IND_INFO";
		}else {
			curCustomerJBOClass = "";
			ARE.getLog().error("出现非法客户类型");
		}
	}

	public BizObject getCustomerObject() {
		return customerObject;
	}
	
	
	

}
